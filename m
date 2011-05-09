Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.126.187]:56028 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab1EIJJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2011 05:09:08 -0400
Date: Mon, 9 May 2011 11:09:05 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Jiang, Scott" <Scott.Jiang@analog.com>
cc: "uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: why is there no enum_input in v4l2_subdev_video_ops
In-Reply-To: <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CDE0C@NWD2CMBX1.ad.analog.com>
Message-ID: <Pine.LNX.4.64.1105091102320.21938@axis700.grange>
References: <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CDE0C@NWD2CMBX1.ad.analog.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Scott

On Mon, 9 May 2011, Jiang, Scott wrote:

> Hi Guennadi,
> 
> Why is there no enum_input operation in v4l2_subdev_video_ops?

Maybe because noone needed it until now?

> I found some drivers put this info in board specific data, but in my 
> opinion this info is sensor or decoder related.

Can you tell which drivers / boards you're referring to?

> So it should be put into the sensor drivers.

Maybe. Also notice, I'm not a maintainer nor a principal v4l2-subdev 
developer. I've added Hans and Laurent to Cc:, will see what they say, or 
you can just point out which drivers / platforms are doing this wrong and 
propose a fix.

> Please give me some advice.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
