Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:60367 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751264AbdCZKLW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Mar 2017 06:11:22 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] BIT_ULL macro change in 3.13
Date: Sun, 26 Mar 2017 11:11:19 +0100
Message-Id: <1490523079-1617-1-git-send-email-sean@mess.org>
In-Reply-To: <d3dc1068087d6e0ec3a2215729fb7725@smtp-cloud2.xs4all.net>
References: <d3dc1068087d6e0ec3a2215729fb7725@smtp-cloud2.xs4all.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 backports/backports.txt       |  1 +
 backports/v3.12_bit_ull.patch | 70 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)
 create mode 100644 backports/v3.12_bit_ull.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index ebd3ce0..35473dc 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -78,6 +78,7 @@ add v3.16_void_gpiochip_remove.patch
 
 [3.12.255]
 add v3.12_kfifo_in.patch
+add v3.12_bit_ull.patch
 
 [3.11.255]
 add v3.11_dev_groups.patch
diff --git a/backports/v3.12_bit_ull.patch b/backports/v3.12_bit_ull.patch
new file mode 100644
index 0000000..e57f478
--- /dev/null
+++ b/backports/v3.12_bit_ull.patch
@@ -0,0 +1,70 @@
+diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
+index 90f66dc..456d59f 100644
+--- a/drivers/media/rc/rc-ir-raw.c
++++ b/drivers/media/rc/rc-ir-raw.c
+@@ -264,7 +264,7 @@ int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
+ 	u64 i;
+ 	int ret = -ENOBUFS;
+ 
+-	i = BIT_ULL(n - 1);
++	i = 1ULL << (n - 1);
+ 
+ 	if (timings->leader) {
+ 		if (!max--)
+diff --git a/include/media/rc-map.h b/include/media/rc-map.h
+index 1a815a5..c16b157 100644
+--- a/include/media/rc-map.h
++++ b/include/media/rc-map.h
+@@ -65,29 +65,29 @@ enum rc_type {
+ };
+ 
+ #define RC_BIT_NONE		0ULL
+-#define RC_BIT_UNKNOWN		BIT_ULL(RC_TYPE_UNKNOWN)
+-#define RC_BIT_OTHER		BIT_ULL(RC_TYPE_OTHER)
+-#define RC_BIT_RC5		BIT_ULL(RC_TYPE_RC5)
+-#define RC_BIT_RC5X_20		BIT_ULL(RC_TYPE_RC5X_20)
+-#define RC_BIT_RC5_SZ		BIT_ULL(RC_TYPE_RC5_SZ)
+-#define RC_BIT_JVC		BIT_ULL(RC_TYPE_JVC)
+-#define RC_BIT_SONY12		BIT_ULL(RC_TYPE_SONY12)
+-#define RC_BIT_SONY15		BIT_ULL(RC_TYPE_SONY15)
+-#define RC_BIT_SONY20		BIT_ULL(RC_TYPE_SONY20)
+-#define RC_BIT_NEC		BIT_ULL(RC_TYPE_NEC)
+-#define RC_BIT_NECX		BIT_ULL(RC_TYPE_NECX)
+-#define RC_BIT_NEC32		BIT_ULL(RC_TYPE_NEC32)
+-#define RC_BIT_SANYO		BIT_ULL(RC_TYPE_SANYO)
+-#define RC_BIT_MCIR2_KBD	BIT_ULL(RC_TYPE_MCIR2_KBD)
+-#define RC_BIT_MCIR2_MSE	BIT_ULL(RC_TYPE_MCIR2_MSE)
+-#define RC_BIT_RC6_0		BIT_ULL(RC_TYPE_RC6_0)
+-#define RC_BIT_RC6_6A_20	BIT_ULL(RC_TYPE_RC6_6A_20)
+-#define RC_BIT_RC6_6A_24	BIT_ULL(RC_TYPE_RC6_6A_24)
+-#define RC_BIT_RC6_6A_32	BIT_ULL(RC_TYPE_RC6_6A_32)
+-#define RC_BIT_RC6_MCE		BIT_ULL(RC_TYPE_RC6_MCE)
+-#define RC_BIT_SHARP		BIT_ULL(RC_TYPE_SHARP)
+-#define RC_BIT_XMP		BIT_ULL(RC_TYPE_XMP)
+-#define RC_BIT_CEC		BIT_ULL(RC_TYPE_CEC)
++#define RC_BIT_UNKNOWN		(1ULL << RC_TYPE_UNKNOWN)
++#define RC_BIT_OTHER		(1ULL << RC_TYPE_OTHER)
++#define RC_BIT_RC5		(1ULL << RC_TYPE_RC5)
++#define RC_BIT_RC5X_20		(1ULL << RC_TYPE_RC5X_20)
++#define RC_BIT_RC5_SZ		(1ULL << RC_TYPE_RC5_SZ)
++#define RC_BIT_JVC		(1ULL << RC_TYPE_JVC)
++#define RC_BIT_SONY12		(1ULL << RC_TYPE_SONY12)
++#define RC_BIT_SONY15		(1ULL << RC_TYPE_SONY15)
++#define RC_BIT_SONY20		(1ULL << RC_TYPE_SONY20)
++#define RC_BIT_NEC		(1ULL << RC_TYPE_NEC)
++#define RC_BIT_NECX		(1ULL << RC_TYPE_NECX)
++#define RC_BIT_NEC32		(1ULL << RC_TYPE_NEC32)
++#define RC_BIT_SANYO		(1ULL << RC_TYPE_SANYO)
++#define RC_BIT_MCIR2_KBD	(1ULL << RC_TYPE_MCIR2_KBD)
++#define RC_BIT_MCIR2_MSE	(1ULL << RC_TYPE_MCIR2_MSE)
++#define RC_BIT_RC6_0		(1ULL << RC_TYPE_RC6_0)
++#define RC_BIT_RC6_6A_20	(1ULL << RC_TYPE_RC6_6A_20)
++#define RC_BIT_RC6_6A_24	(1ULL << RC_TYPE_RC6_6A_24)
++#define RC_BIT_RC6_6A_32	(1ULL << RC_TYPE_RC6_6A_32)
++#define RC_BIT_RC6_MCE		(1ULL << RC_TYPE_RC6_MCE)
++#define RC_BIT_SHARP		(1ULL << RC_TYPE_SHARP)
++#define RC_BIT_XMP		(1ULL << RC_TYPE_XMP)
++#define RC_BIT_CEC		(1ULL << RC_TYPE_CEC)
+ 
+ #define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | \
+ 			 RC_BIT_RC5 | RC_BIT_RC5X_20 | RC_BIT_RC5_SZ | \
-- 
2.9.3
