Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.17.9]:50959 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1AFHaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 02:30:17 -0500
Date: Thu, 6 Jan 2011 08:30:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Roberto Rodriguez Alcala <rralcala@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: Question about Night Mode
In-Reply-To: <AANLkTi=XSy2GU2+oBQXXWAgftsVZBkM5rxHGFGr3CGEm@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1101060806330.29151@axis700.grange>
References: <AANLkTi=XSy2GU2+oBQXXWAgftsVZBkM5rxHGFGr3CGEm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, 6 Jan 2011, Roberto Rodriguez Alcala wrote:

> Hi, i'm interested in implement the Night Mode for the ov7370 driver, and it
> is done by modifyng 1 bit of the control register 11, but i'm unable to find
> a V4l2 user Control ID for that (Ex: V4L2-CID-NIGHT_MODE). I also think that
> the mentioned feature is quite common in cameras so my question is:
> 
> Is there any control commonly used for that feature or it has to be a hack?

I cannot claim, that I understand what all existing controls do, but in 
general, I would say, try to think, whether one of them has the same 
function, as what you need, is you find one - use it, if not - try to 
propose a new control ID. Of course, you can always implement a 
driver-private control, using V4L2_CID_PRIVATE_BASE, but it is not for 
features, that are common for multiple devices.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
