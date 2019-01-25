Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BA0C282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 07:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D67C62184C
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 07:05:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="mJqUj6Fu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfAYHFa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 02:05:30 -0500
Received: from condef-06.nifty.com ([202.248.20.71]:31939 "EHLO
        condef-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfAYHFa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 02:05:30 -0500
Received: from conuserg-10.nifty.com ([10.126.8.73])by condef-06.nifty.com with ESMTP id x0P6tCsX021624
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2019 15:55:12 +0900
Received: from pug.e01.socionext.com (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id x0P6sNWp014857;
        Fri, 25 Jan 2019 15:54:25 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com x0P6sNWp014857
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1548399266;
        bh=PzesMvB7iVXqa+zKaWBiL5i327PsGVECtcZjeWDDDyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJqUj6Fuyw6P/cc1PDpJ/S/k1Qa+PCwARq9gPHLLgURSIOeFTIod25K/+g7m7QOWZ
         MD7cia77PUls8xAHTydMSOpRAQoAn3+YO7bIeHRNnZt57J++ZcMfsmd/I1xRe1XhWz
         uKjGI3zSEBU4/oUf2GcrhEadq7HIIiJr5Ga2SO5oiNva2ovEgjHzYzLzJOl5wRJRCI
         vGEaq+kj97zPrvY4O/y+rwCVbisSngd0ETN8nDaRyWz2JfrL24XYhPSyrgdlFzWurX
         j/6QoCoW4AWDRDR9wHW6Uc12T+H/JLdEkf+NpvJvpwmnNQplRdb/35IRtwv3maIJk/
         FiX2H7zyrGH8A==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] media: remove unneeded header search paths
Date:   Fri, 25 Jan 2019 15:54:18 +0900
Message-Id: <1548399259-17750-3-git-send-email-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548399259-17750-1-git-send-email-yamada.masahiro@socionext.com>
References: <1548399259-17750-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

I was able to build without these extra header search paths.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/media/dvb-frontends/cxd2880/Makefile  | 2 --
 drivers/media/pci/bt8xx/Makefile              | 1 -
 drivers/media/platform/sti/c8sectpfe/Makefile | 1 -
 drivers/media/radio/Makefile                  | 2 --
 drivers/media/spi/Makefile                    | 2 --
 drivers/media/usb/cx231xx/Makefile            | 1 -
 drivers/media/usb/usbvision/Makefile          | 2 --
 7 files changed, 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2880/Makefile b/drivers/media/dvb-frontends/cxd2880/Makefile
index c6baa4c..646598b 100644
--- a/drivers/media/dvb-frontends/cxd2880/Makefile
+++ b/drivers/media/dvb-frontends/cxd2880/Makefile
@@ -14,5 +14,3 @@ cxd2880-objs := cxd2880_common.o \
 		cxd2880_top.o
 
 obj-$(CONFIG_DVB_CXD2880) += cxd2880.o
-
-ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/pci/bt8xx/Makefile b/drivers/media/pci/bt8xx/Makefile
index 7f1c3be..0b5032c 100644
--- a/drivers/media/pci/bt8xx/Makefile
+++ b/drivers/media/pci/bt8xx/Makefile
@@ -7,5 +7,4 @@ obj-$(CONFIG_VIDEO_BT848) += bttv.o
 obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o dst.o dst_ca.o
 
 ccflags-y += -Idrivers/media/dvb-frontends
-ccflags-y += -Idrivers/media/common
 ccflags-y += -Idrivers/media/tuners
diff --git a/drivers/media/platform/sti/c8sectpfe/Makefile b/drivers/media/platform/sti/c8sectpfe/Makefile
index 34d6947..4bf0c6b 100644
--- a/drivers/media/platform/sti/c8sectpfe/Makefile
+++ b/drivers/media/platform/sti/c8sectpfe/Makefile
@@ -4,6 +4,5 @@ c8sectpfe-y += c8sectpfe-core.o c8sectpfe-common.o c8sectpfe-dvb.o \
 
 obj-$(CONFIG_DVB_C8SECTPFE) += c8sectpfe.o
 
-ccflags-y += -Idrivers/media/common
 ccflags-y += -Idrivers/media/dvb-frontends/
 ccflags-y += -Idrivers/media/tuners/
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index 37e6e82..53c7ae1 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -36,5 +36,3 @@ obj-$(CONFIG_RADIO_TEA575X) += tea575x.o
 obj-$(CONFIG_USB_RAREMONO) += radio-raremono.o
 
 shark2-objs := radio-shark2.o radio-tea5777.o
-
-ccflags-y += -Isound
diff --git a/drivers/media/spi/Makefile b/drivers/media/spi/Makefile
index 9e53677..c254e2a 100644
--- a/drivers/media/spi/Makefile
+++ b/drivers/media/spi/Makefile
@@ -1,6 +1,4 @@
 obj-$(CONFIG_VIDEO_GS1662) += gs1662.o
 obj-$(CONFIG_CXD2880_SPI_DRV) += cxd2880-spi.o
 
-ccflags-y += -Idrivers/media/dvb-core
-ccflags-y += -Idrivers/media/dvb-frontends
 ccflags-y += -Idrivers/media/dvb-frontends/cxd2880
diff --git a/drivers/media/usb/cx231xx/Makefile b/drivers/media/usb/cx231xx/Makefile
index c023d97..af824fd 100644
--- a/drivers/media/usb/cx231xx/Makefile
+++ b/drivers/media/usb/cx231xx/Makefile
@@ -11,4 +11,3 @@ obj-$(CONFIG_VIDEO_CX231XX_DVB) += cx231xx-dvb.o
 
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-frontends
-ccflags-y += -Idrivers/media/usb/dvb-usb
diff --git a/drivers/media/usb/usbvision/Makefile b/drivers/media/usb/usbvision/Makefile
index 494d030..e8e5eda 100644
--- a/drivers/media/usb/usbvision/Makefile
+++ b/drivers/media/usb/usbvision/Makefile
@@ -1,5 +1,3 @@
 usbvision-objs  := usbvision-core.o usbvision-video.o usbvision-i2c.o usbvision-cards.o
 
 obj-$(CONFIG_VIDEO_USBVISION) += usbvision.o
-
-ccflags-y += -Idrivers/media/tuners
-- 
2.7.4

