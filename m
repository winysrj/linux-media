Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:65479 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752535AbdLPLaw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 06:30:52 -0500
Date: Sat, 16 Dec 2017 09:30:46 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: more build failures
Message-ID: <20171216093046.1d8ac7ab@recife.lan>
In-Reply-To: <20171216034939.GA20217@ubuntu.windy>
References: <20171215124111.GA29657@ubuntu.windy>
        <20171216034939.GA20217@ubuntu.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 16 Dec 2017 14:49:41 +1100
Vincent McIntyre <vincent.mcintyre@gmail.com> escreveu:

> On Fri, Dec 15, 2017 at 11:41:13PM +1100, Vincent McIntyre wrote:
> > 
> > ...
> > 
> > $ make allyesconfig
> > make -C /home/me/git/clones/media_build/v4l allyesconfig
> > make[1]: Entering directory '/home/me/git/clones/media_build/v4l'
> > No version yet, using 4.4.0-103-generic
> > make[2]: Entering directory '/home/me/git/clones/media_build/linux'
> > Syncing with dir ../media/
> > Applying patches for kernel 4.4.0-103-generic
> > patch -s -f -N -p1 -i ../backports/api_version.patch
> > patch -s -f -N -p1 -i ../backports/pr_fmt.patch
> > patch -s -f -N -p1 -i ../backports/debug.patch
> > patch -s -f -N -p1 -i ../backports/drx39xxj.patch
> > patch -s -f -N -p1 -i ../backports/v4.14_compiler_h.patch
> > patch -s -f -N -p1 -i ../backports/v4.14_saa7146_timer_cast.patch
> > patch -s -f -N -p1 -i ../backports/v4.14_module_param_call.patch
> > patch -s -f -N -p1 -i ../backports/v4.12_revert_solo6x10_copykerneluser.patch
> > patch -s -f -N -p1 -i ../backports/v4.10_sched_signal.patch
> > 1 out of 1 hunk FAILED
> > The text leading up to this was:
> > --------------------------
> > |diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> > |index 015e41bd036e..fd61081b47d9 100644
> > |--- a/drivers/staging/media/lirc/lirc_zilog.c
> > |+++ b/drivers/staging/media/lirc/lirc_zilog.c
> > --------------------------
> > No file to patch.  Skipping patch.
> > 1 out of 1 hunk ignored
> > Makefile:130: recipe for target 'apply_patches' failed
> > make[2]: *** [apply_patches] Error 1
> > make[2]: Leaving directory '/home/me/git/clones/media_build/linux'
> > Makefile:374: recipe for target 'allyesconfig' failed
> > make[1]: *** [allyesconfig] Error 2
> > make[1]: Leaving directory '/home/me/git/clones/media_build/v4l'
> > Makefile:26: recipe for target 'allyesconfig' failed
> > make: *** [allyesconfig] Error 2
> > can't select all drivers at ./build line 525
> > + status=29
> > + date
> > Friday 15 December  23:29:17 AEDT 2017
> > + [ 0 = 29 ]  
> 
> I managed to get past the failure above with this change
> 
>  - media: rc: move ir-lirc-codec.c contents into lirc_dev.c
>    media: lirc: remove last remnants of lirc kapi
>  - Sean removed lirc_zilog.c, so it no longer needs patching
> 
> --- a/backports/v4.10_sched_signal.patch
> +++ b/backports/v4.10_sched_signal.patch
> @@ -195,19 +195,6 @@ index 0e8025b7b4dd..8c59d4f53200 100644
>   #include <linux/delay.h>
>   #include <linux/videodev2.h>
>   #include <linux/v4l2-dv-timings.h>
> -diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> -index db1e7b70c998..fc03068e22b5 100644
> ---- a/drivers/media/rc/lirc_dev.c
> -+++ b/drivers/media/rc/lirc_dev.c
> -@@ -18,7 +18,7 @@
> - #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> - 
> - #include <linux/module.h>
> --#include <linux/sched/signal.h>
> -+#include <linux/sched.h>
> - #include <linux/ioctl.h>
> - #include <linux/poll.h>
> - #include <linux/mutex.h>
>  diff --git a/drivers/media/usb/cpia2/cpia2_core.c b/drivers/media/usb/cpia2/cpia2_core.c
>  index 0efba0da0a45..5d8aa65ab40b 100644
>  --- a/drivers/media/usb/cpia2/cpia2_core.c
> @@ -246,19 +233,6 @@ index 0b5c43f7e020..36bd904946bd 100644
>   #include <linux/slab.h>
>   #include <linux/interrupt.h>
>   
> -diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> -index 015e41bd036e..fd61081b47d9 100644
> ---- a/drivers/staging/media/lirc/lirc_zilog.c
> -+++ b/drivers/staging/media/lirc/lirc_zilog.c
> -@@ -42,7 +42,7 @@
> - #include <linux/module.h>
> - #include <linux/kmod.h>
> - #include <linux/kernel.h>
> --#include <linux/sched/signal.h>
> -+#include <linux/sched.h>
> - #include <linux/fs.h>
> - #include <linux/poll.h>
> - #include <linux/string.h>
> 
> 
> However it falls over later in a way I don't think I can help with.
> 
> ...
>   CC [M]  /home/me/git/clones/media_build/v4l/pvrusb2-i2c-core.o
>   CC [M]  /home/me/git/clones/media_build/v4l/pvrusb2-audio.o
>   CC [M]  /home/me/git/clones/media_build/v4l/pvrusb2-encoder.o
>   CC [M]  /home/me/git/clones/media_build/v4l/pvrusb2-video-v4l.o
>   CC [M]  /home/me/git/clones/media_build/v4l/pvrusb2-eeprom.o
>   CC [M]  /home/me/git/clones/media_build/v4l/pvrusb2-main.o
>   CC [M]  /home/me/git/clones/media_build/v4l/pvrusb2-hdw.o
> /home/me/git/clones/media_build/v4l/pvrusb2-hdw.c: In function 'pvr2_send_request_ex':
> /home/me/git/clones/media_build/v4l/pvrusb2-hdw.c:3651:7: error: implicit declaration of function 'usb_urb_ep_type_check' [-Werror=implicit-function-declaration]
>    if (usb_urb_ep_type_check(hdw->ctl_write_urb)) {
>        ^
> cc1: some warnings being treated as errors
> scripts/Makefile.build:258: recipe for target '/home/me/git/clones/media_build/v4l/pvrusb2-hdw.o' failed
> make[3]: *** [/home/me/git/clones/media_build/v4l/pvrusb2-hdw.o] Error 1
> Makefile:1423: recipe for target '_module_/home/me/git/clones/media_build/v4l' failed
> make[2]: *** [_module_/home/me/git/clones/media_build/v4l] Error 2
> make[2]: Leaving directory '/usr/src/linux-headers-4.4.0-103-generic'
> Makefile:51: recipe for target 'default' failed
> make[1]: *** [default] Error 2
> make[1]: Leaving directory '/home/me/git/clones/media_build/v4l'
> Makefile:26: recipe for target 'all' failed
> make: *** [all] Error 2

Just pushed two patches to media build, in order to address those
issues. Here, it is now compiling fine with Kernel 4.4.59.

Thanks,
Mauro
