+++  
title = 'Java 相关'  
date = 2024-04-12T09:39:39Z  
draft = true  
+++

- 数据结构
- 算法题
- Java基础
- Java高级
- 三大框架
- 数据库
- 操作系统
- 计算机网络
- 分布式，集群等高级主题
- 技术开放题
- 题目参考
- 解答参考

## 数据结构

1. 讲一下 HashMap 中 put 方法过程？
2. 对 Key 求 Hash 值，然后再计算 下标。
3. 如果没有碰撞，直接放入桶中，
4. 如果碰撞了，以链表的方式链接到后面，
5. 如果链表长度超过阀值（TREEIFY_THRESHOLD == 8），就把链表转成红黑树。
6. 如果节点已经存在就替换旧值
7. 如果桶满了（容量 * 加载因子），就需要 resize。
8. HashMap 中 hash 函数怎么是是实现的？ 还有哪些 hash 的实现方式？
9. 高 16bit 不变，低 16bit 和高 16bit 做了一个异或
10. （n - 1） & hash --> 得到下标
11. 还有哪些 Hash 实现方式：可以参考之前的博客 Effective Java 学习笔记 -- hashCode()
12. HashMap 怎样解决冲突，讲一下扩容过程，假如一个值在原数组中，现在移动了新数组，位置肯定改变了，那是什么定位到在这个值新数组中的位置，
13. 将新节点加到链表后，
14. 容量扩充为原来的两倍，然后对每个节点重新计算哈希值。
15. 这个值只可能在两个地方，一个是原下标的位置，另一种是在下标为 <原下标+原容量> 的位置。
16. 抛开 HashMap，hash 冲突有那些解决办法？
17. 开放定址，链地址法
18. 针对 HashMap 中某个 Entry 链太长，查找的时间复杂度可能达到 O(n)，怎么优化？
19. 将链表转为红黑树， JDK1.8 已经实现了。
20. 数组和 ArrayList 的区别；
21. 数组可以包含基本类型和对象类型，ArrayList 只能包含对象类型
22. 数组大小固定，ArrayList 大小可以动态变化
23. ArrayList 提供了更多的特性（addAll、removeAll）。
24. Arraylist 如何实现排序
25. Collections.sort(List<T> list);
26. sort(List<T> list, Comparator<? super T> c);
27. HashMap
28. 数组 + 链表方式存储
29. 默认容量： 16(2^n 为宜,若定义的初始容量不是 2^n，容量会定义为大于该初始容量的最小 2^n)
30. 例如：初始容量为 13，则真正的容量是 16.
31. put:
32. 索引计算 : ((key.hashCode() ^ (key.hashCode() >>> 16)) & (table.length - 1))
33. 在链表中查找，并记录链表长度，若链表长度达到了 TREEIFY_THRESHOLD(8)，则将该链转成红黑树。
34. 若在链表中找到了，则替换旧值，若未找到则继续
35. 当总元素个数超过容量\*加载因子时，扩容为原来 2 倍并重新散列
36. (元素的下标要么不变，要么变为【原下标+原容量】)。
37. 将新元素加到链表尾部
38. 线程不安全
39. HashTable
40. 数组 + 链表方式存储
41. 默认容量： 11(质数 为宜)
42. put:
43. 索引计算 : （key.hashCode() & 0x7FFFFFFF）% table.length
44. 若在链表中找到了，则替换旧值，若未找到则继续
45. 当总元素个数超过容量*加载因子时，扩容为原来 2 倍并重新散列。
46. 将新元素加到链表头部
47. 对修改 Hashtable 内部共享数据的方法添加了 synchronized，保证线程安全。
48. HashMap ，HashTable 区别
49. 默认容量不同。
50. 索引计算方式不同。
51. HashMap 特有的将过长链表转换为红黑树。
52. 新元素的位置不同。
53. 线程安全性
54. HashMap、ConcurrentHashMap 区别。
55. 索引计算消除了最高位的影响
56. 默认容量： 16(若定义了初始容量(c)，容量会定义为大于(c + (c >>> 1) +1) 的最小 2^n)
57. 例如：初始容量为 13，则真正的容量是 32.
58. 线程安全，并发性能较好
59. 并发性能好的原因是 ConcurrentHashMap 并不是定义 synchronized 方法，而是在链表头上同步，不同的链表之间是互不影响的。
60. ConcurrentHashMap 原理
61. 最大特点是引入了 CAS（借助 Unsafe 来实现【native code】）
62. CAS有3个操作数，内存值V，旧的预期值A，要修改的新值B。当且仅当预期值A和内存值V相同时，将内存值V修改为B，否则什么都不做。
63. Unsafe 借助 CPU 指令 cmpxchg 来实现
64. 使用实例：
65. 对 sizeCtl 的控制都是用 CAS 来实现的
66. sizeCtl ：默认为0，用来控制 table 的初始化和扩容操作。
67. -1 代表table正在初始化
68. N 表示有 -N-1 个线程正在进行扩容操作
69. 如果table未初始化，表示table需要初始化的大小。
70. 如果table初始化完成，表示table的容量，默认是table大小的0.75倍，居然用这个公式算0.75（n - (n >>> 2)）。
71. CAS 会出现的问题：ABA
72. 对变量增加一个版本号，每次修改，版本号加 1，比较的时候比较版本号。
73. TreeMap 和 TreeSet 区别和实现原理
74. TreeSet 底层是 TreeMap，TreeMap 是基于红黑树来实现的。
75. 如果想实现一个线程安全的队列，可以怎么实现？
76. 知道 LRU 吗，20分钟基于 HashMap 实现一个 LRU 算法，面试官给个地址，进去写代码，面试官远程看
77. 如何设计实现一个LRU Cache？
78. 二叉树的遍历方式，前序、中序、后序和层序
79. 可以再写一篇了。。
80. 常见的排序算法时间复杂度（排序算法实现也要重点掌握）
81. 常见排序算法实现(Java)
82. B+树的了解
83. 多分支结构有效降低了树的高度
84. B 树的各种操作能使 B 树保持较低的高度，从而达到有效避免磁盘过于频繁的查找存取操作，从而有效提高查找效率

## 算法题

1. 怎么查询一个单向链表的倒数第五个节点
2. 判断链表是否成环
3. 两条相交的单向链表，如何求他们的第一个公共节点
4. 在无序数组中找最大的K个数?
5. 给定n个数，寻找第k小的数，同时给出时间复杂度
6. 找一个数组中的第三大数
7. 找出数组中第一个出现2次的数，
8. 求 1-N 中数字 1 的个数。
9. 判断一个数是不是丑数；
10. 求第 K 个丑数；
11. 10w行数据，每行一个单词，统计出现次数出现最多的前100个。
12. 一个文本文件，给你一个单词，判断单词是否出现。
13. 一进去要求敲代码二叉排序树的插入、删除及查找
14. 某海量用户网站，用户拥有积分，积分可能会在使用过程中随时更新。现在要为该网站设计一种算法，在每次用户登录时显示其当前积分排名。用户最大规模为2 亿；积分为非负整数，且小于 100 万；
15. 判断一棵二叉树是否是 BST。
16. 一副扑克 54 张牌，现在分成 3 份，每份 18 张，问大小王出现在同一份中的概率是多少；
17. 50个白球50个红球，两个盒子，怎么放让人随机在一个盒子里抽到红球概率最高。。。这个就是一个盒子放一个红球，另一个盒子放99个球。
18. logN 查找一个有序数组移动后类似 4 5 6 7 1 2 3里面的一个数
19. 0 ~ n 连续 n + 1 数，现在有一个长度为 n 的数组存放了上面 n + 1 个数的其中 n 个，找出哪一个数没有被放进数组
20. 将M个平均长度为N的有序队列组合成一个有序队列
21. 10亿条短信，找出前一万条重复率高的
22. 对一万条数据排序，你认为最好的方式是什么
23. 假如有100万个玩家，需要对这100W个玩家的积分中前100名的积分，按照顺序显示在网站中，要求是实时更新的。积分可能由做的任务和获得的金钱决定。问如何对着100万个玩家前100名的积分进行实时更新？

- 除了前100名，后100W-100名玩家的积分，让变化的积分跟第100名比较，如果比第100名高，那就替换的原则。

## Java 基础

1. Java 的优势
2. 语法简单
3. 跨平台
4. 当开发规模膨胀到一定程度，Java在规范、协作和性能调优上还是占有很大优势,在大型应用，尤其是企业应用上，Java的地位仍然难以撼动
5. boolean 占几个字节
6. 如果 boolean 变量在栈上，那么它占用一个栈单元（32-bits）
7. 如果在堆上，那么就跟 JVM 的实现有关了
8. 在 Oracle 的 JVM 实现，boolean[] 中每个元素占用一个字节（8-bits）
9. Java 访问修饰符权限的区别；
10. public 所有类都可访问
11. protected 只允许包内、子类访问。
12. 默认 只允许包内访问
13. private 只允许类内访问
14. String 是否可以继承， “+” 怎样实现?
15. String 是 final 类，不可继承。
16. \+ 是通过 StringBuilder（或 StringBuffer） 类，和 append 方法实现
17. String，StringBuffer，StringBuilder，区别，项目中那里用到了 StringBuffer 或者 StringBuilder
18. String 不可变
19. StringBuffer，可变，线程安全
20. Stringbuilder，可变，线程不安全
21. String为啥不可变，在内存中的具体形态？
22. String 使用 final char value[] 来存放字符序列。
23. Comparable 接口和 Comparator 接口实现比较
24. Comparable 是直接在"被比较"的类内部来实现的
25. Comparator则是在被比较的类外部实现的
26. Arrays 静态类如何实现排序的？
27. 双轴快排
28. 首先检查数组长度，如果比阀值（286）小，直接使用双轴快排
29. 否则先检查数组中数据的连续性，标记连续升序，反转连续降序，如果连续性好，使用 TimSort 算法（可以很好的利用数列中的原始顺序）
30. 否则使用双轴快排 + 成对插入排序
31. Java 中异常怎么处理，什么时候抛出，什么时候捕获；
32. 一般原则是提早抛出，延迟捕获
33. 出现异常时，若当前无法处理则抛，否则捕获异常，尝试恢复。
34. Java 锁机制
35. 重入锁、对象锁、类锁的关系
36. 哪些方法实现线程安全？
37. Java 中的同步机制，synchronized 关键字，锁（重入锁）机制，其他解决同步的方 volatile 关键字 ThreadLocal 类的实现原理要懂。
38. Synchronized 和 lock 区别
39. 锁的优化策略
40. 读写分离
41. 分段加锁
42. 减少锁持有的时间
43. 多个线程尽量以相同的顺序去获取资源
44. Java线程阻塞调用 wait 函数和 sleep 区别和联系，还有函数 yield，notify 等的作用。
45. sleep 时线程的方法（让出 CPU），wait 是对象的方法。
46. 谈谈的 Java 反射的理解，怎么通过反射访问某各类的私有属性
47. 通过反射，我们可以获取类的运行时内部结构。
48. 反射 API 中有个方法 getDeclaredFields()
49. 动态代理的原理
50. 动态代理基于反射实现，调用者通过代理对象来访问方法的时候，代理对象可以做相应的处理，然后通过反射调用被代理对象的方法。
51. 项目中都是用的框架，用过 Servlet 吗？ Servlet 是单例吗？多线程下 Servlet 怎么保证数据安全的？Servlet 的生命周期？
52. Thread 状态有哪些

## Java 高级

1. GC 算法，除了常见的复制算法，标记整理，标记清除算法，还有哪些？
2. 增量算法。主要思想是垃圾收集线程与用户线程交替执行。也可以说一边执行垃圾回收一遍执行用户代码。但是这种方法会造成系统吞吐量下降。
3. 分代收集。这种方法没有使用新算法，只是根据对象的特点将堆分为年轻代和老年代，年轻代使用复制算法，老年代使用标记整理算法。
4. 垃圾收集器
5. 收集器收集算法收集区域线程停顿特点serial复制算法新生代单线程收集时必须停顿其他所有工作线程简单高效serial old标记整理老年代单线程收集时必须停顿其他所有工作线程PerNew复制算法新生代多线程serial 的多线程版本Server 模式下首选parallel Scavenge复制算法新生代多线程收集时必须停顿其他所有工作线程注重吞吐量，适合后台计算多parallel old标记整理老年代多线程收集时必须停顿其他所有工作线程同 parallel Scavenge

## CMS（concurrent mark sweep）并发收集、低停顿

1. 初始标记（CMS initial mark）：仅仅只是标记一下GC Roots能直接关联到的对象，速度很快，需要“Stop The World”。
2. 并发标记（CMS concurrent mark）：进行GC Roots Tracing的过程，在整个过程中耗时最长。
3. 重新标记（CMS remark）：为了修正并发标记期间因用户程序继续运作而导致标记产生变动的那一部分对象的标记记录，这个阶段的停顿时间一般会比初始标记阶段稍长一些，但远比并发标记的时间短。此阶段也需要“Stop The World”。
4. 并发清除（CMS concurrent sweep）

## G1

1. 将整个Java堆划分为多个大小相等的独立区域（Region），虽然还保留新生代和老年代的概念，但新生代和老年代不再是物理隔离的了，而都是一部分Region（不需要连续）的集合。
2. 整体使用标记整理，局部使用复制算法。



1. 初始标记（Initial Marking） 仅仅只是标记一下GC Roots 能直接关联到的对象，并且修改TAMS（Nest Top Mark Start）的值，让下一阶段用户程序并发运行时，能在正确可以的Region中创建对象，此阶段需要停顿线程，但耗时很短。
2. 并发标记（Concurrent Marking） 从GC Root 开始对堆中对象进行可达性分析，找到存活对象，此阶段耗时较长，但可与用户程序并发执行。
3. 最终标记（Final Marking） 为了修正在并发标记期间因用户程序继续运作而导致标记产生变动的那一部分标记记录，虚拟机将这段时间对象变化记录在线程的Remembered Set Logs里面，最终标记阶段需要把Remembered Set Logs的数据合并到Remembered Set中，这阶段需要停顿线程，但是可并行执行。
4. 筛选回收（Live Data Counting and Evacuation） 首先对各个Region中的回收价值和成本进行排序，根据用户所期望的GC 停顿是时间来制定回收计划。此阶段其实也可以做到与用户程序一起并发执行，但是因为只回收一部分Region，时间是用户可控制的，而且停顿用户线程将大幅度提高收集效率。



## G1 vs CMS



我们选择哪个收集器是由我们垃圾回收的目标来决定的，主要考虑以下几点：

1. 吞吐量
2. 停顿时间
3. 堆容量

## G1 vs CMS

1. G1 基本不用配置，低停顿，用于大容量的堆。但是他牺牲了应用程序的吞吐量和部分堆空间。
2. CMS 配置比较复杂，合理的低停顿，用于中等或更小的堆。
3. 所以当你觉得配置 CMS 太难了，或你的堆在 2 G 以上，或你想要显式的指定停顿时间那么你可以使用 G1。否则使用 CMS

## Java 内存模型

1. 深入理解 Java 虚拟机

## 问 JVM 内存分代机制（会问分为那几个代，各个代特点），分代回收的优点（这个问了很多次）。

1. 分为年轻代和老年代，年轻代中的对象生命周期短，基本是朝生夕死，所以需要频繁的回收；老年代中的对象一般都能熬过多次 GC 所以他们不需要频繁回收。分代收集利用了这种特点，年轻代使用复制算法，老年代使用标记整理算法，所以总的来说分代收集的效率相对还是不错的。

## Java 虚拟机类加载机制，双亲委派模型

1. 深入理解 Java 虚拟机

## GC roots 不可达的对象是可以回收的。

1. 栈中的引用的对象
2. 方法区常量引用的对象
3. 方法区静态域引用的对象

## 介绍一下 Java 的强软弱虚四种引用，问什么时候使用软引用

1. 一般 new 出来的对象都是强引用，GC 不会回收强引用的对象
2. 软引用：软引用的对象不那么重要，当内存不足时可以被回收。非常适合于创建缓存。
3. 弱引用：只是引用一个对象，若一个对象的所有引用都是弱引用的话，下次 GC 会回收该对象。一般用在集合类中，特别是哈希表。
4. 虚引用：一般用于对实现比较精细的内存使用控制。对于移动设备来说比较有意义

## RPC 原理

1. 你应该知道的 RPC 原理

## 三大框架

1. Spring 主要思想是什么，回答 IOC 和AOP，怎么自己实现 AOP ？
2. IOC 的好处：阿里一面总结 12 题
3. 使用基于反射的动态代理
4. SpringAOP 用的哪一种代理
5. JDK 动态代理，这种是一般意义上的动态代理；用一个代理类来间接调用目标类的方法。目标类如果实现了接口那就用这种方式代理。
6. cglib 动态代理。通过框架转换字节码生成目标类的子类，并覆盖其中的方法实现增强，因为采用的是继承，所以不能对 final 类进行代理。目标类没有实现任何接口，就使用这种方法
7. spring bean 初始化过程
8. 读取 XML 资源，并解析，最终注册到 Bean Factory 中
9. spring bean 对象的生命周期
10. 当一个 bean 被实例化时，它需要执行一些初始化(init-method)使它转换成可用状态。同样，当 bean 不再需要，并且从容器中移除时，需要做一些清除工作(destroy-method)
11. 讲讲 Spring 中 ApplicationContext 初始化过程。
12. SpringMVC 处理请求的流程
13. 收到用户请求
14. dispatcher Servlet 将请求转发到相应的 Controller
15. 通过 View Resolver 进行视图解析
16. 返回给用户

7.SpringMVC 的设计模式

8.Spring 的 annotation 如何实现

9.Spring拦截器怎么使用，Controller是单例吗

1. 基于 XML 配置文件

2. 基于注解

3. 基于 Spring 定义的 MethodInterceptor 接口

## 数据库

1.SQL 优化方案
2. 根据我目前的知识水平，大概分为两类：
3. 多表连接时不直接连接表，而是先用 where 筛选出符合条件的记录然后进行连接。一般情况下，筛选一次会除去相当多的无效记录，这会极大的提高效率。
4. 当前的 SQL 是否合理的使用了索引。如果设置的索引没有使用的话，会导致全表扫描。效率上会差很多。没有利用索引的情况一般有以下几种：
5以“%”开头的LIKE语句，模糊匹配
6. OR 语句前后没有同时使用索引
7. 数据类型出现隐式转化（如varchar不加单引号的话可能会自动转换为int型）
8. where 子句中对字段进行表达式操作
9. 在where子句中对字段进行函数操作
10. 索引有哪分别有什么特点？
11. 从数据结构来划分的话，主要有两种：一种是基于 B+ 树的索引，一种是基于哈希表的索引。基于哈希表的索引在等值查询上有绝对的优势，但其他方面就不是很好了。B+ 树是一种多分支的树结构，相比二叉树来说高度降低了很多，能够有效的减少磁盘 IO，所以我们平时使用的都是基于 B+ 树的索引
12. 索引为什么用 B不用二叉树，有什么好处？
13. 基于 B 索引实现，降低了树的高度，减少了磁盘 IO 的次数。
14. 数据库索引优点和缺点
15. 优点：有效查询；
16. 缺点：操作数据时需要对索引进行更新，效率上稍微差一点；索引需要占用一定的空间。
17. 数据库事务的四个隔离，MySql 在哪一个级别

> MyL 默认隔离级别为 Repeatable read

## 操作系统

1. 进程和线程的区别. 进程是拥有资基本单位，线程是 CPU 调度的基本单位
3. 进程拥有独立的地址空间，同一个进程的线程共享该进程的地址空间
4. 进程上下文切换相对线程上下文切换会消耗更多的资源
5. 一个进程必须至少拥有一个线程
6. 一个线程死掉就等于整个进程死掉，所以多进程的程序相对于多线程的程序来说会更健壮
7. 通信方式不同，线程通过进程内的资源进行通信，进程的通信有多种方式，包括管道、共享内存、消息等等。
8. 进程间通信
9.道（Pip及有名管道（named pipe）：管道可用于具有亲缘关系进程间的通信，有名管道克服了管道没有名字的限制，因此，除具有管道所具有的功能外，它还允许无亲缘关系进程间的通信；
10. 信号（Signal）：信号是比较复杂的通信方式，用于通知接受进程有某种事件发生，除了用于进程间通信外，进程还可以发送信号给进程本身；
11. 报文（Message）队列（消息队列）：消息队列是消息的链接表。有足够权限的进程可以向队列中添加消息，被赋予读权限的进程则可以读走队列中的消息。消息队列克服了信号承载信息量少，管道只能承载无格式字节流以及缓冲区大小受限等缺点。
12. 共享内存：使得多个进程可以访问同一块内存空间，是最快的可用IPC形式。是针对其他通信机制运行效率较低而设计的。往往与其它通信机制，如信号量结合使用，来达到进程间的同步及互斥。
13. 信号量（semaphore）：主要作为进程间以及同一进程不同线程之间的同步手段。
14. 套接口（Socket）：更为一般的进程间通信机制，可用于不同机器之间的进程间通信。
15. 在共享内存中如何使用utex
16. selt 和 ell
17. 操作系哪几部分组进程结构
18. 多进程线程的区别
19. 什么时用多线程，时候使用多进程
20. Jav多线程与操统线程的关系
21. 一般线守护线程的
22. 多线程线程的实现
23. 死锁的，死锁避免*
24. 互斥条件
. 占有和等待条件
26. 不剥夺条件
27. 循环等待
28. linux中如何查看等命令
29. 不同进开了同一个，那么这两个进程得到的文件描述符（fd）相同吗
30. 不一定，因开文件有三个表，inode 表，系统文件描述符表，进程文件描述符表。不同进程的文件描述符的范围是一样的，有可能刚好相同，也有可能不相同
31. 两个线程如何同时监听端口。
32. SO_REEPORT 参数。

## 计算机网络

1. HTTP 状态码有哪一一解释含义
2. 1xx 
3100 服务接收到部分请求，但是一旦服务器并没有拒绝该请求，客户端应该继续发送其余的请求。
4. 2xx 成功
5200 OK求成功（其后是对GET和POST请求的应答文档。）
6. 3xx 重定向
 304 NoModified 未修改的文档。客户端有缓冲的文档并发出了一个条件性的请求（一般是提供If-Modified-Since头表示客户只想比指定日期更新的文档）。服务器告诉客户，原来缓冲的文档还可以继续使用。
8. 4xx: 客户端错误
9. 400 BaRequest 服务器未能理解请求。
10. 404 Not Found 服务器无法找到被请求的页面。
11. 5xx: 服务器错误
12. 500 Iernal Server Error 请求未完成。服务器遇到不可预知的情况。
13. HTTP 请求头有哪介绍平时见过的，怎么利用这些信息来进行前后端调试
14. Host,求的域名
15. User-Agent，用户的浏览器版本信息
16. Accept，响应的内容类型
17. Accept-Language, 接受的语言
18. Accept-Encoding, 可接受的编码方式
19. Cookie，本地的 Cookie 信息
20. if-Modified-Since, 本地有缓存，如果在那之后没有做修改，则可以直接使用本地缓存。
21. TCP 和 UDP 别

|            |     TCP      |    UDP     |
| :--------: | :----------: | :--------: |
|  是否连接  |   面向连接   | 面向非连接 |
| 传输可靠性 |    可靠性    |   不可靠   |
|  应用场合  | 传输大量数据 |  少量数据  |
|    速度    |      慢      |     快     |

1. HTTP1.0 和 1.1 的区别
2. 最主要的区别1.1 支持持久连接。Connection 请求头的值为 Keep-Alive 时，客户端通知服务器返回本次请求结果后保持连接；Connection 请求头的值为 close 时，客户端通知服务器返回本次请求结果后关闭连接。
3. 1.1 支持断点续传。RANGE:bytes=XXX 表示要求服务器从文件 XXX 字节处开始传送
4. 还有一些其他的改进，有兴趣可以自行查阅相关资料
5. HTTP 和 HTT 的主要区别
6. 安全。HTT直接与 TCP 通信，而 HTTPS 是先与 SSL（加密） 通信，然后再由 SSL 和 TCP 通信
7. 滑动窗口算法
8又称回退 N（go-back-N）,发送方的窗口滑动是由接收方是否已成功收到数据包来决定的。即接收方的窗口向前滑动后发送方的窗口才会向前滑动。//TODO
9. 域名解析详细过程0. IP 分为几类，都代表什么，私网是哪些
11. A：前 1yte 为网络标识，剩下的是主机标识
12. B：前 2 bytes 为网络标识
13. C：前 3 bytes 为网络标识
14. D：为多播地址，最高位为 1110
15. E：特殊 IP。例如 0.0.0.0，127.0.0.1,255.255.255.255 等等
16. IP 头组成；
. 计算机中的同步和
18. 发现百不去，怎么*
19. 查看 DN解析是否正确。若有错误，删除本地 DNS 缓存
20. 若 DNS 没有问题，使用 traceroute 检测路径，若路径不通则说明网路阻塞，暂时就别上网了
21. traceroute 没有问题，ping 也能通一般就是服务器端出问题了。

## 分布式/集群等高级主题

1. 负载均衡算法
2随机：负载均法随机的把负载分配到各个可用的服务器上。
3. 轮询：按顺序将新的连接请求分配给下一个服务器
4. 加权轮询：每台服务器接受到的连接数按权重分配，一般是用在应用服务器的处理能力大小不同的情况下。
5. 最少连接：把新连接分配给当前连接最少的服务器
6. BLABAL...
7. 分布式数据库
8分布式数据库了原来集中式数据库不具备的高可用性和拓展能力

## 技术开放题

1. 如何设计一个高并发的
2. 数据库的优化括合理的事务隔离级别、SQL语句优化、索引的优化
3. 使用缓存，尽量减少数据库 IO
4. 分布式数据库、分布式缓存
5. 服务器的负载均衡
6. 现在一个网页响应速度变慢了，假如我把这个任务交给你，你怎么处理这个问题
7. 负载均衡题，数千负载部署到机器上，要求对问题进行抽象，建模，提出解决方案。
8. 美团面试到一个城试应聘者，面试有三天，每天面试官上午可以面试三场，下午可以面试四场，怎么设计面试系统，面试者可以选择面试日期，面试时间和面试官。
9. 有一些爬P不断的美团网站，现在美团设定一个IP5分钟之内访问美团网站超过100次，就判定为爬虫IP，怎么设计这个程序？如果100改成10000，怎么设计？
10. 假设在时刻由几万发请求同时产生，请设计一个方案来处理这种情况。
11. 问我简学校 oj台这个项目怎么实现1000人并发?并发的性能瓶颈在哪?
12. 因为还没完现处于开发阶段，只跟面试官说了下自己的构想，nginx+tomcat集群，性能瓶颈可能出现在网络io和java gc上，然后说了下jvm gc的优化，如何实现session共享。最后我问了下面试官这样设计可以吗，他说这样设计不行可能有问题，没有告诉我问题出现在哪里。