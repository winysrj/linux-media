Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52671 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161490Ab3FUXc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 19:32:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: media: i2c: mt9p031: HFLIP/VFLIP changes format
Date: Sat, 22 Jun 2013 01:32:44 +0200
Message-ID: <2959002.SlIJC0ILYx@avalon>
In-Reply-To: <6EE9CD707FBED24483D4CB0162E8546745F4218E@AMSPRD0711MB532.eurprd07.prod.outlook.com>
References: <6EE9CD707FBED24483D4CB0162E8546745F4218E@AMSPRD0711MB532.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Friday 21 June 2013 15:48:25 Florian Neuhaus wrote:
> Hi Laurent
> 
> In the mt9p031 driver, the picture can be flipped either horizontally or
> vertically by using the according V4L2 controls. This can be done at
> runtime.
> I have noticed, that flipping the picture will change the bayer-pattern.
> So if I flip horizontally and vertically to get a 180 degree rotation
> the bayer pattern changes from
> V4L2_MBUS_FMT_SGRBG12_1X12
> to
> V4L2_MBUS_FMT_SGBRG12_1X12
> I'm not sure how the patch should look like...
> The format code could be adapted accordingly to the flipping, but
> how does the userspace notices this change? The user could issue
> another get_format. But what about the omap3isp-pipe?
> Concrete:
> What should I do to configure a streaming pipe with a flipped image?
> Flip the image on the v4l-subdev and then build the pipe?
> Is there a chance to propagate the format change through the pipe
> during streaming?

There are two ways to handle this situation. You could modify the output 
format, which would then bring format propagation issues, or you could offset 
the sensor crop rectangle by one pixel. The second option is probably easier 
to implement as it's local to the sensor, without any need to propagate format 
changes.

-- 
Regards,

Laurent Pinchart

