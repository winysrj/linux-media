Return-path: <linux-media-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:39325 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3D1Rqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 13:46:49 -0400
Subject: [PATCH v3 3/3] mutex: Add ww tests to lib/locking-selftest.c. v3
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, peterz@infradead.org, x86@kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	robclark@gmail.com, rostedt@goodmis.org, daniel@ffwll.ch,
	tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org
Date: Sun, 28 Apr 2013 19:04:14 +0200
Message-ID: <20130428170414.17075.40337.stgit@patser>
In-Reply-To: <20130428165914.17075.57751.stgit@patser>
References: <20130428165914.17075.57751.stgit@patser>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This stresses the lockdep code in some ways specifically useful to
ww_mutexes. It adds checks for most of the common locking errors.

Changes since v1:
 - Add tests to verify reservation_id is untouched.
 - Use L() and U() macros where possible.

Changes since v2:
 - Use the ww_mutex api directly.
 - Use macros for most of the code.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 lib/locking-selftest.c |  439 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 420 insertions(+), 19 deletions(-)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index c3eb261..9cef196 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -26,6 +26,8 @@
  */
 static unsigned int debug_locks_verbose;
 
+static DEFINE_WW_CLASS(ww_lockdep);
+
 static int __init setup_debug_locks_verbose(char *str)
 {
 	get_option(&str, &debug_locks_verbose);
@@ -42,6 +44,10 @@ __setup("debug_locks_verbose=", setup_debug_locks_verbose);
 #define LOCKTYPE_RWLOCK	0x2
 #define LOCKTYPE_MUTEX	0x4
 #define LOCKTYPE_RWSEM	0x8
+#define LOCKTYPE_WW	0x10
+
+static struct ww_acquire_ctx t, t2;
+static struct ww_mutex o, o2;
 
 /*
  * Normal standalone locks, for the circular and irq-context
@@ -193,6 +199,17 @@ static void init_shared_classes(void)
 #define RSU(x)			up_read(&rwsem_##x)
 #define RWSI(x)			init_rwsem(&rwsem_##x)
 
+#define WWAI(x)			ww_acquire_init(x, &ww_lockdep)
+#define WWAD(x)			ww_acquire_done(x)
+#define WWAF(x)			ww_acquire_fini(x)
+
+#define WWL(x, c)		ww_mutex_lock(x, c)
+#define WWU(x)			ww_mutex_unlock(x)
+
+#define WWL1(x)			ww_mutex_lock_single(x)
+#define WWT1(x)			ww_mutex_trylock_single(x)
+#define WWU1(x)			ww_mutex_unlock_single(x)
+
 #define LOCK_UNLOCK_2(x,y)	LOCK(x); LOCK(y); UNLOCK(y); UNLOCK(x)
 
 /*
@@ -894,11 +911,13 @@ GENERATE_PERMUTATIONS_3_EVENTS(irq_read_recursion_soft)
 # define I_RWLOCK(x)	lockdep_reset_lock(&rwlock_##x.dep_map)
 # define I_MUTEX(x)	lockdep_reset_lock(&mutex_##x.dep_map)
 # define I_RWSEM(x)	lockdep_reset_lock(&rwsem_##x.dep_map)
+# define I_WW(x)	lockdep_reset_lock(&x.dep_map)
 #else
 # define I_SPINLOCK(x)
 # define I_RWLOCK(x)
 # define I_MUTEX(x)
 # define I_RWSEM(x)
+# define I_WW(x)
 #endif
 
 #define I1(x)					\
@@ -920,11 +939,20 @@ GENERATE_PERMUTATIONS_3_EVENTS(irq_read_recursion_soft)
 static void reset_locks(void)
 {
 	local_irq_disable();
+	lockdep_free_key_range(&ww_lockdep.acquire_key, 1);
+	lockdep_free_key_range(&ww_lockdep.mutex_key, 1);
+
 	I1(A); I1(B); I1(C); I1(D);
 	I1(X1); I1(X2); I1(Y1); I1(Y2); I1(Z1); I1(Z2);
+	I_WW(t); I_WW(t2); I_WW(o.base); I_WW(o2.base);
 	lockdep_reset();
 	I2(A); I2(B); I2(C); I2(D);
 	init_shared_classes();
+
+	ww_mutex_init(&o, &ww_lockdep); ww_mutex_init(&o2, &ww_lockdep);
+	memset(&t, 0, sizeof(t)); memset(&t2, 0, sizeof(t2));
+	memset(&ww_lockdep.acquire_key, 0, sizeof(ww_lockdep.acquire_key));
+	memset(&ww_lockdep.mutex_key, 0, sizeof(ww_lockdep.mutex_key));
 	local_irq_enable();
 }
 
@@ -938,7 +966,6 @@ static int unexpected_testcase_failures;
 static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 {
 	unsigned long saved_preempt_count = preempt_count();
-	int expected_failure = 0;
 
 	WARN_ON(irqs_disabled());
 
@@ -946,26 +973,16 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 	/*
 	 * Filter out expected failures:
 	 */
+	if (debug_locks != expected) {
 #ifndef CONFIG_PROVE_LOCKING
-	if ((lockclass_mask & LOCKTYPE_SPIN) && debug_locks != expected)
-		expected_failure = 1;
-	if ((lockclass_mask & LOCKTYPE_RWLOCK) && debug_locks != expected)
-		expected_failure = 1;
-	if ((lockclass_mask & LOCKTYPE_MUTEX) && debug_locks != expected)
-		expected_failure = 1;
-	if ((lockclass_mask & LOCKTYPE_RWSEM) && debug_locks != expected)
-		expected_failure = 1;
+		expected_testcase_failures++;
+		printk("failed|");
+#else
+		unexpected_testcase_failures++;
+		printk("FAILED|");
+
+		dump_stack();
 #endif
-	if (debug_locks != expected) {
-		if (expected_failure) {
-			expected_testcase_failures++;
-			printk("failed|");
-		} else {
-			unexpected_testcase_failures++;
-
-			printk("FAILED|");
-			dump_stack();
-		}
 	} else {
 		testcase_successes++;
 		printk("  ok  |");
@@ -1108,6 +1125,388 @@ static inline void print_testname(const char *testname)
 	DO_TESTCASE_6IRW(desc, name, 312);			\
 	DO_TESTCASE_6IRW(desc, name, 321);
 
+static void ww_test_fail_acquire(void)
+{
+	int ret;
+
+	WWAI(&t);
+	t.stamp++;
+
+	ret = WWL(&o, &t);
+
+	if (WARN_ON(!o.ctx) ||
+	    WARN_ON(ret))
+		return;
+
+	/* No lockdep test, pure API */
+	ret = WWL(&o, &t);
+	WARN_ON(ret != -EALREADY);
+
+	ret = WWT1(&o);
+	WARN_ON(ret);
+
+	t2 = t;
+	t2.stamp++;
+	ret = WWL(&o, &t2);
+	WARN_ON(ret != -EDEADLK);
+	WWU(&o);
+
+	if (WWT1(&o))
+		WWU1(&o);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	else
+		DEBUG_LOCKS_WARN_ON(1);
+#endif
+}
+
+static void ww_test_normal(void)
+{
+	int ret;
+
+	WWAI(&t);
+
+	/*
+	 * test if ww_id is kept identical if not
+	 * called with any of the ww_* locking calls
+	 */
+
+	/* mutex_lock (and indirectly, mutex_lock_nested) */
+	o.ctx = (void *)~0UL;
+	WWL1(&o);
+	WWU1(&o);
+	WARN_ON(o.ctx != (void *)~0UL);
+
+	/* mutex_lock_interruptible (and *_nested) */
+	o.ctx = (void *)~0UL;
+	ret = mutex_lock_interruptible(&o.base);
+	if (!ret)
+		WWU1(&o);
+	else
+		WARN_ON(1);
+	WARN_ON(o.ctx != (void *)~0UL);
+
+	/* mutex_lock_killable (and *_nested) */
+	o.ctx = (void *)~0UL;
+	ret = mutex_lock_killable(&o.base);
+	if (!ret)
+		WWU1(&o);
+	else
+		WARN_ON(1);
+	WARN_ON(o.ctx != (void *)~0UL);
+
+	/* trylock, succeeding */
+	o.ctx = (void *)~0UL;
+	ret = WWT1(&o);
+	WARN_ON(!ret);
+	if (ret)
+		WWU1(&o);
+	else
+		WARN_ON(1);
+	WARN_ON(o.ctx != (void *)~0UL);
+
+	/* trylock, failing */
+	o.ctx = (void *)~0UL;
+	WWL1(&o);
+	ret = WWT1(&o);
+	WARN_ON(ret);
+	WWU1(&o);
+	WARN_ON(o.ctx != (void *)~0UL);
+
+	/* nest_lock */
+	o.ctx = (void *)~0UL;
+	mutex_lock_nest_lock(&o.base, &t);
+	WWU1(&o);
+	WARN_ON(o.ctx != (void *)~0UL);
+}
+
+static void ww_test_two_contexts(void)
+{
+	WWAI(&t);
+	WWAI(&t2);
+}
+
+static void ww_test_context_unlock_twice(void)
+{
+	WWAI(&t);
+	WWAD(&t);
+	WWAF(&t);
+	WWAF(&t);
+}
+
+static void ww_test_object_unlock_twice(void)
+{
+	WWL1(&o);
+	WWU1(&o);
+	WWU1(&o);
+}
+
+static void ww_test_spin_nest_unlocked(void)
+{
+	raw_spin_lock_nest_lock(&lock_A, &o.base);
+	U(A);
+}
+
+static void ww_test_mismatch_normal_ww(void)
+{
+	WWL1(&o);
+	WWU(&o);
+}
+
+static void ww_test_mismatch_ww_normal(void)
+{
+	int ret;
+
+	WWAI(&t);
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+	WWU1(&o);
+
+	/*
+	 * the second ww_mutex_lock will detect the
+	 * mismatch of the first one
+	 */
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+}
+
+static void ww_test_mismatch_ww_normal_slow(void)
+{
+	int ret;
+
+	WWAI(&t);
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+	WWU1(&o);
+
+	ww_mutex_lock_slow(&o, &t);
+}
+
+static void ww_test_context_block(void)
+{
+	int ret;
+
+	WWAI(&t);
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+	WWL1(&o2);
+}
+
+static void ww_test_context_try(void)
+{
+	int ret;
+
+	WWAI(&t);
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWT1(&o2);
+	WARN_ON(!ret);
+	WWU1(&o2);
+	WWU(&o);
+}
+
+static void ww_test_context_context(void)
+{
+	int ret;
+
+	WWAI(&t);
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret);
+
+	WWU(&o2);
+	WWU(&o);
+}
+
+static void ww_test_try_block(void)
+{
+	bool ret;
+
+	ret = WWT1(&o);
+	WARN_ON(!ret);
+
+	WWL1(&o2);
+	WWU1(&o2);
+	WWU1(&o);
+}
+
+static void ww_test_try_try(void)
+{
+	bool ret;
+
+	ret = WWT1(&o);
+	WARN_ON(!ret);
+	ret = WWT1(&o2);
+	WARN_ON(!ret);
+	WWU1(&o2);
+	WWU1(&o);
+}
+
+static void ww_test_try_context(void)
+{
+	int ret;
+
+	ret = WWT1(&o);
+	WARN_ON(!ret);
+
+	WWAI(&t);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret);
+}
+
+static void ww_test_block_block(void)
+{
+	WWL1(&o);
+	WWL1(&o2);
+}
+
+static void ww_test_block_try(void)
+{
+	bool ret;
+
+	WWL1(&o);
+	ret = WWT1(&o2);
+	WARN_ON(!ret);
+}
+
+static void ww_test_block_context(void)
+{
+	int ret;
+
+	WWL1(&o);
+	WWAI(&t);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret);
+}
+
+static void ww_test_spin_block(void)
+{
+	L(A);
+	U(A);
+
+	WWL1(&o);
+	L(A);
+	U(A);
+	WWU1(&o);
+
+	L(A);
+	WWL1(&o);
+	WWU1(&o);
+	U(A);
+}
+
+static void ww_test_spin_try(void)
+{
+	bool ret;
+
+	L(A);
+	U(A);
+
+	ret = WWT1(&o);
+	WARN_ON(!ret);
+	L(A);
+	U(A);
+	WWU1(&o);
+
+	L(A);
+	ret = WWT1(&o);
+	WARN_ON(!ret);
+	WWU1(&o);
+	U(A);
+}
+
+static void ww_test_spin_context(void)
+{
+	int ret;
+
+	L(A);
+	U(A);
+
+	WWAI(&t);
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+	L(A);
+	U(A);
+	WWU(&o);
+
+	L(A);
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+	WWU(&o);
+	U(A);
+}
+
+static void ww_tests(void)
+{
+	printk("  --------------------------------------------------------------------------\n");
+	printk("  | Wound/wait tests |\n");
+	printk("  ---------------------\n");
+
+	print_testname("ww api failures");
+	dotest(ww_test_fail_acquire, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_normal, SUCCESS, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("using two ww contexts");
+	dotest(ww_test_two_contexts, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("finish ww context twice");
+	dotest(ww_test_context_unlock_twice, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("unlock twice");
+	dotest(ww_test_object_unlock_twice, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("spinlock nest unlocked");
+	dotest(ww_test_spin_nest_unlocked, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("ww mutex (un)lock mismatch");
+	dotest(ww_test_mismatch_normal_ww, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_mismatch_ww_normal, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_mismatch_ww_normal_slow, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	printk("  -----------------------------------------------------\n");
+	printk("                                 |block | try  |context|\n");
+	printk("  -----------------------------------------------------\n");
+
+	print_testname("context");
+	dotest(ww_test_context_block, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_context_try, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_context_context, SUCCESS, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("try");
+	dotest(ww_test_try_block, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_try_try, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_try_context, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("block");
+	dotest(ww_test_block_block, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_block_try, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_block_context, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("spinlock");
+	dotest(ww_test_spin_block, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_spin_try, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_spin_context, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+}
 
 void locking_selftest(void)
 {
@@ -1188,6 +1587,8 @@ void locking_selftest(void)
 	DO_TESTCASE_6x2("irq read-recursion", irq_read_recursion);
 //	DO_TESTCASE_6x2B("irq read-recursion #2", irq_read_recursion2);
 
+	ww_tests();
+
 	if (unexpected_testcase_failures) {
 		printk("-----------------------------------------------------------------\n");
 		debug_locks = 0;

