Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:50765 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab1AIRQu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Jan 2011 12:16:50 -0500
Date: Sun, 9 Jan 2011 09:55:40 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Drake <dsd@laptop.org>
Subject: Re: [RFCv2 PATCH 0/5] Use control framework in cafe_ccic and
 s_config removal
Message-ID: <20110109095540.21fcd9e4@bike.lwn.net>
In-Reply-To: <1294484508-14820-1-git-send-email-hverkuil@xs4all.nl>
References: <1294484508-14820-1-git-send-email-hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat,  8 Jan 2011 12:01:43 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> This patch series converts the OLPC cafe_ccic driver to the new control
> framework. It turned out that this depended on the removal of the legacy
> s_config subdev operation. I originally created the ov7670 controls in
> s_config, but it turned out that s_config is called after v4l2_device_register_subdev,
> so v4l2_device_register_subdev is unable to 'inherit' the ov7670 controls
> in cafe_ccic since there aren't any yet.
> 
> Another reason why s_config is a bad idea.
> 
> So the first patch removes s_config and v4l2_i2c_new_subdev_cfg and converts
> any users (cafe_ccic/ov7670 among them) to v4l2_i2c_new_subdev_board, which is
> what God (i.e. Jean Delvare) intended. :-)

I've been "vacationing" with the in-laws in Europe for the last couple of
weeks; just got back home last night.  Body clock is still in transit
somewhere.

Anyway, I've looked the patches over quickly and can't find anything to
really complain about, but I can't claim to have done an in-depth review.
Before it's merged, it would be nice to let the OLPC folks take a look
(adding Daniel to Cc).  It also would be really nice to know that the
reworked ov7670 driver still plays nice with the via-camera driver.  I can
try to find time to check that out, but my time between now and LCA/FOSDEM
is going to be tight indeed.

> This has been extensively tested on my humble OLPC laptop (and it took me 4-5
> hours just to get the damn thing up and running with these drivers).

My experience with the XO is always the same; it's a real pain to get
things going after I've been away from it for a while.

> The way this works is that setting the gain on its own will turn off autogain
> (this conforms to the current behavior of ov7670), setting autogain and gain
> atomically will only set the gain if autogain is set to manual.
> 
> Ditto for exposure/autoexposure.
> 
> The only question is: is the current behavior of implicitly turning off autogain
> when setting a new gain value correct? I think setting the gain in that case
> should do nothing.

I did it that way years ago because it seemed to me that, if the
application is setting the gain, it should actually set the gain.  I still
think that is the behavior that makes sense.  I don't know that anybody is
tied to that behavior, though, so it probably makes more sense to do what
all the other drivers do, whatever that is.

Thanks,

jon
