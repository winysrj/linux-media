Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35052 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755956AbcCOLGQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 07:06:16 -0400
Date: Tue, 15 Mar 2016 13:06:09 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philippe De Muyter <phdm@macq.eu>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: subdev sensor driver and
 V4L2_FRMIVAL_TYPE_CONTINUOUS/V4L2_FRMIVAL_TYPE_STEPWISE
Message-ID: <20160315110608.GT11084@valkosipuli.retiisi.org.uk>
References: <20160315101417.GA31990@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160315101417.GA31990@frolo.macqel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philippe,

On Tue, Mar 15, 2016 at 11:14:17AM +0100, Philippe De Muyter wrote:
> Hi,
> 
> Sorry if you read the following twice, but the subject of my previous post
> was not precise enough :(
> 
> I am in the process of converting a sensor driver compatible with the imx6
> freescale linux kernel, to a subdev driver compatible with a current kernel
> and Steve Longerbeam's work.
> 
> My sensor can work at any fps (even fractional) up to 60 fps with its default
> frame size or even higher when using crop or "binning'.  That fact is reflected
> in my previous implemetation of VIDIOC_ENUM_FRAMEINTERVALS, which answered
> with a V4L2_FRMIVAL_TYPE_CONTINUOUS-type reply.
> 
> This seem not possible anymore because of the lack of the needed fields
> in the 'struct v4l2_subdev_frame_interval_enum' used to delegate the question
> to the subdev driver.  V4L2_FRMIVAL_TYPE_STEPWISE does not seem possible
> anymore either.  Has that been replaced by something else or is that
> functionality not considered relevant anymorea ?

I think the issue was that the CONTINUOUS and STEPWISE were considered too
clumsy for applications and practically no application was using them, or at
least the need for these was not seen to be there. They were not added to
the V4L2 sub-device implementation of the interface as a result.

Cc Hans.

The smiapp driver uses horizontal and vertical blanking controls for
changing the frame rate. That's a bit lower level interface than most
drivers use, but then you have to provide enough other information to the
user space as well, including the pixel rate.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
