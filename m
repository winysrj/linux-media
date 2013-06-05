Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor1.renesas.com ([210.160.252.171]:39358 "EHLO
	relmlor1.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab3FEKwQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jun 2013 06:52:16 -0400
Received: from relmlir4.idc.renesas.com ([10.200.68.154])
 by relmlor1.idc.renesas.com ( SJSMS)
 with ESMTP id <0MNX00EUS2734E80@relmlor1.idc.renesas.com> for
 linux-media@vger.kernel.org; Wed, 05 Jun 2013 19:52:15 +0900 (JST)
Received: from relmlac4.idc.renesas.com ([10.200.69.24])
 by relmlir4.idc.renesas.com ( SJSMS)
 with ESMTP id <0MNX00GT9273E340@relmlir4.idc.renesas.com> for
 linux-media@vger.kernel.org; Wed, 05 Jun 2013 19:52:15 +0900 (JST)
In-reply-to: <Pine.LNX.4.64.1306051120160.19739@axis700.grange>
References: <201306031547.52124.hverkuil@xs4all.nl>
 <1370276302-7295-1-git-send-email-phil.edworthy@renesas.com>
 <CAGGh5h1btafaMoaB89RBND2L8+Zg767HW3+hKG7Xcq2fsEN6Ew@mail.gmail.com>
 <Pine.LNX.4.64.1306051120160.19739@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	jean-philippe francois <jp.francois@cynove.com>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-version: 1.0
From: phil.edworthy@renesas.com
Subject: Re: [PATCH v2] ov10635: Add OmniVision ov10635 SoC camera driver
Message-id: <OFEC07D882.0142D918-ON80257B81.003B6E8B-80257B81.003BA5F4@eu.necel.com>
Date: Wed, 05 Jun 2013 11:51:29 +0100
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

> Thanks for the patch. I'll look at it in more detail hopefully soon 
> enough... One remark so far to Jean-Philippe's comment:
> 
[snip]
> > Register 0x3042 is only touched by the enable part, not by the "change
> > mode" part
> > I think you could move the {0x3042, 0xf0} sequence in the
> > standard_regs array, and keep
> > only the 0x301b, 0x301c, 0x301a registers.
> > 
> > By the way, did you test with a single write ? There is the same
> > sequence in ov5642
> > init, so I believe it is copy pasted in every omnivision init. Is it
> > actually useful ?
> 
> If this is indeed the case and all OV sensor camera drivers use the same 

> initialisation sequence, maybe it's time to consider making one firmware 

> file for them all and loading it in user-space?

After looking at other OV drivers, the sequences are very different. I 
think Jean-Philippe's comment was specific to data files that OV provide 
for their cameras.

Regards
Phil
