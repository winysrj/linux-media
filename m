Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35841 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbcFXJJw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 05:09:52 -0400
From: Chris Wilson <chris@chris-wilson.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Tejun Heo <tj@kernel.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: [PATCH 9/9] async: Introduce a dependency resolver for parallel execution
Date: Fri, 24 Jun 2016 10:08:53 +0100
Message-Id: <1466759333-4703-10-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A challenge in driver initialisation is the coordination of many small
sometimes independent, sometimes interdependent tasks. We would like to
schedule the independent tasks for execution in parallel across as many
cores as possible for rapid initialisation, and then schedule all the
dependent tasks once they have completed, again running as many of those
in parallel as is possible.

Resolving the interdependencies by hand is time consuming and error
prone. Instead, we want to declare what dependencies a particular task
has, and what that task provides, and let a runtime dependency solver
work out what tasks to run and when, and which in parallel. To this end,
we introduce the struct async_dependency_graph building upon the kfence
and async_work from the previous patches to allow for the runtime
computation of the topological task ordering.

The graph is constructed with async_dependency_graph_build(), which
takes the task, its dependencies and what it provides, and builds the
graph of kfences required for ordering. Additional kfences can be
inserted through async_dependency_depends() and
async_dependency_provides() for manual control of the execution order,
and async_dependency_get() retrieves a kfence for inspection or waiting
upon.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
---
 include/linux/async.h                              |  37 +++
 kernel/async.c                                     | 250 ++++++++++++++++
 lib/Kconfig.debug                                  |  12 +
 lib/Makefile                                       |   1 +
 lib/test-async-dependency-graph.c                  | 317 +++++++++++++++++++++
 .../selftests/lib/async-dependency-graph.sh        |  10 +
 6 files changed, 627 insertions(+)
 create mode 100644 lib/test-async-dependency-graph.c
 create mode 100755 tools/testing/selftests/lib/async-dependency-graph.sh

diff --git a/include/linux/async.h b/include/linux/async.h
index 64a090e3f24f..c9cadb383813 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/kfence.h>
 #include <linux/list.h>
+#include <linux/rbtree.h>
 
 typedef u64 async_cookie_t;
 typedef void (*async_func_t) (void *data, async_cookie_t cookie);
@@ -101,4 +102,40 @@ extern async_cookie_t queue_async_work(struct async_domain *domain,
 				       gfp_t gfp);
 extern async_cookie_t schedule_async_work(struct async_work *work);
 
+/* Build a graph of work based on dependencies generated by keywords.
+ * The graph must be acyclic. Can be used to both generate a topological
+ * ordering of tasks, and to execute independent chains of tasks in
+ * parallel.
+ */
+
+struct async_dependency_graph {
+	struct rb_root root;
+	struct list_head list;
+};
+
+#define ASYNC_DEPENDENCY_GRAPH_INIT(_name) {				\
+	.root = RB_ROOT,						\
+	.list = LIST_HEAD_INIT(_name.list),				\
+}
+#define ASYNC_DEPENDENCY_GRAPH(_name) \
+	struct async_dependency_graph _name = ASYNC_DEPENDENCY_GRAPH_INIT(_name)
+
+extern int async_dependency_graph_build(struct async_dependency_graph *adg,
+					async_func_t fn, void *data,
+					const char *depends,
+					const char *provides);
+
+extern int async_dependency_depends(struct async_dependency_graph *adg,
+				    struct kfence *fence,
+				    const char *depends);
+
+extern int async_dependency_provides(struct async_dependency_graph *adg,
+				     struct kfence *fence,
+				     const char *provides);
+
+extern struct kfence *async_dependency_get(struct async_dependency_graph *adg,
+					   const char *name);
+
+extern void async_dependency_graph_execute(struct async_dependency_graph *adg);
+
 #endif
diff --git a/kernel/async.c b/kernel/async.c
index a22945f4b4c4..8330d719074b 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -1005,3 +1005,253 @@ void init_async_domain(struct async_domain *domain, bool registered)
 	domain->registered = registered;
 }
 EXPORT_SYMBOL_GPL(init_async_domain);
+
+struct async_dependency {
+	struct kfence fence;
+	struct rb_node node;
+	struct list_head link;
+	char name[0];
+};
+
+static struct async_dependency *
+__lookup_dependency(struct async_dependency_graph *adg, const char *name)
+{
+	struct rb_node **p, *parent;
+	struct async_dependency *d;
+	int len;
+
+	parent = NULL;
+	p = &adg->root.rb_node;
+	while (*p) {
+		int cmp;
+
+		parent = *p;
+		d = container_of(parent, typeof(*d), node);
+
+		cmp = strcmp(name, d->name);
+		if (cmp < 0)
+			p = &parent->rb_left;
+		else if (cmp > 0)
+			p = &parent->rb_right;
+		else
+			return d;
+	}
+
+	len = strlen(name) + 1;
+	d = kmalloc(sizeof(*d) + len, GFP_KERNEL);
+	if (!d)
+		return ERR_PTR(-ENOMEM);
+
+	__kfence_init(&d->fence);
+	memcpy(d->name, name, len);
+
+	rb_link_node(&d->node, parent, p);
+	rb_insert_color(&d->node, &adg->root);
+	list_add_tail(&d->link, &adg->list);
+
+	return d;
+}
+
+/**
+ * async_dependency_depends - declare a prerequisite fence for a named stage
+ * @adg: the async_dependency_graph for tracking the named stages
+ * @fence: the kfence to add that depends upon the named stage completing
+ * @depends: the named stage
+ *
+ * This function appends @fence into the async_dependency_graph @adg after
+ * the @depends stage is completed. That is the @fence is signaled once
+ * the chain of dependencies upto and including @depends is complete.
+ *
+ * Returns: 0 on success, negative error code on failure.
+ * In particular, note that if CONFIG_KFENCE_CHECK_DAG is enabled, the
+ * dependency graph will be checked for cycles, and -EINVAL reported
+ * in such cases. A dependency cycle leads to unexecutable code.
+ */
+int async_dependency_depends(struct async_dependency_graph *adg,
+			     struct kfence *fence,
+			     const char *depends)
+{
+	struct async_dependency *d;
+
+	d = __lookup_dependency(adg, depends);
+	if (IS_ERR(d))
+		return PTR_ERR(d);
+
+	return kfence_add(fence, &d->fence, GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(async_dependency_depends);
+
+/**
+ * async_dependency_provides - declare a named stage that should follow
+ * @adg: the async_dependency_graph for tracking the named stages
+ * @fence: the kfence to add that provides the named stage with a signal
+ * @depends: the named stage
+ *
+ * This function inserts @fence into the async_dependency_graph @adg before
+ * the @provides stage is signaled. That is the @fence signals the
+ * @provides stage once completed (and once all providers have completed,
+ * work from the @provides commences).
+ *
+ * Returns: 0 on success, negative error code on failure.
+ * In particular, note that if CONFIG_KFENCE_CHECK_DAG is enabled, the
+ * dependency graph will be checked for cycles, and -EINVAL reported
+ * in such cases. A dependency cycle leads to unexecutable code.
+ */
+int async_dependency_provides(struct async_dependency_graph *adg,
+			      struct kfence *fence,
+			      const char *provides)
+{
+	struct async_dependency *d;
+
+	d = __lookup_dependency(adg, provides);
+	if (IS_ERR(d))
+		return PTR_ERR(d);
+
+	return kfence_add(&d->fence, fence, GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(async_dependency_provides);
+
+/**
+ * async_dependency_get - lookup the kfence for a named stage
+ * @adg: the async_dependency_graph for tracking the named stages
+ * @name: the named stage
+ *
+ * This function lookups the kfence associated with the named stage. This
+ * fence will be signaled once the named stage is ready. For example,
+ * waiting on that fence will wait until all prior dependencies of that
+ * named stage have been completed.
+ *
+ * Returns: a new reference on the kfence. The caller must release the
+ * reference with kfence_put() when finished.
+ */
+struct kfence *async_dependency_get(struct async_dependency_graph *adg,
+				    const char *name)
+{
+	struct async_dependency *d;
+
+	d = __lookup_dependency(adg, name);
+	if (IS_ERR(d))
+		return ERR_CAST(d);
+
+	return kfence_get(&d->fence);
+}
+EXPORT_SYMBOL_GPL(async_dependency_get);
+
+static int __adg_for_each_token(struct async_dependency_graph *adg,
+				struct kfence *fence,
+				const char *string,
+				int (*fn)(struct async_dependency_graph *,
+					  struct kfence *,
+					  const char *))
+{
+	char *tmp, *s, *t;
+	int ret = 0;
+
+	if (!string)
+		return 0;
+
+	tmp = kstrdup(string, GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
+	for (s = tmp; (t = strsep(&s, ",")); ) {
+		if (*t == '\0')
+			continue;
+
+		ret |= fn(adg, fence, t);
+		if (ret < 0)
+			break;
+	}
+
+	kfree(tmp);
+	return ret;
+}
+
+/**
+ * async_dependency_graph_build - insert a task into the dependency graph
+ * @adg: the async_dependency_graph for tracking the named stages
+ * @fn: the async_func_t to execute
+ * @data: the data to pass to the @fn
+ * @depends: a comma-separated list of named stages that must complete
+ *           before the task can execute
+ * @provides: a comma-separated list of named stages that will be signaled
+ *            when this task completes
+ *
+ * This function inserts the task @fn into the async_dependency_graph @adg
+ * after all the named stages in @depends have completed. Upon completion
+ * of the task, all the named stages in @provides are signaled (and once all
+ * their dependent tasks have also finished, the tasks afterwards will
+ * execute).
+ *
+ * If a task has no dependency (@depends is NULL or an empty string), it will
+ * be scheduled for execution as soon as it is inserted into the graph @adg.
+ *
+ * Returns: 0 on success, negative error code on failure.
+ * In particular, note that if CONFIG_KFENCE_CHECK_DAG is enabled, the
+ * dependency graph will be checked for cycles, and -EINVAL reported
+ * in such cases. A dependency cycle leads to unexecutable code.
+ */
+int
+async_dependency_graph_build(struct async_dependency_graph *adg,
+			     async_func_t fn, void *data,
+			     const char *depends, const char *provides)
+{
+	struct async_work *work;
+	int ret;
+
+	work = async_work_create(fn, data, GFP_KERNEL);
+	if (!work)
+		return -ENOMEM;
+
+	ret = __adg_for_each_token(adg, &work->fence, depends,
+				   async_dependency_depends);
+	if (ret < 0)
+		goto err;
+
+	ret = __adg_for_each_token(adg, &work->fence, provides,
+				   async_dependency_provides);
+	if (ret < 0)
+		goto err;
+
+	if (!schedule_async_work(work)) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = 0;
+out:
+	async_work_put(work);
+	return ret;
+
+err:
+	clear_bit(ASYNC_WORK_BIT, &work->fence.flags);
+	kfence_signal(&work->fence);
+	goto out;
+}
+EXPORT_SYMBOL_GPL(async_dependency_graph_build);
+
+/**
+ * async_dependency_graph_execute - execute the dependency graph
+ * @adg: the async_dependency_graph
+ *
+ * This function marks the @adg as ready for execution. As soon as the
+ * dependencies of a task have been completed (in their entirety), that
+ * task is executed. Once completed, it signals the tasks that have listed
+ * its @provides as one of their @depends, and once ready (all @provides are
+ * complete) those tasks are scheduled for execution.
+ *
+ * Tasks are executed in the topological order of their dependencies. If two,
+ * or more, tasks are not dependent on each other they may be run concurrently.
+ *
+ * The graph @adg is freed upon execution.
+ */
+void async_dependency_graph_execute(struct async_dependency_graph *adg)
+{
+	struct async_dependency *d, *next;
+
+	list_for_each_entry_safe(d, next, &adg->list, link) {
+		kfence_signal(&d->fence);
+		kfence_put(&d->fence);
+	}
+}
+EXPORT_SYMBOL_GPL(async_dependency_graph_execute);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 47319f501954..4943b8dbcdf1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1798,6 +1798,18 @@ config ASYNC_DOMAIN_SELFTEST
 
 	  Say N if you are unsure.
 
+config ASYNC_DEPENDENCY_GRAPH_SELFTEST
+	tristate "Asynchronous dependency graph self tests"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  This option provides a kernel modules that can be used to test
+	  the asynchronous dependency graph. This option is not useful for
+	  distributions or general kernels, but only for kernel developers
+	  working on the async_dependency_graph facility.
+
+	  Say N if you are unsure.
+
 config BACKTRACE_SELF_TEST
 	tristate "Self test for the backtrace code"
 	depends on DEBUG_KERNEL
diff --git a/lib/Makefile b/lib/Makefile
index 82e8b5f77c44..fa7da38d4383 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -30,6 +30,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 obj-$(CONFIG_KFENCE_SELFTEST) += test-kfence.o
 obj-$(CONFIG_ASYNC_DOMAIN_SELFTEST) += test-async-domain.o
+obj-$(CONFIG_ASYNC_DEPENDENCY_GRAPH_SELFTEST) += test-async-dependency-graph.o
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 lib-$(CONFIG_HAS_DMA) += dma-noop.o
diff --git a/lib/test-async-dependency-graph.c b/lib/test-async-dependency-graph.c
new file mode 100644
index 000000000000..ebee26d7b99e
--- /dev/null
+++ b/lib/test-async-dependency-graph.c
@@ -0,0 +1,317 @@
+/*
+ * Test cases for async-dependency-graph facility.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/async.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+struct chain {
+	atomic_t idx;
+	unsigned long values[0];
+};
+
+struct task_write {
+	struct chain *chain;
+	unsigned long value;
+};
+
+static void __init task_write(void *arg, async_cookie_t cookie)
+{
+	struct task_write *t = arg;
+	int idx = atomic_inc_return(&t->chain->idx) - 1;
+	WRITE_ONCE(t->chain->values[idx], t->value);
+}
+
+static void __init task_nop(void *data, async_cookie_t cookie)
+{
+}
+
+static int __init test_ordering(int nchain, int nwide)
+{
+	ASYNC_DEPENDENCY_GRAPH(adg);
+	struct chain **chains;
+	struct task_write *tests, *t;
+	int c, w, ret;
+
+	/* Test implementation of simple chains within the dependency graphs */
+	pr_debug("%s(nchain=%d, nwide=%d)\n", __func__, nchain, nwide);
+
+	chains = kmalloc(sizeof(struct chain *)*nwide, GFP_KERNEL);
+	tests = kmalloc(sizeof(struct task_write)*nwide*nchain, GFP_KERNEL);
+
+	if (!chains || !tests)
+		return -ENOMEM;
+
+	t = tests;
+	for (w = 0; w < nwide; w++) {
+		char *depends = NULL, *provides;
+
+		chains[w] = kzalloc(sizeof(struct chain) +
+				    nchain*sizeof(unsigned long),
+				    GFP_KERNEL);
+
+		for (c = 0; c < nchain; c++) {
+			t->chain = chains[w];
+			t->value = c;
+			provides = kasprintf(GFP_KERNEL, "%d.%d", c, w);
+			async_dependency_graph_build(&adg, task_write, t,
+						     depends, provides);
+			kfree(depends);
+			depends = provides;
+			t++;
+		}
+
+		kfree(depends);
+	}
+	async_dependency_graph_execute(&adg);
+	async_synchronize_full();
+
+	ret = 0;
+	kfree(tests);
+	for (w = 0; w < nwide; w++) {
+		for (c = 0; c < nchain; c++) {
+			if (chains[w]->values[c] != c) {
+				pr_err("%s(%d, %d): Invalid execution order (chain %d, position %d): found %d\n",
+				       __func__, nchain, nwide,
+				       w, c, (int)chains[w]->values[c]);
+
+				ret = -EINVAL;
+			}
+		}
+		kfree(chains[w]);
+	}
+	kfree(chains);
+
+	return ret;
+}
+
+static int __init test_barrier(int nwide)
+{
+	ASYNC_DEPENDENCY_GRAPH(adg);
+	struct chain **chains;
+	struct task_write *tests, *t;
+	int c, w, ret;
+
+	/* Test implementation of barriers within the dependency graphs */
+	pr_debug("%s(nwide=%d)\n", __func__, nwide);
+
+	chains = kmalloc(sizeof(struct chain *)*nwide, GFP_KERNEL);
+	tests = kmalloc(sizeof(struct task_write)*2*nwide, GFP_KERNEL);
+	if (!chains || !tests)
+		return -ENOMEM;
+
+	t = tests;
+
+	/* A,B act as a barrier running between the nops */
+	for (w = 0; w < nwide; w++) {
+		char *provides, *depends;
+
+		chains[w] = kzalloc(sizeof(struct chain) +
+				    2*sizeof(unsigned long),
+				    GFP_KERNEL);
+
+		depends = NULL;
+
+		provides = kasprintf(GFP_KERNEL, "nop1.%d", w);
+		async_dependency_graph_build(&adg, task_nop, NULL,
+					     depends, provides);
+		async_dependency_graph_build(&adg, task_nop, NULL,
+					     depends, provides);
+
+		kfree(depends);
+		depends = provides;
+
+		provides = kasprintf(GFP_KERNEL, "A.%d", w);
+		t->chain = chains[w];
+		t->value = 0;
+		async_dependency_graph_build(&adg, task_write, t,
+					     depends, provides);
+		t++;
+
+		kfree(depends);
+		depends = provides;
+
+		provides = kasprintf(GFP_KERNEL, "nop2.%d", w);
+		async_dependency_graph_build(&adg, task_nop, NULL,
+					     depends, provides);
+		kfree(provides);
+
+		provides = kasprintf(GFP_KERNEL, "nop3.%d", w);
+		async_dependency_graph_build(&adg, task_nop, NULL,
+					     depends, provides);
+		kfree(provides);
+
+		kfree(depends);
+		depends = kasprintf(GFP_KERNEL, "nop2.%d,nop3.%d", w, w);
+		t->chain = chains[w];
+		t->value = 1;
+		async_dependency_graph_build(&adg, task_write, t,
+					     depends, NULL);
+		kfree(depends);
+		t++;
+	}
+	async_dependency_graph_execute(&adg);
+	async_synchronize_full();
+
+	ret = 0;
+	kfree(tests);
+	for (w = 0; w < nwide; w++) {
+		for (c = 0; c < 2; c++) {
+			if (chains[w]->values[c] != c) {
+				pr_err("%s(%d): Invalid execution order (chain %d, position %d): found %d\n",
+				       __func__, nwide,
+				       w, c, (int)chains[w]->values[c]);
+
+				ret = -EINVAL;
+			}
+		}
+		kfree(chains[w]);
+	}
+	kfree(chains);
+
+	return ret;
+}
+
+static int __init test_dag(void)
+{
+	ASYNC_DEPENDENCY_GRAPH(adg);
+
+	/* Test detection of cycles within the dependency graphs */
+	pr_debug("%s\n", __func__);
+
+	if (!config_enabled(CONFIG_KFENCE_CHECK_DAG))
+		return 0;
+
+	async_dependency_graph_build(&adg, task_nop, NULL, "__start__", "A");
+	if (async_dependency_graph_build(&adg, task_nop, NULL, "A", "A") != -EINVAL) {
+		pr_err("Failed to detect AA cycle\n");
+		return -EINVAL;
+	}
+
+	async_dependency_graph_build(&adg, task_nop, NULL, "A", "B");
+	if (async_dependency_graph_build(&adg, task_nop, NULL, "B", "A") != -EINVAL) {
+		pr_err("Failed to detect ABA cycle\n");
+		return -EINVAL;
+	}
+
+	async_dependency_graph_build(&adg, task_nop, NULL, "B", "C");
+	if (async_dependency_graph_build(&adg, task_nop, NULL, "C", "A") != -EINVAL) {
+		pr_err("Failed to detect ABCA cycle\n");
+		return -EINVAL;
+	}
+
+	async_dependency_graph_execute(&adg);
+	async_synchronize_full();
+
+	return 0;
+}
+
+static int __init perf_nop(int chain, int width, long timeout_us)
+{
+	ktime_t start;
+	long count, delay;
+
+	count = 0;
+	start = ktime_get();
+	do {
+		ASYNC_DEPENDENCY_GRAPH(adg);
+		ktime_t delta;
+		int c, w;
+
+		for (w = 0; w < width; w++) {
+			char *depends = NULL, *provides;
+
+			for (c = 0; c < chain; c++) {
+				provides = kasprintf(GFP_KERNEL, "%d.%d", c, w);
+				async_dependency_graph_build(&adg,
+							     task_nop, NULL,
+							     depends, provides);
+				kfree(depends);
+				depends = provides;
+			}
+
+			kfree(depends);
+		}
+		async_dependency_graph_execute(&adg);
+		async_synchronize_full();
+		delta = ktime_sub(ktime_get(), start);
+		delay = ktime_to_ns(delta) >> 10;
+		count += width * chain;
+	} while (delay < timeout_us);
+
+	pr_info("%ld nop tasks (in chains of %d, %d chains in parallel) completed in %ldus\n",
+		count, chain, width, delay);
+	return 0;
+}
+
+static int __init test_async_dependency_graph_init(void)
+{
+	int ret;
+
+	pr_info("Testing async-dependency-graph\n");
+
+	ret = test_ordering(1, 1);
+	if (ret)
+		return ret;
+
+	ret = test_ordering(2, 1);
+	if (ret)
+		return ret;
+
+	ret = test_ordering(1, 2);
+	if (ret)
+		return ret;
+
+	ret = test_ordering(2, 2);
+	if (ret)
+		return ret;
+
+	ret = test_ordering(26, 26);
+	if (ret)
+		return ret;
+
+	ret = test_dag();
+	if (ret)
+		return ret;
+
+	ret = test_barrier(1);
+	if (ret)
+		return ret;
+
+	ret = test_barrier(16);
+	if (ret)
+		return ret;
+
+	ret = perf_nop(1, 1, 100);
+	if (ret)
+		return ret;
+
+	ret = perf_nop(256, 1, 2000);
+	if (ret)
+		return ret;
+
+	ret = perf_nop(128, 2, 2000);
+	if (ret)
+		return ret;
+
+	ret = perf_nop(16, 16, 2000);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void __exit test_async_dependency_graph_cleanup(void)
+{
+}
+
+module_init(test_async_dependency_graph_init);
+module_exit(test_async_dependency_graph_cleanup);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL");
diff --git a/tools/testing/selftests/lib/async-dependency-graph.sh b/tools/testing/selftests/lib/async-dependency-graph.sh
new file mode 100755
index 000000000000..ea4bbc76f60f
--- /dev/null
+++ b/tools/testing/selftests/lib/async-dependency-graph.sh
@@ -0,0 +1,10 @@
+#!/bin/sh
+# Runs infrastructure tests using test-async-dependency-graph kernel module
+
+if /sbin/modprobe -q test-async-dependency-graph; then
+	/sbin/modprobe -q -r test-async-dependency-graph
+	echo "async-dependency-graph: ok"
+else
+	echo "async-dependency-graph: [FAIL]"
+	exit 1
+fi
-- 
2.8.1

