Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53272 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751659AbZBQWME (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 17:12:04 -0500
Date: Tue, 17 Feb 2009 23:12:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
cc: Agustin <gatoguan-os@yahoo.com>,
	Linux Arm Kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Rv: mx3-camera on current mxc kernel tree
In-Reply-To: <499B2A60.9080009@epfl.ch>
Message-ID: <alpine.DEB.2.00.0902172255560.6986@axis700.grange>
References: <50561.11594.qm@web32108.mail.mud.yahoo.com> <499B2A60.9080009@epfl.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(moving to the new video4linux list)

On Tue, 17 Feb 2009, Valentin Longchamp wrote:

> > I am trying to integrate your "mx3_camera" (soc-camera) driver into latest
> > MXC kernel tree in order to be able to use it along with other drivers I
> > need (specially USB and SDHC storage).

I am currently working on my soc-camera patch queue, which I shall clean 
up, complete and push upstream. Then, on top of it, I'll update the 
mx3-camera driver. My current version contains a few improvements and 
fixes over the original version. You should be able to start with the 
original version too, but if you can, maybe it is better to wait a few 
days for an updated version.

> I would need USB (both host and otg) too (and why not SDHC storage, but this
> is less needed for now), it would help my development flow a lot. Maybe I have
> missed something, but where is the usb support for mx31 in the last mxc
> kernels ?
> 
> For the mx3_camera, I am testing it these days on our mx31moboard to validate
> the camera interface hardware design. I am able to integrate it in the
> sources, compile it and register devices on the soc_camera bus with it. I am
> now experiencing troubles getting somes images, but this is another story (by
> the way, Guennadi, with what fmt have you tested the ipu and csi codes ?
> Because with a bayer camera I have problems).

I used Bayer, as this is the only format, that mt9t031 can produce. 
Answering your question from another email, you can use gstreamer, it has 
a bayer plugin. You probably will get funny colours, because the start 
pixel is wrong, you could use my patch for gstreamer from here

http://bugzilla.gnome.org/show_bug.cgi?id=571976

and then specify on gst-launch command line which starting pixel you want. 
E.g., my command line looked like

gst-launch v4l2src ! video/x-raw-bayed,width=240,height=320 ! \
bayer2rgb start-pixel=green_red ! ffmpegcolorspace ! fbdevsink

where the "start-pixel=green_red" parameter is provided by the 
aforementioned patch. You can also view Bayer images as monochrome, they 
will look checked, but unless you have very special colour patterns, 
images should be recognisable.

> > I am using branch "mxc-devel" from
> > git://git.pengutronix.de/git/imx/linux-2.6
> > 
> > I am trying to use your patches from
> > http://gross-embedded.homelinux.org/~lyakh/i.MX31-20090124/:
> >   0001-plat-mxc-define-CONSISTENT_DMA_SIZE-to-8M-needed.patch
> >   0002-soc-camera-camera-host-driver-for-i.MX3x-SoCs.patch
> >   0003-soc-camera-board-bindings-for-camera-host-driver-fo.patch
> > ... as apparently everything needed is already present on that branch, since
> > you submitted your latest IPU & IDAC DMA patches to the Linux ARM kernel
> > list.
> > 
> > However, this mx3_camera implementation does not fit the IPU/IDMA API
> > present in the aforementioned tree, and before asuming the required
> > rewritting effort I must ask:
> > 
> > Am I using the right tree, branch and patches for the task?

Sorry, I am afraid, you'll have to wait. I only have 24 hours a day...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
