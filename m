Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:49198 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaIWSeT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 14:34:19 -0400
Received: by mail-lb0-f170.google.com with SMTP id z11so3930103lbi.15
        for <linux-media@vger.kernel.org>; Tue, 23 Sep 2014 11:34:17 -0700 (PDT)
Message-ID: <5421BD84.8090609@googlemail.com>
Date: Tue, 23 Sep 2014 20:35:48 +0200
From: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: kbuild test robot <fengguang.wu@intel.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: Re: [linuxtv-media:devel-3.17-rc6 491/499] drivers/media/usb/em28xx/em28xx.h:787:2:
 warning: 'vid' may be used uninitialized in this function
References: <5420da9a.AVbO33MRDo+yIJFy%fengguang.wu@intel.com>
In-Reply-To: <5420da9a.AVbO33MRDo+yIJFy%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 23.09.2014 um 04:27 schrieb kbuild test robot:
> tree:   git://linuxtv.org/media_tree.git devel-3.17-rc6
> head:   7f8de65b0dc84c19e79d7a642a5655524c57035c
> commit: f5ac7a471e156f997833f94bad2228e57122c227 [491/499] [media] em28xx: remove some unnecessary fields from struct em28xx_audio_mode
> config: i386-randconfig-r0-0923 (attached as .config)
> reproduce:
>   git checkout f5ac7a471e156f997833f94bad2228e57122c227
>   # save the attached .config to linux build tree
>   make ARCH=i386 
>
> Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
> http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings
>
> All warnings:
>
>    In file included from drivers/media/usb/em28xx/em28xx-core.c:35:0:
>    drivers/media/usb/em28xx/em28xx-core.c: In function 'em28xx_audio_setup':
>>> drivers/media/usb/em28xx/em28xx.h:787:2: warning: 'vid' may be used uninitialized in this function [-Wmaybe-uninitialized]
>      printk(KERN_INFO "%s: "fmt,\
>      ^
>    drivers/media/usb/em28xx/em28xx-core.c:507:6: note: 'vid' was declared here
>      u32 vid;
>          ^
This is a false warning.
Applying https://patchwork.linuxtv.org/patch/25918/ makes it disappear.

Regards,
Frank


> vim +/vid +787 drivers/media/usb/em28xx/em28xx.h
>
> 47677e51 drivers/media/usb/em28xx/em28xx.h   Mauro Carvalho Chehab 2014-03-05  771  void em28xx_free_device(struct kref *ref);
> c8793b03 drivers/media/video/em28xx/em28xx.h Mauro Carvalho Chehab 2008-01-13  772  
> 855ff38e drivers/media/usb/em28xx/em28xx.h   Frank Schaefer        2013-03-27  773  /* Provided by em28xx-camera.c */
> 855ff38e drivers/media/usb/em28xx/em28xx.h   Frank Schaefer        2013-03-27  774  int em28xx_detect_sensor(struct em28xx *dev);
> 855ff38e drivers/media/usb/em28xx/em28xx.h   Frank Schaefer        2013-03-27  775  int em28xx_init_camera(struct em28xx *dev);
> 855ff38e drivers/media/usb/em28xx/em28xx.h   Frank Schaefer        2013-03-27  776  
> a6c2ba28 drivers/media/video/em28xx/em28xx.h Andrew Morton         2005-11-08  777  /* printk macros */
> a6c2ba28 drivers/media/video/em28xx/em28xx.h Andrew Morton         2005-11-08  778  
> 3acf2809 drivers/media/video/em28xx/em28xx.h Mauro Carvalho Chehab 2005-11-08  779  #define em28xx_err(fmt, arg...) do {\
> a6c2ba28 drivers/media/video/em28xx/em28xx.h Andrew Morton         2005-11-08  780  	printk(KERN_ERR fmt , ##arg); } while (0)
> a6c2ba28 drivers/media/video/em28xx/em28xx.h Andrew Morton         2005-11-08  781  
> 3acf2809 drivers/media/video/em28xx/em28xx.h Mauro Carvalho Chehab 2005-11-08  782  #define em28xx_errdev(fmt, arg...) do {\
> a6c2ba28 drivers/media/video/em28xx/em28xx.h Andrew Morton         2005-11-08  783  	printk(KERN_ERR "%s: "fmt,\
> a6c2ba28 drivers/media/video/em28xx/em28xx.h Andrew Morton         2005-11-08  784  			dev->name , ##arg); } while (0)
> a6c2ba28 drivers/media/video/em28xx/em28xx.h Andrew Morton         2005-11-08  785  
> 3acf2809 drivers/media/video/em28xx/em28xx.h Mauro Carvalho Chehab 2005-11-08  786  #define em28xx_info(fmt, arg...) do {\
> a6c2ba28 drivers/media/video/em28xx/em28xx.h Andrew Morton         2005-11-08 @787  	printk(KERN_INFO "%s: "fmt,\
> a6c2ba28 drivers/media/video/em28xx/em28xx.h Andrew Morton         2005-11-08  788  			dev->name , ##arg); } while (0)
> 3acf2809 drivers/media/video/em28xx/em28xx.h Mauro Carvalho Chehab 2005-11-08  789  #define em28xx_warn(fmt, arg...) do {\
> a6c2ba28 drivers/media/video/em28xx/em28xx.h Andrew Morton         2005-11-08  790  	printk(KERN_WARNING "%s: "fmt,\
> a6c2ba28 drivers/media/video/em28xx/em28xx.h Andrew Morton         2005-11-08  791  			dev->name , ##arg); } while (0)
> a6c2ba28 drivers/media/video/em28xx/em28xx.h Andrew Morton         2005-11-08  792  
> a6c2ba28 drivers/media/video/em28xx/em28xx.h Andrew Morton         2005-11-08  793  #endif
>
> :::::: The code at line 787 was first introduced by commit
> :::::: a6c2ba283565dbc9f055dcb2ecba1971460bb535 [PATCH] v4l: 716: support for em28xx board family
>
> :::::: TO: akpm@osdl.org <akpm@osdl.org>
> :::::: CC: Linus Torvalds <torvalds@g5.osdl.org>
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

