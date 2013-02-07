Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58209 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758976Ab3BGRD1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 12:03:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Adriano Martins <adrianomatosmartins@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: omap3isp - set_xclk dont work
Date: Thu, 07 Feb 2013 18:03:36 +0100
Message-ID: <8504007.0jva5VQ4En@avalon>
In-Reply-To: <CAJRKTVo279P0dqTxqoQLLpyRQYn8HNDpE6=csk1pV46E7hQp4g@mail.gmail.com>
References: <CAJRKTVo279P0dqTxqoQLLpyRQYn8HNDpE6=csk1pV46E7hQp4g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Adriano,

On Wednesday 06 February 2013 11:26:43 Adriano Martins wrote:
> Hi,
> 
> I have 2 boards with DM3730 processor, a beagleboard  and a custom board. 
> The omap3isp is working in both boards, any error is seen. On beagleboard I
> can see the xclka, then the sensor is detected and the driver is load
> correctly. But, in the custom board, every seem work, there are no errors
> too. But I can't see the xclka signal.
> 
> The hardware is ok. Because, I load another driver that uses the camera bus.
> The xclka is working.
> 
> it is the same processor, same kernel version, same driver. Why, it work in
> one, and not another.
> 
> Someone can help me? please.

The XCLK clocks currently require special handling in board code, with the 
sensor calling back to board code when it wants to turn the clock on/off, and 
board code calling the set_xclk isp operation. Does your board code perform 
that operation ?

-- 
Regards,

Laurent Pinchart

