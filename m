Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43073 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1AWCCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 21:02:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH V3] v4l: OMAP3 ISP CCDC: Add support for 8bit greyscale sensors
Date: Sun, 23 Jan 2011 03:02:09 +0100
Cc: linux-media@vger.kernel.org
References: <20110120230246.GE13173@neutronstar.dyndns.org> <1295567011-6395-1-git-send-email-martin@neutronstar.dyndns.org>
In-Reply-To: <1295567011-6395-1-git-send-email-martin@neutronstar.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101230302.10692.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Martin,

Thanks for the patch.

On Friday 21 January 2011 00:43:31 Martin Hostettler wrote:
> Adds support for V4L2_MBUS_FMT_Y8_1X8 format and 8bit data width in
> synchronous interface.
> 
> When using V4L2_MBUS_FMT_Y8_1X8 (or possibly another 8bit per pixel) mode
> set the CDCC to output 8bit per pixel instead of 16bit.
> 
> Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've submitted the patch internally, it should end up in the public tree in 
the (hopefully) near future.

-- 
Regards,

Laurent Pinchart
