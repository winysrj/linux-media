Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60463 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727280AbeKGHsD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Nov 2018 02:48:03 -0500
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Cc: Sean Young <sean@mess.org>
Subject: [PATCH v4l-utils] Add missing linux/bpf_common.h
Date: Tue,  6 Nov 2018 23:20:36 +0100
Message-Id: <20181106222036.26563-1-ps.report@gmx.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

File needed by linux/bpf.h, add copy from linux-4.19.1 (and add
to sync-with-kernel Makefile target).

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
=2D--
Changes v1 -> v2:
  - add linux/bpf_common.h to sync-with-kernel target
=2D--
 Makefile.am                |  4 ++-
 include/linux/bpf_common.h | 57 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/bpf_common.h

diff --git a/Makefile.am b/Makefile.am
index 52f8e4c2..b0b8a098 100644
=2D-- a/Makefile.am
+++ b/Makefile.am
@@ -26,7 +26,8 @@ sync-with-kernel:
 	      ! -f $(KERNEL_DIR)/usr/include/linux/dvb/frontend.h -o \
 	      ! -f $(KERNEL_DIR)/usr/include/linux/dvb/dmx.h -o \
 	      ! -f $(KERNEL_DIR)/usr/include/linux/lirc.h -o \
-	      ! -f $(KERNEL_DIR)/usr/include/linux/bpf.h ]; then \
+	      ! -f $(KERNEL_DIR)/usr/include/linux/bpf.h -o \
+	      ! -f $(KERNEL_DIR)/usr/include/linux/bpf_common.h ]; then \
 	  echo "Error you must set KERNEL_DIR to point to an extracted kernel so=
urce dir"; \
 	  echo "and run 'make headers_install' in \$$KERNEL_DIR."; \
 	  exit 1; \
@@ -45,6 +46,7 @@ sync-with-kernel:
 	cp -a $(KERNEL_DIR)/usr/include/linux/dvb/dmx.h $(top_srcdir)/include/li=
nux/dvb
 	cp -a $(KERNEL_DIR)/usr/include/linux/lirc.h $(top_srcdir)/include/linux
 	cp -a $(KERNEL_DIR)/usr/include/linux/bpf.h $(top_srcdir)/include/linux
+	cp -a $(KERNEL_DIR)/usr/include/linux/bpf_common.h $(top_srcdir)/include=
/linux
 	cp -a $(KERNEL_DIR)/usr/include/linux/cec.h $(top_srcdir)/include/linux
 	cp -a $(KERNEL_DIR)/usr/include/linux/cec-funcs.h $(top_srcdir)/include/=
linux
 	cp -a $(KERNEL_DIR)/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c $(top_=
srcdir)/utils/common
diff --git a/include/linux/bpf_common.h b/include/linux/bpf_common.h
new file mode 100644
index 00000000..f0fe1394
=2D-- /dev/null
+++ b/include/linux/bpf_common.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __LINUX_BPF_COMMON_H__
+#define __LINUX_BPF_COMMON_H__
+
+/* Instruction classes */
+#define BPF_CLASS(code) ((code) & 0x07)
+#define		BPF_LD		0x00
+#define		BPF_LDX		0x01
+#define		BPF_ST		0x02
+#define		BPF_STX		0x03
+#define		BPF_ALU		0x04
+#define		BPF_JMP		0x05
+#define		BPF_RET		0x06
+#define		BPF_MISC        0x07
+
+/* ld/ldx fields */
+#define BPF_SIZE(code)  ((code) & 0x18)
+#define		BPF_W		0x00 /* 32-bit */
+#define		BPF_H		0x08 /* 16-bit */
+#define		BPF_B		0x10 /*  8-bit */
+/* eBPF		BPF_DW		0x18    64-bit */
+#define BPF_MODE(code)  ((code) & 0xe0)
+#define		BPF_IMM		0x00
+#define		BPF_ABS		0x20
+#define		BPF_IND		0x40
+#define		BPF_MEM		0x60
+#define		BPF_LEN		0x80
+#define		BPF_MSH		0xa0
+
+/* alu/jmp fields */
+#define BPF_OP(code)    ((code) & 0xf0)
+#define		BPF_ADD		0x00
+#define		BPF_SUB		0x10
+#define		BPF_MUL		0x20
+#define		BPF_DIV		0x30
+#define		BPF_OR		0x40
+#define		BPF_AND		0x50
+#define		BPF_LSH		0x60
+#define		BPF_RSH		0x70
+#define		BPF_NEG		0x80
+#define		BPF_MOD		0x90
+#define		BPF_XOR		0xa0
+
+#define		BPF_JA		0x00
+#define		BPF_JEQ		0x10
+#define		BPF_JGT		0x20
+#define		BPF_JGE		0x30
+#define		BPF_JSET        0x40
+#define BPF_SRC(code)   ((code) & 0x08)
+#define		BPF_K		0x00
+#define		BPF_X		0x08
+
+#ifndef BPF_MAXINSNS
+#define BPF_MAXINSNS 4096
+#endif
+
+#endif /* __LINUX_BPF_COMMON_H__ */
=2D-
2.19.1
