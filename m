Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:39061 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752850AbeFFVJp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Jun 2018 17:09:45 -0400
Date: Wed, 6 Jun 2018 22:09:40 +0100
From: Sean Young <sean@mess.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Matthias Reichl <hias@horus.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Y Song <ys114321@gmail.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH] bpf: attach type BPF_LIRC_MODE2 should not depend on
 CONFIG_BPF_CGROUP
Message-ID: <20180606210939.q3vviyc4b2h6gu3c@gofer.mess.org>
References: <cover.1527419762.git.sean@mess.org>
 <9f2c54d4956f962f44fcda739a824397ddea132c.1527419762.git.sean@mess.org>
 <20180604174730.sctfoklq7klswebp@camel2.lan>
 <20180605101629.yffyp64o7adg6hu5@gofer.mess.org>
 <04cc36e7-4597-dc57-4ad7-71afcc17244a@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04cc36e7-4597-dc57-4ad7-71afcc17244a@iogearbox.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compile bpf_prog_{attach,detach,query} even if CONFIG_BPF_CGROUP is not
set.

Signed-off-by: Sean Young <sean@mess.org>
---
 include/linux/bpf-cgroup.h |  31 +++++++++++
 kernel/bpf/cgroup.c        | 110 +++++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c       | 105 ++---------------------------------
 3 files changed, 145 insertions(+), 101 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 975fb4cf1bb7..ee67cd35f426 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -188,12 +188,43 @@ int __cgroup_bpf_check_dev_permission(short dev_type, u32 major, u32 minor,
 									      \
 	__ret;								      \
 })
+int sockmap_get_from_fd(const union bpf_attr *attr, int type, bool attach);
+int cgroup_bpf_prog_attach(const union bpf_attr *attr,
+			   enum bpf_prog_type ptype);
+int cgroup_bpf_prog_detach(const union bpf_attr *attr,
+			   enum bpf_prog_type ptype);
+int cgroup_bpf_prog_query(const union bpf_attr *attr,
+			  union bpf_attr __user *uattr);
 #else
 
 struct cgroup_bpf {};
 static inline void cgroup_bpf_put(struct cgroup *cgrp) {}
 static inline int cgroup_bpf_inherit(struct cgroup *cgrp) { return 0; }
 
+static inline int sockmap_get_from_fd(const union bpf_attr *attr,
+				      int type, bool attach)
+{
+	return -EINVAL;
+}
+
+static inline int cgroup_bpf_prog_attach(const union bpf_attr *attr,
+					 enum bpf_prog_type ptype)
+{
+	return -EINVAL;
+}
+
+static inline int cgroup_bpf_prog_detach(const union bpf_attr *attr,
+					 enum bpf_prog_type ptype)
+{
+	return -EINVAL;
+}
+
+static inline int cgroup_bpf_prog_query(const union bpf_attr *attr,
+					union bpf_attr __user *uattr)
+{
+	return -EINVAL;
+}
+
 #define cgroup_bpf_enabled (0)
 #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
 #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk,skb) ({ 0; })
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index f7c00bd6f8e4..d6e18f9dc0c4 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -428,6 +428,116 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	return ret;
 }
 
+int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
+				      enum bpf_attach_type attach_type)
+{
+	switch (prog->type) {
+	case BPF_PROG_TYPE_CGROUP_SOCK:
+	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
+		return attach_type == prog->expected_attach_type ? 0 : -EINVAL;
+	default:
+		return 0;
+	}
+}
+
+int sockmap_get_from_fd(const union bpf_attr *attr, int type, bool attach)
+{
+	struct bpf_prog *prog = NULL;
+	int ufd = attr->target_fd;
+	struct bpf_map *map;
+	struct fd f;
+	int err;
+
+	f = fdget(ufd);
+	map = __bpf_map_get(f);
+	if (IS_ERR(map))
+		return PTR_ERR(map);
+
+	if (attach) {
+		prog = bpf_prog_get_type(attr->attach_bpf_fd, type);
+		if (IS_ERR(prog)) {
+			fdput(f);
+			return PTR_ERR(prog);
+		}
+	}
+
+	err = sock_map_prog(map, prog, attr->attach_type);
+	if (err) {
+		fdput(f);
+		if (prog)
+			bpf_prog_put(prog);
+		return err;
+	}
+
+	fdput(f);
+	return 0;
+}
+
+int cgroup_bpf_prog_attach(const union bpf_attr *attr, enum bpf_prog_type ptype)
+{
+	struct bpf_prog *prog;
+	struct cgroup *cgrp;
+	int ret;
+
+	prog = bpf_prog_get_type(attr->attach_bpf_fd, ptype);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	if (bpf_prog_attach_check_attach_type(prog, attr->attach_type)) {
+		bpf_prog_put(prog);
+		return -EINVAL;
+	}
+
+	cgrp = cgroup_get_from_fd(attr->target_fd);
+	if (IS_ERR(cgrp)) {
+		bpf_prog_put(prog);
+		return PTR_ERR(cgrp);
+	}
+
+	ret = cgroup_bpf_attach(cgrp, prog, attr->attach_type,
+				attr->attach_flags);
+	if (ret)
+		bpf_prog_put(prog);
+	cgroup_put(cgrp);
+
+	return ret;
+}
+
+int cgroup_bpf_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype)
+{
+	struct bpf_prog *prog;
+	struct cgroup *cgrp;
+	int ret;
+
+	cgrp = cgroup_get_from_fd(attr->target_fd);
+	if (IS_ERR(cgrp))
+		return PTR_ERR(cgrp);
+
+	prog = bpf_prog_get_type(attr->attach_bpf_fd, ptype);
+	if (IS_ERR(prog))
+		prog = NULL;
+
+	ret = cgroup_bpf_detach(cgrp, prog, attr->attach_type, 0);
+	if (prog)
+		bpf_prog_put(prog);
+	cgroup_put(cgrp);
+	return ret;
+}
+
+int cgroup_bpf_prog_query(const union bpf_attr *attr,
+			  union bpf_attr __user *uattr)
+{
+	struct cgroup *cgrp;
+	int ret;
+
+	cgrp = cgroup_get_from_fd(attr->query.target_fd);
+	if (IS_ERR(cgrp))
+		return PTR_ERR(cgrp);
+	ret = cgroup_bpf_query(cgrp, attr, uattr);
+	cgroup_put(cgrp);
+	return ret;
+}
+
 /**
  * __cgroup_bpf_run_filter_skb() - Run a program for packet filtering
  * @sk: The socket sending or receiving traffic
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 0fa20624707f..52fa44856623 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1489,65 +1489,14 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 	return err;
 }
 
-#ifdef CONFIG_CGROUP_BPF
-
-static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
-					     enum bpf_attach_type attach_type)
-{
-	switch (prog->type) {
-	case BPF_PROG_TYPE_CGROUP_SOCK:
-	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
-		return attach_type == prog->expected_attach_type ? 0 : -EINVAL;
-	default:
-		return 0;
-	}
-}
-
 #define BPF_PROG_ATTACH_LAST_FIELD attach_flags
 
-static int sockmap_get_from_fd(const union bpf_attr *attr,
-			       int type, bool attach)
-{
-	struct bpf_prog *prog = NULL;
-	int ufd = attr->target_fd;
-	struct bpf_map *map;
-	struct fd f;
-	int err;
-
-	f = fdget(ufd);
-	map = __bpf_map_get(f);
-	if (IS_ERR(map))
-		return PTR_ERR(map);
-
-	if (attach) {
-		prog = bpf_prog_get_type(attr->attach_bpf_fd, type);
-		if (IS_ERR(prog)) {
-			fdput(f);
-			return PTR_ERR(prog);
-		}
-	}
-
-	err = sock_map_prog(map, prog, attr->attach_type);
-	if (err) {
-		fdput(f);
-		if (prog)
-			bpf_prog_put(prog);
-		return err;
-	}
-
-	fdput(f);
-	return 0;
-}
-
 #define BPF_F_ATTACH_MASK \
 	(BPF_F_ALLOW_OVERRIDE | BPF_F_ALLOW_MULTI)
 
 static int bpf_prog_attach(const union bpf_attr *attr)
 {
 	enum bpf_prog_type ptype;
-	struct bpf_prog *prog;
-	struct cgroup *cgrp;
-	int ret;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -1593,28 +1542,7 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 		return -EINVAL;
 	}
 
-	prog = bpf_prog_get_type(attr->attach_bpf_fd, ptype);
-	if (IS_ERR(prog))
-		return PTR_ERR(prog);
-
-	if (bpf_prog_attach_check_attach_type(prog, attr->attach_type)) {
-		bpf_prog_put(prog);
-		return -EINVAL;
-	}
-
-	cgrp = cgroup_get_from_fd(attr->target_fd);
-	if (IS_ERR(cgrp)) {
-		bpf_prog_put(prog);
-		return PTR_ERR(cgrp);
-	}
-
-	ret = cgroup_bpf_attach(cgrp, prog, attr->attach_type,
-				attr->attach_flags);
-	if (ret)
-		bpf_prog_put(prog);
-	cgroup_put(cgrp);
-
-	return ret;
+	return cgroup_bpf_prog_attach(attr, ptype);
 }
 
 #define BPF_PROG_DETACH_LAST_FIELD attach_type
@@ -1622,9 +1550,6 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 static int bpf_prog_detach(const union bpf_attr *attr)
 {
 	enum bpf_prog_type ptype;
-	struct bpf_prog *prog;
-	struct cgroup *cgrp;
-	int ret;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -1667,19 +1592,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 		return -EINVAL;
 	}
 
-	cgrp = cgroup_get_from_fd(attr->target_fd);
-	if (IS_ERR(cgrp))
-		return PTR_ERR(cgrp);
-
-	prog = bpf_prog_get_type(attr->attach_bpf_fd, ptype);
-	if (IS_ERR(prog))
-		prog = NULL;
-
-	ret = cgroup_bpf_detach(cgrp, prog, attr->attach_type, 0);
-	if (prog)
-		bpf_prog_put(prog);
-	cgroup_put(cgrp);
-	return ret;
+	return cgroup_bpf_prog_detach(attr, ptype);
 }
 
 #define BPF_PROG_QUERY_LAST_FIELD query.prog_cnt
@@ -1687,9 +1600,6 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 static int bpf_prog_query(const union bpf_attr *attr,
 			  union bpf_attr __user *uattr)
 {
-	struct cgroup *cgrp;
-	int ret;
-
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 	if (CHECK_ATTR(BPF_PROG_QUERY))
@@ -1717,14 +1627,9 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	default:
 		return -EINVAL;
 	}
-	cgrp = cgroup_get_from_fd(attr->query.target_fd);
-	if (IS_ERR(cgrp))
-		return PTR_ERR(cgrp);
-	ret = cgroup_bpf_query(cgrp, attr, uattr);
-	cgroup_put(cgrp);
-	return ret;
+
+	return cgroup_bpf_prog_query(attr, uattr);
 }
-#endif /* CONFIG_CGROUP_BPF */
 
 #define BPF_PROG_TEST_RUN_LAST_FIELD test.duration
 
@@ -2371,7 +2276,6 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_OBJ_GET:
 		err = bpf_obj_get(&attr);
 		break;
-#ifdef CONFIG_CGROUP_BPF
 	case BPF_PROG_ATTACH:
 		err = bpf_prog_attach(&attr);
 		break;
@@ -2381,7 +2285,6 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_PROG_QUERY:
 		err = bpf_prog_query(&attr, uattr);
 		break;
-#endif
 	case BPF_PROG_TEST_RUN:
 		err = bpf_prog_test_run(&attr, uattr);
 		break;
-- 
2.17.1
