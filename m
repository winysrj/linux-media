Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51474 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1E3IpT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 04:45:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: Capabilities of the Omap3 ISP driver
Date: Mon, 30 May 2011 10:45:23 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Felix v. Hundelshausen" <felix.v.hundelshausen@live.de>
References: <BANLkTineUffG1yd3Ey30wr0xzAj3_Zd1KQ@mail.gmail.com>
In-Reply-To: <BANLkTineUffG1yd3Ey30wr0xzAj3_Zd1KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105301045.24326.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On Sunday 29 May 2011 15:27:23 Bastian Hecht wrote:
> Hello Laurent,
> 
> I'm on to a project that needs two synced separate small cameras for
> stereovision. It's for harvesting tomatoes in fact :)
> 
> I was thinking about realizing this on an DM3730 with 2 aptina csi2
> cameras that are used in snapshot mode.

As far as I know, the DM3730 doesn't have CSI2 interfaces.

> The questions that arise are:
> 
> - is the ISP driver capable of running 2 concurrent cameras?

Yes it can, but only one of them can use the CCDC, preview engine and resizer. 
The other will be captured directly to memory as raw data. You could capture 
both raw streams to memory, and then feed them alternatively through the rest 
of the pipeline. Whether this can work will depend on the image size and frame 
rate.

> - is it possible to simulate a kind of video stream that is externally
> triggered (I would use a gpio line that simply triggers 10 times a
> sec) or would there arise problems with the csi2 protocoll (timeouts
> or similar)?

I don't think there will be CSI2 issues (although I'm not an expert there) if 
you trigger the sensors externally.

-- 
Regards,

Laurent Pinchart
