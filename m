Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:54684 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190AbcAZPyV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 10:54:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] [media] em28xx: add MEDIA_TUNER dependency
Date: Tue, 26 Jan 2016 16:53:38 +0100
Message-ID: <6929423.KuNZKsBgHV@wuerfel>
In-Reply-To: <20160126123308.6d59d373@recife.lan>
References: <1453817424-3080054-1-git-send-email-arnd@arndb.de> <1453817424-3080054-6-git-send-email-arnd@arndb.de> <20160126123308.6d59d373@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 26 January 2016 12:33:08 Mauro Carvalho Chehab wrote:
> Em Tue, 26 Jan 2016 15:10:00 +0100
> Arnd Bergmann <arnd@arndb.de> escreveu:
> 
> > em28xx selects VIDEO_TUNER, which has a dependency on MEDIA_TUNER,
> > so we get a Kconfig warning if that is disabled:
> > 
> > warning: (VIDEO_PVRUSB2 && VIDEO_USBVISION && VIDEO_GO7007 && VIDEO_AU0828_V4L2 && VIDEO_CX231XX && VIDEO_TM6000 && VIDEO_EM28XX && VIDEO_IVTV && VIDEO_MXB && VIDEO_CX18 && VIDEO_CX23885 && VIDEO_CX88 && VIDEO_BT848 && VIDEO_SAA7134 && VIDEO_SAA7164) selects VIDEO_TUNER which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER)
> 
> This warning is bogus, as it is OK to select VIDEO_TUNER even if MEDIA_TUNER
> is not defined.
> 
> See how MEDIA_TUNER is defined:
> 
> 
> config MEDIA_TUNER
> 	tristate
> 	depends on (MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT) && I2C
> 	default y
> 	select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
> 	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
> 	select MEDIA_TUNER_XC4000 if MEDIA_SUBDRV_AUTOSELECT
> 	select MEDIA_TUNER_MT20XX if MEDIA_SUBDRV_AUTOSELECT
> 	select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
> 	select MEDIA_TUNER_TEA5761 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_RADIO_SUPPORT
> 	select MEDIA_TUNER_TEA5767 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_RADIO_SUPPORT
> 	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
> 	select MEDIA_TUNER_TDA9887 if MEDIA_SUBDRV_AUTOSELECT
> 	select MEDIA_TUNER_MC44S803 if MEDIA_SUBDRV_AUTOSELECT
> 
> MEDIA_TUNER is just one of the media Kconfig workarounds to its limitation of
> not allowing to select a device that has dependencies. It is true if the user
> selected either TV or radio media devices. It works together with 
> MEDIA_SUBDRV_AUTOSELECT. When both are enabled, it selects all
> media tuners. That makes easier for end users to not need to worry about
> manually selecting the needed tuners.
> 
> Advanced users may, instead, manually select the media tuner that his
> hardware needs. In such case, it doesn't matter if MEDIA_TUNER
> is enabled or not.
> 
> As this is due to a Kconfig limitation, I've no idea how to fix or get
> hid of it, but making em28xx dependent of MEDIA_TUNER is wrong.

I don't understand what limitation you see here. The definition
of the VIDEO_TUNER symbol is an empty 'tristate' symbol with a
dependency on MEDIA_TUNER to ensure we get a warning if MEDIA_TUNER
is not enabled, and to ensure it is set to 'm' if MEDIA_TUNER=m and
a "bool" driver selects VIDEO_TUNER.

You are saying that the first one is not correct, so I assume we
still need the second meaning. We could probably do that like the
patch below (untested) that makes the intention much more explicit.

	Arnd

diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 9beece00869b..1050bdf1848f 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -37,7 +37,11 @@ config VIDEO_PCI_SKELETON
 # Used by drivers that need tuner.ko
 config VIDEO_TUNER
 	tristate
-	depends on MEDIA_TUNER
+
+config VIDEO_TUNER_MODULE
+	tristate # must not be built-in if MEDIA_TUNER=m because of I2C
+	default y if VIDEO_TUNER=y || MEDIA_TUNER=y
+	default m if VIDEO_TUNER=m
 
 # Used by drivers that need v4l2-mem2mem.ko
 config V4L2_MEM2MEM_DEV
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 1dc8bba2b198..971af6398d6d 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -21,7 +21,7 @@ obj-$(CONFIG_VIDEO_V4L2) += videodev.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-dv-timings.o
 
-obj-$(CONFIG_VIDEO_TUNER) += tuner.o
+obj-$(CONFIG_VIDEO_TUNER_MODULE) += tuner.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 

