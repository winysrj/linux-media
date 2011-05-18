Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:49234 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab1ERGVr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 02:21:47 -0400
Date: Wed, 18 May 2011 08:21:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kassey Lee <kassey1216@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, qingx@marvell.com,
	ygli@marvell.com, leiwen@marvell.com, hzhuang1@marvell.com
Subject: Re: pxa ccic driver based on soc_camera and videobuf
In-Reply-To: <BANLkTiko27NWjPx6sT0o7NEYSY2RLsX=_Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1105180817420.21439@axis700.grange>
References: <BANLkTiko27NWjPx6sT0o7NEYSY2RLsX=_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Kassey

On Wed, 18 May 2011, Kassey Lee wrote:

> hi, Guennadi, Hans:
> 
>       I just converted  Marvell CCIC driver from ccic_cafe to
> soc_camera + videobuf, and make it stable and robust.

Nice!

>       do you accept the soc_camera + videobuf to the latest kernel ?

My understanding is, that since videobuf2 is really an improved videobuf, 
the latter shall be deprecated and removed in some time, after all 
existing drivers are converted, so, there is no point in developing new 
drivers with videobuf. That said, the conversion is not very difficult, 
so, please, either do it yourself (preferred;)), or post your driver as is 
and we'll help you convert it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
