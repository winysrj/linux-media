Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:61312 "EHLO
	relmlor2.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab1JSH4n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Oct 2011 03:56:43 -0400
Received: from relmlir3.idc.renesas.com ([10.200.68.153])
 by relmlor2.idc.renesas.com ( SJSMS)
 with ESMTP id <0LTA00ERXZEI0K00@relmlor2.idc.renesas.com> for
 linux-media@vger.kernel.org; Wed, 19 Oct 2011 16:56:42 +0900 (JST)
Received: from relmlac3.idc.renesas.com ([10.200.69.23])
 by relmlir3.idc.renesas.com ( SJSMS)
 with ESMTP id <0LTA0087SZEI7J10@relmlir3.idc.renesas.com> for
 linux-media@vger.kernel.org; Wed, 19 Oct 2011 16:56:42 +0900 (JST)
In-reply-to: <877h41vm7e.wl%kuninori.morimoto.gx@renesas.com>
References: <uock8ky42.wl%morimoto.kuninori@renesas.com>
 <4E76149D.5050102@redhat.com>
 <Pine.LNX.4.64.1109181808410.9975@axis700.grange>
 <87aaa0njj0.wl%kuninori.morimoto.gx@renesas.com>
 <Pine.LNX.4.64.1109200931210.11274@axis700.grange>
 <Pine.LNX.4.64.1109301116130.1888@axis700.grange>
 <87vcrtl9d7.wl%kuninori.morimoto.gx@renesas.com>
 <Pine.LNX.4.64.1110181834570.7139@axis700.grange>
 <877h41vm7e.wl%kuninori.morimoto.gx@renesas.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux-V4L2 <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-version: 1.0
Subject: Re: [PATCH 2/3] soc-camera: mt9t112: modify delay time after initialize
From: phil.edworthy@renesas.com
Message-id: <OF41B9F5B0.6696789C-ON8025792E.002B011F-8025792E.002B7CF1@eu.necel.com>
Date: Wed, 19 Oct 2011 08:56:31 +0100
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi, Morimoto-san,

> > > Both are needed.
> > > These are bug fix patches
> > 
> > I tried to capture several frames beginning with the very first one 
(as 
> > much as performance allowed), and I do see several black or wrongly 
> > coloured framed in the beginning, but none of those patches, including 
the 
> > proposed 300ms at the end of .s_stream() fixes the problem reliably. 
So, 
> > either this problems, that these patches fix, are specific to the 
Solution 
> > Engine board (is it the one, where the problems have been observed?), 
or 
> > one needs a different testing method. If they are SE-specific - I 
don't 
> > think, getting those fixes in the driver is very important, because 
> > mt9t112 data for SE is not in the mainline. If I was testing wrongly, 
> > please, tell me how exactly to reproduce those problems and see, how 
one 
> > or another patch fixes them.
> 
> I guess mt9t112 camera is used in SE (with local circuit ?)
> and Ecovec.
> But I forgot detail of this issue (I have no mt9t112 for now).
> 
> I think Phil is the person who wanted this patch.

There are capture issues on the Ecovec board with this camera. iirc, these 
patches made the situation better but still didn't completely fix all 
issues. Morimoto-san has made comments previously that the mt9t112 is a 
little difficult to setup and we don't have the relevant information from 
the manufacturer.

Thanks
Phil

