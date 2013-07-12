Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:43017 "EHLO
	relmlor2.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab3GLIPR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jul 2013 04:15:17 -0400
Received: from relmlir4.idc.renesas.com ([10.200.68.154])
 by relmlor2.idc.renesas.com ( SJSMS)
 with ESMTP id <0MPT00C2SDLFCA20@relmlor2.idc.renesas.com> for
 linux-media@vger.kernel.org; Fri, 12 Jul 2013 17:15:15 +0900 (JST)
Received: from relmlac1.idc.renesas.com ([10.200.69.21])
 by relmlir4.idc.renesas.com ( SJSMS)
 with ESMTP id <0MPT00AP0DLEX3H0@relmlir4.idc.renesas.com> for
 linux-media@vger.kernel.org; Fri, 12 Jul 2013 17:15:15 +0900 (JST)
In-reply-to: <Pine.LNX.4.64.1306060954020.32566@axis700.grange>
References: <201306031547.52124.hverkuil@xs4all.nl>
 <1370276302-7295-1-git-send-email-phil.edworthy@renesas.com>
 <CAGGh5h1btafaMoaB89RBND2L8+Zg767HW3+hKG7Xcq2fsEN6Ew@mail.gmail.com>
 <Pine.LNX.4.64.1306051120160.19739@axis700.grange>
 <CAGGh5h21HYbfDUbB0_etu1Zb4EWqftRd0GW2bJHKbZzXEFn67A@mail.gmail.com>
 <Pine.LNX.4.64.1306060954020.32566@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	jean-philippe francois <jp.francois@cynove.com>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-version: 1.0
From: phil.edworthy@renesas.com
Message-id: <OF4003F7C5.B19CA5D0-ON80257BA6.002A393C-80257BA6.002D53C4@eu.necel.com>
Date: Fri, 12 Jul 2013 09:15:04 +0100
Subject: Re: [PATCH v2] ov10635: Add OmniVision ov10635 SoC camera driver
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

<snip>
> Well, I think, both of you will agree, that these register value lists 
> look horrible and actually have little to do with open-source software, 
> but I don't know what to do about them either. We could just reject them 

> and only accept drivers, properly describing what they do with the 
> hardware, or request to move this into one of firmware loading 
options... 
> But I'm not sure any of these options would actually do us any good. 
Just 
> sayin'.
Any further thoughts on what to do about this driver?

Based on what I have seen, we aren't going to get the info to properly 
describe _all_ of the registers. It's a shame the camera's registers don't 
default to usable settings, but that's what we have.

In the case of this driver, there are a number of registers that are 
programmed based on the required resolution, framerate and format. 
Extracting that from the material I had was rather painful and the result 
is useful for anyone wanting to use this camera. Any register written to 
outside ov10635_regs_default[] should be programmed in some meaningful 
way, whereas those in ov10635_regs_default[] should be treated like 
firmware. However, even those registers accessed outside of 
ov10635_regs_default[] could still do with better descriptions. I should 
note that some of the values written to registers are empirically derived 
since they are based on device timing. I don't have any details about the 
device timing, just the values that were written for a number of different 
modes (resolution and framerate).

Maybe the pragmatic approach is to use firmware for all those in 
ov10635_regs_default[], and the rest of the registers have to be well 
documented. I was asked to remove some comments about register 
names/functionality by OmniVision, but I can ask again if it helps.

Thanks
Phil
