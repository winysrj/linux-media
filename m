Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52042 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755Ab1ESNCM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 09:02:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alex Gershgorin <alexg@meprolight.com>
Subject: Re: FW: OMAP 3 ISP
Date: Thu, 19 May 2011 15:02:10 +0200
Cc: "'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>,
	"'sakari.ailus@iki.fi'" <sakari.ailus@iki.fi>,
	"'agersh@rambler.ru'" <agersh@rambler.ru>
References: <4875438356E7CA4A8F2145FCD3E61C0B15D3557D38@MEP-EXCH.meprolight.com>
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B15D3557D38@MEP-EXCH.meprolight.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105191502.11130.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Alex,

On Thursday 19 May 2011 14:51:16 Alex Gershgorin wrote:
> Thanks Laurent,
> 
> My video source is not the video camera and performs many other functions.
> For this purpose I have RS232 port.
> As for the video, it runs continuously and is not subject to control except
> for the power supply.

As a quick hack, you can create an I2C driver for your video source that 
doesn't access the device and just returns fixed format and frame size.

The correct fix is to implement support for platform subdevs in the V4L2 core.

-- 
Regards,

Laurent Pinchart
