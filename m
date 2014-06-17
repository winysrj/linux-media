Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59079 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbaFQLPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jun 2014 07:15:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?utf-8?B?0JzQuNGF0LDQudC70L4g0J3QvtCy0L7RgtC90LjQuQ==?=
	<michael.novotnuy@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: omap3-isp driver in CSI2 mode
Date: Tue, 17 Jun 2014 13:15:50 +0200
Message-ID: <4441884.LLcx2kbRvM@avalon>
In-Reply-To: <CAAT6_74xo5MSxfAVZNHoxXQPMWd_KRWCDTaKvUMx054BD9-9NQ@mail.gmail.com>
References: <CAAT6_74xo5MSxfAVZNHoxXQPMWd_KRWCDTaKvUMx054BD9-9NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

(Removing linux-sh and dridevel from the CC list as they're not related)

On Tuesday 17 June 2014 12:00:52 Михайло Новотний wrote:
> Hi Laurent Pinchart!
> 
> I'm working on multimedia project. And use processor DM3730.
> Now I am try capture image from sensor OV5640 over MIPI interface.
> I can see that you are author of omap3-isp driver for linux-2.6.37.
> I spent more then month try do it, but can't do it.
> 
> I asked on TI forum:
> http://e2e.ti.com/support/dsp/davinci_digital_media_processors/f/537/p/33699
> 1/1182836.aspx#1182836
> http://e2e.ti.com/support/dsp/davinci_digital_media_processors/f/537/p/3030
> 66/1220093.aspx#1220093
> 
> Is your driver really can work on DM3730 in CSI2 mode? Did you test it on
> DM3730?

The OMAP3 ISP driver present in the mainline kernel supports the CSI2 
receiver. However, the CSI2 interface is not officially available on the 
DM3730. I have seen reports claiming that the interface is present in the 
DM3730, but I haven't tested it myself due to lack of hardware.

-- 
Regards,

Laurent Pinchart

