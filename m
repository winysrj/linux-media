Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:53667 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab1CCHag (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 02:30:36 -0500
Date: Thu, 3 Mar 2011 08:30:33 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Kim, HeungJun" <riverful.kim@samsung.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
In-Reply-To: <4D6F3EBE.6070404@samsung.com>
Message-ID: <Pine.LNX.4.64.1103030826350.31639@axis700.grange>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <4D6F3EBE.6070404@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

On Thu, 3 Mar 2011, Kim, HeungJun wrote:

> Hi Guennadi,
> 
> I have another question about capture, not related with exact this topic.
> 
> Dose the sensor which you use make EXIF information in itself while capturing??

So far we have no sensors, about which we know, that they're delivering 
any metainformation with frames. There are a couple of sensors, about 
which we suspect, that a part of the image data might be some metadata, 
but we don't know for sure.

> If it is right, how to deliver EXIF information from v4l2(subdev or media driver)
> to userapplication?

I don't think this is currently possible and it is among the topics to be 
discussed at the coming v4l2-summit.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
