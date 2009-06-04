Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:28556 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZFDAJC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2009 20:09:02 -0400
Received: by yw-out-2324.google.com with SMTP id 5so207965ywb.1
        for <linux-media@vger.kernel.org>; Wed, 03 Jun 2009 17:09:04 -0700 (PDT)
Message-ID: <4A271083.1060100@gmail.com>
Date: Wed, 03 Jun 2009 20:08:35 -0400
From: =?UTF-8?B?RGFuaWVsIFNhbnRpYsOhw7Fleg==?= <dansanti@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Fwd: driver trident tm5600
References: <fc70a2550906011337v14a33ddfue20eaffb06d289c@mail.gmail.com>	 <fc70a2550906021427s61221090l8bbd738d223df41a@mail.gmail.com>	 <4A263E07.6070804@yahoo.co.nz> <fc70a2550906031250v4ed29e6bs90a6ba255246449a@mail.gmail.com> <4A26DB12.9030708@yahoo.co.nz>
In-Reply-To: <4A26DB12.9030708@yahoo.co.nz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hello again!

now when i tried to compile, appear :

v4l/tm6000-dvb.c:240: error: unknown field 'video_dev' specified in
initializer
v4l/tm6000-dvb.c:240: warning: initialization makes integer from
pointer without a cast

after i tried changing video_dev by videodev, but still happend

>>
>>     Daniel Santibáńez wrote:
>>
>>
>>         Hello.!!
>>         i tried to install a driver for this usb device, long time
>> i try
>>         to finish but, when i probe the driver error by erro
>> appear,and
>>          this don't work aparently.. when i run modprobe this say:
>>
>>         tm6000-alsa: Unknow symbol tm6000_get_reg
>>         tm6000-alsa: Unknow symbol tm6000_set_reg
>>
>>         what i have to do.? could you help me.?? exist a how to?
>>         actualy? thanks.
>>
>>
>>         I currently use:
>>
>>         Kernel        : Linux 2.6.28-12-generic (i686)
>>         Compiled        : #43-Ubuntu SMP Fri May 1 19:27:06 UTC 2009
>>         C Library        : GNU C Library version 2.9 (stable)
>>         Distribution        : Ubuntu 9.04
>>         Desktop Environment        : GNOME 2.26
>>
>>     Hi Daniel,
>>
>>     I suggest you post to the linux-media mailing list in future. That
>>     way the mailing lists acts as a knowledge base for other people
>> with
>>     the same problem. See http://www.linuxtv.org/lists.php for
>> details.
>>     I used BCC in case you don't want your e-mail address on a
>> public site.
>>
>>     Did you pull from the http://linuxtv.org/hg/~mchehab/tm6010
>>     <http://linuxtv.org/hg/%7Emchehab/tm6010> repository with last
>>     change dated 28 Nov 2008? That code compiles on Ubuntu 8.10 but
>> not
>>     on Ubuntu 9.04. You could try the following (untested) patch to
>>     resolve this.
>>
>>     I only have experience trying to get the Hauppauge HVR-900H
>> working
>>     with this driver. It does not currently work for me with New
>> Zealand
>>     television.
>>
>>     Kevin
>>
>>     diff -r ca10a33f275b linux/drivers/media/dvb/dvb-core/dvbdev.c
>>     --- a/linux/drivers/media/dvb/dvb-core/dvbdev.c Sun Apr 05
>> 10:57:01
>>     2009 +1200
>>     +++ b/linux/drivers/media/dvb/dvb-core/dvbdev.c Wed Jun 03
>> 20:45:03
>>     2009 +1200
>>     @@ -261,7 +261,7 @@
>>
>>      #if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 27)
>>            clsdev = device_create(dvb_class, adap->device,
>>     -                              MKDEV(DVB_MAJOR,
>>     nums2minor(adap->num, type, id)),
>>     +                              MKDEV(DVB_MAJOR, minor),
>>                                   NULL, "dvb%d.%s%d", adap->num,
>>     dnames[type], id);
>>      #elif LINUX_VERSION_CODE == KERNEL_VERSION(2, 6, 27)
>>            clsdev = device_create_drvdata(dvb_class, adap->device,
>>     diff -r ca10a33f275b
>> linux/drivers/media/video/tm6000/tm6000-alsa.c
>>     --- a/linux/drivers/media/video/tm6000/tm6000-alsa.c    Sun Apr 05
>>     10:57:01 2009 +1200
>>     +++ b/linux/drivers/media/video/tm6000/tm6000-alsa.c    Wed Jun 03
>>     20:45:03 2009 +1200
>>     @@ -17,7 +17,7 @@
>>      #include <linux/usb.h>
>>
>>      #include <asm/delay.h>
>>     -#include <sound/driver.h>
>>     +/*#include <sound/driver.h>*/
>>      #include <sound/core.h>
>>      #include <sound/pcm.h>
>>      #include <sound/pcm_params.h>
>>     diff -r ca10a33f275b linux/drivers/media/video/tm6000/tm6000-i2c.c
>>     --- a/linux/drivers/media/video/tm6000/tm6000-i2c.c     Sun Apr 05
>>     10:57:01 2009 +1200
>>     +++ b/linux/drivers/media/video/tm6000/tm6000-i2c.c     Wed Jun 03
>>     20:45:03 2009 +1200
>>     @@ -258,7 +258,7 @@
>>
>>      /* Tuner callback to provide the proper gpio changes needed for
>>     xc2028 */
>>
>>     -static int tm6000_tuner_callback(void *ptr, int command, int arg)
>>     +static int tm6000_tuner_callback(void *ptr, int component, int
>>     command, int arg)
>>      {
>>            int rc=0;
>>            struct tm6000_core *dev = ptr;
>>
>>

-- 
Daniel Santibáñez
Ð.§.

