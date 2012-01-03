Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53562 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab2ACOAH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 09:00:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: MEM2MEM devices: how to handle sequence number?
Date: Tue, 3 Jan 2012 15:00:22 +0100
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, s.hauer@pengutronix.de,
	r.schwebel@pengutronix.de, Pawel Osciak <p.osciak@gmail.com>
References: <CACKLOr0H4enuADtWcUkZCS_V92mmLD8K5CgScbGo7w9nbT=-CA@mail.gmail.com> <201201021206.06397.laurent.pinchart@ideasonboard.com> <CACKLOr3gc9o7JYzG+rV9Mp9C7xtgf0Q5W7vgxQ5H8wQDvO-ong@mail.gmail.com>
In-Reply-To: <CACKLOr3gc9o7JYzG+rV9Mp9C7xtgf0Q5W7vgxQ5H8wQDvO-ong@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201031500.23732.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Monday 02 January 2012 12:44:08 javier Martin wrote:
> Just one more question about this.
> 
> The v4l2 encoder, which is the last element in my processing chain, is
> an H.264 encoder that has to know about previous frames to encode.
> For these kind of devices it is very useful to know whether a frame
> has been lost to introduce a skip frame and improve the encoding
> process.
> 
> But, with the current approach we don't have any way to communicate
> this to the device.
> 
> One option would be that the user specified a sequence number when
> issuing VIDIOC_QBUF at the output queue so that the device could
> detect any discontinuity and introduce a skip frame. But this would
> break your rule that sequence number introduced at the output queue
> has to be ignored by the driver.

That's a use case I haven't thought about. Using sequence numbers could indeed 
help in that case. My concern is that most (if not all) applications don't set 
the sequence number before queuing a buffer, so requiring them to do so could 
introduce breakages. This could be limited to H.264 encoders (or more 
generally codecs) though.

Another option would be to queue a 0-bytes frame. That might be a bit hackish 
though.

-- 
Regards,

Laurent Pinchart
