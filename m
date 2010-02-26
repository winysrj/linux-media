Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54410 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966545Ab0BZXjT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 18:39:19 -0500
Date: Sat, 27 Feb 2010 02:39:04 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: smatch on V4L/DVB updates
Message-ID: <20100226233904.GH8417@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 26, 2010 at 04:43:05PM -0300, Mauro Carvalho Chehab wrote:
> The following changes since commit 60b341b778cc2929df16c0a504c91621b3c6a4ad:
>   Linus Torvalds (1):
>         Linux 2.6.33
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus
> 

These changes introduce some smatch warnings.

How I generated this list was I made a list of the C files that were changed:

	for i in $(cat files.retest) ; do kchecker $i ; done | tee retest.out
	/path/to/smatch_scripts/new_bugs.sh retest.out warns.txt | tee err-list

	(I had created warns.txt in a previous nightly compile)

Then I went through the list and manually seperated out the actual bugs from the 
false positives using smatch_scripts/summarize_errs.sh.  Mostly it's just doing 
DMA on the stack (see Documentation/DMA-mapping.txt).

Eventually, the goal is to start testing linux-next using smatch but it could be a 
couple months yet because I'm going to be on the road for a while.

regards,
dan carpenter

drivers/media/dvb/dvb-usb/az6027.c +1043 az6027_identify_state(6) error: doing dma on the stack (b)
drivers/media/dvb/dvb-usb/dib0700_core.c +643 dib0700_rc_setup(12) error: doing dma on the stack (rc_setup)
arch/mn10300/unit-asb2305/pci.c +294 pci_sanity_check(2) warn: 'bus' puts 612 bytes on stack
arch/mn10300/unit-asb2305/pci.c +502 unit_pci_init(2) warn: 'bus' puts 612 bytes on stack
drivers/media/dvb/dvb-usb/dib0700_devices.c +494 dib0700_rc_query(18) error: doing dma on the stack (key)
drivers/media/dvb/frontends/stv090x.c +4553 stv090x_attach(37) error: potential null dereference 'state->internal'.  (kmalloc returns null)
drivers/media/video/davinci/dm355_ccdc.c +332 ccdc_set_params(2) warn: 'ccdc_raw_params' puts 584 bytes on stack
drivers/media/video/davinci/vpfe_capture.c +1988 vpfe_probe(200) warn: 'mutex:&ccdc_lock' is sometimes locked here and sometimes unlocked.
drivers/media/video/em28xx/em28xx-video.c +287 em28xx_copy_vbi(10) warn: variable dereferenced before check 'dev'
drivers/media/video/sh_mobile_ceu_camera.c +356 sh_mobile_ceu_videobuf_prepare(29) warn: variable dereferenced before check 'icd->current_fmt'
drivers/media/video/sh_mobile_ceu_camera.c +1032 client_s_crop(9) warn: variable dereferenced before check 'sd'
drivers/media/video/tlg2300/pd-main.c +83 send_set_req(18) error: doing dma on the stack (&data)
drivers/media/video/tlg2300/pd-main.c +123 send_get_req(18) error: doing dma on the stack (&data)
drivers/media/video/uvc/uvc_ctrl.c +1292 uvc_ctrl_add_ctrl(51) error: doing dma on the stack (&inf)
drivers/media/video/uvc/uvc_v4l2.c +688 uvc_v4l2_do_ioctl(207) error: doing dma on the stack (&input)

