Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:45729 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0JHHMY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Oct 2010 03:12:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PULL] soc-camera: welcome a new host: OMAP1 and a couple of new sensor drivers
Date: Fri, 8 Oct 2010 09:12:37 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1010080848550.21992@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1010080848550.21992@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010080912.38034.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Friday 08 October 2010 09:00:36 Guennadi Liakhovetski wrote:
> Hi Mauro
> 
> So, as promised, here goes part 2 of 2.6.37 patches for soc-camera and
> related. There's also going to be one issue with this one to take care of:
> the last patch will conflict with Laurent's pad-level ops patches, which
> also move mediabus pixel codes around. But since Laurent's patches are
> still at the RFC stage, AFAICS, they'll have to be extended slightly:)

That's fine with me.

-- 
Regards,

Laurent Pinchart
