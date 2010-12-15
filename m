Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44391 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760278Ab0LOBAg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 20:00:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH] v4l: OMAP3 ISP CCDC: Add support for 8bit greyscale sensors
Date: Wed, 15 Dec 2010 02:01:31 +0100
Cc: linux-media@vger.kernel.org
References: <1292337823-15994-1-git-send-email-martin@neutronstar.dyndns.org>
In-Reply-To: <1292337823-15994-1-git-send-email-martin@neutronstar.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012150201.31635.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Martin,

Thanks for the patch.

On Tuesday 14 December 2010 15:43:43 Martin Hostettler wrote:
> Adds support for V4L2_MBUS_FMT_Y8_1X8 format and 8bit data width in
> syncronous interface.
> 
> The data width is configured in the parallel interface part of the isp
> platform data, defaulting to 10bit as before this commit. When i 8bit mode
> don't apply DC substraction of 64 per default as this would remove 1/4 of
> the sensor range.
> 
> When using V4L2_MBUS_FMT_Y8_1X8 (or possibly another 8bit per pixel) mode
> set the CDCC to output 8bit per pixel instead of 16bit.
> 
> Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>

I got a similar patch for 12bit support. I'll try to push a new version of the 
ISP driver with that patch included in the next few days (it needs to go 
through internal review first), could you then rebase your patch on top of it 
? The core infrastructure will be set up, you will just have to add 8-bit 
support.

-- 
Regards,

Laurent Pinchart
