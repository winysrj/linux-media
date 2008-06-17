Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bcjenkins@tvwhere.com>) id 1K8di1-00011A-LH
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 18:07:02 +0200
Received: by ug-out-1314.google.com with SMTP id m3so633132uge.20
	for <linux-dvb@linuxtv.org>; Tue, 17 Jun 2008 09:06:58 -0700 (PDT)
Message-Id: <6CF9A586-AF45-4900-8BA4-3F537C1CB562@tvwhere.com>
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: mkrufky@linuxtv.org
In-Reply-To: <4857D73D.8080709@linuxtv.org>
Mime-Version: 1.0 (Apple Message framework v924)
Date: Tue, 17 Jun 2008 12:06:53 -0400
References: <4857D73D.8080709@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx18 or tveeprom - Missing dependency? [PATCH]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


On Jun 17, 2008, at 11:24 AM, mkrufky@linuxtv.org wrote:

> Brandon Jenkins wrote:
>>
>> On Jun 17, 2008, at 10:52 AM, mkrufky@linuxtv.org wrote:
>>
>>> Brandon Jenkins wrote:
>>> Brandon,
>>>
>>> VIDEO_CX18 selects VIDEO_TUNER , but you chose the option,
>>> "MEDIA_TUNER_CUSTOMIZE" , which turns off the automatic tuner  
>>> dependency
>>> selections.  Please note the description of this option:
>>>
>>> menuconfig MEDIA_TUNER_CUSTOMIZE
>>>       bool "Customize analog and hybrid tuner modules to build"
>>>       depends on MEDIA_TUNER
>>>       help
>>>         This allows the user to deselect tuner drivers unnecessary
>>>         for their hardware from the build. Use this option with care
>>>         as deselecting tuner drivers which are in fact necessary  
>>> will
>>>         result in V4L/DVB devices which cannot be tuned due to  
>>> lack of
>>>         driver support
>>>
>>>         If unsure say N.
>>>
>>>
>>> We allow users to disable certain modules if they think they know
>>> better, and choose to compile out drivers that they don't need.  You
>>> should not have disabled tuner-simple -- to play it safe, don't  
>>> enable
>>> MEDIA_TUNER_CUSTOMIZE
>>>
>>> Regards,
>>>
>>> Mike
>>>
>>>
>> Mike,
>>
>> Thank you. I understand the impact my choice makes in that matter.
>> However, all of the other modules required for cx18 to function are
>> marked in the lists as -M- indicating it is a required module/module
>> dependency. I apologize for my ignorance of terminology, etc., but it
>> would seem to me that "Simple tuner support" should automatically  
>> have
>> the -M- as a required resource for the tuner to function correctly.
>>
>> Thank you for your time in responding.
>>
>> Brandon
> No -- You are misunderstanding -- The selection of the tuner.ko i2c
> client module is forced as -M- , since it is selected as a dependency.
> You then proceeded into a deeper layer of customization, and enabled
> "MEDIA_TUNER_CUSTOMIZE" -- this option allows you to disable tuner
> modules that should have otherwise been autoselected for your  
> hardware.
> I repeat -- this is an advanced customization option, and you have  
> been
> so warned by its Kconfig description.
>
> I am pushing up a patch now that disables MEDIA_TUNER_CUSTOMIZE by  
> default.
>
> -Mike
Mike,

That doesn't solve the problem. I believe the patch below, will.

Brandon

diff -r 50be11af3fdb linux/drivers/media/video/cx18/Kconfig
--- a/linux/drivers/media/video/cx18/Kconfig	Mon Jun 16 18:04:06 2008  
-0300
+++ b/linux/drivers/media/video/cx18/Kconfig	Tue Jun 17 12:02:03 2008  
-0400
@@ -12,6 +12,7 @@ config VIDEO_CX18
  	select VIDEO_CS5345
  	select DVB_S5H1409
  	select MEDIA_TUNER_MXL5005S
+	select MEDIA_TUNER_SIMPLE
  	---help---
  	  This is a video4linux driver for Conexant cx23418 based
  	  PCI combo video recorder devices.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
