Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:49222 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755557Ab0GNCl6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jul 2010 22:41:58 -0400
Subject: Re: [PATCH] Add interlace support to sh_mobile_ceu_camera.c
From: hermann pitton <hermann-pitton@arcor.de>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <w3pwrsygbv8.wl%kuninori.morimoto.gx@renesas.com>
References: <uvdtrmtin.wl%morimoto.kuninori@renesas.com>
	 <Pine.LNX.4.64.1007120900430.7130@axis700.grange>
	 <w3pd3uskwpw.wl%kuninori.morimoto.gx@renesas.com>
	 <Pine.LNX.4.64.1007131622010.26727@axis700.grange>
	 <w3pwrsygbv8.wl%kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain
Date: Wed, 14 Jul 2010 04:35:33 +0200
Message-Id: <1279074933.3203.21.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Mittwoch, den 14.07.2010, 09:12 +0900 schrieb Kuninori Morimoto:
> Dear Guennadi
> 
> 
> > our luck, that mplayer (and gstreamer?) ignore returned field value. But 
> > we'll have to fix this in sh_mobile_ceu_camera.
> 
> Hmm  I understand.
> I guess, at first, we need test program for it.
> 
> 
> > Well, I think, 720p is a little too optimistic for tw9910;) tw9910 works 
> > on migor for me, but not on ecovec, although the chip can be detected. Are 
> > there any modifications necessary to the kernel or to the board to get it 
> > to work? Maybe a jumper or something? I plug in a video signal source in 
> > the "video in" connector, next to the "viceo out" one, using the same 
> > cable, so, cabling should work too. But I'm only getting select timeouts 
> > and no interrupts on the CEU.
> 
> Hmm..  strange...
> No kernel patch is needed to use tw9910 on Ecovec.
> 
> Ahh...
> Maybe the criminal is dip-switch.
> We can not use "tw9910" and "2nd camera" in same time.
> 
> Please check DS2[3] on Ecovec.
> It should OFF when you use tw9910.
> 
> I wrote dip-switch info on top of
> ${LINUX}/arch/sh/boards/mach-ecovec24/setup.c
> Please check it too.
> 
> Best regards
> --
> Kuninori Morimoto
>  


Kuninori,

you are well treated and highly honored by all staying in development
with you. For me it is just some glitch on the edges, but very well
noted.

For now, a dip-switch, you must have been abroad somewhere, can't be a
criminal. Or?

http://www.dip-switch.com/?gclid=COjg9Mn86aICFYSdzAodNEcLkQ

Could you eventually agree with that about what a dip-switch is or do I
miss what you mean?

Do you really tell there are still unclear dip-switches in 2010?

If so, please let's know, but then you can't do anything against such in
software, of course.

Cheers,
Hermann






