Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40209 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932762AbeFRRMT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 13:12:19 -0400
Date: Mon, 18 Jun 2018 18:12:16 +0100
From: Sean Young <sean@mess.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Y Song <ys114321@gmail.com>, Matthias Reichl <hias@horus.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH v3] bpf: attach type BPF_LIRC_MODE2 should not depend on
 CONFIG_CGROUP_BPF
Message-ID: <20180618171216.gearpr755pm3wot7@gofer.mess.org>
References: <cover.1527419762.git.sean@mess.org>
 <9f2c54d4956f962f44fcda739a824397ddea132c.1527419762.git.sean@mess.org>
 <20180604174730.sctfoklq7klswebp@camel2.lan>
 <20180605101629.yffyp64o7adg6hu5@gofer.mess.org>
 <04cc36e7-4597-dc57-4ad7-71afcc17244a@iogearbox.net>
 <20180606210939.q3vviyc4b2h6gu3c@gofer.mess.org>
 <CAH3MdRXE8=dE25Sj3TPDzVh7ytnvCkUDvCDzZkEZe0N84dy-Zw@mail.gmail.com>
 <34406f72-722d-9c23-327f-b7c5d7a3090c@iogearbox.net>
 <20180614184207.khwcmwmj4duous4c@gofer.mess.org>
 <d2613314-406e-dd7d-1cf0-b5a78a155e3b@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2613314-406e-dd7d-1cf0-b5a78a155e3b@iogearbox.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the kernel is compiled with CONFIG_CGROUP_BPF not enabled, it is not
possible to attach, detach or query IR BPF programs to /dev/lircN devices,
making them impossible to use. For embedded devices, it should be possible
to use IR decoding without cgroups or CONFIG_CGROUP_BPF enabled.

This change requires some refactoring, since bpf_prog_{attach,detach,query}
functions are now always compiled, but their code paths for cgroups need
moving out. Rather than a #ifdef CONFIG_CGROUP_BPF in kernel/bpf/syscall.c,
moving them to kernel/bpf/cgroup.c and kernel/bpf/sockmap.c does not
require #ifdefs since that is already conditionally compiled.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/bpf-lirc.c | 14 +-----
 include/linux/bpf-cgroup.h  | 26 ++++++++++
 include/linux/bpf.h         |  8 +++
 include/linux/bpf_lirc.h    |  5 +-
 kernel/bpf/cgroup.c         | 52 ++++++++++++++++++++
 kernel/bpf/sockmap.c        | 18 +++++++
 kernel/bpf/syscall.c        | 98 ++++++++-----------------------------
 7 files changed, 130 insertions(+), 91 deletions(-)

diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
index 40826bba06b6..fcfab6635f9c 100644
--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -207,29 +207,19 @@ void lirc_bpf_free(struct rc_dev *rcdev)
 	bpf_prog_array_free(rcdev->raw->progs);
 }
 
-int lirc_prog_attach(const union bpf_attr *attr)
+int lirc_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 {
-	struct bpf_prog *prog;
 	struct rc_dev *rcdev;
 	int ret;
 
 	if (attr->attach_flags)
 		return -EINVAL;
 
-	prog = bpf_prog_get_type(attr->attach_bpf_fd,
-				 BPF_PROG_TYPE_LIRC_MODE2);
-	if (IS_ERR(prog))
-		return PTR_ERR(prog);
-
 	rcdev = rc_dev_get_from_fd(attr->target_fd);
-	if (IS_ERR(rcdev)) {
-		bpf_prog_put(prog);
+	if (IS_ERR(rcdev))
 		return PTR_ERR(rcdev);
-	}
 
 	ret = lirc_bpf_attach(rcdev, prog);
-	if (ret)
-		bpf_prog_put(prog);
 
 	put_device(&rcdev->dev);
 
diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 975fb4cf1bb7..79795c5fa7c3 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -188,12 +188,38 @@ int __cgroup_bpf_check_dev_permission(short dev_type, u32 major, u32 minor,
 									      \
 	__ret;								      \
 })
+int cgroup_bpf_prog_attach(const union bpf_attr *attr,
+			   enum bpf_prog_type ptype, struct bpf_prog *prog);
+int cgroup_bpf_prog_detach(const union bpf_attr *attr,
+			   enum bpf_prog_type ptype);
+int cgroup_bpf_prog_query(const union bpf_attr *attr,
+			  union bpf_attr __user *uattr);
 #else
 
+struct bpf_prog;
 struct cgroup_bpf {};
 static inline void cgroup_bpf_put(struct cgroup *cgrp) {}
 static inline int cgroup_bpf_inherit(struct cgroup *cgrp) { return 0; }
 
+static inline int cgroup_bpf_prog_attach(const union bpf_attr *attr,
+					 enum bpf_prog_type ptype,
+					 struct bpf_prog *prog)
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
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 995c3b1e59bf..ac4c73d29f96 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -684,6 +684,8 @@ static inline void bpf_map_offload_map_free(struct bpf_map *map)
 struct sock  *__sock_map_lookup_elem(struct bpf_map *map, u32 key);
 struct sock  *__sock_hash_lookup_elem(struct bpf_map *map, void *key);
 int sock_map_prog(struct bpf_map *map, struct bpf_prog *prog, u32 type);
+int sockmap_get_from_fd(const union bpf_attr *attr, int type,
+			struct bpf_prog *prog);
 #else
 static inline struct sock  *__sock_map_lookup_elem(struct bpf_map *map, u32 key)
 {
@@ -702,6 +704,12 @@ static inline int sock_map_prog(struct bpf_map *map,
 {
 	return -EOPNOTSUPP;
 }
+
+int sockmap_get_from_fd(const union bpf_attr *attr, int type,
+			struct bpf_prog *prog);
+{
+	return -EINVAL;
+}
 #endif
 
 #if defined(CONFIG_XDP_SOCKETS)
diff --git a/include/linux/bpf_lirc.h b/include/linux/bpf_lirc.h
index 5f8a4283092d..9d9ff755ec29 100644
--- a/include/linux/bpf_lirc.h
+++ b/include/linux/bpf_lirc.h
@@ -5,11 +5,12 @@
 #include <uapi/linux/bpf.h>
 
 #ifdef CONFIG_BPF_LIRC_MODE2
-int lirc_prog_attach(const union bpf_attr *attr);
+int lirc_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog);
 int lirc_prog_detach(const union bpf_attr *attr);
 int lirc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr);
 #else
-static inline int lirc_prog_attach(const union bpf_attr *attr)
+static inline int lirc_prog_attach(const union bpf_attr *attr,
+				   struct bpf_prog *prog)
 {
 	return -EINVAL;
 }
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index f7c00bd6f8e4..f0ae8a3d01f9 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -428,6 +428,58 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	return ret;
 }
 
+int cgroup_bpf_prog_attach(const union bpf_attr *attr,
+			   enum bpf_prog_type ptype, struct bpf_prog *prog)
+{
+	struct cgroup *cgrp;
+	int ret;
+
+	cgrp = cgroup_get_from_fd(attr->target_fd);
+	if (IS_ERR(cgrp))
+		return PTR_ERR(cgrp);
+
+	ret = cgroup_bpf_attach(cgrp, prog, attr->attach_type,
+				attr->attach_flags);
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
diff --git a/kernel/bpf/sockmap.c b/kernel/bpf/sockmap.c
index 52a91d816c0e..81d0c55a77aa 100644
--- a/kernel/bpf/sockmap.c
+++ b/kernel/bpf/sockmap.c
@@ -1915,6 +1915,24 @@ int sock_map_prog(struct bpf_map *map, struct bpf_prog *prog, u32 type)
 	return 0;
 }
 
+int sockmap_get_from_fd(const union bpf_attr *attr, int type,
+			struct bpf_prog *prog)
+{
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
+	err = sock_map_prog(map, prog, attr->attach_type);
+	fdput(f);
+	return err;
+}
+
 static void *sock_map_lookup(struct bpf_map *map, void *key)
 {
 	return NULL;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 0fa20624707f..93993c03c9ac 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1489,8 +1489,6 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 	return err;
 }
 
-#ifdef CONFIG_CGROUP_BPF
-
 static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
 					     enum bpf_attach_type attach_type)
 {
@@ -1505,40 +1503,6 @@ static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
 
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
 
@@ -1546,7 +1510,6 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 {
 	enum bpf_prog_type ptype;
 	struct bpf_prog *prog;
-	struct cgroup *cgrp;
 	int ret;
 
 	if (!capable(CAP_NET_ADMIN))
@@ -1583,12 +1546,15 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 		ptype = BPF_PROG_TYPE_CGROUP_DEVICE;
 		break;
 	case BPF_SK_MSG_VERDICT:
-		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_MSG, true);
+		ptype = BPF_PROG_TYPE_SK_MSG;
+		break;
 	case BPF_SK_SKB_STREAM_PARSER:
 	case BPF_SK_SKB_STREAM_VERDICT:
-		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_SKB, true);
+		ptype = BPF_PROG_TYPE_SK_SKB;
+		break;
 	case BPF_LIRC_MODE2:
-		return lirc_prog_attach(attr);
+		ptype = BPF_PROG_TYPE_LIRC_MODE2;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1602,17 +1568,20 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 		return -EINVAL;
 	}
 
-	cgrp = cgroup_get_from_fd(attr->target_fd);
-	if (IS_ERR(cgrp)) {
-		bpf_prog_put(prog);
-		return PTR_ERR(cgrp);
+	switch (ptype) {
+	case BPF_PROG_TYPE_SK_SKB:
+	case BPF_PROG_TYPE_SK_MSG:
+		ret = sockmap_get_from_fd(attr, ptype, prog);
+		break;
+	case BPF_PROG_TYPE_LIRC_MODE2:
+		ret = lirc_prog_attach(attr, prog);
+		break;
+	default:
+		ret = cgroup_bpf_prog_attach(attr, ptype, prog);
 	}
 
-	ret = cgroup_bpf_attach(cgrp, prog, attr->attach_type,
-				attr->attach_flags);
 	if (ret)
 		bpf_prog_put(prog);
-	cgroup_put(cgrp);
 
 	return ret;
 }
@@ -1622,9 +1591,6 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 static int bpf_prog_detach(const union bpf_attr *attr)
 {
 	enum bpf_prog_type ptype;
-	struct bpf_prog *prog;
-	struct cgroup *cgrp;
-	int ret;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -1657,29 +1623,17 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 		ptype = BPF_PROG_TYPE_CGROUP_DEVICE;
 		break;
 	case BPF_SK_MSG_VERDICT:
-		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_MSG, false);
+		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_MSG, NULL);
 	case BPF_SK_SKB_STREAM_PARSER:
 	case BPF_SK_SKB_STREAM_VERDICT:
-		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_SKB, false);
+		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_SKB, NULL);
 	case BPF_LIRC_MODE2:
 		return lirc_prog_detach(attr);
 	default:
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
@@ -1687,9 +1641,6 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 static int bpf_prog_query(const union bpf_attr *attr,
 			  union bpf_attr __user *uattr)
 {
-	struct cgroup *cgrp;
-	int ret;
-
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 	if (CHECK_ATTR(BPF_PROG_QUERY))
@@ -1717,14 +1668,9 @@ static int bpf_prog_query(const union bpf_attr *attr,
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
 
@@ -2371,7 +2317,6 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_OBJ_GET:
 		err = bpf_obj_get(&attr);
 		break;
-#ifdef CONFIG_CGROUP_BPF
 	case BPF_PROG_ATTACH:
 		err = bpf_prog_attach(&attr);
 		break;
@@ -2381,7 +2326,6 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_PROG_QUERY:
 		err = bpf_prog_query(&attr, uattr);
 		break;
-#endif
 	case BPF_PROG_TEST_RUN:
 		err = bpf_prog_test_run(&attr, uattr);
 		break;
-- 
2.17.1
