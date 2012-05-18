Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54529 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761708Ab2ERNWz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 09:22:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SVN8u-0005nL-De
	for linux-media@vger.kernel.org; Fri, 18 May 2012 15:22:52 +0200
Received: from 92-32-255-209.tn.glocalnet.net ([92.32.255.209])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 18 May 2012 15:22:52 +0200
Received: from simong by 92-32-255-209.tn.glocalnet.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 18 May 2012 15:22:52 +0200
To: linux-media@vger.kernel.org
From: Simon Gustafsson <simong@simong.se>
Subject: Re: How fix driver for this USB camera (MT9T031 sensor and Cypress FX2LP USB bridge)
Date: Fri, 18 May 2012 13:22:42 +0000 (UTC)
Message-ID: <loom.20120518T130226-233@post.gmane.org>
References: <loom.20120517T001241-393@post.gmane.org> <20120517080734.16446c78@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine <moinejf <at> free.fr> writes:

> The FX2 is a processor, and, in ov519, used as a bridge, it has been
> programmed by OmniVision for their sensors. It is quite sure that its
> firmware is different in your webcam.
> 
> To know more, you should examine USB traces done with some other driver

You're right, protocol was completely different, for instance, we can't
read/write to I2C registers of our own choice. Got it working in user space now, 
including all settings available in their windows software (except software-only
settings like gamma etc).

Not sure if it's appropriate with a kernel driver, but since the amount of code
needed would be so small, we might just as well add it. It would probably add
support for these Chinese industrial cameras: DLC130/130L, DLC131/131L, DLC200, 
DLC300, Whitehawk, Goldenhawk, and GoldenEagle. The Windows software lets you
choose between those cameras at start up, and my camera produces images for all
those choices. For some choices, the images are cropped, and/or in gray scale 
with visible bayer pattern (suggesting those cameras would be monochrome).

Have a list of bad things below, would appreciate feedback on these. May amount 
to question whether there should be a kernel driver, in which case I'll just fix 
up the user space code, and host it somewhere.

1a) This FX2 bridge can't be used for auto-detection, since I didn't snoop
anything indicating we could read/write to any sensor registers of our own
choice. Additionally, the Windows software don't choose camera based on VID:PID
(you have the same choice of cameras even without a camera plugged in), so I
assume we need a module parameter for selecting which camera to use. 

1b) I only have one of these cameras, so I can only verify against this one, and 
since mine support the highest resolution, I can't try auto detection methods of 
requesting higher resolutions then the camera supports (hoping it fails), so 
module parameters would be needed here to begin with.

2) I guess the video format won't be supported by many apps (raw byer, 
specifically V4L2_PIX_FMT_SRGGB8). Would it be OK with a module parameter 
switching on kernel space conversion to something universally useful? (would 
happen in a workqueueue of course).

3) The windows software (or FX2 bridge) don't handle selecting lower resolutions 
correctly (it always crops the image, and we get the upper-left portion of the
image). This may be appropriate in many industrial applications. But I still
feel that users won't know why the driver sucks, so I would spontaneously think
we should always emit a couple of KERN_ERR messages describing the possible
problems, and possibly even require the user to configure the camera type module
parameter before opening the device.
  Alternatively, we could provide all resolutions, and all combinations of
color/monochrome all the time, but then only one out of 14 choices would give 
the expected image for a normal user, but industrial users would think seven of 
those 14 modes would be OK.
  This is a big usability point, I would go for an additional module parameter,
"allow_crop", which industrial users could set to get access to cropped images,
so regular users won't have to set more then a "max_resolution" or "camera_type" 
parameter.


But on the bright side, one can have a lot of fun with cheap Chinese industrial 
cameras, like reverse engineering, and writing kernel drivers :)

BR
/Simon

