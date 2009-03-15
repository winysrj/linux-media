Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2498 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbZCOTFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 15:05:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: RFC: ov7670 soc-camera driver
Date: Sun, 15 Mar 2009 20:05:36 +0100
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	corbet@lwn.net
References: <49BD3669.1070409@cam.ac.uk> <Pine.LNX.4.64.0903151948180.11969@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0903151948180.11969@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903152005.36265.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 15 March 2009 19:50:39 Guennadi Liakhovetski wrote:
> On Sun, 15 Mar 2009, Jonathan Cameron wrote:
> > From: Jonathan Cameron <jic23@cam.ac.uk>
> >
> > OV7670 driver for soc-camera interfaces.
>
> Much appreciated, thanks!
>
> > ---
> > There is already an ov7670 driver in tree, but it is very interface
> > specific (olpc) and hence not much use for the crossbow IMB400 board
> > which is plugged into an imote 2 pxa271 main board.
> >
> > Thanks go to Crossbow (www.xbow.com) for assistance in developing
> > this driver.
> >
> > This is my first driver related to v4l let alone soc-camera so this
> > is probably full of errors.  All comments appreciated!
> >
> > A couple of questions related to this patch.
> >
> > Unfortunately the data ordering in rgb565 is not that expected by
> > the pxa271 which for reasons best known to someone else shuffles
> > the bit order coming off the camera.  I don't know if this is a
> > common problem.  I haven't been able to come up with a combination
> > of sensor and soc colour modes that will let this through. Anyone
> > else met a similar problem?  At the moment I'm relying on
> > board specific documentation explaining how to rebuild the data
> > once an image has been captured, but obviously this is far from
> > ideal.
> >
> > The primary control on this chip related to shutter rate is actualy
> > the frame rate. There are rather complex (and largerly undocumented)
> > interactions between this setting and the auto brightness controls
> > etc. Anyone have any suggestions on a better way of specifying this?
> >
> > Clearly this driver shares considerable portions of code with
> > Jonathan Corbet's driver (in tree). It would be complex to combine
> > the two drivers, but perhaps people feel this would be worthwhile?
>
> Now, there we go... Hans, time for v4l2-device?...
>
> This means, I will look through the driver, but we should really think
> properly whether to pull it in now, or "just" convert the OLPC driver and
> soc-camera to v4l2-device and thus enable re-use.

I have already converted ov7670 to v4l2_subdev here:

http://linuxtv.org/hg/~hverkuil/v4l-dvb-cafe2/

I'm waiting for test feedback (Hi Corbet!) before I'll merge it.

This situation is exactly why we need one single API for subdevices like 
this. As soon as soc-camera is converted to v4l2-device it will just all 
fall neatly into place.

I don't think it is a good idea to merge a second ov7670 driver as that's 
exactly what we are trying to avoid. Migrating soc-camera to the 
v4l2-device/v4l2-subdev framework is the right approach. Otherwise this 
issue will just crop up time and again.

Although not good news for Jonathan, since his work will be delayed. 
Jonathan, to get an idea what all of this is about you should read the 
v4l2-framework.txt document in the master v4l-dvb repository 
(linuxtv.org/hg/v4l-dvb). It will give you the background information on 
the v4l2_subdev structure and associated API that we are migrating towards. 
And soc-camera happens to a framework that hasn't been converted yet.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
