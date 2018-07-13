Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:54223 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729764AbeGMOpH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 10:45:07 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>,
        VDR User <user.vdr@gmail.com>
Subject: [PATCH v3 1/5] keytable: add support for BPF based protocols
Date: Fri, 13 Jul 2018 15:30:07 +0100
Message-Id: <65a49511120cd64e38dde5a01ab6f0ecf684086e.1531491415.git.sean@mess.org>
In-Reply-To: <cover.1531491415.git.sean@mess.org>
References: <cover.1531491415.git.sean@mess.org>
In-Reply-To: <cover.1531491415.git.sean@mess.org>
References: <cover.1531491415.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We use a modified version of samples/bpf/bpf_load.c from the linux kernel
tree to load elf based BPF protocols and display the BPF program names.

Any global int variables can be overrided from the command line. The
immediate values are patched in the BPF LD instructions.

Write a BPF protocol decoder in C, and compile with:

	clang -O2 -c --target=bpf foo.c

Now you can load the object file like so:

	ir-keytable -p foo.o -v

Any parameters can be specified using -e name=value.

Signed-off-by: Sean Young <sean@mess.org>
---
 Makefile.am                     |    4 +-
 configure.ac                    |   11 +
 include/linux/bpf.h             | 2669 +++++++++++++++++++++++++++++++
 utils/keytable/Makefile.am      |    7 +-
 utils/keytable/bpf.c            |  515 ++++++
 utils/keytable/bpf.h            |  110 ++
 utils/keytable/bpf_load.c       |  455 ++++++
 utils/keytable/bpf_load.h       |   43 +
 utils/keytable/ir-keytable.1.in |   14 +-
 utils/keytable/keytable.c       |  318 +++-
 v4l-utils.spec.in               |    2 +-
 11 files changed, 4117 insertions(+), 31 deletions(-)
 create mode 100644 include/linux/bpf.h
 create mode 100644 utils/keytable/bpf.c
 create mode 100644 utils/keytable/bpf.h
 create mode 100644 utils/keytable/bpf_load.c
 create mode 100644 utils/keytable/bpf_load.h

diff --git a/Makefile.am b/Makefile.am
index fc8f2f34..38e17bab 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -25,7 +25,8 @@ sync-with-kernel:
 	      ! -f $(KERNEL_DIR)/usr/include/linux/ivtv.h -o \
 	      ! -f $(KERNEL_DIR)/usr/include/linux/dvb/frontend.h -o \
 	      ! -f $(KERNEL_DIR)/usr/include/linux/dvb/dmx.h -o \
-	      ! -f $(KERNEL_DIR)/usr/include/linux/lirc.h ]; then \
+	      ! -f $(KERNEL_DIR)/usr/include/linux/lirc.h -o \
+	      ! -f $(KERNEL_DIR)/usr/include/linux/bpf.h ]; then \
 	  echo "Error you must set KERNEL_DIR to point to an extracted kernel source dir"; \
 	  echo "and run 'make headers_install' in \$$KERNEL_DIR."; \
 	  exit 1; \
@@ -43,6 +44,7 @@ sync-with-kernel:
 	cp $(top_srcdir)/include/linux/dvb/frontend.h $(top_srcdir)/lib/include/libdvbv5/dvb-frontend.h
 	cp -a $(KERNEL_DIR)/usr/include/linux/dvb/dmx.h $(top_srcdir)/include/linux/dvb
 	cp -a $(KERNEL_DIR)/usr/include/linux/lirc.h $(top_srcdir)/include/linux
+	cp -a $(KERNEL_DIR)/usr/include/linux/bpf.h $(top_srcdir)/include/linux
 	cp -a $(KERNEL_DIR)/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c $(top_srcdir)/utils/common
 	cp -a $(KERNEL_DIR)/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c $(top_srcdir)/utils/common
 	cp -a $(KERNEL_DIR)/include/media/tpg/v4l2-tpg* $(top_srcdir)/utils/common
diff --git a/configure.ac b/configure.ac
index dc1e9cbf..08f5a4c5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -167,6 +167,16 @@ AC_SUBST([X11_CFLAGS])
 AC_SUBST([X11_LIBS])
 AM_CONDITIONAL([HAVE_X11], [test x$x11_pkgconfig = xyes])
 
+PKG_CHECK_MODULES([LIBELF], [libelf], [libelf_pkgconfig=yes], [libelf_pkgconfig=no])
+AC_SUBST([LIBELF_CFLAGS])
+AC_SUBST([LIBELF_LIBS])
+AM_CONDITIONAL([HAVE_LIBELF], [test x$libelf_pkgconfig = xyes])
+if test "x$libelf_pkgconfig" = "xyes"; then
+  AC_DEFINE([HAVE_LIBELF], [1], [libelf library is present])
+else
+  AC_MSG_WARN(libelf library not available)
+fi
+
 AS_IF([test "x$x11_pkgconfig" = xyes],
       [PKG_CHECK_MODULES(GL, [gl], [gl_pkgconfig=yes], [gl_pkgconfig=no])], [gl_pkgconfig=no])
 AC_SUBST([GL_CFLAGS])
@@ -497,6 +507,7 @@ compile time options summary
     X11                        : $x11_pkgconfig
     GL                         : $gl_pkgconfig
     glu                        : $glu_pkgconfig
+    libelf		       : $libelf_pkgconfig
     libjpeg                    : $have_jpeg
     libudev                    : $have_libudev
     pthread                    : $have_pthread
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
new file mode 100644
index 00000000..59b19b6a
--- /dev/null
+++ b/include/linux/bpf.h
@@ -0,0 +1,2669 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* Copyright (c) 2011-2014 PLUMgrid, http://plumgrid.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+#ifndef _UAPI__LINUX_BPF_H__
+#define _UAPI__LINUX_BPF_H__
+
+#include <linux/types.h>
+#include <linux/bpf_common.h>
+
+/* Extended instruction set based on top of classic BPF */
+
+/* instruction classes */
+#define BPF_ALU64	0x07	/* alu mode in double word width */
+
+/* ld/ldx fields */
+#define BPF_DW		0x18	/* double word (64-bit) */
+#define BPF_XADD	0xc0	/* exclusive add */
+
+/* alu/jmp fields */
+#define BPF_MOV		0xb0	/* mov reg to reg */
+#define BPF_ARSH	0xc0	/* sign extending arithmetic shift right */
+
+/* change endianness of a register */
+#define BPF_END		0xd0	/* flags for endianness conversion: */
+#define BPF_TO_LE	0x00	/* convert to little-endian */
+#define BPF_TO_BE	0x08	/* convert to big-endian */
+#define BPF_FROM_LE	BPF_TO_LE
+#define BPF_FROM_BE	BPF_TO_BE
+
+/* jmp encodings */
+#define BPF_JNE		0x50	/* jump != */
+#define BPF_JLT		0xa0	/* LT is unsigned, '<' */
+#define BPF_JLE		0xb0	/* LE is unsigned, '<=' */
+#define BPF_JSGT	0x60	/* SGT is signed '>', GT in x86 */
+#define BPF_JSGE	0x70	/* SGE is signed '>=', GE in x86 */
+#define BPF_JSLT	0xc0	/* SLT is signed, '<' */
+#define BPF_JSLE	0xd0	/* SLE is signed, '<=' */
+#define BPF_CALL	0x80	/* function call */
+#define BPF_EXIT	0x90	/* function return */
+
+/* Register numbers */
+enum {
+	BPF_REG_0 = 0,
+	BPF_REG_1,
+	BPF_REG_2,
+	BPF_REG_3,
+	BPF_REG_4,
+	BPF_REG_5,
+	BPF_REG_6,
+	BPF_REG_7,
+	BPF_REG_8,
+	BPF_REG_9,
+	BPF_REG_10,
+	__MAX_BPF_REG,
+};
+
+/* BPF has 10 general purpose 64-bit registers and stack frame. */
+#define MAX_BPF_REG	__MAX_BPF_REG
+
+struct bpf_insn {
+	__u8	code;		/* opcode */
+	__u8	dst_reg:4;	/* dest register */
+	__u8	src_reg:4;	/* source register */
+	__s16	off;		/* signed offset */
+	__s32	imm;		/* signed immediate constant */
+};
+
+/* Key of an a BPF_MAP_TYPE_LPM_TRIE entry */
+struct bpf_lpm_trie_key {
+	__u32	prefixlen;	/* up to 32 for AF_INET, 128 for AF_INET6 */
+	__u8	data[0];	/* Arbitrary size */
+};
+
+/* BPF syscall commands, see bpf(2) man-page for details. */
+enum bpf_cmd {
+	BPF_MAP_CREATE,
+	BPF_MAP_LOOKUP_ELEM,
+	BPF_MAP_UPDATE_ELEM,
+	BPF_MAP_DELETE_ELEM,
+	BPF_MAP_GET_NEXT_KEY,
+	BPF_PROG_LOAD,
+	BPF_OBJ_PIN,
+	BPF_OBJ_GET,
+	BPF_PROG_ATTACH,
+	BPF_PROG_DETACH,
+	BPF_PROG_TEST_RUN,
+	BPF_PROG_GET_NEXT_ID,
+	BPF_MAP_GET_NEXT_ID,
+	BPF_PROG_GET_FD_BY_ID,
+	BPF_MAP_GET_FD_BY_ID,
+	BPF_OBJ_GET_INFO_BY_FD,
+	BPF_PROG_QUERY,
+	BPF_RAW_TRACEPOINT_OPEN,
+	BPF_BTF_LOAD,
+	BPF_BTF_GET_FD_BY_ID,
+	BPF_TASK_FD_QUERY,
+};
+
+enum bpf_map_type {
+	BPF_MAP_TYPE_UNSPEC,
+	BPF_MAP_TYPE_HASH,
+	BPF_MAP_TYPE_ARRAY,
+	BPF_MAP_TYPE_PROG_ARRAY,
+	BPF_MAP_TYPE_PERF_EVENT_ARRAY,
+	BPF_MAP_TYPE_PERCPU_HASH,
+	BPF_MAP_TYPE_PERCPU_ARRAY,
+	BPF_MAP_TYPE_STACK_TRACE,
+	BPF_MAP_TYPE_CGROUP_ARRAY,
+	BPF_MAP_TYPE_LRU_HASH,
+	BPF_MAP_TYPE_LRU_PERCPU_HASH,
+	BPF_MAP_TYPE_LPM_TRIE,
+	BPF_MAP_TYPE_ARRAY_OF_MAPS,
+	BPF_MAP_TYPE_HASH_OF_MAPS,
+	BPF_MAP_TYPE_DEVMAP,
+	BPF_MAP_TYPE_SOCKMAP,
+	BPF_MAP_TYPE_CPUMAP,
+	BPF_MAP_TYPE_XSKMAP,
+	BPF_MAP_TYPE_SOCKHASH,
+};
+
+enum bpf_prog_type {
+	BPF_PROG_TYPE_UNSPEC,
+	BPF_PROG_TYPE_SOCKET_FILTER,
+	BPF_PROG_TYPE_KPROBE,
+	BPF_PROG_TYPE_SCHED_CLS,
+	BPF_PROG_TYPE_SCHED_ACT,
+	BPF_PROG_TYPE_TRACEPOINT,
+	BPF_PROG_TYPE_XDP,
+	BPF_PROG_TYPE_PERF_EVENT,
+	BPF_PROG_TYPE_CGROUP_SKB,
+	BPF_PROG_TYPE_CGROUP_SOCK,
+	BPF_PROG_TYPE_LWT_IN,
+	BPF_PROG_TYPE_LWT_OUT,
+	BPF_PROG_TYPE_LWT_XMIT,
+	BPF_PROG_TYPE_SOCK_OPS,
+	BPF_PROG_TYPE_SK_SKB,
+	BPF_PROG_TYPE_CGROUP_DEVICE,
+	BPF_PROG_TYPE_SK_MSG,
+	BPF_PROG_TYPE_RAW_TRACEPOINT,
+	BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+	BPF_PROG_TYPE_LWT_SEG6LOCAL,
+	BPF_PROG_TYPE_LIRC_MODE2,
+};
+
+enum bpf_attach_type {
+	BPF_CGROUP_INET_INGRESS,
+	BPF_CGROUP_INET_EGRESS,
+	BPF_CGROUP_INET_SOCK_CREATE,
+	BPF_CGROUP_SOCK_OPS,
+	BPF_SK_SKB_STREAM_PARSER,
+	BPF_SK_SKB_STREAM_VERDICT,
+	BPF_CGROUP_DEVICE,
+	BPF_SK_MSG_VERDICT,
+	BPF_CGROUP_INET4_BIND,
+	BPF_CGROUP_INET6_BIND,
+	BPF_CGROUP_INET4_CONNECT,
+	BPF_CGROUP_INET6_CONNECT,
+	BPF_CGROUP_INET4_POST_BIND,
+	BPF_CGROUP_INET6_POST_BIND,
+	BPF_CGROUP_UDP4_SENDMSG,
+	BPF_CGROUP_UDP6_SENDMSG,
+	BPF_LIRC_MODE2,
+	__MAX_BPF_ATTACH_TYPE
+};
+
+#define MAX_BPF_ATTACH_TYPE __MAX_BPF_ATTACH_TYPE
+
+/* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
+ *
+ * NONE(default): No further bpf programs allowed in the subtree.
+ *
+ * BPF_F_ALLOW_OVERRIDE: If a sub-cgroup installs some bpf program,
+ * the program in this cgroup yields to sub-cgroup program.
+ *
+ * BPF_F_ALLOW_MULTI: If a sub-cgroup installs some bpf program,
+ * that cgroup program gets run in addition to the program in this cgroup.
+ *
+ * Only one program is allowed to be attached to a cgroup with
+ * NONE or BPF_F_ALLOW_OVERRIDE flag.
+ * Attaching another program on top of NONE or BPF_F_ALLOW_OVERRIDE will
+ * release old program and attach the new one. Attach flags has to match.
+ *
+ * Multiple programs are allowed to be attached to a cgroup with
+ * BPF_F_ALLOW_MULTI flag. They are executed in FIFO order
+ * (those that were attached first, run first)
+ * The programs of sub-cgroup are executed first, then programs of
+ * this cgroup and then programs of parent cgroup.
+ * When children program makes decision (like picking TCP CA or sock bind)
+ * parent program has a chance to override it.
+ *
+ * A cgroup with MULTI or OVERRIDE flag allows any attach flags in sub-cgroups.
+ * A cgroup with NONE doesn't allow any programs in sub-cgroups.
+ * Ex1:
+ * cgrp1 (MULTI progs A, B) ->
+ *    cgrp2 (OVERRIDE prog C) ->
+ *      cgrp3 (MULTI prog D) ->
+ *        cgrp4 (OVERRIDE prog E) ->
+ *          cgrp5 (NONE prog F)
+ * the event in cgrp5 triggers execution of F,D,A,B in that order.
+ * if prog F is detached, the execution is E,D,A,B
+ * if prog F and D are detached, the execution is E,A,B
+ * if prog F, E and D are detached, the execution is C,A,B
+ *
+ * All eligible programs are executed regardless of return code from
+ * earlier programs.
+ */
+#define BPF_F_ALLOW_OVERRIDE	(1U << 0)
+#define BPF_F_ALLOW_MULTI	(1U << 1)
+
+/* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
+ * verifier will perform strict alignment checking as if the kernel
+ * has been built with CONFIG_EFFICIENT_UNALIGNED_ACCESS not set,
+ * and NET_IP_ALIGN defined to 2.
+ */
+#define BPF_F_STRICT_ALIGNMENT	(1U << 0)
+
+/* when bpf_ldimm64->src_reg == BPF_PSEUDO_MAP_FD, bpf_ldimm64->imm == fd */
+#define BPF_PSEUDO_MAP_FD	1
+
+/* when bpf_call->src_reg == BPF_PSEUDO_CALL, bpf_call->imm == pc-relative
+ * offset to another bpf function
+ */
+#define BPF_PSEUDO_CALL		1
+
+/* flags for BPF_MAP_UPDATE_ELEM command */
+#define BPF_ANY		0 /* create new element or update existing */
+#define BPF_NOEXIST	1 /* create new element if it didn't exist */
+#define BPF_EXIST	2 /* update existing element */
+
+/* flags for BPF_MAP_CREATE command */
+#define BPF_F_NO_PREALLOC	(1U << 0)
+/* Instead of having one common LRU list in the
+ * BPF_MAP_TYPE_LRU_[PERCPU_]HASH map, use a percpu LRU list
+ * which can scale and perform better.
+ * Note, the LRU nodes (including free nodes) cannot be moved
+ * across different LRU lists.
+ */
+#define BPF_F_NO_COMMON_LRU	(1U << 1)
+/* Specify numa node during map creation */
+#define BPF_F_NUMA_NODE		(1U << 2)
+
+/* flags for BPF_PROG_QUERY */
+#define BPF_F_QUERY_EFFECTIVE	(1U << 0)
+
+#define BPF_OBJ_NAME_LEN 16U
+
+/* Flags for accessing BPF object */
+#define BPF_F_RDONLY		(1U << 3)
+#define BPF_F_WRONLY		(1U << 4)
+
+/* Flag for stack_map, store build_id+offset instead of pointer */
+#define BPF_F_STACK_BUILD_ID	(1U << 5)
+
+enum bpf_stack_build_id_status {
+	/* user space need an empty entry to identify end of a trace */
+	BPF_STACK_BUILD_ID_EMPTY = 0,
+	/* with valid build_id and offset */
+	BPF_STACK_BUILD_ID_VALID = 1,
+	/* couldn't get build_id, fallback to ip */
+	BPF_STACK_BUILD_ID_IP = 2,
+};
+
+#define BPF_BUILD_ID_SIZE 20
+struct bpf_stack_build_id {
+	__s32		status;
+	unsigned char	build_id[BPF_BUILD_ID_SIZE];
+	union {
+		__u64	offset;
+		__u64	ip;
+	};
+};
+
+union bpf_attr {
+	struct { /* anonymous struct used by BPF_MAP_CREATE command */
+		__u32	map_type;	/* one of enum bpf_map_type */
+		__u32	key_size;	/* size of key in bytes */
+		__u32	value_size;	/* size of value in bytes */
+		__u32	max_entries;	/* max number of entries in a map */
+		__u32	map_flags;	/* BPF_MAP_CREATE related
+					 * flags defined above.
+					 */
+		__u32	inner_map_fd;	/* fd pointing to the inner map */
+		__u32	numa_node;	/* numa node (effective only if
+					 * BPF_F_NUMA_NODE is set).
+					 */
+		char	map_name[BPF_OBJ_NAME_LEN];
+		__u32	map_ifindex;	/* ifindex of netdev to create on */
+		__u32	btf_fd;		/* fd pointing to a BTF type data */
+		__u32	btf_key_type_id;	/* BTF type_id of the key */
+		__u32	btf_value_type_id;	/* BTF type_id of the value */
+	};
+
+	struct { /* anonymous struct used by BPF_MAP_*_ELEM commands */
+		__u32		map_fd;
+		__aligned_u64	key;
+		union {
+			__aligned_u64 value;
+			__aligned_u64 next_key;
+		};
+		__u64		flags;
+	};
+
+	struct { /* anonymous struct used by BPF_PROG_LOAD command */
+		__u32		prog_type;	/* one of enum bpf_prog_type */
+		__u32		insn_cnt;
+		__aligned_u64	insns;
+		__aligned_u64	license;
+		__u32		log_level;	/* verbosity level of verifier */
+		__u32		log_size;	/* size of user buffer */
+		__aligned_u64	log_buf;	/* user supplied buffer */
+		__u32		kern_version;	/* checked when prog_type=kprobe */
+		__u32		prog_flags;
+		char		prog_name[BPF_OBJ_NAME_LEN];
+		__u32		prog_ifindex;	/* ifindex of netdev to prep for */
+		/* For some prog types expected attach type must be known at
+		 * load time to verify attach type specific parts of prog
+		 * (context accesses, allowed helpers, etc).
+		 */
+		__u32		expected_attach_type;
+	};
+
+	struct { /* anonymous struct used by BPF_OBJ_* commands */
+		__aligned_u64	pathname;
+		__u32		bpf_fd;
+		__u32		file_flags;
+	};
+
+	struct { /* anonymous struct used by BPF_PROG_ATTACH/DETACH commands */
+		__u32		target_fd;	/* container object to attach to */
+		__u32		attach_bpf_fd;	/* eBPF program to attach */
+		__u32		attach_type;
+		__u32		attach_flags;
+	};
+
+	struct { /* anonymous struct used by BPF_PROG_TEST_RUN command */
+		__u32		prog_fd;
+		__u32		retval;
+		__u32		data_size_in;
+		__u32		data_size_out;
+		__aligned_u64	data_in;
+		__aligned_u64	data_out;
+		__u32		repeat;
+		__u32		duration;
+	} test;
+
+	struct { /* anonymous struct used by BPF_*_GET_*_ID */
+		union {
+			__u32		start_id;
+			__u32		prog_id;
+			__u32		map_id;
+			__u32		btf_id;
+		};
+		__u32		next_id;
+		__u32		open_flags;
+	};
+
+	struct { /* anonymous struct used by BPF_OBJ_GET_INFO_BY_FD */
+		__u32		bpf_fd;
+		__u32		info_len;
+		__aligned_u64	info;
+	} info;
+
+	struct { /* anonymous struct used by BPF_PROG_QUERY command */
+		__u32		target_fd;	/* container object to query */
+		__u32		attach_type;
+		__u32		query_flags;
+		__u32		attach_flags;
+		__aligned_u64	prog_ids;
+		__u32		prog_cnt;
+	} query;
+
+	struct {
+		__u64 name;
+		__u32 prog_fd;
+	} raw_tracepoint;
+
+	struct { /* anonymous struct for BPF_BTF_LOAD */
+		__aligned_u64	btf;
+		__aligned_u64	btf_log_buf;
+		__u32		btf_size;
+		__u32		btf_log_size;
+		__u32		btf_log_level;
+	};
+
+	struct {
+		__u32		pid;		/* input: pid */
+		__u32		fd;		/* input: fd */
+		__u32		flags;		/* input: flags */
+		__u32		buf_len;	/* input/output: buf len */
+		__aligned_u64	buf;		/* input/output:
+						 *   tp_name for tracepoint
+						 *   symbol for kprobe
+						 *   filename for uprobe
+						 */
+		__u32		prog_id;	/* output: prod_id */
+		__u32		fd_type;	/* output: BPF_FD_TYPE_* */
+		__u64		probe_offset;	/* output: probe_offset */
+		__u64		probe_addr;	/* output: probe_addr */
+	} task_fd_query;
+} __attribute__((aligned(8)));
+
+/* The description below is an attempt at providing documentation to eBPF
+ * developers about the multiple available eBPF helper functions. It can be
+ * parsed and used to produce a manual page. The workflow is the following,
+ * and requires the rst2man utility:
+ *
+ *     $ ./scripts/bpf_helpers_doc.py \
+ *             --filename include/uapi/linux/bpf.h > /tmp/bpf-helpers.rst
+ *     $ rst2man /tmp/bpf-helpers.rst > /tmp/bpf-helpers.7
+ *     $ man /tmp/bpf-helpers.7
+ *
+ * Note that in order to produce this external documentation, some RST
+ * formatting is used in the descriptions to get "bold" and "italics" in
+ * manual pages. Also note that the few trailing white spaces are
+ * intentional, removing them would break paragraphs for rst2man.
+ *
+ * Start of BPF helper function descriptions:
+ *
+ * void *bpf_map_lookup_elem(struct bpf_map *map, const void *key)
+ * 	Description
+ * 		Perform a lookup in *map* for an entry associated to *key*.
+ * 	Return
+ * 		Map value associated to *key*, or **NULL** if no entry was
+ * 		found.
+ *
+ * int bpf_map_update_elem(struct bpf_map *map, const void *key, const void *value, u64 flags)
+ * 	Description
+ * 		Add or update the value of the entry associated to *key* in
+ * 		*map* with *value*. *flags* is one of:
+ *
+ * 		**BPF_NOEXIST**
+ * 			The entry for *key* must not exist in the map.
+ * 		**BPF_EXIST**
+ * 			The entry for *key* must already exist in the map.
+ * 		**BPF_ANY**
+ * 			No condition on the existence of the entry for *key*.
+ *
+ * 		Flag value **BPF_NOEXIST** cannot be used for maps of types
+ * 		**BPF_MAP_TYPE_ARRAY** or **BPF_MAP_TYPE_PERCPU_ARRAY**  (all
+ * 		elements always exist), the helper would return an error.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_map_delete_elem(struct bpf_map *map, const void *key)
+ * 	Description
+ * 		Delete entry with *key* from *map*.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_probe_read(void *dst, u32 size, const void *src)
+ * 	Description
+ * 		For tracing programs, safely attempt to read *size* bytes from
+ * 		address *src* and store the data in *dst*.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * u64 bpf_ktime_get_ns(void)
+ * 	Description
+ * 		Return the time elapsed since system boot, in nanoseconds.
+ * 	Return
+ * 		Current *ktime*.
+ *
+ * int bpf_trace_printk(const char *fmt, u32 fmt_size, ...)
+ * 	Description
+ * 		This helper is a "printk()-like" facility for debugging. It
+ * 		prints a message defined by format *fmt* (of size *fmt_size*)
+ * 		to file *\/sys/kernel/debug/tracing/trace* from DebugFS, if
+ * 		available. It can take up to three additional **u64**
+ * 		arguments (as an eBPF helpers, the total number of arguments is
+ * 		limited to five).
+ *
+ * 		Each time the helper is called, it appends a line to the trace.
+ * 		The format of the trace is customizable, and the exact output
+ * 		one will get depends on the options set in
+ * 		*\/sys/kernel/debug/tracing/trace_options* (see also the
+ * 		*README* file under the same directory). However, it usually
+ * 		defaults to something like:
+ *
+ * 		::
+ *
+ * 			telnet-470   [001] .N.. 419421.045894: 0x00000001: <formatted msg>
+ *
+ * 		In the above:
+ *
+ * 			* ``telnet`` is the name of the current task.
+ * 			* ``470`` is the PID of the current task.
+ * 			* ``001`` is the CPU number on which the task is
+ * 			  running.
+ * 			* In ``.N..``, each character refers to a set of
+ * 			  options (whether irqs are enabled, scheduling
+ * 			  options, whether hard/softirqs are running, level of
+ * 			  preempt_disabled respectively). **N** means that
+ * 			  **TIF_NEED_RESCHED** and **PREEMPT_NEED_RESCHED**
+ * 			  are set.
+ * 			* ``419421.045894`` is a timestamp.
+ * 			* ``0x00000001`` is a fake value used by BPF for the
+ * 			  instruction pointer register.
+ * 			* ``<formatted msg>`` is the message formatted with
+ * 			  *fmt*.
+ *
+ * 		The conversion specifiers supported by *fmt* are similar, but
+ * 		more limited than for printk(). They are **%d**, **%i**,
+ * 		**%u**, **%x**, **%ld**, **%li**, **%lu**, **%lx**, **%lld**,
+ * 		**%lli**, **%llu**, **%llx**, **%p**, **%s**. No modifier (size
+ * 		of field, padding with zeroes, etc.) is available, and the
+ * 		helper will return **-EINVAL** (but print nothing) if it
+ * 		encounters an unknown specifier.
+ *
+ * 		Also, note that **bpf_trace_printk**\ () is slow, and should
+ * 		only be used for debugging purposes. For this reason, a notice
+ * 		bloc (spanning several lines) is printed to kernel logs and
+ * 		states that the helper should not be used "for production use"
+ * 		the first time this helper is used (or more precisely, when
+ * 		**trace_printk**\ () buffers are allocated). For passing values
+ * 		to user space, perf events should be preferred.
+ * 	Return
+ * 		The number of bytes written to the buffer, or a negative error
+ * 		in case of failure.
+ *
+ * u32 bpf_get_prandom_u32(void)
+ * 	Description
+ * 		Get a pseudo-random number.
+ *
+ * 		From a security point of view, this helper uses its own
+ * 		pseudo-random internal state, and cannot be used to infer the
+ * 		seed of other random functions in the kernel. However, it is
+ * 		essential to note that the generator used by the helper is not
+ * 		cryptographically secure.
+ * 	Return
+ * 		A random 32-bit unsigned value.
+ *
+ * u32 bpf_get_smp_processor_id(void)
+ * 	Description
+ * 		Get the SMP (symmetric multiprocessing) processor id. Note that
+ * 		all programs run with preemption disabled, which means that the
+ * 		SMP processor id is stable during all the execution of the
+ * 		program.
+ * 	Return
+ * 		The SMP id of the processor running the program.
+ *
+ * int bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from, u32 len, u64 flags)
+ * 	Description
+ * 		Store *len* bytes from address *from* into the packet
+ * 		associated to *skb*, at *offset*. *flags* are a combination of
+ * 		**BPF_F_RECOMPUTE_CSUM** (automatically recompute the
+ * 		checksum for the packet after storing the bytes) and
+ * 		**BPF_F_INVALIDATE_HASH** (set *skb*\ **->hash**, *skb*\
+ * 		**->swhash** and *skb*\ **->l4hash** to 0).
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_l3_csum_replace(struct sk_buff *skb, u32 offset, u64 from, u64 to, u64 size)
+ * 	Description
+ * 		Recompute the layer 3 (e.g. IP) checksum for the packet
+ * 		associated to *skb*. Computation is incremental, so the helper
+ * 		must know the former value of the header field that was
+ * 		modified (*from*), the new value of this field (*to*), and the
+ * 		number of bytes (2 or 4) for this field, stored in *size*.
+ * 		Alternatively, it is possible to store the difference between
+ * 		the previous and the new values of the header field in *to*, by
+ * 		setting *from* and *size* to 0. For both methods, *offset*
+ * 		indicates the location of the IP checksum within the packet.
+ *
+ * 		This helper works in combination with **bpf_csum_diff**\ (),
+ * 		which does not update the checksum in-place, but offers more
+ * 		flexibility and can handle sizes larger than 2 or 4 for the
+ * 		checksum to update.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_l4_csum_replace(struct sk_buff *skb, u32 offset, u64 from, u64 to, u64 flags)
+ * 	Description
+ * 		Recompute the layer 4 (e.g. TCP, UDP or ICMP) checksum for the
+ * 		packet associated to *skb*. Computation is incremental, so the
+ * 		helper must know the former value of the header field that was
+ * 		modified (*from*), the new value of this field (*to*), and the
+ * 		number of bytes (2 or 4) for this field, stored on the lowest
+ * 		four bits of *flags*. Alternatively, it is possible to store
+ * 		the difference between the previous and the new values of the
+ * 		header field in *to*, by setting *from* and the four lowest
+ * 		bits of *flags* to 0. For both methods, *offset* indicates the
+ * 		location of the IP checksum within the packet. In addition to
+ * 		the size of the field, *flags* can be added (bitwise OR) actual
+ * 		flags. With **BPF_F_MARK_MANGLED_0**, a null checksum is left
+ * 		untouched (unless **BPF_F_MARK_ENFORCE** is added as well), and
+ * 		for updates resulting in a null checksum the value is set to
+ * 		**CSUM_MANGLED_0** instead. Flag **BPF_F_PSEUDO_HDR** indicates
+ * 		the checksum is to be computed against a pseudo-header.
+ *
+ * 		This helper works in combination with **bpf_csum_diff**\ (),
+ * 		which does not update the checksum in-place, but offers more
+ * 		flexibility and can handle sizes larger than 2 or 4 for the
+ * 		checksum to update.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_tail_call(void *ctx, struct bpf_map *prog_array_map, u32 index)
+ * 	Description
+ * 		This special helper is used to trigger a "tail call", or in
+ * 		other words, to jump into another eBPF program. The same stack
+ * 		frame is used (but values on stack and in registers for the
+ * 		caller are not accessible to the callee). This mechanism allows
+ * 		for program chaining, either for raising the maximum number of
+ * 		available eBPF instructions, or to execute given programs in
+ * 		conditional blocks. For security reasons, there is an upper
+ * 		limit to the number of successive tail calls that can be
+ * 		performed.
+ *
+ * 		Upon call of this helper, the program attempts to jump into a
+ * 		program referenced at index *index* in *prog_array_map*, a
+ * 		special map of type **BPF_MAP_TYPE_PROG_ARRAY**, and passes
+ * 		*ctx*, a pointer to the context.
+ *
+ * 		If the call succeeds, the kernel immediately runs the first
+ * 		instruction of the new program. This is not a function call,
+ * 		and it never returns to the previous program. If the call
+ * 		fails, then the helper has no effect, and the caller continues
+ * 		to run its subsequent instructions. A call can fail if the
+ * 		destination program for the jump does not exist (i.e. *index*
+ * 		is superior to the number of entries in *prog_array_map*), or
+ * 		if the maximum number of tail calls has been reached for this
+ * 		chain of programs. This limit is defined in the kernel by the
+ * 		macro **MAX_TAIL_CALL_CNT** (not accessible to user space),
+ * 		which is currently set to 32.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_clone_redirect(struct sk_buff *skb, u32 ifindex, u64 flags)
+ * 	Description
+ * 		Clone and redirect the packet associated to *skb* to another
+ * 		net device of index *ifindex*. Both ingress and egress
+ * 		interfaces can be used for redirection. The **BPF_F_INGRESS**
+ * 		value in *flags* is used to make the distinction (ingress path
+ * 		is selected if the flag is present, egress path otherwise).
+ * 		This is the only flag supported for now.
+ *
+ * 		In comparison with **bpf_redirect**\ () helper,
+ * 		**bpf_clone_redirect**\ () has the associated cost of
+ * 		duplicating the packet buffer, but this can be executed out of
+ * 		the eBPF program. Conversely, **bpf_redirect**\ () is more
+ * 		efficient, but it is handled through an action code where the
+ * 		redirection happens only after the eBPF program has returned.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * u64 bpf_get_current_pid_tgid(void)
+ * 	Return
+ * 		A 64-bit integer containing the current tgid and pid, and
+ * 		created as such:
+ * 		*current_task*\ **->tgid << 32 \|**
+ * 		*current_task*\ **->pid**.
+ *
+ * u64 bpf_get_current_uid_gid(void)
+ * 	Return
+ * 		A 64-bit integer containing the current GID and UID, and
+ * 		created as such: *current_gid* **<< 32 \|** *current_uid*.
+ *
+ * int bpf_get_current_comm(char *buf, u32 size_of_buf)
+ * 	Description
+ * 		Copy the **comm** attribute of the current task into *buf* of
+ * 		*size_of_buf*. The **comm** attribute contains the name of
+ * 		the executable (excluding the path) for the current task. The
+ * 		*size_of_buf* must be strictly positive. On success, the
+ * 		helper makes sure that the *buf* is NUL-terminated. On failure,
+ * 		it is filled with zeroes.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * u32 bpf_get_cgroup_classid(struct sk_buff *skb)
+ * 	Description
+ * 		Retrieve the classid for the current task, i.e. for the net_cls
+ * 		cgroup to which *skb* belongs.
+ *
+ * 		This helper can be used on TC egress path, but not on ingress.
+ *
+ * 		The net_cls cgroup provides an interface to tag network packets
+ * 		based on a user-provided identifier for all traffic coming from
+ * 		the tasks belonging to the related cgroup. See also the related
+ * 		kernel documentation, available from the Linux sources in file
+ * 		*Documentation/cgroup-v1/net_cls.txt*.
+ *
+ * 		The Linux kernel has two versions for cgroups: there are
+ * 		cgroups v1 and cgroups v2. Both are available to users, who can
+ * 		use a mixture of them, but note that the net_cls cgroup is for
+ * 		cgroup v1 only. This makes it incompatible with BPF programs
+ * 		run on cgroups, which is a cgroup-v2-only feature (a socket can
+ * 		only hold data for one version of cgroups at a time).
+ *
+ * 		This helper is only available is the kernel was compiled with
+ * 		the **CONFIG_CGROUP_NET_CLASSID** configuration option set to
+ * 		"**y**" or to "**m**".
+ * 	Return
+ * 		The classid, or 0 for the default unconfigured classid.
+ *
+ * int bpf_skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci)
+ * 	Description
+ * 		Push a *vlan_tci* (VLAN tag control information) of protocol
+ * 		*vlan_proto* to the packet associated to *skb*, then update
+ * 		the checksum. Note that if *vlan_proto* is different from
+ * 		**ETH_P_8021Q** and **ETH_P_8021AD**, it is considered to
+ * 		be **ETH_P_8021Q**.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_skb_vlan_pop(struct sk_buff *skb)
+ * 	Description
+ * 		Pop a VLAN header from the packet associated to *skb*.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_skb_get_tunnel_key(struct sk_buff *skb, struct bpf_tunnel_key *key, u32 size, u64 flags)
+ * 	Description
+ * 		Get tunnel metadata. This helper takes a pointer *key* to an
+ * 		empty **struct bpf_tunnel_key** of **size**, that will be
+ * 		filled with tunnel metadata for the packet associated to *skb*.
+ * 		The *flags* can be set to **BPF_F_TUNINFO_IPV6**, which
+ * 		indicates that the tunnel is based on IPv6 protocol instead of
+ * 		IPv4.
+ *
+ * 		The **struct bpf_tunnel_key** is an object that generalizes the
+ * 		principal parameters used by various tunneling protocols into a
+ * 		single struct. This way, it can be used to easily make a
+ * 		decision based on the contents of the encapsulation header,
+ * 		"summarized" in this struct. In particular, it holds the IP
+ * 		address of the remote end (IPv4 or IPv6, depending on the case)
+ * 		in *key*\ **->remote_ipv4** or *key*\ **->remote_ipv6**. Also,
+ * 		this struct exposes the *key*\ **->tunnel_id**, which is
+ * 		generally mapped to a VNI (Virtual Network Identifier), making
+ * 		it programmable together with the **bpf_skb_set_tunnel_key**\
+ * 		() helper.
+ *
+ * 		Let's imagine that the following code is part of a program
+ * 		attached to the TC ingress interface, on one end of a GRE
+ * 		tunnel, and is supposed to filter out all messages coming from
+ * 		remote ends with IPv4 address other than 10.0.0.1:
+ *
+ * 		::
+ *
+ * 			int ret;
+ * 			struct bpf_tunnel_key key = {};
+ * 			
+ * 			ret = bpf_skb_get_tunnel_key(skb, &key, sizeof(key), 0);
+ * 			if (ret < 0)
+ * 				return TC_ACT_SHOT;	// drop packet
+ * 			
+ * 			if (key.remote_ipv4 != 0x0a000001)
+ * 				return TC_ACT_SHOT;	// drop packet
+ * 			
+ * 			return TC_ACT_OK;		// accept packet
+ *
+ * 		This interface can also be used with all encapsulation devices
+ * 		that can operate in "collect metadata" mode: instead of having
+ * 		one network device per specific configuration, the "collect
+ * 		metadata" mode only requires a single device where the
+ * 		configuration can be extracted from this helper.
+ *
+ * 		This can be used together with various tunnels such as VXLan,
+ * 		Geneve, GRE or IP in IP (IPIP).
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_skb_set_tunnel_key(struct sk_buff *skb, struct bpf_tunnel_key *key, u32 size, u64 flags)
+ * 	Description
+ * 		Populate tunnel metadata for packet associated to *skb.* The
+ * 		tunnel metadata is set to the contents of *key*, of *size*. The
+ * 		*flags* can be set to a combination of the following values:
+ *
+ * 		**BPF_F_TUNINFO_IPV6**
+ * 			Indicate that the tunnel is based on IPv6 protocol
+ * 			instead of IPv4.
+ * 		**BPF_F_ZERO_CSUM_TX**
+ * 			For IPv4 packets, add a flag to tunnel metadata
+ * 			indicating that checksum computation should be skipped
+ * 			and checksum set to zeroes.
+ * 		**BPF_F_DONT_FRAGMENT**
+ * 			Add a flag to tunnel metadata indicating that the
+ * 			packet should not be fragmented.
+ * 		**BPF_F_SEQ_NUMBER**
+ * 			Add a flag to tunnel metadata indicating that a
+ * 			sequence number should be added to tunnel header before
+ * 			sending the packet. This flag was added for GRE
+ * 			encapsulation, but might be used with other protocols
+ * 			as well in the future.
+ *
+ * 		Here is a typical usage on the transmit path:
+ *
+ * 		::
+ *
+ * 			struct bpf_tunnel_key key;
+ * 			     populate key ...
+ * 			bpf_skb_set_tunnel_key(skb, &key, sizeof(key), 0);
+ * 			bpf_clone_redirect(skb, vxlan_dev_ifindex, 0);
+ *
+ * 		See also the description of the **bpf_skb_get_tunnel_key**\ ()
+ * 		helper for additional information.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * u64 bpf_perf_event_read(struct bpf_map *map, u64 flags)
+ * 	Description
+ * 		Read the value of a perf event counter. This helper relies on a
+ * 		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. The nature of
+ * 		the perf event counter is selected when *map* is updated with
+ * 		perf event file descriptors. The *map* is an array whose size
+ * 		is the number of available CPUs, and each cell contains a value
+ * 		relative to one CPU. The value to retrieve is indicated by
+ * 		*flags*, that contains the index of the CPU to look up, masked
+ * 		with **BPF_F_INDEX_MASK**. Alternatively, *flags* can be set to
+ * 		**BPF_F_CURRENT_CPU** to indicate that the value for the
+ * 		current CPU should be retrieved.
+ *
+ * 		Note that before Linux 4.13, only hardware perf event can be
+ * 		retrieved.
+ *
+ * 		Also, be aware that the newer helper
+ * 		**bpf_perf_event_read_value**\ () is recommended over
+ * 		**bpf_perf_event_read**\ () in general. The latter has some ABI
+ * 		quirks where error and counter value are used as a return code
+ * 		(which is wrong to do since ranges may overlap). This issue is
+ * 		fixed with **bpf_perf_event_read_value**\ (), which at the same
+ * 		time provides more features over the **bpf_perf_event_read**\
+ * 		() interface. Please refer to the description of
+ * 		**bpf_perf_event_read_value**\ () for details.
+ * 	Return
+ * 		The value of the perf event counter read from the map, or a
+ * 		negative error code in case of failure.
+ *
+ * int bpf_redirect(u32 ifindex, u64 flags)
+ * 	Description
+ * 		Redirect the packet to another net device of index *ifindex*.
+ * 		This helper is somewhat similar to **bpf_clone_redirect**\
+ * 		(), except that the packet is not cloned, which provides
+ * 		increased performance.
+ *
+ * 		Except for XDP, both ingress and egress interfaces can be used
+ * 		for redirection. The **BPF_F_INGRESS** value in *flags* is used
+ * 		to make the distinction (ingress path is selected if the flag
+ * 		is present, egress path otherwise). Currently, XDP only
+ * 		supports redirection to the egress interface, and accepts no
+ * 		flag at all.
+ *
+ * 		The same effect can be attained with the more generic
+ * 		**bpf_redirect_map**\ (), which requires specific maps to be
+ * 		used but offers better performance.
+ * 	Return
+ * 		For XDP, the helper returns **XDP_REDIRECT** on success or
+ * 		**XDP_ABORTED** on error. For other program types, the values
+ * 		are **TC_ACT_REDIRECT** on success or **TC_ACT_SHOT** on
+ * 		error.
+ *
+ * u32 bpf_get_route_realm(struct sk_buff *skb)
+ * 	Description
+ * 		Retrieve the realm or the route, that is to say the
+ * 		**tclassid** field of the destination for the *skb*. The
+ * 		indentifier retrieved is a user-provided tag, similar to the
+ * 		one used with the net_cls cgroup (see description for
+ * 		**bpf_get_cgroup_classid**\ () helper), but here this tag is
+ * 		held by a route (a destination entry), not by a task.
+ *
+ * 		Retrieving this identifier works with the clsact TC egress hook
+ * 		(see also **tc-bpf(8)**), or alternatively on conventional
+ * 		classful egress qdiscs, but not on TC ingress path. In case of
+ * 		clsact TC egress hook, this has the advantage that, internally,
+ * 		the destination entry has not been dropped yet in the transmit
+ * 		path. Therefore, the destination entry does not need to be
+ * 		artificially held via **netif_keep_dst**\ () for a classful
+ * 		qdisc until the *skb* is freed.
+ *
+ * 		This helper is available only if the kernel was compiled with
+ * 		**CONFIG_IP_ROUTE_CLASSID** configuration option.
+ * 	Return
+ * 		The realm of the route for the packet associated to *skb*, or 0
+ * 		if none was found.
+ *
+ * int bpf_perf_event_output(struct pt_reg *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
+ * 	Description
+ * 		Write raw *data* blob into a special BPF perf event held by
+ * 		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
+ * 		event must have the following attributes: **PERF_SAMPLE_RAW**
+ * 		as **sample_type**, **PERF_TYPE_SOFTWARE** as **type**, and
+ * 		**PERF_COUNT_SW_BPF_OUTPUT** as **config**.
+ *
+ * 		The *flags* are used to indicate the index in *map* for which
+ * 		the value must be put, masked with **BPF_F_INDEX_MASK**.
+ * 		Alternatively, *flags* can be set to **BPF_F_CURRENT_CPU**
+ * 		to indicate that the index of the current CPU core should be
+ * 		used.
+ *
+ * 		The value to write, of *size*, is passed through eBPF stack and
+ * 		pointed by *data*.
+ *
+ * 		The context of the program *ctx* needs also be passed to the
+ * 		helper.
+ *
+ * 		On user space, a program willing to read the values needs to
+ * 		call **perf_event_open**\ () on the perf event (either for
+ * 		one or for all CPUs) and to store the file descriptor into the
+ * 		*map*. This must be done before the eBPF program can send data
+ * 		into it. An example is available in file
+ * 		*samples/bpf/trace_output_user.c* in the Linux kernel source
+ * 		tree (the eBPF program counterpart is in
+ * 		*samples/bpf/trace_output_kern.c*).
+ *
+ * 		**bpf_perf_event_output**\ () achieves better performance
+ * 		than **bpf_trace_printk**\ () for sharing data with user
+ * 		space, and is much better suitable for streaming data from eBPF
+ * 		programs.
+ *
+ * 		Note that this helper is not restricted to tracing use cases
+ * 		and can be used with programs attached to TC or XDP as well,
+ * 		where it allows for passing data to user space listeners. Data
+ * 		can be:
+ *
+ * 		* Only custom structs,
+ * 		* Only the packet payload, or
+ * 		* A combination of both.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
+ * 	Description
+ * 		This helper was provided as an easy way to load data from a
+ * 		packet. It can be used to load *len* bytes from *offset* from
+ * 		the packet associated to *skb*, into the buffer pointed by
+ * 		*to*.
+ *
+ * 		Since Linux 4.7, usage of this helper has mostly been replaced
+ * 		by "direct packet access", enabling packet data to be
+ * 		manipulated with *skb*\ **->data** and *skb*\ **->data_end**
+ * 		pointing respectively to the first byte of packet data and to
+ * 		the byte after the last byte of packet data. However, it
+ * 		remains useful if one wishes to read large quantities of data
+ * 		at once from a packet into the eBPF stack.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_get_stackid(struct pt_reg *ctx, struct bpf_map *map, u64 flags)
+ * 	Description
+ * 		Walk a user or a kernel stack and return its id. To achieve
+ * 		this, the helper needs *ctx*, which is a pointer to the context
+ * 		on which the tracing program is executed, and a pointer to a
+ * 		*map* of type **BPF_MAP_TYPE_STACK_TRACE**.
+ *
+ * 		The last argument, *flags*, holds the number of stack frames to
+ * 		skip (from 0 to 255), masked with
+ * 		**BPF_F_SKIP_FIELD_MASK**. The next bits can be used to set
+ * 		a combination of the following flags:
+ *
+ * 		**BPF_F_USER_STACK**
+ * 			Collect a user space stack instead of a kernel stack.
+ * 		**BPF_F_FAST_STACK_CMP**
+ * 			Compare stacks by hash only.
+ * 		**BPF_F_REUSE_STACKID**
+ * 			If two different stacks hash into the same *stackid*,
+ * 			discard the old one.
+ *
+ * 		The stack id retrieved is a 32 bit long integer handle which
+ * 		can be further combined with other data (including other stack
+ * 		ids) and used as a key into maps. This can be useful for
+ * 		generating a variety of graphs (such as flame graphs or off-cpu
+ * 		graphs).
+ *
+ * 		For walking a stack, this helper is an improvement over
+ * 		**bpf_probe_read**\ (), which can be used with unrolled loops
+ * 		but is not efficient and consumes a lot of eBPF instructions.
+ * 		Instead, **bpf_get_stackid**\ () can collect up to
+ * 		**PERF_MAX_STACK_DEPTH** both kernel and user frames. Note that
+ * 		this limit can be controlled with the **sysctl** program, and
+ * 		that it should be manually increased in order to profile long
+ * 		user stacks (such as stacks for Java programs). To do so, use:
+ *
+ * 		::
+ *
+ * 			# sysctl kernel.perf_event_max_stack=<new value>
+ * 	Return
+ * 		The positive or null stack id on success, or a negative error
+ * 		in case of failure.
+ *
+ * s64 bpf_csum_diff(__be32 *from, u32 from_size, __be32 *to, u32 to_size, __wsum seed)
+ * 	Description
+ * 		Compute a checksum difference, from the raw buffer pointed by
+ * 		*from*, of length *from_size* (that must be a multiple of 4),
+ * 		towards the raw buffer pointed by *to*, of size *to_size*
+ * 		(same remark). An optional *seed* can be added to the value
+ * 		(this can be cascaded, the seed may come from a previous call
+ * 		to the helper).
+ *
+ * 		This is flexible enough to be used in several ways:
+ *
+ * 		* With *from_size* == 0, *to_size* > 0 and *seed* set to
+ * 		  checksum, it can be used when pushing new data.
+ * 		* With *from_size* > 0, *to_size* == 0 and *seed* set to
+ * 		  checksum, it can be used when removing data from a packet.
+ * 		* With *from_size* > 0, *to_size* > 0 and *seed* set to 0, it
+ * 		  can be used to compute a diff. Note that *from_size* and
+ * 		  *to_size* do not need to be equal.
+ *
+ * 		This helper can be used in combination with
+ * 		**bpf_l3_csum_replace**\ () and **bpf_l4_csum_replace**\ (), to
+ * 		which one can feed in the difference computed with
+ * 		**bpf_csum_diff**\ ().
+ * 	Return
+ * 		The checksum result, or a negative error code in case of
+ * 		failure.
+ *
+ * int bpf_skb_get_tunnel_opt(struct sk_buff *skb, u8 *opt, u32 size)
+ * 	Description
+ * 		Retrieve tunnel options metadata for the packet associated to
+ * 		*skb*, and store the raw tunnel option data to the buffer *opt*
+ * 		of *size*.
+ *
+ * 		This helper can be used with encapsulation devices that can
+ * 		operate in "collect metadata" mode (please refer to the related
+ * 		note in the description of **bpf_skb_get_tunnel_key**\ () for
+ * 		more details). A particular example where this can be used is
+ * 		in combination with the Geneve encapsulation protocol, where it
+ * 		allows for pushing (with **bpf_skb_get_tunnel_opt**\ () helper)
+ * 		and retrieving arbitrary TLVs (Type-Length-Value headers) from
+ * 		the eBPF program. This allows for full customization of these
+ * 		headers.
+ * 	Return
+ * 		The size of the option data retrieved.
+ *
+ * int bpf_skb_set_tunnel_opt(struct sk_buff *skb, u8 *opt, u32 size)
+ * 	Description
+ * 		Set tunnel options metadata for the packet associated to *skb*
+ * 		to the option data contained in the raw buffer *opt* of *size*.
+ *
+ * 		See also the description of the **bpf_skb_get_tunnel_opt**\ ()
+ * 		helper for additional information.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_skb_change_proto(struct sk_buff *skb, __be16 proto, u64 flags)
+ * 	Description
+ * 		Change the protocol of the *skb* to *proto*. Currently
+ * 		supported are transition from IPv4 to IPv6, and from IPv6 to
+ * 		IPv4. The helper takes care of the groundwork for the
+ * 		transition, including resizing the socket buffer. The eBPF
+ * 		program is expected to fill the new headers, if any, via
+ * 		**skb_store_bytes**\ () and to recompute the checksums with
+ * 		**bpf_l3_csum_replace**\ () and **bpf_l4_csum_replace**\
+ * 		(). The main case for this helper is to perform NAT64
+ * 		operations out of an eBPF program.
+ *
+ * 		Internally, the GSO type is marked as dodgy so that headers are
+ * 		checked and segments are recalculated by the GSO/GRO engine.
+ * 		The size for GSO target is adapted as well.
+ *
+ * 		All values for *flags* are reserved for future usage, and must
+ * 		be left at zero.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_skb_change_type(struct sk_buff *skb, u32 type)
+ * 	Description
+ * 		Change the packet type for the packet associated to *skb*. This
+ * 		comes down to setting *skb*\ **->pkt_type** to *type*, except
+ * 		the eBPF program does not have a write access to *skb*\
+ * 		**->pkt_type** beside this helper. Using a helper here allows
+ * 		for graceful handling of errors.
+ *
+ * 		The major use case is to change incoming *skb*s to
+ * 		**PACKET_HOST** in a programmatic way instead of having to
+ * 		recirculate via **redirect**\ (..., **BPF_F_INGRESS**), for
+ * 		example.
+ *
+ * 		Note that *type* only allows certain values. At this time, they
+ * 		are:
+ *
+ * 		**PACKET_HOST**
+ * 			Packet is for us.
+ * 		**PACKET_BROADCAST**
+ * 			Send packet to all.
+ * 		**PACKET_MULTICAST**
+ * 			Send packet to group.
+ * 		**PACKET_OTHERHOST**
+ * 			Send packet to someone else.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_skb_under_cgroup(struct sk_buff *skb, struct bpf_map *map, u32 index)
+ * 	Description
+ * 		Check whether *skb* is a descendant of the cgroup2 held by
+ * 		*map* of type **BPF_MAP_TYPE_CGROUP_ARRAY**, at *index*.
+ * 	Return
+ * 		The return value depends on the result of the test, and can be:
+ *
+ * 		* 0, if the *skb* failed the cgroup2 descendant test.
+ * 		* 1, if the *skb* succeeded the cgroup2 descendant test.
+ * 		* A negative error code, if an error occurred.
+ *
+ * u32 bpf_get_hash_recalc(struct sk_buff *skb)
+ * 	Description
+ * 		Retrieve the hash of the packet, *skb*\ **->hash**. If it is
+ * 		not set, in particular if the hash was cleared due to mangling,
+ * 		recompute this hash. Later accesses to the hash can be done
+ * 		directly with *skb*\ **->hash**.
+ *
+ * 		Calling **bpf_set_hash_invalid**\ (), changing a packet
+ * 		prototype with **bpf_skb_change_proto**\ (), or calling
+ * 		**bpf_skb_store_bytes**\ () with the
+ * 		**BPF_F_INVALIDATE_HASH** are actions susceptible to clear
+ * 		the hash and to trigger a new computation for the next call to
+ * 		**bpf_get_hash_recalc**\ ().
+ * 	Return
+ * 		The 32-bit hash.
+ *
+ * u64 bpf_get_current_task(void)
+ * 	Return
+ * 		A pointer to the current task struct.
+ *
+ * int bpf_probe_write_user(void *dst, const void *src, u32 len)
+ * 	Description
+ * 		Attempt in a safe way to write *len* bytes from the buffer
+ * 		*src* to *dst* in memory. It only works for threads that are in
+ * 		user context, and *dst* must be a valid user space address.
+ *
+ * 		This helper should not be used to implement any kind of
+ * 		security mechanism because of TOC-TOU attacks, but rather to
+ * 		debug, divert, and manipulate execution of semi-cooperative
+ * 		processes.
+ *
+ * 		Keep in mind that this feature is meant for experiments, and it
+ * 		has a risk of crashing the system and running programs.
+ * 		Therefore, when an eBPF program using this helper is attached,
+ * 		a warning including PID and process name is printed to kernel
+ * 		logs.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_current_task_under_cgroup(struct bpf_map *map, u32 index)
+ * 	Description
+ * 		Check whether the probe is being run is the context of a given
+ * 		subset of the cgroup2 hierarchy. The cgroup2 to test is held by
+ * 		*map* of type **BPF_MAP_TYPE_CGROUP_ARRAY**, at *index*.
+ * 	Return
+ * 		The return value depends on the result of the test, and can be:
+ *
+ * 		* 0, if the *skb* task belongs to the cgroup2.
+ * 		* 1, if the *skb* task does not belong to the cgroup2.
+ * 		* A negative error code, if an error occurred.
+ *
+ * int bpf_skb_change_tail(struct sk_buff *skb, u32 len, u64 flags)
+ * 	Description
+ * 		Resize (trim or grow) the packet associated to *skb* to the
+ * 		new *len*. The *flags* are reserved for future usage, and must
+ * 		be left at zero.
+ *
+ * 		The basic idea is that the helper performs the needed work to
+ * 		change the size of the packet, then the eBPF program rewrites
+ * 		the rest via helpers like **bpf_skb_store_bytes**\ (),
+ * 		**bpf_l3_csum_replace**\ (), **bpf_l3_csum_replace**\ ()
+ * 		and others. This helper is a slow path utility intended for
+ * 		replies with control messages. And because it is targeted for
+ * 		slow path, the helper itself can afford to be slow: it
+ * 		implicitly linearizes, unclones and drops offloads from the
+ * 		*skb*.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_skb_pull_data(struct sk_buff *skb, u32 len)
+ * 	Description
+ * 		Pull in non-linear data in case the *skb* is non-linear and not
+ * 		all of *len* are part of the linear section. Make *len* bytes
+ * 		from *skb* readable and writable. If a zero value is passed for
+ * 		*len*, then the whole length of the *skb* is pulled.
+ *
+ * 		This helper is only needed for reading and writing with direct
+ * 		packet access.
+ *
+ * 		For direct packet access, testing that offsets to access
+ * 		are within packet boundaries (test on *skb*\ **->data_end**) is
+ * 		susceptible to fail if offsets are invalid, or if the requested
+ * 		data is in non-linear parts of the *skb*. On failure the
+ * 		program can just bail out, or in the case of a non-linear
+ * 		buffer, use a helper to make the data available. The
+ * 		**bpf_skb_load_bytes**\ () helper is a first solution to access
+ * 		the data. Another one consists in using **bpf_skb_pull_data**
+ * 		to pull in once the non-linear parts, then retesting and
+ * 		eventually access the data.
+ *
+ * 		At the same time, this also makes sure the *skb* is uncloned,
+ * 		which is a necessary condition for direct write. As this needs
+ * 		to be an invariant for the write part only, the verifier
+ * 		detects writes and adds a prologue that is calling
+ * 		**bpf_skb_pull_data()** to effectively unclone the *skb* from
+ * 		the very beginning in case it is indeed cloned.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * s64 bpf_csum_update(struct sk_buff *skb, __wsum csum)
+ * 	Description
+ * 		Add the checksum *csum* into *skb*\ **->csum** in case the
+ * 		driver has supplied a checksum for the entire packet into that
+ * 		field. Return an error otherwise. This helper is intended to be
+ * 		used in combination with **bpf_csum_diff**\ (), in particular
+ * 		when the checksum needs to be updated after data has been
+ * 		written into the packet through direct packet access.
+ * 	Return
+ * 		The checksum on success, or a negative error code in case of
+ * 		failure.
+ *
+ * void bpf_set_hash_invalid(struct sk_buff *skb)
+ * 	Description
+ * 		Invalidate the current *skb*\ **->hash**. It can be used after
+ * 		mangling on headers through direct packet access, in order to
+ * 		indicate that the hash is outdated and to trigger a
+ * 		recalculation the next time the kernel tries to access this
+ * 		hash or when the **bpf_get_hash_recalc**\ () helper is called.
+ *
+ * int bpf_get_numa_node_id(void)
+ * 	Description
+ * 		Return the id of the current NUMA node. The primary use case
+ * 		for this helper is the selection of sockets for the local NUMA
+ * 		node, when the program is attached to sockets using the
+ * 		**SO_ATTACH_REUSEPORT_EBPF** option (see also **socket(7)**),
+ * 		but the helper is also available to other eBPF program types,
+ * 		similarly to **bpf_get_smp_processor_id**\ ().
+ * 	Return
+ * 		The id of current NUMA node.
+ *
+ * int bpf_skb_change_head(struct sk_buff *skb, u32 len, u64 flags)
+ * 	Description
+ * 		Grows headroom of packet associated to *skb* and adjusts the
+ * 		offset of the MAC header accordingly, adding *len* bytes of
+ * 		space. It automatically extends and reallocates memory as
+ * 		required.
+ *
+ * 		This helper can be used on a layer 3 *skb* to push a MAC header
+ * 		for redirection into a layer 2 device.
+ *
+ * 		All values for *flags* are reserved for future usage, and must
+ * 		be left at zero.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_xdp_adjust_head(struct xdp_buff *xdp_md, int delta)
+ * 	Description
+ * 		Adjust (move) *xdp_md*\ **->data** by *delta* bytes. Note that
+ * 		it is possible to use a negative value for *delta*. This helper
+ * 		can be used to prepare the packet for pushing or popping
+ * 		headers.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_probe_read_str(void *dst, int size, const void *unsafe_ptr)
+ * 	Description
+ * 		Copy a NUL terminated string from an unsafe address
+ * 		*unsafe_ptr* to *dst*. The *size* should include the
+ * 		terminating NUL byte. In case the string length is smaller than
+ * 		*size*, the target is not padded with further NUL bytes. If the
+ * 		string length is larger than *size*, just *size*-1 bytes are
+ * 		copied and the last byte is set to NUL.
+ *
+ * 		On success, the length of the copied string is returned. This
+ * 		makes this helper useful in tracing programs for reading
+ * 		strings, and more importantly to get its length at runtime. See
+ * 		the following snippet:
+ *
+ * 		::
+ *
+ * 			SEC("kprobe/sys_open")
+ * 			void bpf_sys_open(struct pt_regs *ctx)
+ * 			{
+ * 			        char buf[PATHLEN]; // PATHLEN is defined to 256
+ * 			        int res = bpf_probe_read_str(buf, sizeof(buf),
+ * 				                             ctx->di);
+ *
+ * 				// Consume buf, for example push it to
+ * 				// userspace via bpf_perf_event_output(); we
+ * 				// can use res (the string length) as event
+ * 				// size, after checking its boundaries.
+ * 			}
+ *
+ * 		In comparison, using **bpf_probe_read()** helper here instead
+ * 		to read the string would require to estimate the length at
+ * 		compile time, and would often result in copying more memory
+ * 		than necessary.
+ *
+ * 		Another useful use case is when parsing individual process
+ * 		arguments or individual environment variables navigating
+ * 		*current*\ **->mm->arg_start** and *current*\
+ * 		**->mm->env_start**: using this helper and the return value,
+ * 		one can quickly iterate at the right offset of the memory area.
+ * 	Return
+ * 		On success, the strictly positive length of the string,
+ * 		including the trailing NUL character. On error, a negative
+ * 		value.
+ *
+ * u64 bpf_get_socket_cookie(struct sk_buff *skb)
+ * 	Description
+ * 		If the **struct sk_buff** pointed by *skb* has a known socket,
+ * 		retrieve the cookie (generated by the kernel) of this socket.
+ * 		If no cookie has been set yet, generate a new cookie. Once
+ * 		generated, the socket cookie remains stable for the life of the
+ * 		socket. This helper can be useful for monitoring per socket
+ * 		networking traffic statistics as it provides a unique socket
+ * 		identifier per namespace.
+ * 	Return
+ * 		A 8-byte long non-decreasing number on success, or 0 if the
+ * 		socket field is missing inside *skb*.
+ *
+ * u32 bpf_get_socket_uid(struct sk_buff *skb)
+ * 	Return
+ * 		The owner UID of the socket associated to *skb*. If the socket
+ * 		is **NULL**, or if it is not a full socket (i.e. if it is a
+ * 		time-wait or a request socket instead), **overflowuid** value
+ * 		is returned (note that **overflowuid** might also be the actual
+ * 		UID value for the socket).
+ *
+ * u32 bpf_set_hash(struct sk_buff *skb, u32 hash)
+ * 	Description
+ * 		Set the full hash for *skb* (set the field *skb*\ **->hash**)
+ * 		to value *hash*.
+ * 	Return
+ * 		0
+ *
+ * int bpf_setsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, char *optval, int optlen)
+ * 	Description
+ * 		Emulate a call to **setsockopt()** on the socket associated to
+ * 		*bpf_socket*, which must be a full socket. The *level* at
+ * 		which the option resides and the name *optname* of the option
+ * 		must be specified, see **setsockopt(2)** for more information.
+ * 		The option value of length *optlen* is pointed by *optval*.
+ *
+ * 		This helper actually implements a subset of **setsockopt()**.
+ * 		It supports the following *level*\ s:
+ *
+ * 		* **SOL_SOCKET**, which supports the following *optname*\ s:
+ * 		  **SO_RCVBUF**, **SO_SNDBUF**, **SO_MAX_PACING_RATE**,
+ * 		  **SO_PRIORITY**, **SO_RCVLOWAT**, **SO_MARK**.
+ * 		* **IPPROTO_TCP**, which supports the following *optname*\ s:
+ * 		  **TCP_CONGESTION**, **TCP_BPF_IW**,
+ * 		  **TCP_BPF_SNDCWND_CLAMP**.
+ * 		* **IPPROTO_IP**, which supports *optname* **IP_TOS**.
+ * 		* **IPPROTO_IPV6**, which supports *optname* **IPV6_TCLASS**.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_skb_adjust_room(struct sk_buff *skb, u32 len_diff, u32 mode, u64 flags)
+ * 	Description
+ * 		Grow or shrink the room for data in the packet associated to
+ * 		*skb* by *len_diff*, and according to the selected *mode*.
+ *
+ * 		There is a single supported mode at this time:
+ *
+ * 		* **BPF_ADJ_ROOM_NET**: Adjust room at the network layer
+ * 		  (room space is added or removed below the layer 3 header).
+ *
+ * 		All values for *flags* are reserved for future usage, and must
+ * 		be left at zero.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_redirect_map(struct bpf_map *map, u32 key, u64 flags)
+ * 	Description
+ * 		Redirect the packet to the endpoint referenced by *map* at
+ * 		index *key*. Depending on its type, this *map* can contain
+ * 		references to net devices (for forwarding packets through other
+ * 		ports), or to CPUs (for redirecting XDP frames to another CPU;
+ * 		but this is only implemented for native XDP (with driver
+ * 		support) as of this writing).
+ *
+ * 		All values for *flags* are reserved for future usage, and must
+ * 		be left at zero.
+ *
+ * 		When used to redirect packets to net devices, this helper
+ * 		provides a high performance increase over **bpf_redirect**\ ().
+ * 		This is due to various implementation details of the underlying
+ * 		mechanisms, one of which is the fact that **bpf_redirect_map**\
+ * 		() tries to send packet as a "bulk" to the device.
+ * 	Return
+ * 		**XDP_REDIRECT** on success, or **XDP_ABORTED** on error.
+ *
+ * int bpf_sk_redirect_map(struct bpf_map *map, u32 key, u64 flags)
+ * 	Description
+ * 		Redirect the packet to the socket referenced by *map* (of type
+ * 		**BPF_MAP_TYPE_SOCKMAP**) at index *key*. Both ingress and
+ * 		egress interfaces can be used for redirection. The
+ * 		**BPF_F_INGRESS** value in *flags* is used to make the
+ * 		distinction (ingress path is selected if the flag is present,
+ * 		egress path otherwise). This is the only flag supported for now.
+ * 	Return
+ * 		**SK_PASS** on success, or **SK_DROP** on error.
+ *
+ * int bpf_sock_map_update(struct bpf_sock_ops *skops, struct bpf_map *map, void *key, u64 flags)
+ * 	Description
+ * 		Add an entry to, or update a *map* referencing sockets. The
+ * 		*skops* is used as a new value for the entry associated to
+ * 		*key*. *flags* is one of:
+ *
+ * 		**BPF_NOEXIST**
+ * 			The entry for *key* must not exist in the map.
+ * 		**BPF_EXIST**
+ * 			The entry for *key* must already exist in the map.
+ * 		**BPF_ANY**
+ * 			No condition on the existence of the entry for *key*.
+ *
+ * 		If the *map* has eBPF programs (parser and verdict), those will
+ * 		be inherited by the socket being added. If the socket is
+ * 		already attached to eBPF programs, this results in an error.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_xdp_adjust_meta(struct xdp_buff *xdp_md, int delta)
+ * 	Description
+ * 		Adjust the address pointed by *xdp_md*\ **->data_meta** by
+ * 		*delta* (which can be positive or negative). Note that this
+ * 		operation modifies the address stored in *xdp_md*\ **->data**,
+ * 		so the latter must be loaded only after the helper has been
+ * 		called.
+ *
+ * 		The use of *xdp_md*\ **->data_meta** is optional and programs
+ * 		are not required to use it. The rationale is that when the
+ * 		packet is processed with XDP (e.g. as DoS filter), it is
+ * 		possible to push further meta data along with it before passing
+ * 		to the stack, and to give the guarantee that an ingress eBPF
+ * 		program attached as a TC classifier on the same device can pick
+ * 		this up for further post-processing. Since TC works with socket
+ * 		buffers, it remains possible to set from XDP the **mark** or
+ * 		**priority** pointers, or other pointers for the socket buffer.
+ * 		Having this scratch space generic and programmable allows for
+ * 		more flexibility as the user is free to store whatever meta
+ * 		data they need.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_perf_event_read_value(struct bpf_map *map, u64 flags, struct bpf_perf_event_value *buf, u32 buf_size)
+ * 	Description
+ * 		Read the value of a perf event counter, and store it into *buf*
+ * 		of size *buf_size*. This helper relies on a *map* of type
+ * 		**BPF_MAP_TYPE_PERF_EVENT_ARRAY**. The nature of the perf event
+ * 		counter is selected when *map* is updated with perf event file
+ * 		descriptors. The *map* is an array whose size is the number of
+ * 		available CPUs, and each cell contains a value relative to one
+ * 		CPU. The value to retrieve is indicated by *flags*, that
+ * 		contains the index of the CPU to look up, masked with
+ * 		**BPF_F_INDEX_MASK**. Alternatively, *flags* can be set to
+ * 		**BPF_F_CURRENT_CPU** to indicate that the value for the
+ * 		current CPU should be retrieved.
+ *
+ * 		This helper behaves in a way close to
+ * 		**bpf_perf_event_read**\ () helper, save that instead of
+ * 		just returning the value observed, it fills the *buf*
+ * 		structure. This allows for additional data to be retrieved: in
+ * 		particular, the enabled and running times (in *buf*\
+ * 		**->enabled** and *buf*\ **->running**, respectively) are
+ * 		copied. In general, **bpf_perf_event_read_value**\ () is
+ * 		recommended over **bpf_perf_event_read**\ (), which has some
+ * 		ABI issues and provides fewer functionalities.
+ *
+ * 		These values are interesting, because hardware PMU (Performance
+ * 		Monitoring Unit) counters are limited resources. When there are
+ * 		more PMU based perf events opened than available counters,
+ * 		kernel will multiplex these events so each event gets certain
+ * 		percentage (but not all) of the PMU time. In case that
+ * 		multiplexing happens, the number of samples or counter value
+ * 		will not reflect the case compared to when no multiplexing
+ * 		occurs. This makes comparison between different runs difficult.
+ * 		Typically, the counter value should be normalized before
+ * 		comparing to other experiments. The usual normalization is done
+ * 		as follows.
+ *
+ * 		::
+ *
+ * 			normalized_counter = counter * t_enabled / t_running
+ *
+ * 		Where t_enabled is the time enabled for event and t_running is
+ * 		the time running for event since last normalization. The
+ * 		enabled and running times are accumulated since the perf event
+ * 		open. To achieve scaling factor between two invocations of an
+ * 		eBPF program, users can can use CPU id as the key (which is
+ * 		typical for perf array usage model) to remember the previous
+ * 		value and do the calculation inside the eBPF program.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_perf_prog_read_value(struct bpf_perf_event_data *ctx, struct bpf_perf_event_value *buf, u32 buf_size)
+ * 	Description
+ * 		For en eBPF program attached to a perf event, retrieve the
+ * 		value of the event counter associated to *ctx* and store it in
+ * 		the structure pointed by *buf* and of size *buf_size*. Enabled
+ * 		and running times are also stored in the structure (see
+ * 		description of helper **bpf_perf_event_read_value**\ () for
+ * 		more details).
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_getsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, char *optval, int optlen)
+ * 	Description
+ * 		Emulate a call to **getsockopt()** on the socket associated to
+ * 		*bpf_socket*, which must be a full socket. The *level* at
+ * 		which the option resides and the name *optname* of the option
+ * 		must be specified, see **getsockopt(2)** for more information.
+ * 		The retrieved value is stored in the structure pointed by
+ * 		*opval* and of length *optlen*.
+ *
+ * 		This helper actually implements a subset of **getsockopt()**.
+ * 		It supports the following *level*\ s:
+ *
+ * 		* **IPPROTO_TCP**, which supports *optname*
+ * 		  **TCP_CONGESTION**.
+ * 		* **IPPROTO_IP**, which supports *optname* **IP_TOS**.
+ * 		* **IPPROTO_IPV6**, which supports *optname* **IPV6_TCLASS**.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_override_return(struct pt_reg *regs, u64 rc)
+ * 	Description
+ * 		Used for error injection, this helper uses kprobes to override
+ * 		the return value of the probed function, and to set it to *rc*.
+ * 		The first argument is the context *regs* on which the kprobe
+ * 		works.
+ *
+ * 		This helper works by setting setting the PC (program counter)
+ * 		to an override function which is run in place of the original
+ * 		probed function. This means the probed function is not run at
+ * 		all. The replacement function just returns with the required
+ * 		value.
+ *
+ * 		This helper has security implications, and thus is subject to
+ * 		restrictions. It is only available if the kernel was compiled
+ * 		with the **CONFIG_BPF_KPROBE_OVERRIDE** configuration
+ * 		option, and in this case it only works on functions tagged with
+ * 		**ALLOW_ERROR_INJECTION** in the kernel code.
+ *
+ * 		Also, the helper is only available for the architectures having
+ * 		the CONFIG_FUNCTION_ERROR_INJECTION option. As of this writing,
+ * 		x86 architecture is the only one to support this feature.
+ * 	Return
+ * 		0
+ *
+ * int bpf_sock_ops_cb_flags_set(struct bpf_sock_ops *bpf_sock, int argval)
+ * 	Description
+ * 		Attempt to set the value of the **bpf_sock_ops_cb_flags** field
+ * 		for the full TCP socket associated to *bpf_sock_ops* to
+ * 		*argval*.
+ *
+ * 		The primary use of this field is to determine if there should
+ * 		be calls to eBPF programs of type
+ * 		**BPF_PROG_TYPE_SOCK_OPS** at various points in the TCP
+ * 		code. A program of the same type can change its value, per
+ * 		connection and as necessary, when the connection is
+ * 		established. This field is directly accessible for reading, but
+ * 		this helper must be used for updates in order to return an
+ * 		error if an eBPF program tries to set a callback that is not
+ * 		supported in the current kernel.
+ *
+ * 		The supported callback values that *argval* can combine are:
+ *
+ * 		* **BPF_SOCK_OPS_RTO_CB_FLAG** (retransmission time out)
+ * 		* **BPF_SOCK_OPS_RETRANS_CB_FLAG** (retransmission)
+ * 		* **BPF_SOCK_OPS_STATE_CB_FLAG** (TCP state change)
+ *
+ * 		Here are some examples of where one could call such eBPF
+ * 		program:
+ *
+ * 		* When RTO fires.
+ * 		* When a packet is retransmitted.
+ * 		* When the connection terminates.
+ * 		* When a packet is sent.
+ * 		* When a packet is received.
+ * 	Return
+ * 		Code **-EINVAL** if the socket is not a full TCP socket;
+ * 		otherwise, a positive number containing the bits that could not
+ * 		be set is returned (which comes down to 0 if all bits were set
+ * 		as required).
+ *
+ * int bpf_msg_redirect_map(struct sk_msg_buff *msg, struct bpf_map *map, u32 key, u64 flags)
+ * 	Description
+ * 		This helper is used in programs implementing policies at the
+ * 		socket level. If the message *msg* is allowed to pass (i.e. if
+ * 		the verdict eBPF program returns **SK_PASS**), redirect it to
+ * 		the socket referenced by *map* (of type
+ * 		**BPF_MAP_TYPE_SOCKMAP**) at index *key*. Both ingress and
+ * 		egress interfaces can be used for redirection. The
+ * 		**BPF_F_INGRESS** value in *flags* is used to make the
+ * 		distinction (ingress path is selected if the flag is present,
+ * 		egress path otherwise). This is the only flag supported for now.
+ * 	Return
+ * 		**SK_PASS** on success, or **SK_DROP** on error.
+ *
+ * int bpf_msg_apply_bytes(struct sk_msg_buff *msg, u32 bytes)
+ * 	Description
+ * 		For socket policies, apply the verdict of the eBPF program to
+ * 		the next *bytes* (number of bytes) of message *msg*.
+ *
+ * 		For example, this helper can be used in the following cases:
+ *
+ * 		* A single **sendmsg**\ () or **sendfile**\ () system call
+ * 		  contains multiple logical messages that the eBPF program is
+ * 		  supposed to read and for which it should apply a verdict.
+ * 		* An eBPF program only cares to read the first *bytes* of a
+ * 		  *msg*. If the message has a large payload, then setting up
+ * 		  and calling the eBPF program repeatedly for all bytes, even
+ * 		  though the verdict is already known, would create unnecessary
+ * 		  overhead.
+ *
+ * 		When called from within an eBPF program, the helper sets a
+ * 		counter internal to the BPF infrastructure, that is used to
+ * 		apply the last verdict to the next *bytes*. If *bytes* is
+ * 		smaller than the current data being processed from a
+ * 		**sendmsg**\ () or **sendfile**\ () system call, the first
+ * 		*bytes* will be sent and the eBPF program will be re-run with
+ * 		the pointer for start of data pointing to byte number *bytes*
+ * 		**+ 1**. If *bytes* is larger than the current data being
+ * 		processed, then the eBPF verdict will be applied to multiple
+ * 		**sendmsg**\ () or **sendfile**\ () calls until *bytes* are
+ * 		consumed.
+ *
+ * 		Note that if a socket closes with the internal counter holding
+ * 		a non-zero value, this is not a problem because data is not
+ * 		being buffered for *bytes* and is sent as it is received.
+ * 	Return
+ * 		0
+ *
+ * int bpf_msg_cork_bytes(struct sk_msg_buff *msg, u32 bytes)
+ * 	Description
+ * 		For socket policies, prevent the execution of the verdict eBPF
+ * 		program for message *msg* until *bytes* (byte number) have been
+ * 		accumulated.
+ *
+ * 		This can be used when one needs a specific number of bytes
+ * 		before a verdict can be assigned, even if the data spans
+ * 		multiple **sendmsg**\ () or **sendfile**\ () calls. The extreme
+ * 		case would be a user calling **sendmsg**\ () repeatedly with
+ * 		1-byte long message segments. Obviously, this is bad for
+ * 		performance, but it is still valid. If the eBPF program needs
+ * 		*bytes* bytes to validate a header, this helper can be used to
+ * 		prevent the eBPF program to be called again until *bytes* have
+ * 		been accumulated.
+ * 	Return
+ * 		0
+ *
+ * int bpf_msg_pull_data(struct sk_msg_buff *msg, u32 start, u32 end, u64 flags)
+ * 	Description
+ * 		For socket policies, pull in non-linear data from user space
+ * 		for *msg* and set pointers *msg*\ **->data** and *msg*\
+ * 		**->data_end** to *start* and *end* bytes offsets into *msg*,
+ * 		respectively.
+ *
+ * 		If a program of type **BPF_PROG_TYPE_SK_MSG** is run on a
+ * 		*msg* it can only parse data that the (**data**, **data_end**)
+ * 		pointers have already consumed. For **sendmsg**\ () hooks this
+ * 		is likely the first scatterlist element. But for calls relying
+ * 		on the **sendpage** handler (e.g. **sendfile**\ ()) this will
+ * 		be the range (**0**, **0**) because the data is shared with
+ * 		user space and by default the objective is to avoid allowing
+ * 		user space to modify data while (or after) eBPF verdict is
+ * 		being decided. This helper can be used to pull in data and to
+ * 		set the start and end pointer to given values. Data will be
+ * 		copied if necessary (i.e. if data was not linear and if start
+ * 		and end pointers do not point to the same chunk).
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ *
+ * 		All values for *flags* are reserved for future usage, and must
+ * 		be left at zero.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_bind(struct bpf_sock_addr *ctx, struct sockaddr *addr, int addr_len)
+ * 	Description
+ * 		Bind the socket associated to *ctx* to the address pointed by
+ * 		*addr*, of length *addr_len*. This allows for making outgoing
+ * 		connection from the desired IP address, which can be useful for
+ * 		example when all processes inside a cgroup should use one
+ * 		single IP address on a host that has multiple IP configured.
+ *
+ * 		This helper works for IPv4 and IPv6, TCP and UDP sockets. The
+ * 		domain (*addr*\ **->sa_family**) must be **AF_INET** (or
+ * 		**AF_INET6**). Looking for a free port to bind to can be
+ * 		expensive, therefore binding to port is not permitted by the
+ * 		helper: *addr*\ **->sin_port** (or **sin6_port**, respectively)
+ * 		must be set to zero.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_xdp_adjust_tail(struct xdp_buff *xdp_md, int delta)
+ * 	Description
+ * 		Adjust (move) *xdp_md*\ **->data_end** by *delta* bytes. It is
+ * 		only possible to shrink the packet as of this writing,
+ * 		therefore *delta* must be a negative integer.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_skb_get_xfrm_state(struct sk_buff *skb, u32 index, struct bpf_xfrm_state *xfrm_state, u32 size, u64 flags)
+ * 	Description
+ * 		Retrieve the XFRM state (IP transform framework, see also
+ * 		**ip-xfrm(8)**) at *index* in XFRM "security path" for *skb*.
+ *
+ * 		The retrieved value is stored in the **struct bpf_xfrm_state**
+ * 		pointed by *xfrm_state* and of length *size*.
+ *
+ * 		All values for *flags* are reserved for future usage, and must
+ * 		be left at zero.
+ *
+ * 		This helper is available only if the kernel was compiled with
+ * 		**CONFIG_XFRM** configuration option.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_get_stack(struct pt_regs *regs, void *buf, u32 size, u64 flags)
+ * 	Description
+ * 		Return a user or a kernel stack in bpf program provided buffer.
+ * 		To achieve this, the helper needs *ctx*, which is a pointer
+ * 		to the context on which the tracing program is executed.
+ * 		To store the stacktrace, the bpf program provides *buf* with
+ * 		a nonnegative *size*.
+ *
+ * 		The last argument, *flags*, holds the number of stack frames to
+ * 		skip (from 0 to 255), masked with
+ * 		**BPF_F_SKIP_FIELD_MASK**. The next bits can be used to set
+ * 		the following flags:
+ *
+ * 		**BPF_F_USER_STACK**
+ * 			Collect a user space stack instead of a kernel stack.
+ * 		**BPF_F_USER_BUILD_ID**
+ * 			Collect buildid+offset instead of ips for user stack,
+ * 			only valid if **BPF_F_USER_STACK** is also specified.
+ *
+ * 		**bpf_get_stack**\ () can collect up to
+ * 		**PERF_MAX_STACK_DEPTH** both kernel and user frames, subject
+ * 		to sufficient large buffer size. Note that
+ * 		this limit can be controlled with the **sysctl** program, and
+ * 		that it should be manually increased in order to profile long
+ * 		user stacks (such as stacks for Java programs). To do so, use:
+ *
+ * 		::
+ *
+ * 			# sysctl kernel.perf_event_max_stack=<new value>
+ * 	Return
+ * 		A non-negative value equal to or less than *size* on success,
+ * 		or a negative error in case of failure.
+ *
+ * int skb_load_bytes_relative(const struct sk_buff *skb, u32 offset, void *to, u32 len, u32 start_header)
+ * 	Description
+ * 		This helper is similar to **bpf_skb_load_bytes**\ () in that
+ * 		it provides an easy way to load *len* bytes from *offset*
+ * 		from the packet associated to *skb*, into the buffer pointed
+ * 		by *to*. The difference to **bpf_skb_load_bytes**\ () is that
+ * 		a fifth argument *start_header* exists in order to select a
+ * 		base offset to start from. *start_header* can be one of:
+ *
+ * 		**BPF_HDR_START_MAC**
+ * 			Base offset to load data from is *skb*'s mac header.
+ * 		**BPF_HDR_START_NET**
+ * 			Base offset to load data from is *skb*'s network header.
+ *
+ * 		In general, "direct packet access" is the preferred method to
+ * 		access packet data, however, this helper is in particular useful
+ * 		in socket filters where *skb*\ **->data** does not always point
+ * 		to the start of the mac header and where "direct packet access"
+ * 		is not available.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_fib_lookup(void *ctx, struct bpf_fib_lookup *params, int plen, u32 flags)
+ *	Description
+ *		Do FIB lookup in kernel tables using parameters in *params*.
+ *		If lookup is successful and result shows packet is to be
+ *		forwarded, the neighbor tables are searched for the nexthop.
+ *		If successful (ie., FIB lookup shows forwarding and nexthop
+ *		is resolved), the nexthop address is returned in ipv4_dst
+ *		or ipv6_dst based on family, smac is set to mac address of
+ *		egress device, dmac is set to nexthop mac address, rt_metric
+ *		is set to metric from route (IPv4/IPv6 only).
+ *
+ *             *plen* argument is the size of the passed in struct.
+ *             *flags* argument can be a combination of one or more of the
+ *             following values:
+ *
+ *		**BPF_FIB_LOOKUP_DIRECT**
+ *			Do a direct table lookup vs full lookup using FIB
+ *			rules.
+ *		**BPF_FIB_LOOKUP_OUTPUT**
+ *			Perform lookup from an egress perspective (default is
+ *			ingress).
+ *
+ *             *ctx* is either **struct xdp_md** for XDP programs or
+ *             **struct sk_buff** tc cls_act programs.
+ *     Return
+ *             Egress device index on success, 0 if packet needs to continue
+ *             up the stack for further processing or a negative error in case
+ *             of failure.
+ *
+ * int bpf_sock_hash_update(struct bpf_sock_ops_kern *skops, struct bpf_map *map, void *key, u64 flags)
+ *	Description
+ *		Add an entry to, or update a sockhash *map* referencing sockets.
+ *		The *skops* is used as a new value for the entry associated to
+ *		*key*. *flags* is one of:
+ *
+ *		**BPF_NOEXIST**
+ *			The entry for *key* must not exist in the map.
+ *		**BPF_EXIST**
+ *			The entry for *key* must already exist in the map.
+ *		**BPF_ANY**
+ *			No condition on the existence of the entry for *key*.
+ *
+ *		If the *map* has eBPF programs (parser and verdict), those will
+ *		be inherited by the socket being added. If the socket is
+ *		already attached to eBPF programs, this results in an error.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_msg_redirect_hash(struct sk_msg_buff *msg, struct bpf_map *map, void *key, u64 flags)
+ *	Description
+ *		This helper is used in programs implementing policies at the
+ *		socket level. If the message *msg* is allowed to pass (i.e. if
+ *		the verdict eBPF program returns **SK_PASS**), redirect it to
+ *		the socket referenced by *map* (of type
+ *		**BPF_MAP_TYPE_SOCKHASH**) using hash *key*. Both ingress and
+ *		egress interfaces can be used for redirection. The
+ *		**BPF_F_INGRESS** value in *flags* is used to make the
+ *		distinction (ingress path is selected if the flag is present,
+ *		egress path otherwise). This is the only flag supported for now.
+ *	Return
+ *		**SK_PASS** on success, or **SK_DROP** on error.
+ *
+ * int bpf_sk_redirect_hash(struct sk_buff *skb, struct bpf_map *map, void *key, u64 flags)
+ *	Description
+ *		This helper is used in programs implementing policies at the
+ *		skb socket level. If the sk_buff *skb* is allowed to pass (i.e.
+ *		if the verdeict eBPF program returns **SK_PASS**), redirect it
+ *		to the socket referenced by *map* (of type
+ *		**BPF_MAP_TYPE_SOCKHASH**) using hash *key*. Both ingress and
+ *		egress interfaces can be used for redirection. The
+ *		**BPF_F_INGRESS** value in *flags* is used to make the
+ *		distinction (ingress path is selected if the flag is present,
+ *		egress otherwise). This is the only flag supported for now.
+ *	Return
+ *		**SK_PASS** on success, or **SK_DROP** on error.
+ *
+ * int bpf_lwt_push_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len)
+ *	Description
+ *		Encapsulate the packet associated to *skb* within a Layer 3
+ *		protocol header. This header is provided in the buffer at
+ *		address *hdr*, with *len* its size in bytes. *type* indicates
+ *		the protocol of the header and can be one of:
+ *
+ *		**BPF_LWT_ENCAP_SEG6**
+ *			IPv6 encapsulation with Segment Routing Header
+ *			(**struct ipv6_sr_hdr**). *hdr* only contains the SRH,
+ *			the IPv6 header is computed by the kernel.
+ *		**BPF_LWT_ENCAP_SEG6_INLINE**
+ *			Only works if *skb* contains an IPv6 packet. Insert a
+ *			Segment Routing Header (**struct ipv6_sr_hdr**) inside
+ *			the IPv6 header.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ *	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_lwt_seg6_store_bytes(struct sk_buff *skb, u32 offset, const void *from, u32 len)
+ *	Description
+ *		Store *len* bytes from address *from* into the packet
+ *		associated to *skb*, at *offset*. Only the flags, tag and TLVs
+ *		inside the outermost IPv6 Segment Routing Header can be
+ *		modified through this helper.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ *	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_lwt_seg6_adjust_srh(struct sk_buff *skb, u32 offset, s32 delta)
+ *	Description
+ *		Adjust the size allocated to TLVs in the outermost IPv6
+ *		Segment Routing Header contained in the packet associated to
+ *		*skb*, at position *offset* by *delta* bytes. Only offsets
+ *		after the segments are accepted. *delta* can be as well
+ *		positive (growing) as negative (shrinking).
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ *	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_lwt_seg6_action(struct sk_buff *skb, u32 action, void *param, u32 param_len)
+ *	Description
+ *		Apply an IPv6 Segment Routing action of type *action* to the
+ *		packet associated to *skb*. Each action takes a parameter
+ *		contained at address *param*, and of length *param_len* bytes.
+ *		*action* can be one of:
+ *
+ *		**SEG6_LOCAL_ACTION_END_X**
+ *			End.X action: Endpoint with Layer-3 cross-connect.
+ *			Type of *param*: **struct in6_addr**.
+ *		**SEG6_LOCAL_ACTION_END_T**
+ *			End.T action: Endpoint with specific IPv6 table lookup.
+ *			Type of *param*: **int**.
+ *		**SEG6_LOCAL_ACTION_END_B6**
+ *			End.B6 action: Endpoint bound to an SRv6 policy.
+ *			Type of param: **struct ipv6_sr_hdr**.
+ *		**SEG6_LOCAL_ACTION_END_B6_ENCAP**
+ *			End.B6.Encap action: Endpoint bound to an SRv6
+ *			encapsulation policy.
+ *			Type of param: **struct ipv6_sr_hdr**.
+ *
+ * 		A call to this helper is susceptible to change the underlaying
+ * 		packet buffer. Therefore, at load time, all checks on pointers
+ * 		previously done by the verifier are invalidated and must be
+ * 		performed again, if the helper is used in combination with
+ * 		direct packet access.
+ *	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_rc_keydown(void *ctx, u32 protocol, u64 scancode, u32 toggle)
+ *	Description
+ *		This helper is used in programs implementing IR decoding, to
+ *		report a successfully decoded key press with *scancode*,
+ *		*toggle* value in the given *protocol*. The scancode will be
+ *		translated to a keycode using the rc keymap, and reported as
+ *		an input key down event. After a period a key up event is
+ *		generated. This period can be extended by calling either
+ *		**bpf_rc_keydown** () again with the same values, or calling
+ *		**bpf_rc_repeat** ().
+ *
+ *		Some protocols include a toggle bit, in case the button	was
+ *		released and pressed again between consecutive scancodes.
+ *
+ *		The *ctx* should point to the lirc sample as passed into
+ *		the program.
+ *
+ *		The *protocol* is the decoded protocol number (see
+ *		**enum rc_proto** for some predefined values).
+ *
+ *		This helper is only available is the kernel was compiled with
+ *		the **CONFIG_BPF_LIRC_MODE2** configuration option set to
+ *		"**y**".
+ *
+ *	Return
+ *		0
+ *
+ * int bpf_rc_repeat(void *ctx)
+ *	Description
+ *		This helper is used in programs implementing IR decoding, to
+ *		report a successfully decoded repeat key message. This delays
+ *		the generation of a key up event for previously generated
+ *		key down event.
+ *
+ *		Some IR protocols like NEC have a special IR message for
+ *		repeating last button, for when a button is held down.
+ *
+ *		The *ctx* should point to the lirc sample as passed into
+ *		the program.
+ *
+ *		This helper is only available is the kernel was compiled with
+ *		the **CONFIG_BPF_LIRC_MODE2** configuration option set to
+ *		"**y**".
+ *
+ *	Return
+ *		0
+ *
+ * uint64_t bpf_skb_cgroup_id(struct sk_buff *skb)
+ * 	Description
+ * 		Return the cgroup v2 id of the socket associated with the *skb*.
+ * 		This is roughly similar to the **bpf_get_cgroup_classid**\ ()
+ * 		helper for cgroup v1 by providing a tag resp. identifier that
+ * 		can be matched on or used for map lookups e.g. to implement
+ * 		policy. The cgroup v2 id of a given path in the hierarchy is
+ * 		exposed in user space through the f_handle API in order to get
+ * 		to the same 64-bit id.
+ *
+ * 		This helper can be used on TC egress path, but not on ingress,
+ * 		and is available only if the kernel was compiled with the
+ * 		**CONFIG_SOCK_CGROUP_DATA** configuration option.
+ * 	Return
+ * 		The id is returned or 0 in case the id could not be retrieved.
+ *
+ * u64 bpf_get_current_cgroup_id(void)
+ * 	Return
+ * 		A 64-bit integer containing the current cgroup id based
+ * 		on the cgroup within which the current task is running.
+ */
+#define __BPF_FUNC_MAPPER(FN)		\
+	FN(unspec),			\
+	FN(map_lookup_elem),		\
+	FN(map_update_elem),		\
+	FN(map_delete_elem),		\
+	FN(probe_read),			\
+	FN(ktime_get_ns),		\
+	FN(trace_printk),		\
+	FN(get_prandom_u32),		\
+	FN(get_smp_processor_id),	\
+	FN(skb_store_bytes),		\
+	FN(l3_csum_replace),		\
+	FN(l4_csum_replace),		\
+	FN(tail_call),			\
+	FN(clone_redirect),		\
+	FN(get_current_pid_tgid),	\
+	FN(get_current_uid_gid),	\
+	FN(get_current_comm),		\
+	FN(get_cgroup_classid),		\
+	FN(skb_vlan_push),		\
+	FN(skb_vlan_pop),		\
+	FN(skb_get_tunnel_key),		\
+	FN(skb_set_tunnel_key),		\
+	FN(perf_event_read),		\
+	FN(redirect),			\
+	FN(get_route_realm),		\
+	FN(perf_event_output),		\
+	FN(skb_load_bytes),		\
+	FN(get_stackid),		\
+	FN(csum_diff),			\
+	FN(skb_get_tunnel_opt),		\
+	FN(skb_set_tunnel_opt),		\
+	FN(skb_change_proto),		\
+	FN(skb_change_type),		\
+	FN(skb_under_cgroup),		\
+	FN(get_hash_recalc),		\
+	FN(get_current_task),		\
+	FN(probe_write_user),		\
+	FN(current_task_under_cgroup),	\
+	FN(skb_change_tail),		\
+	FN(skb_pull_data),		\
+	FN(csum_update),		\
+	FN(set_hash_invalid),		\
+	FN(get_numa_node_id),		\
+	FN(skb_change_head),		\
+	FN(xdp_adjust_head),		\
+	FN(probe_read_str),		\
+	FN(get_socket_cookie),		\
+	FN(get_socket_uid),		\
+	FN(set_hash),			\
+	FN(setsockopt),			\
+	FN(skb_adjust_room),		\
+	FN(redirect_map),		\
+	FN(sk_redirect_map),		\
+	FN(sock_map_update),		\
+	FN(xdp_adjust_meta),		\
+	FN(perf_event_read_value),	\
+	FN(perf_prog_read_value),	\
+	FN(getsockopt),			\
+	FN(override_return),		\
+	FN(sock_ops_cb_flags_set),	\
+	FN(msg_redirect_map),		\
+	FN(msg_apply_bytes),		\
+	FN(msg_cork_bytes),		\
+	FN(msg_pull_data),		\
+	FN(bind),			\
+	FN(xdp_adjust_tail),		\
+	FN(skb_get_xfrm_state),		\
+	FN(get_stack),			\
+	FN(skb_load_bytes_relative),	\
+	FN(fib_lookup),			\
+	FN(sock_hash_update),		\
+	FN(msg_redirect_hash),		\
+	FN(sk_redirect_hash),		\
+	FN(lwt_push_encap),		\
+	FN(lwt_seg6_store_bytes),	\
+	FN(lwt_seg6_adjust_srh),	\
+	FN(lwt_seg6_action),		\
+	FN(rc_repeat),			\
+	FN(rc_keydown),			\
+	FN(skb_cgroup_id),		\
+	FN(get_current_cgroup_id),
+
+/* integer value in 'imm' field of BPF_CALL instruction selects which helper
+ * function eBPF program intends to call
+ */
+#define __BPF_ENUM_FN(x) BPF_FUNC_ ## x
+enum bpf_func_id {
+	__BPF_FUNC_MAPPER(__BPF_ENUM_FN)
+	__BPF_FUNC_MAX_ID,
+};
+#undef __BPF_ENUM_FN
+
+/* All flags used by eBPF helper functions, placed here. */
+
+/* BPF_FUNC_skb_store_bytes flags. */
+#define BPF_F_RECOMPUTE_CSUM		(1ULL << 0)
+#define BPF_F_INVALIDATE_HASH		(1ULL << 1)
+
+/* BPF_FUNC_l3_csum_replace and BPF_FUNC_l4_csum_replace flags.
+ * First 4 bits are for passing the header field size.
+ */
+#define BPF_F_HDR_FIELD_MASK		0xfULL
+
+/* BPF_FUNC_l4_csum_replace flags. */
+#define BPF_F_PSEUDO_HDR		(1ULL << 4)
+#define BPF_F_MARK_MANGLED_0		(1ULL << 5)
+#define BPF_F_MARK_ENFORCE		(1ULL << 6)
+
+/* BPF_FUNC_clone_redirect and BPF_FUNC_redirect flags. */
+#define BPF_F_INGRESS			(1ULL << 0)
+
+/* BPF_FUNC_skb_set_tunnel_key and BPF_FUNC_skb_get_tunnel_key flags. */
+#define BPF_F_TUNINFO_IPV6		(1ULL << 0)
+
+/* flags for both BPF_FUNC_get_stackid and BPF_FUNC_get_stack. */
+#define BPF_F_SKIP_FIELD_MASK		0xffULL
+#define BPF_F_USER_STACK		(1ULL << 8)
+/* flags used by BPF_FUNC_get_stackid only. */
+#define BPF_F_FAST_STACK_CMP		(1ULL << 9)
+#define BPF_F_REUSE_STACKID		(1ULL << 10)
+/* flags used by BPF_FUNC_get_stack only. */
+#define BPF_F_USER_BUILD_ID		(1ULL << 11)
+
+/* BPF_FUNC_skb_set_tunnel_key flags. */
+#define BPF_F_ZERO_CSUM_TX		(1ULL << 1)
+#define BPF_F_DONT_FRAGMENT		(1ULL << 2)
+#define BPF_F_SEQ_NUMBER		(1ULL << 3)
+
+/* BPF_FUNC_perf_event_output, BPF_FUNC_perf_event_read and
+ * BPF_FUNC_perf_event_read_value flags.
+ */
+#define BPF_F_INDEX_MASK		0xffffffffULL
+#define BPF_F_CURRENT_CPU		BPF_F_INDEX_MASK
+/* BPF_FUNC_perf_event_output for sk_buff input context. */
+#define BPF_F_CTXLEN_MASK		(0xfffffULL << 32)
+
+/* Mode for BPF_FUNC_skb_adjust_room helper. */
+enum bpf_adj_room_mode {
+	BPF_ADJ_ROOM_NET,
+};
+
+/* Mode for BPF_FUNC_skb_load_bytes_relative helper. */
+enum bpf_hdr_start_off {
+	BPF_HDR_START_MAC,
+	BPF_HDR_START_NET,
+};
+
+/* Encapsulation type for BPF_FUNC_lwt_push_encap helper. */
+enum bpf_lwt_encap_mode {
+	BPF_LWT_ENCAP_SEG6,
+	BPF_LWT_ENCAP_SEG6_INLINE
+};
+
+/* user accessible mirror of in-kernel sk_buff.
+ * new fields can only be added to the end of this structure
+ */
+struct __sk_buff {
+	__u32 len;
+	__u32 pkt_type;
+	__u32 mark;
+	__u32 queue_mapping;
+	__u32 protocol;
+	__u32 vlan_present;
+	__u32 vlan_tci;
+	__u32 vlan_proto;
+	__u32 priority;
+	__u32 ingress_ifindex;
+	__u32 ifindex;
+	__u32 tc_index;
+	__u32 cb[5];
+	__u32 hash;
+	__u32 tc_classid;
+	__u32 data;
+	__u32 data_end;
+	__u32 napi_id;
+
+	/* Accessed by BPF_PROG_TYPE_sk_skb types from here to ... */
+	__u32 family;
+	__u32 remote_ip4;	/* Stored in network byte order */
+	__u32 local_ip4;	/* Stored in network byte order */
+	__u32 remote_ip6[4];	/* Stored in network byte order */
+	__u32 local_ip6[4];	/* Stored in network byte order */
+	__u32 remote_port;	/* Stored in network byte order */
+	__u32 local_port;	/* stored in host byte order */
+	/* ... here. */
+
+	__u32 data_meta;
+};
+
+struct bpf_tunnel_key {
+	__u32 tunnel_id;
+	union {
+		__u32 remote_ipv4;
+		__u32 remote_ipv6[4];
+	};
+	__u8 tunnel_tos;
+	__u8 tunnel_ttl;
+	__u16 tunnel_ext;	/* Padding, future use. */
+	__u32 tunnel_label;
+};
+
+/* user accessible mirror of in-kernel xfrm_state.
+ * new fields can only be added to the end of this structure
+ */
+struct bpf_xfrm_state {
+	__u32 reqid;
+	__u32 spi;	/* Stored in network byte order */
+	__u16 family;
+	__u16 ext;	/* Padding, future use. */
+	union {
+		__u32 remote_ipv4;	/* Stored in network byte order */
+		__u32 remote_ipv6[4];	/* Stored in network byte order */
+	};
+};
+
+/* Generic BPF return codes which all BPF program types may support.
+ * The values are binary compatible with their TC_ACT_* counter-part to
+ * provide backwards compatibility with existing SCHED_CLS and SCHED_ACT
+ * programs.
+ *
+ * XDP is handled seprately, see XDP_*.
+ */
+enum bpf_ret_code {
+	BPF_OK = 0,
+	/* 1 reserved */
+	BPF_DROP = 2,
+	/* 3-6 reserved */
+	BPF_REDIRECT = 7,
+	/* >127 are reserved for prog type specific return codes */
+};
+
+struct bpf_sock {
+	__u32 bound_dev_if;
+	__u32 family;
+	__u32 type;
+	__u32 protocol;
+	__u32 mark;
+	__u32 priority;
+	__u32 src_ip4;		/* Allows 1,2,4-byte read.
+				 * Stored in network byte order.
+				 */
+	__u32 src_ip6[4];	/* Allows 1,2,4-byte read.
+				 * Stored in network byte order.
+				 */
+	__u32 src_port;		/* Allows 4-byte read.
+				 * Stored in host byte order
+				 */
+};
+
+#define XDP_PACKET_HEADROOM 256
+
+/* User return codes for XDP prog type.
+ * A valid XDP program must return one of these defined values. All other
+ * return codes are reserved for future use. Unknown return codes will
+ * result in packet drops and a warning via bpf_warn_invalid_xdp_action().
+ */
+enum xdp_action {
+	XDP_ABORTED = 0,
+	XDP_DROP,
+	XDP_PASS,
+	XDP_TX,
+	XDP_REDIRECT,
+};
+
+/* user accessible metadata for XDP packet hook
+ * new fields must be added to the end of this structure
+ */
+struct xdp_md {
+	__u32 data;
+	__u32 data_end;
+	__u32 data_meta;
+	/* Below access go through struct xdp_rxq_info */
+	__u32 ingress_ifindex; /* rxq->dev->ifindex */
+	__u32 rx_queue_index;  /* rxq->queue_index  */
+};
+
+enum sk_action {
+	SK_DROP = 0,
+	SK_PASS,
+};
+
+/* user accessible metadata for SK_MSG packet hook, new fields must
+ * be added to the end of this structure
+ */
+struct sk_msg_md {
+	void *data;
+	void *data_end;
+
+	__u32 family;
+	__u32 remote_ip4;	/* Stored in network byte order */
+	__u32 local_ip4;	/* Stored in network byte order */
+	__u32 remote_ip6[4];	/* Stored in network byte order */
+	__u32 local_ip6[4];	/* Stored in network byte order */
+	__u32 remote_port;	/* Stored in network byte order */
+	__u32 local_port;	/* stored in host byte order */
+};
+
+#define BPF_TAG_SIZE	8
+
+struct bpf_prog_info {
+	__u32 type;
+	__u32 id;
+	__u8  tag[BPF_TAG_SIZE];
+	__u32 jited_prog_len;
+	__u32 xlated_prog_len;
+	__aligned_u64 jited_prog_insns;
+	__aligned_u64 xlated_prog_insns;
+	__u64 load_time;	/* ns since boottime */
+	__u32 created_by_uid;
+	__u32 nr_map_ids;
+	__aligned_u64 map_ids;
+	char name[BPF_OBJ_NAME_LEN];
+	__u32 ifindex;
+	__u32 gpl_compatible:1;
+	__u64 netns_dev;
+	__u64 netns_ino;
+	__u32 nr_jited_ksyms;
+	__u32 nr_jited_func_lens;
+	__aligned_u64 jited_ksyms;
+	__aligned_u64 jited_func_lens;
+} __attribute__((aligned(8)));
+
+struct bpf_map_info {
+	__u32 type;
+	__u32 id;
+	__u32 key_size;
+	__u32 value_size;
+	__u32 max_entries;
+	__u32 map_flags;
+	char  name[BPF_OBJ_NAME_LEN];
+	__u32 ifindex;
+	__u32 :32;
+	__u64 netns_dev;
+	__u64 netns_ino;
+	__u32 btf_id;
+	__u32 btf_key_type_id;
+	__u32 btf_value_type_id;
+} __attribute__((aligned(8)));
+
+struct bpf_btf_info {
+	__aligned_u64 btf;
+	__u32 btf_size;
+	__u32 id;
+} __attribute__((aligned(8)));
+
+/* User bpf_sock_addr struct to access socket fields and sockaddr struct passed
+ * by user and intended to be used by socket (e.g. to bind to, depends on
+ * attach attach type).
+ */
+struct bpf_sock_addr {
+	__u32 user_family;	/* Allows 4-byte read, but no write. */
+	__u32 user_ip4;		/* Allows 1,2,4-byte read and 4-byte write.
+				 * Stored in network byte order.
+				 */
+	__u32 user_ip6[4];	/* Allows 1,2,4-byte read an 4-byte write.
+				 * Stored in network byte order.
+				 */
+	__u32 user_port;	/* Allows 4-byte read and write.
+				 * Stored in network byte order
+				 */
+	__u32 family;		/* Allows 4-byte read, but no write */
+	__u32 type;		/* Allows 4-byte read, but no write */
+	__u32 protocol;		/* Allows 4-byte read, but no write */
+	__u32 msg_src_ip4;	/* Allows 1,2,4-byte read an 4-byte write.
+				 * Stored in network byte order.
+				 */
+	__u32 msg_src_ip6[4];	/* Allows 1,2,4-byte read an 4-byte write.
+				 * Stored in network byte order.
+				 */
+};
+
+/* User bpf_sock_ops struct to access socket values and specify request ops
+ * and their replies.
+ * Some of this fields are in network (bigendian) byte order and may need
+ * to be converted before use (bpf_ntohl() defined in samples/bpf/bpf_endian.h).
+ * New fields can only be added at the end of this structure
+ */
+struct bpf_sock_ops {
+	__u32 op;
+	union {
+		__u32 args[4];		/* Optionally passed to bpf program */
+		__u32 reply;		/* Returned by bpf program	    */
+		__u32 replylong[4];	/* Optionally returned by bpf prog  */
+	};
+	__u32 family;
+	__u32 remote_ip4;	/* Stored in network byte order */
+	__u32 local_ip4;	/* Stored in network byte order */
+	__u32 remote_ip6[4];	/* Stored in network byte order */
+	__u32 local_ip6[4];	/* Stored in network byte order */
+	__u32 remote_port;	/* Stored in network byte order */
+	__u32 local_port;	/* stored in host byte order */
+	__u32 is_fullsock;	/* Some TCP fields are only valid if
+				 * there is a full socket. If not, the
+				 * fields read as zero.
+				 */
+	__u32 snd_cwnd;
+	__u32 srtt_us;		/* Averaged RTT << 3 in usecs */
+	__u32 bpf_sock_ops_cb_flags; /* flags defined in uapi/linux/tcp.h */
+	__u32 state;
+	__u32 rtt_min;
+	__u32 snd_ssthresh;
+	__u32 rcv_nxt;
+	__u32 snd_nxt;
+	__u32 snd_una;
+	__u32 mss_cache;
+	__u32 ecn_flags;
+	__u32 rate_delivered;
+	__u32 rate_interval_us;
+	__u32 packets_out;
+	__u32 retrans_out;
+	__u32 total_retrans;
+	__u32 segs_in;
+	__u32 data_segs_in;
+	__u32 segs_out;
+	__u32 data_segs_out;
+	__u32 lost_out;
+	__u32 sacked_out;
+	__u32 sk_txhash;
+	__u64 bytes_received;
+	__u64 bytes_acked;
+};
+
+/* Definitions for bpf_sock_ops_cb_flags */
+#define BPF_SOCK_OPS_RTO_CB_FLAG	(1<<0)
+#define BPF_SOCK_OPS_RETRANS_CB_FLAG	(1<<1)
+#define BPF_SOCK_OPS_STATE_CB_FLAG	(1<<2)
+#define BPF_SOCK_OPS_ALL_CB_FLAGS       0x7		/* Mask of all currently
+							 * supported cb flags
+							 */
+
+/* List of known BPF sock_ops operators.
+ * New entries can only be added at the end
+ */
+enum {
+	BPF_SOCK_OPS_VOID,
+	BPF_SOCK_OPS_TIMEOUT_INIT,	/* Should return SYN-RTO value to use or
+					 * -1 if default value should be used
+					 */
+	BPF_SOCK_OPS_RWND_INIT,		/* Should return initial advertized
+					 * window (in packets) or -1 if default
+					 * value should be used
+					 */
+	BPF_SOCK_OPS_TCP_CONNECT_CB,	/* Calls BPF program right before an
+					 * active connection is initialized
+					 */
+	BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB,	/* Calls BPF program when an
+						 * active connection is
+						 * established
+						 */
+	BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB,	/* Calls BPF program when a
+						 * passive connection is
+						 * established
+						 */
+	BPF_SOCK_OPS_NEEDS_ECN,		/* If connection's congestion control
+					 * needs ECN
+					 */
+	BPF_SOCK_OPS_BASE_RTT,		/* Get base RTT. The correct value is
+					 * based on the path and may be
+					 * dependent on the congestion control
+					 * algorithm. In general it indicates
+					 * a congestion threshold. RTTs above
+					 * this indicate congestion
+					 */
+	BPF_SOCK_OPS_RTO_CB,		/* Called when an RTO has triggered.
+					 * Arg1: value of icsk_retransmits
+					 * Arg2: value of icsk_rto
+					 * Arg3: whether RTO has expired
+					 */
+	BPF_SOCK_OPS_RETRANS_CB,	/* Called when skb is retransmitted.
+					 * Arg1: sequence number of 1st byte
+					 * Arg2: # segments
+					 * Arg3: return value of
+					 *       tcp_transmit_skb (0 => success)
+					 */
+	BPF_SOCK_OPS_STATE_CB,		/* Called when TCP changes state.
+					 * Arg1: old_state
+					 * Arg2: new_state
+					 */
+};
+
+/* List of TCP states. There is a build check in net/ipv4/tcp.c to detect
+ * changes between the TCP and BPF versions. Ideally this should never happen.
+ * If it does, we need to add code to convert them before calling
+ * the BPF sock_ops function.
+ */
+enum {
+	BPF_TCP_ESTABLISHED = 1,
+	BPF_TCP_SYN_SENT,
+	BPF_TCP_SYN_RECV,
+	BPF_TCP_FIN_WAIT1,
+	BPF_TCP_FIN_WAIT2,
+	BPF_TCP_TIME_WAIT,
+	BPF_TCP_CLOSE,
+	BPF_TCP_CLOSE_WAIT,
+	BPF_TCP_LAST_ACK,
+	BPF_TCP_LISTEN,
+	BPF_TCP_CLOSING,	/* Now a valid state */
+	BPF_TCP_NEW_SYN_RECV,
+
+	BPF_TCP_MAX_STATES	/* Leave at the end! */
+};
+
+#define TCP_BPF_IW		1001	/* Set TCP initial congestion window */
+#define TCP_BPF_SNDCWND_CLAMP	1002	/* Set sndcwnd_clamp */
+
+struct bpf_perf_event_value {
+	__u64 counter;
+	__u64 enabled;
+	__u64 running;
+};
+
+#define BPF_DEVCG_ACC_MKNOD	(1ULL << 0)
+#define BPF_DEVCG_ACC_READ	(1ULL << 1)
+#define BPF_DEVCG_ACC_WRITE	(1ULL << 2)
+
+#define BPF_DEVCG_DEV_BLOCK	(1ULL << 0)
+#define BPF_DEVCG_DEV_CHAR	(1ULL << 1)
+
+struct bpf_cgroup_dev_ctx {
+	/* access_type encoded as (BPF_DEVCG_ACC_* << 16) | BPF_DEVCG_DEV_* */
+	__u32 access_type;
+	__u32 major;
+	__u32 minor;
+};
+
+struct bpf_raw_tracepoint_args {
+	__u64 args[0];
+};
+
+/* DIRECT:  Skip the FIB rules and go to FIB table associated with device
+ * OUTPUT:  Do lookup from egress perspective; default is ingress
+ */
+#define BPF_FIB_LOOKUP_DIRECT  BIT(0)
+#define BPF_FIB_LOOKUP_OUTPUT  BIT(1)
+
+struct bpf_fib_lookup {
+	/* input:  network family for lookup (AF_INET, AF_INET6)
+	 * output: network family of egress nexthop
+	 */
+	__u8	family;
+
+	/* set if lookup is to consider L4 data - e.g., FIB rules */
+	__u8	l4_protocol;
+	__be16	sport;
+	__be16	dport;
+
+	/* total length of packet from network header - used for MTU check */
+	__u16	tot_len;
+	__u32	ifindex;  /* L3 device index for lookup */
+
+	union {
+		/* inputs to lookup */
+		__u8	tos;		/* AF_INET  */
+		__be32	flowinfo;	/* AF_INET6, flow_label + priority */
+
+		/* output: metric of fib result (IPv4/IPv6 only) */
+		__u32	rt_metric;
+	};
+
+	union {
+		__be32		ipv4_src;
+		__u32		ipv6_src[4];  /* in6_addr; network order */
+	};
+
+	/* input to bpf_fib_lookup, ipv{4,6}_dst is destination address in
+	 * network header. output: bpf_fib_lookup sets to gateway address
+	 * if FIB lookup returns gateway route
+	 */
+	union {
+		__be32		ipv4_dst;
+		__u32		ipv6_dst[4];  /* in6_addr; network order */
+	};
+
+	/* output */
+	__be16	h_vlan_proto;
+	__be16	h_vlan_TCI;
+	__u8	smac[6];     /* ETH_ALEN */
+	__u8	dmac[6];     /* ETH_ALEN */
+};
+
+enum bpf_task_fd_type {
+	BPF_FD_TYPE_RAW_TRACEPOINT,	/* tp name */
+	BPF_FD_TYPE_TRACEPOINT,		/* tp name */
+	BPF_FD_TYPE_KPROBE,		/* (symbol + offset) or addr */
+	BPF_FD_TYPE_KRETPROBE,		/* (symbol + offset) or addr */
+	BPF_FD_TYPE_UPROBE,		/* filename + offset */
+	BPF_FD_TYPE_URETPROBE,		/* filename + offset */
+};
+
+#endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/utils/keytable/Makefile.am b/utils/keytable/Makefile.am
index 904aa96b..ad251915 100644
--- a/utils/keytable/Makefile.am
+++ b/utils/keytable/Makefile.am
@@ -5,8 +5,13 @@ keytablesystem_DATA = $(srcdir)/rc_keymaps/*
 udevrules_DATA = 70-infrared.rules
 
 ir_keytable_SOURCES = keytable.c parse.h ir-encode.c ir-encode.h
+
+if HAVE_LIBELF
+ir_keytable_SOURCES += bpf.c bpf_load.c bpf.h bpf_load.h
+endif
+
 ir_keytable_LDADD = @LIBINTL@
-ir_keytable_LDFLAGS = $(ARGP_LIBS)
+ir_keytable_LDFLAGS = $(ARGP_LIBS) $(LIBELF_LIBS)
 
 EXTRA_DIST = 70-infrared.rules rc_keymaps rc_keymaps_userspace gen_keytables.pl ir-keytable.1 rc_maps.cfg
 
diff --git a/utils/keytable/bpf.c b/utils/keytable/bpf.c
new file mode 100644
index 00000000..b1cd2507
--- /dev/null
+++ b/utils/keytable/bpf.c
@@ -0,0 +1,515 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * common eBPF ELF operations.
+ *
+ * Copyright (C) 2013-2015 Alexei Starovoitov <ast@kernel.org>
+ * Copyright (C) 2015 Wang Nan <wangnan0@huawei.com>
+ * Copyright (C) 2015 Huawei Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
+ */
+
+#include <stdlib.h>
+#include <memory.h>
+#include <unistd.h>
+#include <asm/unistd.h>
+#include <linux/bpf.h>
+#include "bpf.h"
+#include <errno.h>
+
+/*
+ * When building perf, unistd.h is overridden. __NR_bpf is
+ * required to be defined explicitly.
+ */
+#ifndef __NR_bpf
+# if defined(__i386__)
+#  define __NR_bpf 357
+# elif defined(__x86_64__)
+#  define __NR_bpf 321
+# elif defined(__aarch64__)
+#  define __NR_bpf 280
+# elif defined(__sparc__)
+#  define __NR_bpf 349
+# elif defined(__s390__)
+#  define __NR_bpf 351
+# else
+#  error __NR_bpf not defined. libbpf does not support your arch.
+# endif
+#endif
+
+#ifndef min
+#define min(x, y) ((x) < (y) ? (x) : (y))
+#endif
+
+static inline __u64 ptr_to_u64(const void *ptr)
+{
+	return (__u64) (unsigned long) ptr;
+}
+
+static inline int sys_bpf(enum bpf_cmd cmd, union bpf_attr *attr,
+			  unsigned int size)
+{
+	return syscall(__NR_bpf, cmd, attr, size);
+}
+
+int bpf_create_map_xattr(const struct bpf_create_map_attr *create_attr)
+{
+	__u32 name_len = create_attr->name ? strlen(create_attr->name) : 0;
+	union bpf_attr attr;
+
+	memset(&attr, '\0', sizeof(attr));
+
+	attr.map_type = create_attr->map_type;
+	attr.key_size = create_attr->key_size;
+	attr.value_size = create_attr->value_size;
+	attr.max_entries = create_attr->max_entries;
+	attr.map_flags = create_attr->map_flags;
+	memcpy(attr.map_name, create_attr->name,
+	       min(name_len, BPF_OBJ_NAME_LEN - 1));
+	attr.numa_node = create_attr->numa_node;
+	attr.btf_fd = create_attr->btf_fd;
+	attr.btf_key_type_id = create_attr->btf_key_type_id;
+	attr.btf_value_type_id = create_attr->btf_value_type_id;
+	attr.map_ifindex = create_attr->map_ifindex;
+
+	return sys_bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
+}
+
+int bpf_create_map_node(enum bpf_map_type map_type, const char *name,
+			int key_size, int value_size, int max_entries,
+			__u32 map_flags, int node)
+{
+	struct bpf_create_map_attr map_attr = {};
+
+	map_attr.name = name;
+	map_attr.map_type = map_type;
+	map_attr.map_flags = map_flags;
+	map_attr.key_size = key_size;
+	map_attr.value_size = value_size;
+	map_attr.max_entries = max_entries;
+	if (node >= 0) {
+		map_attr.numa_node = node;
+		map_attr.map_flags |= BPF_F_NUMA_NODE;
+	}
+
+	return bpf_create_map_xattr(&map_attr);
+}
+
+int bpf_create_map(enum bpf_map_type map_type, int key_size,
+		   int value_size, int max_entries, __u32 map_flags)
+{
+	struct bpf_create_map_attr map_attr = {};
+
+	map_attr.map_type = map_type;
+	map_attr.map_flags = map_flags;
+	map_attr.key_size = key_size;
+	map_attr.value_size = value_size;
+	map_attr.max_entries = max_entries;
+
+	return bpf_create_map_xattr(&map_attr);
+}
+
+int bpf_create_map_name(enum bpf_map_type map_type, const char *name,
+			int key_size, int value_size, int max_entries,
+			__u32 map_flags)
+{
+	struct bpf_create_map_attr map_attr = {};
+
+	map_attr.name = name;
+	map_attr.map_type = map_type;
+	map_attr.map_flags = map_flags;
+	map_attr.key_size = key_size;
+	map_attr.value_size = value_size;
+	map_attr.max_entries = max_entries;
+
+	return bpf_create_map_xattr(&map_attr);
+}
+
+int bpf_create_map_in_map_node(enum bpf_map_type map_type, const char *name,
+			       int key_size, int inner_map_fd, int max_entries,
+			       __u32 map_flags, int node)
+{
+	__u32 name_len = name ? strlen(name) : 0;
+	union bpf_attr attr;
+
+	memset(&attr, '\0', sizeof(attr));
+
+	attr.map_type = map_type;
+	attr.key_size = key_size;
+	attr.value_size = 4;
+	attr.inner_map_fd = inner_map_fd;
+	attr.max_entries = max_entries;
+	attr.map_flags = map_flags;
+	memcpy(attr.map_name, name, min(name_len, BPF_OBJ_NAME_LEN - 1));
+
+	if (node >= 0) {
+		attr.map_flags |= BPF_F_NUMA_NODE;
+		attr.numa_node = node;
+	}
+
+	return sys_bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
+}
+
+int bpf_create_map_in_map(enum bpf_map_type map_type, const char *name,
+			  int key_size, int inner_map_fd, int max_entries,
+			  __u32 map_flags)
+{
+	return bpf_create_map_in_map_node(map_type, name, key_size,
+					  inner_map_fd, max_entries, map_flags,
+					  -1);
+}
+
+int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
+			   char *log_buf, size_t log_buf_sz)
+{
+	union bpf_attr attr;
+	__u32 name_len;
+	int fd;
+
+	if (!load_attr)
+		return -EINVAL;
+
+	name_len = load_attr->name ? strlen(load_attr->name) : 0;
+
+	bzero(&attr, sizeof(attr));
+	attr.prog_type = load_attr->prog_type;
+	attr.expected_attach_type = load_attr->expected_attach_type;
+	attr.insn_cnt = (__u32)load_attr->insns_cnt;
+	attr.insns = ptr_to_u64(load_attr->insns);
+	attr.license = ptr_to_u64(load_attr->license);
+	attr.log_buf = ptr_to_u64(NULL);
+	attr.log_size = 0;
+	attr.log_level = 0;
+	attr.kern_version = load_attr->kern_version;
+	attr.prog_ifindex = load_attr->prog_ifindex;
+	memcpy(attr.prog_name, load_attr->name,
+	       min(name_len, BPF_OBJ_NAME_LEN - 1));
+
+	fd = sys_bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
+	if (fd >= 0 || !log_buf || !log_buf_sz)
+		return fd;
+
+	/* Try again with log */
+	attr.log_buf = ptr_to_u64(log_buf);
+	attr.log_size = log_buf_sz;
+	attr.log_level = 1;
+	log_buf[0] = 0;
+	return sys_bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
+}
+
+int bpf_load_program(enum bpf_prog_type type, const struct bpf_insn *insns,
+		     size_t insns_cnt, const char *name, const char *license,
+		     __u32 kern_version, char *log_buf,
+		     size_t log_buf_sz)
+{
+	struct bpf_load_program_attr load_attr;
+
+	memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
+	load_attr.prog_type = type;
+	load_attr.expected_attach_type = 0;
+	load_attr.name = name;
+	load_attr.insns = insns;
+	load_attr.insns_cnt = insns_cnt;
+	load_attr.license = license;
+	load_attr.kern_version = kern_version;
+
+	return bpf_load_program_xattr(&load_attr, log_buf, log_buf_sz);
+}
+
+int bpf_verify_program(enum bpf_prog_type type, const struct bpf_insn *insns,
+		       size_t insns_cnt, int strict_alignment,
+		       const char *license, __u32 kern_version,
+		       char *log_buf, size_t log_buf_sz, int log_level)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.prog_type = type;
+	attr.insn_cnt = (__u32)insns_cnt;
+	attr.insns = ptr_to_u64(insns);
+	attr.license = ptr_to_u64(license);
+	attr.log_buf = ptr_to_u64(log_buf);
+	attr.log_size = log_buf_sz;
+	attr.log_level = log_level;
+	log_buf[0] = 0;
+	attr.kern_version = kern_version;
+	attr.prog_flags = strict_alignment ? BPF_F_STRICT_ALIGNMENT : 0;
+
+	return sys_bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
+}
+
+int bpf_map_update_elem(int fd, const void *key, const void *value,
+			__u64 flags)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.map_fd = fd;
+	attr.key = ptr_to_u64(key);
+	attr.value = ptr_to_u64(value);
+	attr.flags = flags;
+
+	return sys_bpf(BPF_MAP_UPDATE_ELEM, &attr, sizeof(attr));
+}
+
+int bpf_map_lookup_elem(int fd, const void *key, void *value)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.map_fd = fd;
+	attr.key = ptr_to_u64(key);
+	attr.value = ptr_to_u64(value);
+
+	return sys_bpf(BPF_MAP_LOOKUP_ELEM, &attr, sizeof(attr));
+}
+
+int bpf_map_delete_elem(int fd, const void *key)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.map_fd = fd;
+	attr.key = ptr_to_u64(key);
+
+	return sys_bpf(BPF_MAP_DELETE_ELEM, &attr, sizeof(attr));
+}
+
+int bpf_map_get_next_key(int fd, const void *key, void *next_key)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.map_fd = fd;
+	attr.key = ptr_to_u64(key);
+	attr.next_key = ptr_to_u64(next_key);
+
+	return sys_bpf(BPF_MAP_GET_NEXT_KEY, &attr, sizeof(attr));
+}
+
+int bpf_obj_pin(int fd, const char *pathname)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.pathname = ptr_to_u64((void *)pathname);
+	attr.bpf_fd = fd;
+
+	return sys_bpf(BPF_OBJ_PIN, &attr, sizeof(attr));
+}
+
+int bpf_obj_get(const char *pathname)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.pathname = ptr_to_u64((void *)pathname);
+
+	return sys_bpf(BPF_OBJ_GET, &attr, sizeof(attr));
+}
+
+int bpf_prog_attach(int prog_fd, int target_fd, enum bpf_attach_type type,
+		    unsigned int flags)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.target_fd	   = target_fd;
+	attr.attach_bpf_fd = prog_fd;
+	attr.attach_type   = type;
+	attr.attach_flags  = flags;
+
+	return sys_bpf(BPF_PROG_ATTACH, &attr, sizeof(attr));
+}
+
+int bpf_prog_detach(int target_fd, enum bpf_attach_type type)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.target_fd	 = target_fd;
+	attr.attach_type = type;
+
+	return sys_bpf(BPF_PROG_DETACH, &attr, sizeof(attr));
+}
+
+int bpf_prog_detach2(int prog_fd, int target_fd, enum bpf_attach_type type)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.target_fd	 = target_fd;
+	attr.attach_bpf_fd = prog_fd;
+	attr.attach_type = type;
+
+	return sys_bpf(BPF_PROG_DETACH, &attr, sizeof(attr));
+}
+
+int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
+		   __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt)
+{
+	union bpf_attr attr;
+	int ret;
+
+	bzero(&attr, sizeof(attr));
+	attr.query.target_fd	= target_fd;
+	attr.query.attach_type	= type;
+	attr.query.query_flags	= query_flags;
+	attr.query.prog_cnt	= *prog_cnt;
+	attr.query.prog_ids	= ptr_to_u64(prog_ids);
+
+	ret = sys_bpf(BPF_PROG_QUERY, &attr, sizeof(attr));
+	if (attach_flags)
+		*attach_flags = attr.query.attach_flags;
+	*prog_cnt = attr.query.prog_cnt;
+	return ret;
+}
+
+int bpf_prog_test_run(int prog_fd, int repeat, void *data, __u32 size,
+		      void *data_out, __u32 *size_out, __u32 *retval,
+		      __u32 *duration)
+{
+	union bpf_attr attr;
+	int ret;
+
+	bzero(&attr, sizeof(attr));
+	attr.test.prog_fd = prog_fd;
+	attr.test.data_in = ptr_to_u64(data);
+	attr.test.data_out = ptr_to_u64(data_out);
+	attr.test.data_size_in = size;
+	attr.test.repeat = repeat;
+
+	ret = sys_bpf(BPF_PROG_TEST_RUN, &attr, sizeof(attr));
+	if (size_out)
+		*size_out = attr.test.data_size_out;
+	if (retval)
+		*retval = attr.test.retval;
+	if (duration)
+		*duration = attr.test.duration;
+	return ret;
+}
+
+int bpf_prog_get_next_id(__u32 start_id, __u32 *next_id)
+{
+	union bpf_attr attr;
+	int err;
+
+	bzero(&attr, sizeof(attr));
+	attr.start_id = start_id;
+
+	err = sys_bpf(BPF_PROG_GET_NEXT_ID, &attr, sizeof(attr));
+	if (!err)
+		*next_id = attr.next_id;
+
+	return err;
+}
+
+int bpf_map_get_next_id(__u32 start_id, __u32 *next_id)
+{
+	union bpf_attr attr;
+	int err;
+
+	bzero(&attr, sizeof(attr));
+	attr.start_id = start_id;
+
+	err = sys_bpf(BPF_MAP_GET_NEXT_ID, &attr, sizeof(attr));
+	if (!err)
+		*next_id = attr.next_id;
+
+	return err;
+}
+
+int bpf_prog_get_fd_by_id(__u32 id)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.prog_id = id;
+
+	return sys_bpf(BPF_PROG_GET_FD_BY_ID, &attr, sizeof(attr));
+}
+
+int bpf_map_get_fd_by_id(__u32 id)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.map_id = id;
+
+	return sys_bpf(BPF_MAP_GET_FD_BY_ID, &attr, sizeof(attr));
+}
+
+int bpf_btf_get_fd_by_id(__u32 id)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.btf_id = id;
+
+	return sys_bpf(BPF_BTF_GET_FD_BY_ID, &attr, sizeof(attr));
+}
+
+int bpf_obj_get_info_by_fd(int prog_fd, void *info, __u32 *info_len)
+{
+	union bpf_attr attr;
+	int err;
+
+	bzero(&attr, sizeof(attr));
+	attr.info.bpf_fd = prog_fd;
+	attr.info.info_len = *info_len;
+	attr.info.info = ptr_to_u64(info);
+
+	err = sys_bpf(BPF_OBJ_GET_INFO_BY_FD, &attr, sizeof(attr));
+	if (!err)
+		*info_len = attr.info.info_len;
+
+	return err;
+}
+
+int bpf_raw_tracepoint_open(const char *name, int prog_fd)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.raw_tracepoint.name = ptr_to_u64(name);
+	attr.raw_tracepoint.prog_fd = prog_fd;
+
+	return sys_bpf(BPF_RAW_TRACEPOINT_OPEN, &attr, sizeof(attr));
+}
+
+int bpf_load_btf(void *btf, __u32 btf_size, char *log_buf, __u32 log_buf_size,
+		 bool do_log)
+{
+	union bpf_attr attr = {};
+	int fd;
+
+	attr.btf = ptr_to_u64(btf);
+	attr.btf_size = btf_size;
+
+retry:
+	if (do_log && log_buf && log_buf_size) {
+		attr.btf_log_level = 1;
+		attr.btf_log_size = log_buf_size;
+		attr.btf_log_buf = ptr_to_u64(log_buf);
+	}
+
+	fd = sys_bpf(BPF_BTF_LOAD, &attr, sizeof(attr));
+	if (fd == -1 && !do_log && log_buf && log_buf_size) {
+		do_log = true;
+		goto retry;
+	}
+
+	return fd;
+}
diff --git a/utils/keytable/bpf.h b/utils/keytable/bpf.h
new file mode 100644
index 00000000..fb3896c9
--- /dev/null
+++ b/utils/keytable/bpf.h
@@ -0,0 +1,110 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * common eBPF ELF operations.
+ *
+ * Copyright (C) 2013-2015 Alexei Starovoitov <ast@kernel.org>
+ * Copyright (C) 2015 Wang Nan <wangnan0@huawei.com>
+ * Copyright (C) 2015 Huawei Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
+ */
+#ifndef __BPF_BPF_H
+#define __BPF_BPF_H
+
+#include <linux/bpf.h>
+#include <stdbool.h>
+#include <stddef.h>
+
+struct bpf_create_map_attr {
+	const char *name;
+	enum bpf_map_type map_type;
+	__u32 map_flags;
+	__u32 key_size;
+	__u32 value_size;
+	__u32 max_entries;
+	__u32 numa_node;
+	__u32 btf_fd;
+	__u32 btf_key_type_id;
+	__u32 btf_value_type_id;
+	__u32 map_ifindex;
+};
+
+int bpf_create_map_xattr(const struct bpf_create_map_attr *create_attr);
+int bpf_create_map_node(enum bpf_map_type map_type, const char *name,
+			int key_size, int value_size, int max_entries,
+			__u32 map_flags, int node);
+int bpf_create_map_name(enum bpf_map_type map_type, const char *name,
+			int key_size, int value_size, int max_entries,
+			__u32 map_flags);
+int bpf_create_map(enum bpf_map_type map_type, int key_size, int value_size,
+		   int max_entries, __u32 map_flags);
+int bpf_create_map_in_map_node(enum bpf_map_type map_type, const char *name,
+			       int key_size, int inner_map_fd, int max_entries,
+			       __u32 map_flags, int node);
+int bpf_create_map_in_map(enum bpf_map_type map_type, const char *name,
+			  int key_size, int inner_map_fd, int max_entries,
+			  __u32 map_flags);
+
+struct bpf_load_program_attr {
+	enum bpf_prog_type prog_type;
+	enum bpf_attach_type expected_attach_type;
+	const char *name;
+	const struct bpf_insn *insns;
+	size_t insns_cnt;
+	const char *license;
+	__u32 kern_version;
+	__u32 prog_ifindex;
+};
+
+/* Recommend log buffer size */
+#define BPF_LOG_BUF_SIZE (256 * 1024)
+int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
+			   char *log_buf, size_t log_buf_sz);
+int bpf_load_program(enum bpf_prog_type type, const struct bpf_insn *insns,
+		     size_t insns_cnt, const char *name, const char *license,
+		     __u32 kern_version, char *log_buf,
+		     size_t log_buf_sz);
+int bpf_verify_program(enum bpf_prog_type type, const struct bpf_insn *insns,
+		       size_t insns_cnt, int strict_alignment,
+		       const char *license, __u32 kern_version,
+		       char *log_buf, size_t log_buf_sz, int log_level);
+
+int bpf_map_update_elem(int fd, const void *key, const void *value,
+			__u64 flags);
+
+int bpf_map_lookup_elem(int fd, const void *key, void *value);
+int bpf_map_delete_elem(int fd, const void *key);
+int bpf_map_get_next_key(int fd, const void *key, void *next_key);
+int bpf_obj_pin(int fd, const char *pathname);
+int bpf_obj_get(const char *pathname);
+int bpf_prog_attach(int prog_fd, int attachable_fd, enum bpf_attach_type type,
+		    unsigned int flags);
+int bpf_prog_detach(int attachable_fd, enum bpf_attach_type type);
+int bpf_prog_detach2(int prog_fd, int attachable_fd, enum bpf_attach_type type);
+int bpf_prog_test_run(int prog_fd, int repeat, void *data, __u32 size,
+		      void *data_out, __u32 *size_out, __u32 *retval,
+		      __u32 *duration);
+int bpf_prog_get_next_id(__u32 start_id, __u32 *next_id);
+int bpf_map_get_next_id(__u32 start_id, __u32 *next_id);
+int bpf_prog_get_fd_by_id(__u32 id);
+int bpf_map_get_fd_by_id(__u32 id);
+int bpf_btf_get_fd_by_id(__u32 id);
+int bpf_obj_get_info_by_fd(int prog_fd, void *info, __u32 *info_len);
+int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
+		   __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt);
+int bpf_raw_tracepoint_open(const char *name, int prog_fd);
+int bpf_load_btf(void *btf, __u32 btf_size, char *log_buf, __u32 log_buf_size,
+		 bool do_log);
+#endif
diff --git a/utils/keytable/bpf_load.c b/utils/keytable/bpf_load.c
new file mode 100644
index 00000000..5e9040a7
--- /dev/null
+++ b/utils/keytable/bpf_load.c
@@ -0,0 +1,455 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <libelf.h>
+#include <gelf.h>
+#include <errno.h>
+#include <unistd.h>
+#include <string.h>
+#include <stdbool.h>
+#include <limits.h>
+#include <stdlib.h>
+#include <linux/bpf.h>
+#include <assert.h>
+#include "bpf.h"
+#include "bpf_load.h"
+
+#ifdef ENABLE_NLS
+# define _(string) gettext(string)
+# include "gettext.h"
+# include <locale.h>
+# include <langinfo.h>
+# include <iconv.h>
+#else
+# define _(string) string
+#endif
+
+
+char bpf_log_buf[BPF_LOG_BUF_SIZE];
+extern int debug;
+
+struct bpf_file {
+	Elf *elf;
+	char license[128];
+	bool processed_sec[128];
+	int map_fd[MAX_MAPS];
+	struct bpf_map_data map_data[MAX_MAPS];
+	int nr_maps;
+	int maps_shidx;
+	int dataidx;
+	int bssidx;
+	Elf_Data *data;
+	int strtabidx;
+	Elf_Data *symbols;
+};
+
+static int load_and_attach(int lirc_fd, struct bpf_file *bpf_file, const char *name, struct bpf_insn *prog, int size)
+{
+        size_t insns_cnt = size / sizeof(struct bpf_insn);
+	int fd, err;
+
+	fd = bpf_load_program(BPF_PROG_TYPE_LIRC_MODE2, prog, insns_cnt,
+			      name, bpf_file->license, 0,
+			      bpf_log_buf, BPF_LOG_BUF_SIZE);
+	if (fd < 0) {
+		printf("bpf_load_program() err=%d\n%s", errno, bpf_log_buf);
+		return -1;
+	}
+
+	err = bpf_prog_attach(fd, lirc_fd, BPF_LIRC_MODE2, 0);
+	if (err) {
+		printf("bpf_prog_attach: err=%m\n");
+		return -1;
+	}
+	return 0;
+}
+
+static int load_maps(struct bpf_file *bpf_file)
+{
+	struct bpf_map_data *maps = bpf_file->map_data;
+	int i, numa_node;
+
+	for (i = 0; i < bpf_file->nr_maps; i++) {
+		numa_node = maps[i].def.map_flags & BPF_F_NUMA_NODE ?
+			maps[i].def.numa_node : -1;
+
+		if (maps[i].def.type == BPF_MAP_TYPE_ARRAY_OF_MAPS ||
+		    maps[i].def.type == BPF_MAP_TYPE_HASH_OF_MAPS) {
+			int inner_map_fd = bpf_file->map_fd[maps[i].def.inner_map_idx];
+
+			bpf_file->map_fd[i] = bpf_create_map_in_map_node(
+							maps[i].def.type,
+							maps[i].name,
+							maps[i].def.key_size,
+							inner_map_fd,
+							maps[i].def.max_entries,
+							maps[i].def.map_flags,
+							numa_node);
+		} else {
+			bpf_file->map_fd[i] = bpf_create_map_node(
+							maps[i].def.type,
+							maps[i].name,
+							maps[i].def.key_size,
+							maps[i].def.value_size,
+							maps[i].def.max_entries,
+							maps[i].def.map_flags,
+							numa_node);
+		}
+		if (bpf_file->map_fd[i] < 0) {
+			printf(_("failed to create a map: %d %s\n"),
+			       errno, strerror(errno));
+			return 1;
+		}
+		maps[i].fd = bpf_file->map_fd[i];
+	}
+	return 0;
+}
+
+static int get_sec(Elf *elf, int i, GElf_Ehdr *ehdr, char **shname,
+		   GElf_Shdr *shdr, Elf_Data **data)
+{
+	Elf_Scn *scn;
+
+	scn = elf_getscn(elf, i);
+	if (!scn)
+		return 1;
+
+	if (gelf_getshdr(scn, shdr) != shdr)
+		return 2;
+
+	*shname = elf_strptr(elf, ehdr->e_shstrndx, shdr->sh_name);
+	if (!*shname || !shdr->sh_size)
+		return 3;
+
+	*data = elf_getdata(scn, 0);
+	if (!*data || elf_getdata(scn, *data) != NULL)
+		return 4;
+
+	return 0;
+}
+
+static int parse_relo_and_apply(struct bpf_file *bpf_file, GElf_Shdr *shdr,
+				struct bpf_insn *insn, Elf_Data *data)
+{
+	int i, nrels;
+
+	nrels = shdr->sh_size / shdr->sh_entsize;
+
+	for (i = 0; i < nrels; i++) {
+		GElf_Sym sym;
+		GElf_Rel rel;
+		unsigned int insn_idx;
+		const char *sym_name;
+		bool match = false;
+		int map_idx;
+
+		gelf_getrel(data, i, &rel);
+
+		insn_idx = rel.r_offset / sizeof(struct bpf_insn);
+
+		gelf_getsym(bpf_file->symbols, GELF_R_SYM(rel.r_info), &sym);
+
+		sym_name = elf_strptr(bpf_file->elf, bpf_file->strtabidx, sym.st_name);
+
+		if (insn[insn_idx].code != (BPF_LD | BPF_IMM | BPF_DW)) {
+			printf(_("invalid relo for insn[%d].code 0x%x\n"),
+			       insn_idx, insn[insn_idx].code);
+			return 1;
+		}
+
+		if (sym.st_shndx == bpf_file->maps_shidx) {
+			/* Match FD relocation against recorded map_data[] offset */
+			for (map_idx = 0; map_idx < bpf_file->nr_maps; map_idx++) {
+				if (bpf_file->map_data[map_idx].elf_offset == sym.st_value) {
+					match = true;
+					break;
+				}
+			}
+
+			if (match) {
+		                insn[insn_idx].src_reg = BPF_PSEUDO_MAP_FD;
+				insn[insn_idx].imm = bpf_file->map_data[map_idx].fd;
+				continue;
+			}
+
+			printf(_("invalid relo for insn[%d] no map_data match\n"),
+			       insn_idx);
+			return 1;
+		}
+		else if (sym.st_shndx == bpf_file->dataidx || sym.st_shndx == bpf_file->bssidx) {
+			const char *raw = NULL;
+			int value = 0;
+
+			if (!bpf_param(sym_name, &value)) {
+				// done
+			} else if (sym.st_shndx == bpf_file->dataidx) {
+				int32_t *p = (bpf_file->data->d_buf + sym.st_value);
+				value = *p;
+			}
+
+			if (debug)
+				printf(_("patching insn[%d] with immediate %d for symbol %s\n"), insn_idx, value, sym_name);
+
+			// patch ld to mov immediate
+			insn[insn_idx].imm = value;
+		} else {
+			printf(_("symbol %s has unknown section %d\n"), sym_name, sym.st_shndx);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int cmp_symbols(const void *l, const void *r)
+{
+	const GElf_Sym *lsym = (const GElf_Sym *)l;
+	const GElf_Sym *rsym = (const GElf_Sym *)r;
+
+	if (lsym->st_value < rsym->st_value)
+		return -1;
+	else if (lsym->st_value > rsym->st_value)
+		return 1;
+	else
+		return 0;
+}
+
+static int load_elf_maps_section(struct bpf_file *bpf_file)
+{
+	int map_sz_elf, map_sz_copy;
+	bool validate_zero = false;
+	Elf_Data *data_maps;
+	int i, nr_maps;
+	GElf_Sym *sym;
+	Elf_Scn *scn;
+
+	if (bpf_file->maps_shidx < 0)
+		return -EINVAL;
+	if (!bpf_file->symbols)
+		return -EINVAL;
+
+	/* Get data for maps section via elf index */
+	scn = elf_getscn(bpf_file->elf, bpf_file->maps_shidx);
+	if (scn)
+		data_maps = elf_getdata(scn, NULL);
+	if (!scn || !data_maps) {
+		printf(_("Failed to get Elf_Data from maps section %d\n"),
+		       bpf_file->maps_shidx);
+		return -EINVAL;
+	}
+
+	/* For each map get corrosponding symbol table entry */
+	sym = calloc(MAX_MAPS+1, sizeof(GElf_Sym));
+	for (i = 0, nr_maps = 0; i < bpf_file->symbols->d_size / sizeof(GElf_Sym); i++) {
+		assert(nr_maps < MAX_MAPS+1);
+		if (!gelf_getsym(bpf_file->symbols, i, &sym[nr_maps]))
+			continue;
+		if (sym[nr_maps].st_shndx != bpf_file->maps_shidx)
+			continue;
+		/* Only increment iif maps section */
+		nr_maps++;
+	}
+
+	/* Align to map_fd[] order, via sort on offset in sym.st_value */
+	qsort(sym, nr_maps, sizeof(GElf_Sym), cmp_symbols);
+
+	/* Keeping compatible with ELF maps section changes
+	 * ------------------------------------------------
+	 * The program size of struct bpf_load_map_def is known by loader
+	 * code, but struct stored in ELF file can be different.
+	 *
+	 * Unfortunately sym[i].st_size is zero.  To calculate the
+	 * struct size stored in the ELF file, assume all struct have
+	 * the same size, and simply divide with number of map
+	 * symbols.
+	 */
+	map_sz_elf = data_maps->d_size / nr_maps;
+	map_sz_copy = sizeof(struct bpf_load_map_def);
+	if (map_sz_elf < map_sz_copy) {
+		/*
+		 * Backward compat, loading older ELF file with
+		 * smaller struct, keeping remaining bytes zero.
+		 */
+		map_sz_copy = map_sz_elf;
+	} else if (map_sz_elf > map_sz_copy) {
+		/*
+		 * Forward compat, loading newer ELF file with larger
+		 * struct with unknown features. Assume zero means
+		 * feature not used.  Thus, validate rest of struct
+		 * data is zero.
+		 */
+		validate_zero = true;
+	}
+
+	/* Memcpy relevant part of ELF maps data to loader maps */
+	for (i = 0; i < nr_maps; i++) {
+		struct bpf_load_map_def *def;
+		unsigned char *addr, *end;
+		const char *map_name;
+		struct bpf_map_data *maps = bpf_file->map_data;
+		size_t offset;
+
+		map_name = elf_strptr(bpf_file->elf, bpf_file->strtabidx, sym[i].st_name);
+		maps[i].name = strdup(map_name);
+		if (!maps[i].name) {
+			printf(_("strdup(%s): %s(%d)\n"), map_name,
+			       strerror(errno), errno);
+			free(sym);
+			return -errno;
+		}
+
+		/* Symbol value is offset into ELF maps section data area */
+		offset = sym[i].st_value;
+		def = (struct bpf_load_map_def *)(data_maps->d_buf + offset);
+		maps[i].elf_offset = offset;
+		memset(&maps[i].def, 0, sizeof(struct bpf_load_map_def));
+		memcpy(&maps[i].def, def, map_sz_copy);
+
+		/* Verify no newer features were requested */
+		if (validate_zero) {
+			addr = (unsigned char*) def + map_sz_copy;
+			end  = (unsigned char*) def + map_sz_elf;
+			for (; addr < end; addr++) {
+				if (*addr != 0) {
+					free(sym);
+					return -EFBIG;
+				}
+			}
+		}
+	}
+
+	free(sym);
+	return nr_maps;
+}
+
+int load_bpf_file(const char *path, int lirc_fd)
+{
+	struct bpf_file bpf_file = {};
+	int fd, i, ret;
+	Elf *elf;
+	GElf_Ehdr ehdr;
+	GElf_Shdr shdr, shdr_prog;
+	Elf_Data *data, *data_prog, *data_map = NULL;
+	char *shname, *shname_prog;
+	int nr_maps = 0;
+
+	if (elf_version(EV_CURRENT) == EV_NONE)
+		return 1;
+
+	fd = open(path, O_RDONLY, 0);
+	if (fd < 0)
+		return 1;
+
+	elf = elf_begin(fd, ELF_C_READ, NULL);
+
+	if (!elf)
+		return 1;
+
+	if (gelf_getehdr(elf, &ehdr) != &ehdr)
+		return 1;
+
+	bpf_file.elf = elf;
+
+	/* scan over all elf sections to get license and map info */
+	for (i = 1; i < ehdr.e_shnum; i++) {
+
+		if (get_sec(elf, i, &ehdr, &shname, &shdr, &data))
+			continue;
+
+		if (debug)
+			printf(_("section %d:%s data %p size %zd link %d flags %d\n"),
+			       i, shname, data->d_buf, data->d_size,
+			       shdr.sh_link, (int) shdr.sh_flags);
+
+		if (strcmp(shname, "license") == 0) {
+			bpf_file.processed_sec[i] = true;
+			memcpy(bpf_file.license, data->d_buf, data->d_size);
+		} else if (strcmp(shname, "maps") == 0) {
+			int j;
+
+			bpf_file.maps_shidx = i;
+			data_map = data;
+			for (j = 0; j < MAX_MAPS; j++)
+				bpf_file.map_data[j].fd = -1;
+		} else if (strcmp(shname, ".data") == 0) {
+			bpf_file.dataidx = i;
+			bpf_file.data = data;
+		} else if (strcmp(shname, ".bss") == 0) {
+			bpf_file.bssidx = i;
+		} else if (shdr.sh_type == SHT_SYMTAB) {
+			bpf_file.strtabidx = shdr.sh_link;
+			bpf_file.symbols = data;
+		}
+	}
+
+	ret = 1;
+
+	if (!bpf_file.symbols) {
+		printf(_("missing SHT_SYMTAB section\n"));
+		goto done;
+	}
+
+	if (data_map) {
+		bpf_file.nr_maps = load_elf_maps_section(&bpf_file);
+		if (bpf_file.nr_maps < 0) {
+			printf(_("Error: Failed loading ELF maps (errno:%d):%s\n"),
+			       nr_maps, strerror(-nr_maps));
+			goto done;
+		}
+		if (load_maps(&bpf_file))
+			goto done;
+
+		bpf_file.processed_sec[bpf_file.maps_shidx] = true;
+	}
+
+	/* process all relo sections, and rewrite bpf insns for maps */
+	for (i = 1; i < ehdr.e_shnum; i++) {
+		if (bpf_file.processed_sec[i])
+			continue;
+
+		if (get_sec(elf, i, &ehdr, &shname, &shdr, &data))
+			continue;
+
+		if (shdr.sh_type == SHT_REL) {
+			struct bpf_insn *insns;
+
+			/* locate prog sec that need map fixup (relocations) */
+			if (get_sec(elf, shdr.sh_info, &ehdr, &shname_prog,
+				    &shdr_prog, &data_prog))
+				continue;
+
+			if (shdr_prog.sh_type != SHT_PROGBITS ||
+			    !(shdr_prog.sh_flags & SHF_EXECINSTR))
+				continue;
+
+			insns = (struct bpf_insn *) data_prog->d_buf;
+			bpf_file.processed_sec[i] = true; /* relo section */
+
+			if (parse_relo_and_apply(&bpf_file, &shdr, insns, data))
+				continue;
+		}
+	}
+
+	/* load programs */
+	for (i = 1; i < ehdr.e_shnum; i++) {
+		if (bpf_file.processed_sec[i])
+			continue;
+
+		if (get_sec(elf, i, &ehdr, &shname, &shdr, &data))
+			continue;
+
+		if (shdr.sh_type != SHT_PROGBITS ||
+		    !(shdr.sh_flags & SHF_EXECINSTR))
+			continue;
+
+		ret = load_and_attach(lirc_fd, &bpf_file, shname, data->d_buf,
+				      data->d_size);
+		break;
+	}
+
+done:
+	close(fd);
+	return ret;
+}
diff --git a/utils/keytable/bpf_load.h b/utils/keytable/bpf_load.h
new file mode 100644
index 00000000..ec9763e4
--- /dev/null
+++ b/utils/keytable/bpf_load.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __BPF_LOAD_H
+#define __BPF_LOAD_H
+
+#define BPF_LOG_BUF_SIZE (256 * 1024)
+
+#define MAX_MAPS 32
+#define MAX_PROGS 64
+
+struct bpf_load_map_def {
+	unsigned int type;
+	unsigned int key_size;
+	unsigned int value_size;
+	unsigned int max_entries;
+	unsigned int map_flags;
+	unsigned int inner_map_idx;
+	unsigned int numa_node;
+};
+
+struct bpf_map_data {
+	int fd;
+	char *name;
+	size_t elf_offset;
+	struct bpf_load_map_def def;
+};
+
+/* parses elf file compiled by llvm .c->.o
+ * . parses 'maps' section and creates maps via BPF syscall
+ * . parses 'license' section and passes it to syscall
+ * . parses elf relocations for BPF maps and adjusts BPF_LD_IMM64 insns by
+ *   storing map_fd into insn->imm and marking such insns as BPF_PSEUDO_MAP_FD
+ * . loads eBPF programs via BPF syscall
+ *
+ * One ELF file can contain multiple BPF programs which will be loaded
+ * and their FDs stored stored in prog_fd array
+ *
+ * returns zero on success
+ */
+int load_bpf_file(const char *path, int lirc_fd);
+
+int bpf_param(const char *name, int *val);
+
+#endif
diff --git a/utils/keytable/ir-keytable.1.in b/utils/keytable/ir-keytable.1.in
index db1843b3..0be8a5a7 100644
--- a/utils/keytable/ir-keytable.1.in
+++ b/utils/keytable/ir-keytable.1.in
@@ -35,8 +35,10 @@ Sets the delay before repeating a keystroke
 Change scan/key pairs
 .TP 
 \fB\-p\fR, \fB\-\-protocol\fR=\fIPROTOCOL\fR
-Protocol to enable (the other ones will be disabled). To enable more than one, 
-use the option more than one time
+Comma seperated list of protocols to enabled (the other ones will be disabled). Alternatively, this is the path to a BPF protocol to be loaded.
+.TP
+\fB\-e\fR, \fB\-\-parameter\fR=\fIPARAMETER\fR
+Commma seperated list of parameters for the BPF protocol
 .TP
 \fB\-P\fR, \fB\-\-period\fR\=\fiPERIOD\fR
 Sets the period to repeat a keystroke
@@ -78,7 +80,9 @@ a file wit a set of scancode=keycode value pairs
 .IP \fISCANKEY\fR
 a set of scancode1=keycode1,scancode2=keycode2.. value pairs
 .IP \fIPROTOCOL\fR
-protocol name to be enabled (case insensitive). Supported protocols are: NEC, RC-5, RC-6, JVC, SONY, SANYO, LIRC, RC-5-SZ, SHARP, MCE-KBD, XMP, other, all.
+Comma separated list of protocols to be enabled (case insensitive). Supported kernel protocols are: NEC, RC-5, RC-6, JVC, SONY, SANYO, LIRC, RC-5-SZ, SHARP, MCE-KBD, XMP, IMON, other, all. There are also BPF protocols: manchester, rc_mm, pulse_distance, grundig. Alternatively, this can be the path to a BPF protocol file to be loaded.
+.IP \fIPARAMETERS\fR
+Comma seperated list of parameters for the BPF protocol being loaded. They have the format of name=value, where value is an number.
 .IP \fIDELAY\fR
 Delay before repeating a keystroke
 .IP \fIPERIOD\fR
@@ -102,6 +106,10 @@ To append more codes to the existing table:
 .PP
 To read the current keytable, on the second remote controller:
 	\fBir\-keytable \-s rc1 \-r\fR
+.PP
+To enable NEC protocol and load a BPF protocol, with a parameter for the BPF protocol:
+.br
+	\fBir\-keytable \-p nec,pulse_distance \-e pulse_header=9000
 .SH BUGS
 Report bugs to \fBLinux Media Mailing List <linux-media@vger.kernel.org>\fR
 .SH COPYRIGHT
diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 482fcf86..d058c856 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -33,6 +33,8 @@
 
 #include "ir-encode.h"
 #include "parse.h"
+#include "bpf.h"
+#include "bpf_load.h"
 
 #ifdef ENABLE_NLS
 # define _(string) gettext(string)
@@ -55,6 +57,10 @@ struct input_keymap_entry_v2 {
 	u_int8_t  scancode[32];
 };
 
+
+#define IR_PROTOCOLS_USER_DIR IR_KEYTABLE_USER_DIR "/protocols"
+#define IR_PROTOCOLS_SYSTEM_DIR IR_KEYTABLE_SYSTEM_DIR "/protocols"
+
 #ifndef EVIOCSCLOCKID
 #define EVIOCSCLOCKID		_IOW('E', 0xa0, int)
 #endif
@@ -218,15 +224,18 @@ static const char doc[] = N_(
 	"\nAllows get/set IR keycode/scancode tables\n"
 	"You need to have read permissions on /dev/input for the program to work\n"
 	"\nOn the options below, the arguments are:\n"
-	"  DEV      - the /dev/input/event* device to control\n"
-	"  SYSDEV   - the ir class as found at /sys/class/rc\n"
-	"  TABLE    - a file with a set of scancode=keycode value pairs\n"
-	"  SCANKEY  - a set of scancode1=keycode1,scancode2=keycode2.. value pairs\n"
-	"  PROTOCOL - protocol name (nec, rc-5, rc-6, jvc, sony, sanyo, rc-5-sz, lirc,\n"
-	"                            sharp, mce_kbd, xmp, other, all) to be enabled\n"
-	"  DELAY    - Delay before repeating a keystroke\n"
-	"  PERIOD   - Period to repeat a keystroke\n"
-	"  CFGFILE  - configuration file that associates a driver/table name with a keymap file\n"
+	"  DEV       - the /dev/input/event* device to control\n"
+	"  SYSDEV    - the ir class as found at /sys/class/rc\n"
+	"  TABLE     - a file with a set of scancode=keycode value pairs\n"
+	"  SCANKEY   - a set of scancode1=keycode1,scancode2=keycode2.. value pairs\n"
+	"  PROTOCOL  - protocol name (nec, rc-5, rc-6, jvc, sony, sanyo, rc-5-sz, lirc,\n"
+	"              sharp, mce_kbd, xmp, imon, other, all) to be enabled,\n"
+	"              or a bpf protocol name or file\n"
+	"  DELAY     - Delay before repeating a keystroke\n"
+	"  PERIOD    - Period to repeat a keystroke\n"
+	"  PARAMETER - a set of name1=number1[,name2=number2]... for the BPF prototcol\n"
+	"  CFGFILE   - configuration file that associates a driver/table name with\n"
+	"              a keymap file\n"
 	"\nOptions can be combined together.");
 
 static const struct argp_option options[] = {
@@ -239,6 +248,7 @@ static const struct argp_option options[] = {
 	{"write",	'w',	N_("TABLE"),	0,	N_("write (adds) the scancodes to the device scancode/keycode table from an specified file"), 0},
 	{"set-key",	'k',	N_("SCANKEY"),	0,	N_("Change scan/key pairs"), 0},
 	{"protocol",	'p',	N_("PROTOCOL"),	0,	N_("Protocol to enable (the other ones will be disabled). To enable more than one, use the option more than one time"), 0},
+	{"parameter",	'e',	N_("PARAMETER"), 0,	N_("Set a parameter for the protocol decoder")},
 	{"delay",	'D',	N_("DELAY"),	0,	N_("Sets the delay before repeating a keystroke"), 0},
 	{"period",	'P',	N_("PERIOD"),	0,	N_("Sets the period to repeat a keystroke"), 0},
 	{"auto-load",	'a',	N_("CFGFILE"),	0,	N_("Auto-load a table, based on a configuration file. Only works with sysdev."), 0},
@@ -258,12 +268,26 @@ static char *devclass = NULL;
 static char *devicename = NULL;
 static int readtable = 0;
 static int clear = 0;
-static int debug = 0;
+int debug = 0;
 static int test = 0;
 static int delay = -1;
 static int period = -1;
 static enum sysfs_protocols ch_proto = 0;
 
+struct bpf_protocol {
+	struct bpf_protocol *next;
+	char *name;
+};
+
+struct bpf_parameter {
+	struct bpf_parameter *next;
+	int value;
+	char name[0];
+};
+
+static struct bpf_protocol *bpf_protocol;
+static struct bpf_parameter *bpf_parameter;
+
 struct cfgfile cfg = {
 	NULL, NULL, NULL, NULL
 };
@@ -397,7 +421,6 @@ err_einval:
 	fprintf(stderr, _("Invalid parameter on line %d of %s\n"),
 		line, fname);
 	return EINVAL;
-
 }
 
 struct cfgfile *nextcfg = &cfg;
@@ -580,13 +603,61 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 
 			protocol = parse_sysfs_protocol(p, true);
 			if (protocol == SYSFS_INVALID) {
-				argp_error(state, _("Unknown protocol: %s"), p);
+				struct bpf_protocol *b;
+
+				b = malloc(sizeof(*b));
+				b->name = strdup(p);
+				b->next = bpf_protocol;
+				bpf_protocol = b;
+			}
+			else {
+				ch_proto |= protocol;
+			}
+		}
+		break;
+	case 'e':
+		p = strtok(arg, ":=");
+		do {
+			struct bpf_parameter *param;
+
+			if (!param) {
+				argp_error(state, _("Missing parameter name: %s"), arg);
 				break;
 			}
 
-			ch_proto |= protocol;
-		}
+			param = calloc(1, sizeof(*param) + strlen(p) + 1);
+			if (!p) {
+				perror(_("No memory!\n"));
+				return ENOMEM;
+			}
+
+			strcpy(param->name, p);
+
+			p = strtok(NULL, ",;");
+			if (!p) {
+				free(param);
+				argp_error(state, _("Missing value"));
+				break;
+			}
+
+			param->value = strtol(p, NULL, 0);
+			if (errno) {
+				free(param);
+				argp_error(state, _("Unknown keycode: %s"), p);
+				break;
+			}
+
+			if (debug)
+				fprintf(stderr, _("parameter %s=%d\n"),
+					param->name, param->value);
+
+			param->next = bpf_parameter;
+			bpf_parameter = param;
+
+			p = strtok(NULL, ":=");
+		} while (p);
 		break;
+
 	case '?':
 		argp_state_help(state, state->out_stream,
 				ARGP_HELP_SHORT_USAGE | ARGP_HELP_LONG
@@ -1188,10 +1259,6 @@ static int set_proto(struct rc_device *rc_dev)
 	int rc = 0;
 
 	rc_dev->current &= rc_dev->supported;
-	if (!rc_dev->current) {
-		fprintf(stderr, _("Invalid protocols selected\n"));
-		return EINVAL;
-	}
 
 	if (rc_dev->version == VERSION_2) {
 		rc = v2_set_protocols(rc_dev);
@@ -1299,9 +1366,9 @@ static int add_keys(int fd)
 static void display_proto(struct rc_device *rc_dev)
 {
 	if (rc_dev->type == HARDWARE_DECODER)
-		fprintf(stderr, _("Current protocols: "));
+		fprintf(stderr, _("Current kernel protocols: "));
 	else
-		fprintf(stderr, _("Enabled protocols: "));
+		fprintf(stderr, _("Enabled kernel protocols: "));
 	write_sysfs_protocols(rc_dev->current, stderr, "%s ");
 	fprintf(stderr, "\n");
 }
@@ -1571,6 +1638,147 @@ static void device_info(int fd, char *prepend)
 		perror ("EVIOCGID");
 }
 
+#ifdef HAVE_LIBELF
+#define MAX_PROGS 64
+static void attach_bpf(const char *lirc_name, const char *bpf_prog)
+{
+	unsigned int features;
+	int fd;
+
+	fd = open(lirc_name, O_RDONLY);
+	if (fd == -1) {
+		perror(lirc_name);
+		return;
+	}
+
+	if (ioctl(fd, LIRC_GET_FEATURES, &features)) {
+		perror(lirc_name);
+		close(fd);
+		return;
+	}
+
+	if (!(features & LIRC_CAN_REC_MODE2)) {
+		fprintf(stderr, _("%s: not a raw IR receiver\n"), lirc_name);
+		close(fd);
+		return;
+	}
+
+	load_bpf_file(bpf_prog, fd);
+	close(fd);
+}
+
+static void show_bpf(const char *lirc_name)
+{
+	unsigned int prog_ids[MAX_PROGS], count = MAX_PROGS;
+	unsigned int features, i;
+	int ret, fd, prog_fd;
+
+	fd = open(lirc_name, O_RDONLY);
+	if (fd == -1)
+		goto error;
+
+	if (ioctl(fd, LIRC_GET_FEATURES, &features)) {
+		close(fd);
+		goto error;
+	}
+
+	if (!(features & LIRC_CAN_REC_MODE2)) {
+		// only support for mode2 type raw ir devices
+		close(fd);
+		return;
+	}
+
+	ret = bpf_prog_query(fd, BPF_LIRC_MODE2, 0, NULL, prog_ids, &count);
+	close(fd);
+	if (ret) {
+		if (errno == EINVAL)
+			errno = ENOTSUP;
+		goto error;
+	}
+
+	printf(_("\tAttached BPF protocols: "));
+	for (i=0; i<count; i++) {
+		if (i)
+			printf(" ");
+		prog_fd = bpf_prog_get_fd_by_id(prog_ids[i]);
+		if (prog_fd != -1) {
+			struct bpf_prog_info info = {};
+			__u32 info_len = sizeof(info);
+
+			ret = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
+			close(prog_fd);
+			if (!ret && info.name[0]) {
+				printf("%s", info.name);
+				continue;
+			}
+		}
+		printf("%d", prog_ids[i]);
+	}
+	printf(_("\n"));
+	return;
+error:
+	printf(_("\tAttached BPF protocols: %m\n"));
+}
+
+static void clear_bpf(const char *lirc_name)
+{
+	unsigned int prog_ids[MAX_PROGS], count = MAX_PROGS;
+	unsigned int features, i;
+	int ret, prog_fd, fd;
+
+	fd = open(lirc_name, O_RDONLY);
+	if (fd == -1) {
+		perror(lirc_name);
+		return;
+	}
+
+	if (ioctl(fd, LIRC_GET_FEATURES, &features)) {
+		perror(lirc_name);
+		close(fd);
+		return;
+	}
+
+	if (!(features & LIRC_CAN_REC_MODE2)) {
+		// only support for mode2 type raw ir devices
+		close(fd);
+		return;
+	}
+
+	ret = bpf_prog_query(fd, BPF_LIRC_MODE2, 0, NULL, prog_ids, &count);
+	if (ret) {
+		close(fd);
+		return;
+	}
+
+	for (i = 0; i < count; i++) {
+		if (debug)
+			fprintf(stderr, _("BPF protocol prog_id %d\n"),
+				prog_ids[i]);
+		prog_fd = bpf_prog_get_fd_by_id(prog_ids[i]);
+		if (prog_fd == -1) {
+			printf(_("Failed to get BPF prog id %u: %m\n"),
+			       prog_ids[i]);
+			continue;
+		}
+		ret = bpf_prog_detach2(prog_fd, fd, BPF_LIRC_MODE2);
+		if (ret)
+			printf(("Failed to detach BPF prog id %u: %m\n"),
+			       prog_ids[i]);
+		close(prog_fd);
+	}
+	close(fd);
+	if (debug)
+		fprintf(stderr, _("BPF protocols removed\n"));
+}
+#else
+static void attach_bpf(const char *lirc_name, const char *bpf_prog)
+{
+	fprintf(stderr, _("error: ir-keytable was compiled without BPF support\n"));
+}
+static void show_bpf(const char *lirc_name) {}
+static void clear_bpf(const char *lirc_name) {}
+#endif
+
 static int show_sysfs_attribs(struct rc_device *rc_dev, char *name)
 {
 	static struct sysfs_names *names, *cur;
@@ -1592,10 +1800,12 @@ static int show_sysfs_attribs(struct rc_device *rc_dev, char *name)
 			fprintf(stderr, _("\tDriver: %s, table: %s\n"),
 				rc_dev->drv_name,
 				rc_dev->keytable_name);
-			if (rc_dev->lirc_name)
-				fprintf(stderr, _("\tlirc device: %s\n"),
+			if (rc_dev->lirc_name) {
+				fprintf(stderr, _("\tLIRC device: %s\n"),
 					rc_dev->lirc_name);
-			fprintf(stderr, _("\tSupported protocols: "));
+				show_bpf(rc_dev->lirc_name);
+			}
+			fprintf(stderr, _("\tSupported kernel protocols: "));
 			write_sysfs_protocols(rc_dev->supported, stderr, "%s ");
 			fprintf(stderr, "\n\t");
 			display_proto(rc_dev);
@@ -1614,6 +1824,44 @@ static int show_sysfs_attribs(struct rc_device *rc_dev, char *name)
 	return 0;
 }
 
+static char *find_bpf_file(const char *name)
+{
+	struct stat st;
+	char *fname;
+
+	if (!stat(name, &st))
+		return strdup(name);
+
+	asprintf(&fname, IR_PROTOCOLS_USER_DIR "/%s.o", name);
+	if (stat(fname, &st)) {
+		free(fname);
+		asprintf(&fname, IR_PROTOCOLS_SYSTEM_DIR "/%s.o", name);
+
+		if (stat(fname, &st)) {
+			fprintf(stderr, _("Can't find %s bpf protocol in %s or %s\n"), name, IR_KEYTABLE_USER_DIR "/protocols", IR_KEYTABLE_SYSTEM_DIR "/protocols");
+			free(fname);
+			return NULL;
+		}
+	}
+
+	return fname;
+}
+
+int bpf_param(const char *name, int *val)
+{
+	struct bpf_parameter *param = bpf_parameter;
+
+	while (param) {
+		if (strcmp(name, param->name) == 0) {
+			*val = param->value;
+			return 0;
+		}
+		param = param->next;
+	}
+
+	return -ENOENT;
+}
+
 int main(int argc, char *argv[])
 {
 	int dev_from_class = 0, write_cnt;
@@ -1630,7 +1878,7 @@ int main(int argc, char *argv[])
 	argp_parse(&argp, argc, argv, ARGP_NO_HELP, 0, 0);
 
 	/* Just list all devices */
-	if (!clear && !readtable && !keytable && !ch_proto && !cfg.next && !test && delay < 0 && period < 0) {
+	if (!clear && !readtable && !keytable && !ch_proto && !cfg.next && !test && delay < 0 && period < 0 && !bpf_protocol) {
 		if (devicename) {
 			fd = open(devicename, O_RDONLY);
 			if (fd < 0) {
@@ -1756,7 +2004,10 @@ int main(int argc, char *argv[])
 	/*
 	 * Third step: change protocol
 	 */
-	if (ch_proto) {
+	if (ch_proto || bpf_protocol) {
+		if (rc_dev.lirc_name)
+			clear_bpf(rc_dev.lirc_name);
+
 		rc_dev.current = ch_proto;
 		if (set_proto(&rc_dev))
 			fprintf(stderr, _("Couldn't change the IR protocols\n"));
@@ -1767,6 +2018,23 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (bpf_protocol) {
+		struct bpf_protocol *b;
+
+		if (!rc_dev.lirc_name) {
+			fprintf(stderr, _("Error: unable to attach bpf program, lirc device name was not found\n"));
+		}
+
+		for (b = bpf_protocol; b && rc_dev.lirc_name; b = b->next) {
+			char *fname = find_bpf_file(b->name);
+
+			if (fname) {
+				attach_bpf(rc_dev.lirc_name, fname);
+				free(fname);
+			}
+		}
+	}
+
 	/*
 	 * Fourth step: display current keytable
 	 */
diff --git a/v4l-utils.spec.in b/v4l-utils.spec.in
index bdbb27ba..f7be08b3 100644
--- a/v4l-utils.spec.in
+++ b/v4l-utils.spec.in
@@ -10,7 +10,7 @@ Source0:        http://linuxtv.org/downloads/v4l-utils/v4l-utils-%{version}.tar.
 Source1:        qv4l2.desktop
 Source2:        qv4l2.svg
 BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
-BuildRequires:  qt4-devel libsysfs-devel kernel-headers desktop-file-utils
+BuildRequires:  qt4-devel libsysfs-devel kernel-headers desktop-file-utils elfutils-libelf-devel
 # For /etc/udev/rules.d ownership
 Requires:       udev
 Requires:       libv4l = %{version}-%{release}
-- 
2.17.1
