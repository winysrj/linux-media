Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59742 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759939Ab2FHBzO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 21:55:14 -0400
Received: by eeit10 with SMTP id t10so660455eei.19
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2012 18:55:13 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 7 Jun 2012 18:55:12 -0700
Message-ID: <CAH5vBdLM4SnXcj7+5+qUXeWRhp4J=kp_V0eSBXMJVMORPd690Q@mail.gmail.com>
Subject: [PATCH] make VIDEO_MEDIA depends on DVB_CORE only (removing depends VIDEO_DEV)
From: cheng renquan <crquan@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	VDR User <user.vdr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think the root cause is VIDEO_MEDIA depending on VIDEO_DEV or DVB_CORE;
since MEDIA_TUNER is depending on VIDEO_MEDIA;
I have VIDEO_DEV but not DVB_CORE, hence should be no VIDEO_MEDIA,

config MEDIA_TUNER
        tristate
        default VIDEO_MEDIA && I2C
        depends on VIDEO_MEDIA && I2C


diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 9575db4..1b35dae 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -99,7 +99,7 @@ config DVB_NET

 config VIDEO_MEDIA
 	tristate
-	default (DVB_CORE && (VIDEO_DEV = n)) || (VIDEO_DEV && (DVB_CORE =
n)) || (DVB_CORE && VIDEO_DEV)
+	default DVB_CORE

 comment "Multimedia drivers"


On Thu, Jun 7, 2012 at 4:09 PM, VDR User <user.vdr@gmail.com> wrote:
> On Thu, Jun 7, 2012 at 2:53 PM, cheng renquan <crquan@gmail.com> wrote:
>> till recently I found that also chosen those media tuner modules,
>>
>> $ grep MEDIA_TUNER /boot/config
>> CONFIG_MEDIA_TUNER=m
>> # CONFIG_MEDIA_TUNER_CUSTOMISE is not set
>> CONFIG_MEDIA_TUNER_SIMPLE=m
>> CONFIG_MEDIA_TUNER_TDA8290=m
>> CONFIG_MEDIA_TUNER_TDA827X=m
>> CONFIG_MEDIA_TUNER_TDA18271=m
>> CONFIG_MEDIA_TUNER_TDA9887=m
>> CONFIG_MEDIA_TUNER_TEA5761=m
>> CONFIG_MEDIA_TUNER_TEA5767=m
>> CONFIG_MEDIA_TUNER_MT20XX=m
>> CONFIG_MEDIA_TUNER_XC2028=m
>> CONFIG_MEDIA_TUNER_XC5000=m
>> CONFIG_MEDIA_TUNER_XC4000=m
>> CONFIG_MEDIA_TUNER_MC44S803=m
>>
>> as I understand, MEDIA_TUNER is for some tv adapters but I don't have
>> such hardware,
>> to disable them I need to enable MEDIA_TUNER_CUSTOMISE, then
>> a menu "Customize TV tuners" becomes visible then I need to enter that
>> menu and disable all the tuners one-by-one;
>> this looks not convenient,
>
> I hate that too so you're not alone. I've just gotten into the habit
> of having to manually disabling everything I don't need as opposed to
> only needing to enable what I do need. :\
