Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55044 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbcCUKOt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 06:14:49 -0400
Date: Mon, 21 Mar 2016 07:14:43 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: cron job: media_tree daily build: OK
Message-ID: <20160321071443.2d139482@recife.lan>
In-Reply-To: <20160321065708.281a4aa4@recife.lan>
References: <20160321040508.0C6691800EC@tschai.lan>
	<20160321065708.281a4aa4@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Mar 2016 06:57:08 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Mon, 21 Mar 2016 05:05:07 +0100
> "Hans Verkuil" <hverkuil@xs4all.nl> escreveu:
> 
> > This message is generated daily by a cron job that builds media_tree for
> > the kernels and architectures in the list below.
> > 
> > Results of the daily build of media_tree:
> > 
> > date:		Mon Mar 21 04:00:22 CET 2016
> > git branch:	test
> > git hash:	b39950960d2b890c21465c69c7c0e4ff6253c6b5
> > gcc version:	i686-linux-gcc (GCC) 5.3.0
> > sparse version:	v0.5.0-56-g7647c77
> > smatch version:	Warning: /share/smatch/smatch_data/ is not accessible.
> > Use --no-data or --data to suppress this message.
> > v0.5.0-3353-gcae47da  
> 
> Not sure how you're running smatch, but what I do here is to run
> it as:
> 	/<smatch_dir>/smatch
> 
> This way, it finds the smatch_data dir at /<smatch_dir, with also
> suppress several false positive error messages from the smatch logs.
> 
> As a side effect, it simplifies a little bit the procedure to update
> smatch's version.
> 
> Regards

As a reference, those are what I get here with the latest version of
smatch (plus a patch to avoid a "Function too hairy." warning, posted
in the end of this email):

$ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y C=1 W=1 CHECK='/devel/smatch/smatch -p=kernel' M=drivers/staging/media
$ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y C=1 W=1 CHECK='/devel/smatch/smatch -p=kernel' M=drivers/media
drivers/media/tuners/tuner-xc2028.c:1498 xc2028_attach() error: potential null dereference 'priv'.  (kzalloc returns null)
drivers/media/radio/radio-aztech.c:87 aztech_alloc() warn: possible memory leak of 'az'
drivers/media/pci/mantis/mantis_uart.c:105 mantis_uart_work() warn: this loop depends on readl() succeeding
drivers/media/dvb-core/dvb_frontend.c:272 dvb_frontend_get_event() warn: inconsistent returns 'sem:&fepriv->sem'.
  Locked on:   line 246
               line 253
               line 264
               line 272
  Unlocked on: line 261
drivers/media/pci/ddbridge/ddbridge-core.c:1007 input_tasklet() warn: this loop depends on readl() succeeding
drivers/media/pci/ddbridge/ddbridge-core.c:1351 flashio() warn: this loop depends on readl() succeeding
drivers/media/pci/ddbridge/ddbridge-core.c:1371 flashio() warn: this loop depends on readl() succeeding
drivers/media/tuners/tuner-simple.c:1102 simple_tuner_attach() error: potential null dereference 'priv'.  (kzalloc returns null)
drivers/media/radio/radio-typhoon.c:79 typhoon_alloc() warn: possible memory leak of 'ty'
drivers/media/radio/radio-aimslab.c:73 rtrack_alloc() warn: possible memory leak of 'rt'
drivers/media/radio/radio-zoltrix.c:83 zoltrix_alloc() warn: possible memory leak of 'zol'
drivers/media/radio/radio-gemtek.c:189 gemtek_alloc() warn: possible memory leak of 'gt'
drivers/media/tuners/tda9887.c:692 tda9887_attach() error: potential null dereference 'priv'.  (kzalloc returns null)
drivers/media/radio/radio-trust.c:60 trust_alloc() warn: possible memory leak of 'tr'
drivers/media/tuners/tda18271-fe.c:1317 tda18271_attach() error: potential null dereference 'priv'.  (kzalloc returns null)
drivers/media/tuners/xc5000.c:1418 xc5000_attach() error: potential null dereference 'priv'.  (kzalloc returns null)
drivers/media/tuners/xc4000.c:1690 xc4000_attach() error: potential null dereference 'priv'.  (kzalloc returns null)
drivers/media/tuners/mxl5007t.c:878 mxl5007t_attach() error: potential null dereference 'state'.  (kzalloc returns null)
drivers/media/rc/ir-lirc-codec.c:289 ir_lirc_ioctl() warn: check for integer overflow 'val'
drivers/media/tuners/r820t.c:2342 r820t_attach() error: potential null dereference 'priv'.  (kzalloc returns null)
drivers/media/rc/st_rc.c:110 st_rc_rx_interrupt() warn: this loop depends on readl() succeeding
drivers/media/pci/bt8xx/dvb-bt8xx.c:720 frontend_init() warn: possible memory leak of 'state'
./arch/x86/include/asm/bitops.h:416:22: warning: asm output is not an lvalue
./arch/x86/include/asm/bitops.h:416:22: warning: asm output is not an lvalue
./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an lvalue
./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an lvalue
./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an lvalue
./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an lvalue
./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an lvalue
./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an lvalue
drivers/media/usb/uvc/uvc_ctrl.c:1387 uvc_ctrl_begin() warn: inconsistent returns 'mutex:&chain->ctrl_mutex'.
  Locked on:   line 1387
  Unlocked on: line 1387
drivers/media/usb/pvrusb2/pvrusb2-hdw.c:3676 pvr2_send_request_ex() error: we previously assumed 'write_data' could be null (see line 3648)
drivers/media/usb/pvrusb2/pvrusb2-hdw.c:3829 pvr2_send_request_ex() error: we previously assumed 'read_data' could be null (see line 3649)
drivers/media/platform/vivid/vivid-rds-gen.c:82 vivid_rds_generate() error: buffer overflow 'rds->psname' 9 <= 43
drivers/media/platform/vivid/vivid-rds-gen.c:83 vivid_rds_generate() error: buffer overflow 'rds->psname' 9 <= 42
drivers/media/platform/vivid/vivid-rds-gen.c:89 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 84
drivers/media/platform/vivid/vivid-rds-gen.c:90 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 85
drivers/media/platform/vivid/vivid-rds-gen.c:92 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 86
drivers/media/platform/vivid/vivid-rds-gen.c:93 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 87

---

[PATCH] smatch_slist: use a higher memory limit

50M is not enough for some code at the Kernel. It produces this
warning:

drivers/media/pci/cx23885/cx23885-dvb.c:2046 dvb_register() Function too hairy.  Giving up.

While checking for troubles on a loop with attaches the device
specific sub-devices based on the PCI ID.

There's not much that could be done at the code to simplify it.
The code there is big just because the cx23885 driver supports
lots of different cards.

On the other hand, increasing the maximum memory size to 500MB
is cheap, as nowadays even desktops have 16GB.

So, let's increase it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/smatch_slist.c b/smatch_slist.c
index 947c35c7f9e0..c4027341ca30 100644
--- a/smatch_slist.c
+++ b/smatch_slist.c
@@ -235,11 +235,11 @@ char *alloc_sname(const char *str)
 int out_of_memory(void)
 {
 	/*
-	 * I decided to use 50M here based on trial and error.
+	 * I decided to use 500M here based on trial and error.
 	 * It works out OK for the kernel and so it should work
 	 * for most other projects as well.
 	 */
-	if (sm_state_counter * sizeof(struct sm_state) >= 50000000)
+	if (sm_state_counter * sizeof(struct sm_state) >= 500000000)
 		return 1;
 	return 0;
 }


-- 
Thanks,
Mauro
