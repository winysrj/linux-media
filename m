Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:64412 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbcGAPL4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 11:11:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] cec: add missing inline stubs
Date: Fri, 01 Jul 2016 17:13:55 +0200
Message-ID: <6419506.V8JtZUoqT3@wuerfel>
In-Reply-To: <51b68698-eced-a659-016f-cf9566851fd2@xs4all.nl>
References: <20160701112027.102024-1-arnd@arndb.de> <51b68698-eced-a659-016f-cf9566851fd2@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, July 1, 2016 4:35:09 PM CEST Hans Verkuil wrote:
> On 07/01/2016 01:19 PM, Arnd Bergmann wrote:
> > The linux/cec.h header file contains empty inline definitions for
> > a subset of the API for the case in which CEC is not enabled,
> > however we have driver that call other functions as well:
> > 
> > drivers/media/i2c/adv7604.c: In function 'adv76xx_cec_tx_raw_status':
> > drivers/media/i2c/adv7604.c:1956:3: error: implicit declaration of function 'cec_transmit_done' [-Werror=implicit-function-declaration]
> > drivers/media/i2c/adv7604.c: In function 'adv76xx_cec_isr':
> > drivers/media/i2c/adv7604.c:2012:4: error: implicit declaration of function 'cec_received_msg' [-Werror=implicit-function-declaration]
> > drivers/media/i2c/adv7604.c: In function 'adv76xx_probe':
> > drivers/media/i2c/adv7604.c:3482:20: error: implicit declaration of function 'cec_allocate_adapter' [-Werror=implicit-function-declaration]
> 
> I don't understand this. These calls are under #if IS_ENABLED(CONFIG_VIDEO_ADV7842_CEC),
> and that should be 0 if MEDIA_CEC is not selected.
> 
> Am I missing some weird config combination?

This must have been a build error I ran into before your patch, when I
had this one applied locally instead:

diff --git a/include/media/cec.h b/include/media/cec.h
index c462f9b44074..564a6a06bed7 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -187,7 +187,7 @@ static inline bool cec_is_sink(const struct cec_adapter *adap)
 	return adap->phys_addr == 0;
 }
 
-#if IS_ENABLED(CONFIG_MEDIA_CEC)
+#if IS_REACHABLE(CONFIG_MEDIA_CEC)
 struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 		void *priv, const char *name, u32 caps, u8 available_las,
 		struct device *parent);

because that was hiding the declarations when the code could not
reach it. With your newer patch that is not possible any more.

I also wasn't aware that each of these already had their own Kconfig
symbols. Could we just do this instead of your patch then:

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index ce9006e10a30..73e047220905 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -222,6 +222,7 @@ config VIDEO_ADV7604
 config VIDEO_ADV7604_CEC
 	bool "Enable Analog Devices ADV7604 CEC support"
 	depends on VIDEO_ADV7604 && MEDIA_CEC
+	depends on VIDEO_ADV7604=m || MEDIA_CEC=y
 	---help---
 	  When selected the adv7604 will support the optional
 	  HDMI CEC feature.
@@ -243,6 +244,7 @@ config VIDEO_ADV7842
 config VIDEO_ADV7842_CEC
 	bool "Enable Analog Devices ADV7842 CEC support"
 	depends on VIDEO_ADV7842 && MEDIA_CEC
+	depends on VIDEO_ADV7842=m || MEDIA_CEC=y
 	---help---
 	  When selected the adv7842 will support the optional
 	  HDMI CEC feature.
@@ -475,6 +477,7 @@ config VIDEO_ADV7511
 config VIDEO_ADV7511_CEC
 	bool "Enable Analog Devices ADV7511 CEC support"
 	depends on VIDEO_ADV7511 && MEDIA_CEC
+	depends on VIDEO_ADV7511=m || MEDIA_CEC=y
 	---help---
 	  When selected the adv7511 will support the optional
 	  HDMI CEC feature.
diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
index 8e6918c5c87c..8e31146d079a 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -26,6 +26,7 @@ config VIDEO_VIVID
 config VIDEO_VIVID_CEC
 	bool "Enable CEC emulation support"
 	depends on VIDEO_VIVID && MEDIA_CEC
+	depends on VIDEO_VIVID=m || MEDIA_CEC=y
 	---help---
 	  When selected the vivid module will emulate the optional
 	  HDMI CEC feature.

which is still not overly nice, but it manages to avoid the
IS_REACHABLE() check and it lets MEDIA_CEC be a module.

	Arnd
