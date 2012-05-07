Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46971 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2EGW7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2012 18:59:23 -0400
Received: by wibhj6 with SMTP id hj6so66189wib.1
        for <linux-media@vger.kernel.org>; Mon, 07 May 2012 15:59:22 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 7 May 2012 16:59:22 -0600
Message-ID: <CAEULaVLja27TBpSNKGGOuxP09_F=-UDXAn00K0qEXfBNL=QFcA@mail.gmail.com>
Subject: Capturing from MT9J003 Camera on DM3730 using Previewer and Resizer
From: Neil Johnson <realdealneil@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linux-media list,

We've recently had some success capturing from the MT9J003 Aptina
camera on a DM3730 board (custom board).  We have been able to prove
this functionality by adapting the MT9P031 driver from
Linux-3.0.tar.gz (we downloaded the tarball and patched from there).
The exact URL for that version of the kernel is:

http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.bz2

We have been working off of this kernel and using the media-ctl and
yavta applications to manipulate pipelines and test out the capture
interface.  Everything seems to work okay up through capturing from
the CCDC output (/dev/video2), but once we try to send the data
through the previewer or resizer, the app hangs at "start streaming"
or the call to the DQBUF ioctl.

The resolution we're capturing is a little odd: 912x688 (that happens
to be the recommended resolution according to one of Aptina's
manuals).  The pipeline that works looks like this:

================Start CCDC Pipeline==========================
#! /bin/sh

#
# Configure media-controller pipeline for MT9J003
#
media-ctl -r
media-ctl -l '"mt9j003 2-0010":0->"OMAP3 ISP CCDC":0[1]'
media-ctl -l '"OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
media-ctl -f '"mt9j003 2-0010":0[SGRBG12 916x688]'
media-ctl -f '"OMAP3 ISP CCDC":0[SGRBG10 916x688]'
media-ctl -f '"OMAP3 ISP CCDC":1[SGRBG10 916x688]'

./yavta -p -f SGRBG10 -s 912x688 -n 4 --capture=5 -F `media-ctl -e
"OMAP3 ISP CCDC output"` --file=./images/img#.raw
================End CCDC Pipeline======================
=====

That spits out nice images which I can demosaic using post-processing
tools, and I get an actual image.

The following pipeline does not work properly:
================Start Preview Pipeline=========================
#! /bin/sh

#
# Configure media-controller pipeline for MT9J003
#
media-ctl -r
media-ctl -l '"mt9j003 2-0010":0->"OMAP3 ISP CCDC":0[1]'
media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP preview output":0[1]'
media-ctl -f '"mt9j003 2-0010":0[SGRBG12 916x688]'
media-ctl -f  '"OMAP3 ISP CCDC":0 [SGRBG10 916x688]'
media-ctl -f  '"OMAP3 ISP CCDC":1 [SGRBG10 916x688]'
media-ctl -f  '"OMAP3 ISP preview":0 [SGRBG10 916x687]'
media-ctl -f  '"OMAP3 ISP preview":1 [UYVY 898x679]'

# Now capture:
./yavta -p -f UYVY -s 898x679 -n 4 --capture=5 -F `media-ctl -e "OMAP3
ISP preview output"` --file=./images/img#.uyvy
=================End Preview Pipeline==========================

When I run this preview capture script (from /dev/video4), the
application hangs after going into streaming mode on the sensor.
Here's the output when running the preview pipeline script (with some
annotations, and some printk's inserted):

=================Start output=================================
root@cobra3530p7303:~# ./grab_preview_yavta
***** preview_link_setup: drivers/media/video/omap3isp/isppreview.c, 1923
***** preview_link_setup: drivers/media/video/omap3isp/isppreview.c, 1923


cobra_mt9j003_cam_reset: Resetting MT9J003 camera, active = 0
Setting MT9J003 Coarse Int Time to 24000
  Confirmed: set coarse int time to 24000
mt9j003_set_format:754 Called mt9j003_get_format
***** preview_init_formats: drivers/media/video/omap3isp/isppreview.c, 1861
***** preview_set_format: drivers/media/video/omap3isp/isppreview.c, 1826
***** preview_try_format: drivers/media/video/omap3isp/isppreview.c, 1633
    * pad = 0 (0=sink(input), 1=src(output))
***** preview_try_format: drivers/media/video/omap3isp/isppreview.c, 1633
    * pad = 1 (0=sink(input), 1=src(output))
***** preview_set_format: drivers/media/video/omap3isp/isppreview.c, 1826
***** preview_try_format: drivers/media/video/omap3isp/isppreview.c, 1633
    * pad = 0 (0=sink(input), 1=src(output))
***** preview_try_format: drivers/media/video/omap3isp/isppreview.c, 1633
    * pad = 1 (0=sink(input), 1=src(output))
***** preview_init_formats: drivers/media/video/omap3isp/isppreview.c, 1861
***** preview_set_format: drivers/media/video/omap3isp/isppreview.c, 1826
***** preview_try_format: drivers/media/video/omap3isp/isppreview.c, 1633
    * pad = 0 (0=sink(input), 1=src(output))
***** preview_try_format: drivers/media/video/omap3isp/isppreview.c, 1633
    * pad = 1 (0=sink(input), 1=src(output))
***** preview_set_format: drivers/media/video/omap3isp/isppreview.c, 1826
***** preview_try_format: drivers/media/video/omap3isp/isppreview.c, 1633
    * pad = 1 (0=sink(input), 1=src(output))
cobra_mt9j003_cam_reset: Resetting MT9J003 camera, active = 0
Number of arguments = 12
Last argument = /dev/video4
Setting MT9J003 Coarse Int Time to 24000
  Confirmed: set coarse int time to 24000
Device /dev/vide  mbus size: w=898, h=679
o4 opened.
Devi  Selected 16 from formats list
ce `OMAP3 ISP pr  min_bpl = 1796eview output' on
isp_video_mbus_to_pix returning 28
 `media' is a video capture device.
Video format set: UYVY (59565955) 898x679 (stride 1824) buffer size 1238496
Video format: UYVY (59565955) 898x679 (stride 1824) buffer size 1238496
4 buffers requested.
length: 1238496 offset: 0
Buffer 0 mapped at address 0x402e5000.
length: 1238496 offset: 1241088
Buffer 1 mapped at address 0x404e1000.
length: 1238496 offset: 2482176
Buffer 2 mapped at address 0x4070c000.
length: 1238496 offset: 3723264
Buffer 3 mapped at address 0x40913000.
Press enter to start capture

***** preview_get_format: drivers/media/video/omap3isp/isppreview.c, 1803
  mbus size: w=898, h=679
  Selected 16 from formats list
  min_bpl = 1796  isp_video_mbus_to_pix returning 28
  isp_video_mbus_to_pix returned 28
  isp_video_check_format returned 28
  SinkPad = OMAP3 ISP preview, 0
***** preview_get_format: drivers/media/video/omap3isp/isppreview.c, 1803
  SourcePad = OMAP3 ISP CCDC, 2
  SinkPad = OMAP3 ISP CCDC, 0
  SourcePad = mt9j003 2-0010, 0
mt9j003_get_format:711 Called mt9j003_get_format
***** preview_set_stream: drivers/media/video/omap3isp/isppreview.c, 1541
    * enable = 1 (1=continuous,2=single-shot)
mt9j003_get_format:711 Called mt9j003_get_format
  mbus size: w=912, h=688
  Selected 10 from formats list
  min_bpl = 1824  isp_video_mbus_to_pix returning 0
mt9j003_s_stream:609 Called mt9j003_s_stream
mt9j003_set_params:598 Called mt9j003_set_params
mt9j003_set_software_standby: Going from standby into streaming (reset
reg now = 0x14)

(At this point the app hangs, so eventually I hit Ctrl-C and it exits
out without getting any buffers)

***** preview_set_stream: drivers/media/video/omap3isp/isppreview.c, 1541
    * enable = 0 (1=continuous,2=single-shot)
omap3isp omap3isp: CCDC stop timeout!
ISR - total: 0, matches: 0, restarts: 0
0 total buffers, 0 failures
mt9j003_s_stream:609 Called mt9j003_s_stream
mt9j003_set_software_standby: Going from streaming into standby (reset
reg now = 0x10)
=================End output=========================================

I have a couple of questions to help me figure out next steps to resolving this:

1) It appears that the pipeline is getting set up correctly.  Is there
a way to print out debugging info on the previewer to determine if
data is getting to that section of the pipeline?
2) Interrupts do not appear to be triggering when I do the Preview
capture, but they definitely trigger when I do the CCDC capture
pipeline.  Why would they not trigger in the preview case?
3) It is a bit tricky to know the right resolution input/output sizes
for different stages of the pipeline (CCDC output, preview input,
etc).  Is there a way of solving for these without manually testing
out pipelines and seeing what fails?
4) Are there known issues with the 3.0 version of kernel?  Will some
or all of these problems be resolved if I rebase my code off of the
latest stable release?  Is there an alternative tree that I should be
using to test out omap3isp?

Thanks,

Neil Johnson
