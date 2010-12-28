Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45335 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab0L1Uq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 15:46:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enric =?utf-8?q?Balletb=C3=B2_i_Serra?= <eballetbo@gmail.com>
Subject: Re: OMAP3 ISP and tvp5151 driver.
Date: Tue, 28 Dec 2010 21:46:48 +0100
Cc: linux-media@vger.kernel.org
References: <AANLkTimec2+VyO+iRSx1PYy3btOb6RbHt0j3ytmnykVo@mail.gmail.com>
In-Reply-To: <AANLkTimec2+VyO+iRSx1PYy3btOb6RbHt0j3ytmnykVo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012282146.49327.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Enric,

On Monday 27 December 2010 17:24:13 Enric Balletbò i Serra wrote:
> Hello all,
> 
> I'm new on media and camera, I try to use the OMAP3 ISP driver on
> OMAP3530 with media framework. I've a TVP5151 connected on ISP port
> though the parallel interface on own custom board
> 
> Against which repository/branch should I start the development ?

The most up-to-date code is located in the media-0004-omap3isp branch of the 
http://git.linuxtv.org/pinchartl/media.git repository.

> Should I port tvp5150 driver to new tvp5151 device and new media
> framework ?

That would be great :-)

> Any driver as reference ?

The MT9T001 and MT9V032 drivers in the media-0005-sensors branch. I haven't 
tested the MT9T001 driver recently, so my advice would be to use the MT9V032 
driver.

> Hopefully, somebody can give me some tips. Thanks

-- 
Regards,

Laurent Pinchart
