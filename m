Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab2ETNk3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 09:40:29 -0400
Message-ID: <4FB8F448.4030702@redhat.com>
Date: Sun, 20 May 2012 10:40:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Ismael Luceno <ismael.luceno@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] au0828: Move under dvb
References: <1336716892-5446-1-git-send-email-ismael.luceno@gmail.com> <1336716892-5446-2-git-send-email-ismael.luceno@gmail.com> <CAGoCfiydH48uY86w3oHbRDoJddX5qS1Va7vo4-vXwAn9JeSaaQ@mail.gmail.com> <20120512000858.3d9e41a8@pirotess> <CAGoCfizjD0wMpd+p4zxATfe+NKJqTqRTE4UEAZTTNdq9yCkxXg@mail.gmail.com> <4FB8F266.7050308@redhat.com>
In-Reply-To: <4FB8F266.7050308@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-05-2012 10:32, Mauro Carvalho Chehab escreveu:
> Em 12-05-2012 07:21, Devin Heitmueller escreveu:
>> On Fri, May 11, 2012 at 11:08 PM, Ismael Luceno <ismael.luceno@gmail.com> wrote:
>>> On Fri, 11 May 2012 08:04:59 -0400
>>> Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
>>> ...
>>>> What is the motivation for moving these files?
>>>
>>> Well, the device was on the wrong Kconfig section, and while thinking
>>> about changing that, I just thought to move it under DVB.
>>>
>>>> The au0828 is a hybrid bridge, and every other hybrid bridge is
>>>> under video?
>>>
>>> Sorry, the devices I got don't support analog, so I didn't thought
>>> about it that much...
>>>
>>> I guess it's arbitrary... isn't it? wouldn't it be better to have an
>>> hybrid section? (just thinking out loud)
>>
>> Yeah, in this case it's largely historical (a product from before the
>> V4L and DVB subsystems were merged).  At this point I don't see any
>> real advantage to arbitrarily moving the stuff around.  And in fact in
>> some areas it's even more ambiguous because some drivers are hybrid
>> drivers but support both hybrid chips as well as analog-only (the
>> em28xx driver is one such example).
>>
>> Anyway, Mauro is welcome to offer his opinion if it differs, but as
>> far as I'm concerned this patch shouldn't get applied.
> 
> I won't apply this patch.
> 
> If the Kconfig menus are confusing, then we should fix it, instead of moving
> things from one place to another ;)

Hmm...

menuconfig VIDEO_CAPTURE_DRIVERS
        bool "Video capture adapters"
        depends on VIDEO_V4L2
        default y
        ---help---
          Say Y here to enable selecting the video adapters for
          webcams, analog TV, and hybrid analog/digital TV.
          Some of those devices also supports FM radio.

The help explanation is OK. Maybe we could change the description:

comment at the bool description. What about the change below?

Regards,
Mauro

-
[media] video: Improve Kconfig menu description

The menu description can mislead to indicate that only capture devices
are there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/Kconfig b/drivers/media/dvb/Kconfig
index f6e40b3..8efa494 100644
--- a/drivers/media/dvb/Kconfig
+++ b/drivers/media/dvb/Kconfig
@@ -29,11 +29,12 @@ config DVB_DYNAMIC_MINORS
 	  If you are unsure about this, say N here.
 
 menuconfig DVB_CAPTURE_DRIVERS
-	bool "DVB/ATSC adapters"
+	bool "Digital TV adapters"
 	depends on DVB_CORE
 	default y
 	---help---
-	  Say Y to select Digital TV adapters
+	  Say Y to select Digital TV adapters. Hybrid devices
+	  with both analog TV and digital TVs are not there.
 
 if DVB_CAPTURE_DRIVERS && DVB_CORE
 
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 268b36d..a5a0ef2 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -71,12 +71,13 @@ config VIDEOBUF2_DMA_SG
 #
 
 menuconfig VIDEO_CAPTURE_DRIVERS
-	bool "Video capture adapters"
+	bool "Video adapters (capture, webcams, analog TV, hybrid TV)"
 	depends on VIDEO_V4L2
 	default y
 	---help---
 	  Say Y here to enable selecting the video adapters for
-	  webcams, analog TV, and hybrid analog/digital TV.
+	  webcams, video capture, analog TV, and hybrid
+	  analog/digital TV.
 	  Some of those devices also supports FM radio.
 
 if VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2
