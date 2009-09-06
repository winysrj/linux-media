Return-path: <linux-media-owner@vger.kernel.org>
Received: from compulab.co.il ([67.18.134.219]:34298 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbZIFGDp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Sep 2009 02:03:45 -0400
Message-ID: <4AA350B4.30204@compulab.co.il>
Date: Sun, 06 Sep 2009 09:03:32 +0300
From: Mike Rapoport <mike@compulab.co.il>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Eric Miao <eric.y.miao@gmail.com>,
	Marek Vasut <marek.vasut@gmail.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Add RGB555X and RGB565X formats to pxa-camera
References: <200908031031.00676.marek.vasut@gmail.com> <4A76CB7C.10401@gmail.com> <Pine.LNX.4.64.0908031415370.5310@axis700.grange> <4A76DF29.1050008@compulab.co.il> <Pine.LNX.4.64.0909042102200.4501@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0909042102200.4501@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Guennadi Liakhovetski wrote:
> On Mon, 3 Aug 2009, Mike Rapoport wrote:
> 
>>> 2. Mike, while reviewing this patch I came across code in 
>>> pxa_camera_setup_cicr(), introduced by your earlier patch:
>>>
>>> 	case V4L2_PIX_FMT_RGB555:
>>> 		cicr1 |= CICR1_RGB_BPP_VAL(1) | CICR1_RGBT_CONV_VAL(2) |
>>> 			CICR1_TBIT | CICR1_COLOR_SP_VAL(1);
>>> 		break;
>>>
>>> Why are you enabling the RGB to RGBT conversion here unconditionally? 
>>> Generally, what are the advantages of configuring CICR1 for a specific RGB 
>>> format compared to using just a raw capture? Do I understand it right, 
>>> that ATM we are not using any of those features?
>> As far as I remember I've tried to overlay the captured imagery using pxa
>> overlay1. Most probably it's left here after those tries.
> 
> Mike, could you, please, verify that those bits are indeed unneeded and 
> provide patch to remove them?

Unfortunately, I don't have the sensor handy at the time :( The one I've used
then is now broken (physically) and there's no replacement for it :(

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Sincerely yours,
Mike.

