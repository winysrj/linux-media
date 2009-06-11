Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:63703 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868AbZFKAY2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 20:24:28 -0400
Received: by gxk10 with SMTP id 10so1633037gxk.13
        for <linux-media@vger.kernel.org>; Wed, 10 Jun 2009 17:24:30 -0700 (PDT)
Message-ID: <4A304EBA.1030404@gmail.com>
Date: Wed, 10 Jun 2009 20:24:26 -0400
From: =?UTF-8?B?RGFuaWVsIFNhbnRpYsOhw7Fleg==?= <dansanti@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Fwd: driver trident tm5600
References: <fc70a2550906011337v14a33ddfue20eaffb06d289c@mail.gmail.com>	 <fc70a2550906021427s61221090l8bbd738d223df41a@mail.gmail.com>	 <4A263E07.6070804@yahoo.co.nz> <fc70a2550906031250v4ed29e6bs90a6ba255246449a@mail.gmail.com> <4A26DB12.9030708@yahoo.co.nz> <4A271083.1060100@gmail.com>
In-Reply-To: <4A271083.1060100@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ok i can compile it. only i have to change it:
CONFIG_VIDEO_TM6000=y
CONFIG_VIDEO_TM6000_DVB=m
CONFIG_VIDEO_TM6000_ALSA=m

but when i put modprobe tm6000-alsa card=5, still happend the previous
error

    tm6000-alsa: Unknow symbol tm6000_get_reg
        tm6000-alsa: Unknow symbol tm6000_set_reg

but also i try with
make insmod tm6000-alsa
ans
make insmod tm6000-alsa card=5

appear this error


/usr/lib/gcc/i486-linux-gnu/4.3.3/../../../../lib/crt1.o: In function
`_start':
/build/buildd/glibc-2.9/csu/../sysdeps/i386/elf/start.S:115: undefined
reference to `main'
tm6000-alsa.o: In function `dsp_buffer_free':
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:148:
undefined reference to `printk'
tm6000-alsa.o: In function `tm6000_audio_init':
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:369:
undefined reference to `__this_module'
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:369:
undefined reference to `snd_card_new'
tm6000-alsa.o: In function `kmalloc':
/usr/src/linux-headers-2.6.28-13-generic/include/linux/slub_def.h:224:
undefined reference to `kmalloc_caches'
/usr/src/linux-headers-2.6.28-13-generic/include/linux/slub_def.h:224:
undefined reference to `kmem_cache_alloc'
tm6000-alsa.o: In function `tm6000_audio_init':
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:388:
undefined reference to `snd_component_add'
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:400:
undefined reference to `strlcat'
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:402:
undefined reference to `strlcat'
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:408:
undefined reference to `strlcat'
tm6000-alsa.o: In function `snd_tm6000_pcm':
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:336:
undefined reference to `snd_pcm_new'
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:341:
undefined reference to `snd_pcm_set_ops'
tm6000-alsa.o: In function `tm6000_audio_init':
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:418:
undefined reference to `snd_card_register'
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:426:
undefined reference to `snd_card_free'
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:391:
undefined reference to `usb_string'
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:398:
undefined reference to `strlcat'
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:371:
undefined reference to `printk'
tm6000-alsa.o: In function `snd_tm6000_card_trigger':
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:280:
undefined reference to `_spin_lock'
tm6000-alsa.o: In function `_tm6000_stop_audio_dma':
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:135:
undefined reference to `tm6000_get_reg'
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:137:
undefined reference to `tm6000_set_reg'
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:139:
undefined reference to `tm6000_set_reg'
tm6000-alsa.o: In function `__raw_spin_unlock':
/usr/src/linux-headers-2.6.28-13-generic/arch/x86/include/asm/paravirt.h:1411:
undefined reference to `pv_lock_ops'
tm6000-alsa.o: In function `_tm6000_start_audio_dma':
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:116:
undefined reference to `tm6000_get_reg'
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:118:
undefined reference to `tm6000_set_reg'
tm6000-alsa.o: In function `_tm6000_stop_audio_dma':
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:132:
undefined reference to `printk'
tm6000-alsa.o: In function `snd_tm6000_hw_params':
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:230:
undefined reference to `snd_pcm_format_physical_width'
tm6000-alsa.o: In function `dsp_buffer_free':
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:148:
undefined reference to `printk'
tm6000-alsa.o: In function `snd_tm6000_hw_params':
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:236:
undefined reference to `printk'
tm6000-alsa.o: In function `snd_tm6000_pcm_open':
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:194:
undefined reference to `snd_pcm_hw_constraint_pow2'
/home/daniel/driver-tm5600/tm6010-3d58b6531a81/v4l/tm6000-alsa.c:205:
undefined reference to `printk'
tm6000-alsa.o:(__param+0x8): undefined reference to `param_set_int'
tm6000-alsa.o:(__param+0xc): undefined reference to `param_get_int'
tm6000-alsa.o:(__param+0x1c): undefined reference to `param_array_set'
tm6000-alsa.o:(__param+0x20): undefined reference to `param_array_get'
tm6000-alsa.o:(__param+0x30): undefined reference to `param_array_set'
tm6000-alsa.o:(__param+0x34): undefined reference to `param_array_get'
tm6000-alsa.o:(.rodata+0xcc): undefined reference to `param_set_int'
tm6000-alsa.o:(.rodata+0xd0): undefined reference to `param_get_int'
tm6000-alsa.o:(.rodata+0xec): undefined reference to `param_set_bool'
tm6000-alsa.o:(.rodata+0xf0): undefined reference to `param_get_bool'
tm6000-alsa.o:(.data+0x108): undefined reference to `snd_pcm_lib_ioctl'
collect2: ld returned 1 exit status

any ideas...
thanks..


Daniel Santibáñez escribió:
> hello again!
>
> now when i tried to compile, appear :
>
> v4l/tm6000-dvb.c:240: error: unknown field 'video_dev' specified in
> initializer
> v4l/tm6000-dvb.c:240: warning: initialization makes integer from
> pointer without a cast
>
> after i tried changing video_dev by videodev, but still happend
>
>>>     Daniel Santibáńez wrote:
>>>
>>>
>>>         Hello.!!
>>>         i tried to install a driver for this usb device, long time
>>> i try
>>>         to finish but, when i probe the driver error by erro
>>> appear,and
>>>          this don't work aparently.. when i run modprobe this say:
>>>
>>>         tm6000-alsa: Unknow symbol tm6000_get_reg
>>>         tm6000-alsa: Unknow symbol tm6000_set_reg
>>>
>>>         what i have to do.? could you help me.?? exist a how to?
>>>         actualy? thanks.
>>>
>>>
>>>         I currently use:
>>>
>>>         Kernel        : Linux 2.6.28-12-generic (i686)
>>>         Compiled        : #43-Ubuntu SMP Fri May 1 19:27:06 UTC 2009
>>>         C Library        : GNU C Library version 2.9 (stable)
>>>         Distribution        : Ubuntu 9.04
>>>         Desktop Environment        : GNOME 2.26
>>>
>>>     Hi Daniel,
>>>
>>>     I suggest you post to the linux-media mailing list in future. That
>>>     way the mailing lists acts as a knowledge base for other people
>>> with
>>>     the same problem. See http://www.linuxtv.org/lists.php for
>>> details.
>>>     I used BCC in case you don't want your e-mail address on a
>>> public site.
>>>
>>>     Did you pull from the http://linuxtv.org/hg/~mchehab/tm6010
>>>     <http://linuxtv.org/hg/%7Emchehab/tm6010> repository with last
>>>     change dated 28 Nov 2008? That code compiles on Ubuntu 8.10 but
>>> not
>>>     on Ubuntu 9.04. You could try the following (untested) patch to
>>>     resolve this.
>>>
>>>     I only have experience trying to get the Hauppauge HVR-900H
>>> working
>>>     with this driver. It does not currently work for me with New
>>> Zealand
>>>     television.
>>>
>>>     Kevin
>>>
>>>     diff -r ca10a33f275b linux/drivers/media/dvb/dvb-core/dvbdev.c
>>>     --- a/linux/drivers/media/dvb/dvb-core/dvbdev.c Sun Apr 05
>>> 10:57:01
>>>     2009 +1200
>>>     +++ b/linux/drivers/media/dvb/dvb-core/dvbdev.c Wed Jun 03
>>> 20:45:03
>>>     2009 +1200
>>>     @@ -261,7 +261,7 @@
>>>
>>>      #if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 27)
>>>            clsdev = device_create(dvb_class, adap->device,
>>>     -                              MKDEV(DVB_MAJOR,
>>>     nums2minor(adap->num, type, id)),
>>>     +                              MKDEV(DVB_MAJOR, minor),
>>>                                   NULL, "dvb%d.%s%d", adap->num,
>>>     dnames[type], id);
>>>      #elif LINUX_VERSION_CODE == KERNEL_VERSION(2, 6, 27)
>>>            clsdev = device_create_drvdata(dvb_class, adap->device,
>>>     diff -r ca10a33f275b
>>> linux/drivers/media/video/tm6000/tm6000-alsa.c
>>>     --- a/linux/drivers/media/video/tm6000/tm6000-alsa.c    Sun Apr 05
>>>     10:57:01 2009 +1200
>>>     +++ b/linux/drivers/media/video/tm6000/tm6000-alsa.c    Wed Jun 03
>>>     20:45:03 2009 +1200
>>>     @@ -17,7 +17,7 @@
>>>      #include <linux/usb.h>
>>>
>>>      #include <asm/delay.h>
>>>     -#include <sound/driver.h>
>>>     +/*#include <sound/driver.h>*/
>>>      #include <sound/core.h>
>>>      #include <sound/pcm.h>
>>>      #include <sound/pcm_params.h>
>>>     diff -r ca10a33f275b linux/drivers/media/video/tm6000/tm6000-i2c.c
>>>     --- a/linux/drivers/media/video/tm6000/tm6000-i2c.c     Sun Apr 05
>>>     10:57:01 2009 +1200
>>>     +++ b/linux/drivers/media/video/tm6000/tm6000-i2c.c     Wed Jun 03
>>>     20:45:03 2009 +1200
>>>     @@ -258,7 +258,7 @@
>>>
>>>      /* Tuner callback to provide the proper gpio changes needed for
>>>     xc2028 */
>>>
>>>     -static int tm6000_tuner_callback(void *ptr, int command, int arg)
>>>     +static int tm6000_tuner_callback(void *ptr, int component, int
>>>     command, int arg)
>>>      {
>>>            int rc=0;
>>>            struct tm6000_core *dev = ptr;
>>>
>>>
>

