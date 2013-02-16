Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3925 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab3BPMlG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 07:41:06 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id r1GCexmb009253
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sat, 16 Feb 2013 13:41:04 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (marune.xs4all.nl [80.101.105.217])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id A5FF911E00BE
	for <linux-media@vger.kernel.org>; Sat, 16 Feb 2013 13:40:59 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [REPORT] Use of legacy APIs in V4L2 drivers
Date: Sat, 16 Feb 2013 13:40:58 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302161340.58361.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As regular readers of this mailinglist have no doubt noticed I have been
cleaning up lots of drivers recently. Some of that work I did last year,
but for one reason or another I never got the chance to post them until
recently, and some of it is new development.

The purpose is to make these drivers more compliant with the V4L API using
the v4l2-compliance tool, but by doing so I also want to eventually remove
some legacy API support from the v4l2 core.

This report gives the status of the remaining work. I have quite a few
outstanding patches in various branches, so those drivers that I have
converted, but are not yet tested or merged I state the branch name those
patches can be found in. All branches can be found here:

http://git.linuxtv.org/hverkuil/media_tree.git/heads


1) Use of the control framework in sub-devices.

All subdevices must use it. The following sub-devices are still not converted:

a) Nothing done yet:

- go7007/s2250-board

The other go7007 i2c drivers are special cases: these first need to be converted
to subdevs, then the control framework needs to be added. The saa7113/5 drivers
can probably go away, using the existing saa7115 driver instead.

Patches were posted in 2010 converting at least some of these to a subdev.

- go7007/wis-saa7113: needs to be converted to a subdev first.
- go7007/wis-saa7115: needs to be converted to a subdev first.
- go7007/wis-tw9903: needs to be converted to a subdev first.
- go7007/wis-tw2804: needs to be converted to a subdev first.

b) Patch pending, but not yet posted for review:

- sr030pc30: see branch ctrlfw.
- saa6752hs: see branch ctrlfw.
- saa7706h: see branch ctrlfw. Trying to find someone who can
  test this.
- si4713-i2c: see branch si4713. Found someone who might be able
  to test this. Waiting for feedback.
- saa7191: see branch subdev-ctrl (very old branch)
- indycam: see branch subdev-ctrl (very old branch)

c) Patch pending, posted for review:

- au8522_decoder: see branch au0828.

d) Patch pending, pull request posted:

- tda7432: see branch bttv.


2) Use of the control framework in bridge drivers.

a) Nothing done yet:

- uvc. May never be converted since it does not fit the concept of the
  control framework very well (or at all).
- sn9c102
- saa7134-go7007
- pvrusb2
- cx25821
- cx23885
- saa7134
- zoran
- saa7164
- davinci/vpfe_capture
- omap_vout
- omap24xxcam
- go7007
- dt3155v4l

b) Patch pending, but not yet posted for review:

- usbvision: see branch usbvision.
- hdpvr: see branch hdpvr.
- gspca-sonixj: see branch gspca.
- vino: see branch subdev-ctrl (very old branch)
- radio-timb: see branch ctrlfw. Trying to find someone who can test this.
- radio-si4713: see branch si4713. Found someone who might be able
  to test this. Waiting for feedback.
- radio-tea5764: see branch ctrlfw. Trying to find someone who can test this.
- radio-sf16fmi: see branch ctrlfw. Trying to find someone who can test this.
- solo6x10: see branch solo.

c) Patch pending, posted for review:

- s2255: see branch s2255.
- au0828: see branch au0828.
- fsl-viu: see branch fsl-viu.

d) Patch pending, pull request posted:

- stkwebcam: see branch stkwebcam.
- tlg2300: see branch tlg2300.
- cx231xx: see branch cx231xx.
- bttv: see branch bttv.


3) Use of .ioctl instead of .unlocked_ioctl in bridge drivers.

This is nasty since this takes a very high level lock to simulate the now
defunct Big Kernel Lock.

a) Nothing done yet:

- pvrusb2
- tlg2300: video nodes only.
- cx25821
- cx23885
- saa7134
- davinci/vpbe_venc
- omap24xxcam
- solo6x10
- go7007

b) Patch pending, pull request posted:

- cx231xx: see branch cx231xx.
- stkwebcam: see branch stkwebcam.
- tlg2300: see branch tlg2300, fixed for the radio node only.


4) Use of non-standard unlocked_ioctl.

This should be video_ioctl2 and there is no reason not to use it.

a) Nothing done yet:

- uvc (although I believe a patch changing this is floating around somewhere)
- sn9c102
- zoran
- vino


5) Set the parent field instead of the v4l2_dev field in struct video_device

By pointing to struct v4l2_device you can inherit information from that
top-level struct. It's also a prerequisite of the control framework
conversion.

a) Nothing done yet:

- sn9c102
- cx23885
- zoran
- saa7164
- soc_camera
- omap24xxcam
- go7007

b) Patch pending, but not yet posted for review:

- hdpvr: see branch hdpvr.
- solo6x10: see branch solo.

c) Patch pending, posted for review:

- au0828: see branch au0828.

d) Patch pending, pull request posted:

- stkwebcam: see branch stkwebcam.


6) Use of current_norm instead of implementing the .g_std op.

The use of current_norm is very confusing and will not work for drivers with
multiple device nodes sharing the same video source (or sink). Drivers should
just implement the g_std op.

a) Nothing done yet:

- tm6000
- cx25821
- cx23885
- saa7134
- saa7164
- davinci/vpbe_display
- davinci/vpfe_capture
- soc_camera
- via-camera
- sh_vou
- mcam-core
- go7007
- dt3155v4l

b) Patch pending, but not yet posted for review:

- usbvision: see branch usbvision.
- solo6x10: see branch solo.
- hdpvr: see branch hdpvr.

c) Patch pending, posted for review:

- s2255: see branch s2255.
- au0828: see branch au0828.
- fsl-viu: see branch fsl-viu.

d) Patch pending, pull request posted:

- stkwebcam: see branch stkwebcam.
- cx231xx: see branch cx231xx.
- bttv: see branch bttv.


7) Conclusion

The situation is quite good with regards to the subdev drivers. Except for
some small ones, the main problem is with some go7007 i2c drivers.

The bridge drivers that still need a lot of work are cx25821, cx23885,
saa7134, saa7164, zoran, pvrusb2 and go7007.

I plan on dealing with the go7007 driver next. I have now three different
go7007 devices and should get a fourth very soon. That should give me enough
hardware to do some decent testing and hammer this driver into shape and
possibly out of staging.

If someone wants to help out with some of the open issues, please let me know.
In particular I would appreciate help with getting rid of current_norm and
the use of .ioctl instead of .unlocked_ioctl. Once gone, both would clean up
the v4l2 core quite nicely. Replacing current_norm by g_std isn't difficult to
do so that makes it a nice janitorial project.

Once all this has been done, then I will look at some other cleanups:

- require all drivers to use struct v4l2_fh (might well be a consequence of the
  current round of cleanups, so I expect this to be fairly easy).
- convert to vb2 (much harder to do).
- implement much of the DBG_G_CHIP_IDENT and DBG_G/S_REGISTER in the core.
  The code in the current drivers is messy but they all need to do the same
  thing. Ideal to replace by some smart core code.
- improve error handling of subdev result codes. Calling the same op for
  multiple subdevs makes for tricky result code handling. Usually it is
  ignored, and that can be improved.
- standardize disconnect/release handling. It's hard to do disconnect and
  release handling correctly in drivers. Many drivers try to keep track of
  use-counts themselves, generally incorrectly.

Regards,

	Hans
