Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:56415 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754426Ab0C3Lnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Mar 2010 07:43:37 -0400
Subject: Re: [PATCH/RFC 0/1] v4l: Add support for binary controls
From: Andy Walls <awalls@md.metrocast.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Kamil Debski <k.debski@samsung.com>,
	linux-media@vger.kernel.org, p.osciak@samsung.com,
	kyungmin.park@samsung.com
In-Reply-To: <201003301057.56034.laurent.pinchart@ideasonboard.com>
References: <1269856386-29557-1-git-send-email-k.debski@samsung.com>
	 <201003300841.47978.hverkuil@xs4all.nl>
	 <201003301057.56034.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 07:43:42 -0400
Message-Id: <1269949422.3018.25.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-03-30 at 10:57 +0200, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday 30 March 2010 08:41:47 Hans Verkuil wrote:
> > On Monday 29 March 2010 11:53:05 Kamil Debski wrote:
> > > Hello,
> > > 
> > > This patch introduces new type of v4l2 control - the binary control. It
> > > will be useful for exchanging raw binary data between the user space and
> > > the driver/hardware.
> > > 
> > > The patch is pretty small – basically it adds a new control type.
> > > 
> > > 1.  Reasons to include this new type
> > > - Some devices require data which are not part of the stream, but there
> > > are necessary for the device to work e.g. coefficients for transformation
> > > matrices.
> > > - String control is not suitable as it suggests that the data is a null
> > > terminated string. This might be important when printing debug
> > > information - one might output strings as they are and binary data in
> > > hex.
> > > 
> > > 2. How does the binary control work
> > > The binary control has been based on the string control. The principle of
> > > use is the same. It uses v4l2_ext_control structure to pass the pointer
> > > and size of the data. It is left for the driver to call the
> > > copy_from_user/ copy_to_user function to copy the data.
> > > 
> > > 3. About the patch
> > > The patch is pretty small – it basically adds a new control type.
> > > 
> > > Best wishes,
> > 
> > I don't think this is a good idea. Controls are not really meant to be used
> > as an ioctl replacement.
> > 
> > Controls can be used to control the hardware via a GUI (e.g. qv4l2).
> > Obviously, this will fail for binary controls. Controls can also be used
> > in cases where it is not known up front which controls are needed. This
> > typically happens for bridge drivers that can use numerous combinations of
> > i2c sub-devices. Each subdev can have its own controls.
> > 
> > There is a grey area where you want to give the application access to
> > low-level parameters but without showing them to the end-user. This is
> > currently not possible, but it will be once the control framework is
> > finished and once we have the possibility to create device nodes for
> > subdevs.
> > 
> > But what you want is to basically pass whole structs as a control. That's
> > something that ioctls where invented for. Especially once we have subdev
> > nodes this shouldn't be a problem.
> > 
> > Just the fact that it is easy to implement doesn't mean it should be done
> > :-)
> > 
> > Do you have specific use-cases for your proposed binary control?
> 
> As discussed yesterday, here are a few use cases for the OMAP3 ISP driver.
> 
> - white balance matrix
> - gamma correction tables
> 
> In both cases, the driver needs an array (possible 2 dimensional) of values to 
> configure the hardware.
> 
> This can obviously be done using private ioctls, but what makes the red&blue 
> white balance gains different from the white balance matrix ? Why should the 
> first be controls and the later not ?

I'll suggest some tests:

1. Can an operator easily manipulate the control in an intuitive
fashion?

2. Can the kernel easily convey the visual form of the control to an
application, such the application can render it with common widget sets
not knowing much information apriori?



So sliders for gain controls fit that criteria easily.


I'm not sure about a matrix.  I'm guessing one could have a "look up
table" type control.  It would visually (on a gui) be a matrix of text
boxes that take numeric inputs; maybe with some kernel provided axes
labels and row and column labaels.  (I think that's better than an
arbitrary binary blob, although more work to implement.)


Regards,
Andy

