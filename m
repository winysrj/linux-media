Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:38972 "EHLO
	relmlor2.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3G2H7X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 03:59:23 -0400
Received: from relmlir4.idc.renesas.com ([10.200.68.154])
 by relmlor2.idc.renesas.com ( SJSMS)
 with ESMTP id <0MQO007EYU6XWL90@relmlor2.idc.renesas.com> for
 linux-media@vger.kernel.org; Mon, 29 Jul 2013 16:59:21 +0900 (JST)
Received: from relmlac1.idc.renesas.com ([10.200.69.21])
 by relmlir4.idc.renesas.com ( SJSMS)
 with ESMTP id <0MQO003OHU6X0AG0@relmlir4.idc.renesas.com> for
 linux-media@vger.kernel.org; Mon, 29 Jul 2013 16:59:21 +0900 (JST)
In-reply-to: <Pine.LNX.4.64.1307151141190.16726@axis700.grange>
References: <CAGGh5h1btafaMoaB89RBND2L8+Zg767HW3+hKG7Xcq2fsEN6Ew@mail.gmail.com>
 <1370423495-16784-1-git-send-email-phil.edworthy@renesas.com>
 <Pine.LNX.4.64.1307141216310.9479@axis700.grange>
 <OF23E0ECB2.378DD339-ON80257BA9.002CD00C-80257BA9.00321DEB@eu.necel.com>
 <Pine.LNX.4.64.1307151114270.16726@axis700.grange>
 <OFD872F119.19A49694-ON80257BA9.003406ED-80257BA9.003467F5@eu.necel.com>
 <Pine.LNX.4.64.1307151141190.16726@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-version: 1.0
From: phil.edworthy@renesas.com
Message-id: <OF0AFD1E8A.88D1196C-ON80257BB7.002B713E-80257BB7.002BDDA1@eu.necel.com>
Date: Mon, 29 Jul 2013 08:59:04 +0100
Subject: Re: [PATCH v3] ov10635: Add OmniVision ov10635 SoC camera driver
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

> > Ok, now I see. My comment about the sensor output size changing is 
wrong. 
> > The sensor doesn't do any scaling, so we are cropping it.
> 
> Ah, ok, then you shouldn't change video sizes in your .s_fmt(), just 
> return the current cropping rectangle.

I'm reworking the code but realised that the sensor _does_ do both scaling 
and cropping. Though scaling is only possible by dropping every other scan 
line when required height is <= 400 pixels. So does that mean .s_fmt() 
should select the appropriate mode?

Thanks
Phil
