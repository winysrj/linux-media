Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:51308 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3GOJmm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jul 2013 05:42:42 -0400
Date: Mon, 15 Jul 2013 11:42:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: phil.edworthy@renesas.com
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v3] ov10635: Add OmniVision ov10635 SoC camera driver
In-Reply-To: <OFD872F119.19A49694-ON80257BA9.003406ED-80257BA9.003467F5@eu.necel.com>
Message-ID: <Pine.LNX.4.64.1307151141190.16726@axis700.grange>
References: <CAGGh5h1btafaMoaB89RBND2L8+Zg767HW3+hKG7Xcq2fsEN6Ew@mail.gmail.com>
 <1370423495-16784-1-git-send-email-phil.edworthy@renesas.com>
 <Pine.LNX.4.64.1307141216310.9479@axis700.grange>
 <OF23E0ECB2.378DD339-ON80257BA9.002CD00C-80257BA9.00321DEB@eu.necel.com>
 <Pine.LNX.4.64.1307151114270.16726@axis700.grange>
 <OFD872F119.19A49694-ON80257BA9.003406ED-80257BA9.003467F5@eu.necel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 15 Jul 2013, phil.edworthy@renesas.com wrote:

> Ok, now I see. My comment about the sensor output size changing is wrong. 
> The sensor doesn't do any scaling, so we are cropping it.

Ah, ok, then you shouldn't change video sizes in your .s_fmt(), just 
return the current cropping rectangle.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
