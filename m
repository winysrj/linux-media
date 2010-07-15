Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:58021 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932168Ab0GOC4q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jul 2010 22:56:46 -0400
Subject: Re: [PATCH] Add interlace support to sh_mobile_ceu_camera.c
From: hermann pitton <hermann-pitton@arcor.de>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <w3poceafxpn.wl%kuninori.morimoto.gx@renesas.com>
References: <uvdtrmtin.wl%morimoto.kuninori@renesas.com>
	 <Pine.LNX.4.64.1007120900430.7130@axis700.grange>
	 <w3pd3uskwpw.wl%kuninori.morimoto.gx@renesas.com>
	 <Pine.LNX.4.64.1007131622010.26727@axis700.grange>
	 <w3pwrsygbv8.wl%kuninori.morimoto.gx@renesas.com>
	 <1279074933.3203.21.camel@pc07.localdom.local>
	 <w3poceafxpn.wl%kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain
Date: Thu, 15 Jul 2010 04:48:15 +0200
Message-Id: <1279162095.3129.17.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Kuninori,

Am Mittwoch, den 14.07.2010, 14:18 +0900 schrieb Kuninori Morimoto:
> Dear hermann
> 
> > For now, a dip-switch, you must have been abroad somewhere, can't be a
> > criminal. Or?
> > 
> > http://www.dip-switch.com/?gclid=COjg9Mn86aICFYSdzAodNEcLkQ
> > 
> > Could you eventually agree with that about what a dip-switch is or do I
> > miss what you mean?
> > 
> > Do you really tell there are still unclear dip-switches in 2010?
> > 
> > If so, please let's know, but then you can't do anything against such in
> > software, of course.
> 
> I'm so sorry about my stupid English.
> I should not use the words of "criminal".
> 
> I should say
> "The reason that there are no video output on Ecovec
>  might dip-switch setting issue.
>  DS2[3] should be OFF when you use video"
> 
> Best regards
> --
> Kuninori Morimoto
>  

thanks for providing more insight.

I really could not believe that we depend on dip-switch settings on
v4l-dvb. Last I saw such, despite of mobos, was in the mid of the
nineties on some ISA network cards.

Assured for now enough, that such stuff exists, we still have a serious
leak of documentation about hundreds of new devices recently rushed in.

I take this dip-switch just as an example.

Is there any documentation and how can a user know about it?

Without any, "criminal" is fine so far :)

Thanks,
Hermann




