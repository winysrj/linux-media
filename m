Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACCFC169C4
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 04:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B3AE20833
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 04:14:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="M8htlJAs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfAaEOD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 23:14:03 -0500
Received: from condef-09.nifty.com ([202.248.20.74]:33310 "EHLO
        condef-09.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbfAaEOD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 23:14:03 -0500
Received: from conuserg-12.nifty.com ([10.126.8.75])by condef-09.nifty.com with ESMTP id x0V4AM1h023521
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2019 13:10:27 +0900
Received: from pug.e01.socionext.com (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-12.nifty.com with ESMTP id x0V48g7O028416;
        Thu, 31 Jan 2019 13:08:43 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-12.nifty.com x0V48g7O028416
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1548907724;
        bh=qtR6JBtIsv5On0l3JmbxwP6woOzsFy3pXGV1XwsD1qA=;
        h=From:To:Cc:Subject:Date:From;
        b=M8htlJAsWH4ih4sVLUMTMj2J3B+IhkWeIHlb/UEEkhq935jetcJg0Joh17Pk2wtMP
         QNJThFcEybUvB44JaY/mSYwL398kiNgSKyCppNFu+GupfDOTrQosw8QLtIvw10Kqil
         J0+UKyBCmnmCBOpIA7+Pzo0T/VMzcA2CQcuSSfioycqk2TntGBCutlFoiOLEMH3Mgw
         pm7Ij9TmU1nMwJSBqDi5WHE7zWEzzGJ9FQH7AE1Gk8Yb4E+IbUZtdM/wrahWKMOPau
         9gZVTsKGhRnETxsly5g2v29xf7W4PTX8hnTPe8YIP3di60U7oOBVa8ZkWsP/MRRBWl
         /6qr92DmoJwpQ==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Gao Xiang <gaoxiang25@huawei.com>,
        linux-erofs@lists.ozlabs.org,
        David Kershner <david.kershner@unisys.com>,
        sparmaintainer@unisys.com, Scott Branden <sbranden@broadcom.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org, Chao Yu <yuchao0@huawei.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Anholt <eric@anholt.net>, Ray Jui <rjui@broadcom.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH] staging: prefix header search paths with $(srctree)/
Date:   Thu, 31 Jan 2019 13:08:33 +0900
Message-Id: <1548907713-24160-1-git-send-email-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Currently, the Kbuild core manipulates header search paths in a crazy
way [1].

To fix this mess, I want all Makefiles to add explicit $(srctree)/ to
the search paths in the srctree. Some Makefiles are already written in
that way, but not all. The goal of this work is to make the notation
consistent, and finally get rid of the gross hacks.

Having whitespaces after -I does not matter since commit 48f6e3cf5bc6
("kbuild: do not drop -I without parameter").

[1]: https://patchwork.kernel.org/patch/9632347/

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/staging/erofs/Makefile                        | 2 +-
 drivers/staging/media/davinci_vpfe/Makefile           | 2 +-
 drivers/staging/most/Makefile                         | 2 +-
 drivers/staging/most/cdev/Makefile                    | 2 +-
 drivers/staging/most/dim2/Makefile                    | 2 +-
 drivers/staging/most/i2c/Makefile                     | 2 +-
 drivers/staging/most/net/Makefile                     | 2 +-
 drivers/staging/most/sound/Makefile                   | 2 +-
 drivers/staging/most/usb/Makefile                     | 2 +-
 drivers/staging/most/video/Makefile                   | 2 +-
 drivers/staging/rtl8192u/Makefile                     | 2 +-
 drivers/staging/unisys/visorhba/Makefile              | 3 +--
 drivers/staging/unisys/visornic/Makefile              | 3 +--
 drivers/staging/vc04_services/bcm2835-audio/Makefile  | 3 +--
 drivers/staging/vc04_services/bcm2835-camera/Makefile | 2 +-
 15 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/erofs/Makefile b/drivers/staging/erofs/Makefile
index c91b652..38ab344 100644
--- a/drivers/staging/erofs/Makefile
+++ b/drivers/staging/erofs/Makefile
@@ -6,7 +6,7 @@ ccflags-y += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\"
 
 obj-$(CONFIG_EROFS_FS) += erofs.o
 # staging requirement: to be self-contained in its own directory
-ccflags-y += -I$(src)/include
+ccflags-y += -I $(srctree)/$(src)/include
 erofs-objs := super.o inode.o data.o namei.o dir.o utils.o
 erofs-$(CONFIG_EROFS_FS_XATTR) += xattr.o
 erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o unzip_vle_lz4.o
diff --git a/drivers/staging/media/davinci_vpfe/Makefile b/drivers/staging/media/davinci_vpfe/Makefile
index 9c57042..9268e50 100644
--- a/drivers/staging/media/davinci_vpfe/Makefile
+++ b/drivers/staging/media/davinci_vpfe/Makefile
@@ -6,5 +6,5 @@ davinci-vfpe-objs := \
 
 # Allow building it with COMPILE_TEST on other archs
 ifndef CONFIG_ARCH_DAVINCI
-ccflags-y += -Iarch/arm/mach-davinci/include/
+ccflags-y += -I $(srctree)/arch/arm/mach-davinci/include/
 endif
diff --git a/drivers/staging/most/Makefile b/drivers/staging/most/Makefile
index f8bcf48..c7662f6 100644
--- a/drivers/staging/most/Makefile
+++ b/drivers/staging/most/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MOST) += most_core.o
 most_core-y := core.o
-ccflags-y += -Idrivers/staging/
+ccflags-y += -I $(srctree)/drivers/staging/
 
 obj-$(CONFIG_MOST_CDEV)	+= cdev/
 obj-$(CONFIG_MOST_NET)	+= net/
diff --git a/drivers/staging/most/cdev/Makefile b/drivers/staging/most/cdev/Makefile
index afb9870..21b0bd7 100644
--- a/drivers/staging/most/cdev/Makefile
+++ b/drivers/staging/most/cdev/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_MOST_CDEV) += most_cdev.o
 
 most_cdev-objs := cdev.o
-ccflags-y += -Idrivers/staging/
+ccflags-y += -I $(srctree)/drivers/staging/
diff --git a/drivers/staging/most/dim2/Makefile b/drivers/staging/most/dim2/Makefile
index 66676f5..6d15f04 100644
--- a/drivers/staging/most/dim2/Makefile
+++ b/drivers/staging/most/dim2/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_MOST_DIM2) += most_dim2.o
 
 most_dim2-objs := dim2.o hal.o sysfs.o
-ccflags-y += -Idrivers/staging/
+ccflags-y += -I $(srctree)/drivers/staging/
diff --git a/drivers/staging/most/i2c/Makefile b/drivers/staging/most/i2c/Makefile
index a7d094c..c032fea 100644
--- a/drivers/staging/most/i2c/Makefile
+++ b/drivers/staging/most/i2c/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_MOST_I2C) += most_i2c.o
 
 most_i2c-objs := i2c.o
-ccflags-y += -Idrivers/staging/
+ccflags-y += -I $(srctree)/drivers/staging/
diff --git a/drivers/staging/most/net/Makefile b/drivers/staging/most/net/Makefile
index 54500aa..820faec 100644
--- a/drivers/staging/most/net/Makefile
+++ b/drivers/staging/most/net/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_MOST_NET) += most_net.o
 
 most_net-objs := net.o
-ccflags-y += -Idrivers/staging/
+ccflags-y += -I $(srctree)/drivers/staging/
diff --git a/drivers/staging/most/sound/Makefile b/drivers/staging/most/sound/Makefile
index eee8774..5bb55bb 100644
--- a/drivers/staging/most/sound/Makefile
+++ b/drivers/staging/most/sound/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_MOST_SOUND) += most_sound.o
 
 most_sound-objs := sound.o
-ccflags-y += -Idrivers/staging/
+ccflags-y += -I $(srctree)/drivers/staging/
diff --git a/drivers/staging/most/usb/Makefile b/drivers/staging/most/usb/Makefile
index 18d28cb..910cd08 100644
--- a/drivers/staging/most/usb/Makefile
+++ b/drivers/staging/most/usb/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_MOST_USB) += most_usb.o
 
 most_usb-objs := usb.o
-ccflags-y += -Idrivers/staging/
+ccflags-y += -I $(srctree)/drivers/staging/
diff --git a/drivers/staging/most/video/Makefile b/drivers/staging/most/video/Makefile
index 1c8e520..c6e01b6e 100644
--- a/drivers/staging/most/video/Makefile
+++ b/drivers/staging/most/video/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_MOST_VIDEO) += most_video.o
 
 most_video-objs := video.o
-ccflags-y += -Idrivers/staging/
+ccflags-y += -I $(srctree)/drivers/staging/
diff --git a/drivers/staging/rtl8192u/Makefile b/drivers/staging/rtl8192u/Makefile
index 3022728..dcd51bf 100644
--- a/drivers/staging/rtl8192u/Makefile
+++ b/drivers/staging/rtl8192u/Makefile
@@ -7,7 +7,7 @@ ccflags-y += -O2
 ccflags-y += -DCONFIG_FORCE_HARD_FLOAT=y
 ccflags-y += -DJACKSON_NEW_8187 -DJACKSON_NEW_RX
 ccflags-y += -DTHOMAS_BEACON -DTHOMAS_TASKLET -DTHOMAS_SKB -DTHOMAS_TURBO
-ccflags-y += -Idrivers/staging/rtl8192u/ieee80211
+ccflags-y += -I $(srctree)/$(src)/ieee80211
 
 r8192u_usb-y := r8192U_core.o r8180_93cx6.o r8192U_wx.o		\
 		  r8190_rtl8256.o r819xU_phy.o r819xU_firmware.o	\
diff --git a/drivers/staging/unisys/visorhba/Makefile b/drivers/staging/unisys/visorhba/Makefile
index a8a8e0e..97e4875 100644
--- a/drivers/staging/unisys/visorhba/Makefile
+++ b/drivers/staging/unisys/visorhba/Makefile
@@ -6,5 +6,4 @@ obj-$(CONFIG_UNISYS_VISORHBA)	+= visorhba.o
 
 visorhba-y := visorhba_main.o
 
-ccflags-y += -Idrivers/staging/unisys/include
-
+ccflags-y += -I $(srctree)/$(src)/../include
diff --git a/drivers/staging/unisys/visornic/Makefile b/drivers/staging/unisys/visornic/Makefile
index 439e95e..336a746f 100644
--- a/drivers/staging/unisys/visornic/Makefile
+++ b/drivers/staging/unisys/visornic/Makefile
@@ -6,5 +6,4 @@ obj-$(CONFIG_UNISYS_VISORNIC)	+= visornic.o
 
 visornic-y := visornic_main.o
 
-ccflags-y += -Idrivers/staging/unisys/include
-
+ccflags-y += -I $(srctree)/$(src)/../include
diff --git a/drivers/staging/vc04_services/bcm2835-audio/Makefile b/drivers/staging/vc04_services/bcm2835-audio/Makefile
index d7b88d1..536bd0c 100644
--- a/drivers/staging/vc04_services/bcm2835-audio/Makefile
+++ b/drivers/staging/vc04_services/bcm2835-audio/Makefile
@@ -1,5 +1,4 @@
 obj-$(CONFIG_SND_BCM2835)	+= snd-bcm2835.o
 snd-bcm2835-objs		:= bcm2835.o bcm2835-ctl.o bcm2835-pcm.o bcm2835-vchiq.o
 
-ccflags-y += -Idrivers/staging/vc04_services -D__VCCOREVER__=0x04000000
-
+ccflags-y += -I $(srctree)/$(src)/.. -D__VCCOREVER__=0x04000000
diff --git a/drivers/staging/vc04_services/bcm2835-camera/Makefile b/drivers/staging/vc04_services/bcm2835-camera/Makefile
index 2a4565e..472f21e 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/Makefile
+++ b/drivers/staging/vc04_services/bcm2835-camera/Makefile
@@ -7,5 +7,5 @@ bcm2835-v4l2-$(CONFIG_VIDEO_BCM2835) := \
 obj-$(CONFIG_VIDEO_BCM2835) += bcm2835-v4l2.o
 
 ccflags-y += \
-	-Idrivers/staging/vc04_services \
+	-I $(srctree)/$(src)/.. \
 	-D__VCCOREVER__=0x04000000
-- 
2.7.4

