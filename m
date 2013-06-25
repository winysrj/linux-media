Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52918 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751767Ab3FYIVZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 04:21:25 -0400
Date: Tue, 25 Jun 2013 11:21:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Question: interaction between selection API, ENUM_FRAMESIZES and
 S_FMT?
Message-ID: <20130625082119.GJ2064@valkosipuli.retiisi.org.uk>
References: <201306241448.15187.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306241448.15187.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Jun 24, 2013 at 02:48:15PM +0200, Hans Verkuil wrote:
> Hi all,
> 
> While working on extending v4l2-compliance with cropping/selection test cases
> I decided to add support for that to vivi as well (this would give applications
> a good test driver to work with).
> 
> However, I ran into problems how this should be implemented for V4L2 devices
> (we are not talking about complex media controller devices where the video
> pipelines are setup manually).
> 
> There are two problems, one related to ENUM_FRAMESIZES and one to S_FMT.
> 
> The ENUM_FRAMESIZES issue is simple: if you have a sensor that has several
> possible frame sizes, and that can crop, compose and/or scale, then you need
> to be able to set the frame size. Currently this is decided by S_FMT which

Sensors have a single "frame size". Other sizes are achieved by using
cropping and scaling (or binning) from the native pixel array size. The
drivers should probably also expose these properties rather than advertise
multiple frame sizes.

> maps the format size to the closest valid frame size. This however makes
> it impossible to e.g. scale up a frame, or compose the image into a larger
> buffer.
> 
> For video receivers this issue doesn't exist: there the size of the incoming
> video is decided by S_STD or S_DV_TIMINGS, but no equivalent exists for sensors.
> 
> I propose that a new selection target is added: V4L2_SEL_TGT_FRAMESIZE.

The smiapp (well, subdev) driver uses V4L2_SEL_TGT_CROP_BOUNDS rectangle for
this purpose. It was agreed to use that instead of creating a separate
"pixel array size" rectangle back then. Could it be used for the same
purpose on video nodes, too? If not, then smiapp should also be switched to
use the new "frame size" rectangle.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
