Return-path: <linux-media-owner@vger.kernel.org>
Received: from d1.icnet.pl ([212.160.220.21]:45189 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab0GTRjT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jul 2010 13:39:19 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC] [PATCH 0/6] Add camera support to the OMAP1 Amstrad Delta videophone
Date: Tue, 20 Jul 2010 19:38:13 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201007180618.08266.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1007201139320.29807@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1007201139320.29807@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007201938.16054.jkrzyszt@tis.icnet.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tuesday 20 July 2010 11:49:54 Guennadi Liakhovetski wrote:
> Hi Janusz

Hi Guennadi,
Thanks for your answer.

> On Sun, 18 Jul 2010, Janusz Krzysztofik wrote:
> > This series consists of the following patches:
> >
> >   1/6	SoC Camera: add driver for OMAP1 camera interface
> >   2/6	OMAP1: Add support for SoC camera interface
> >   3/6	SoC Camera: add driver for OV6650 sensor
> >   4/6	SoC Camera: add support for g_parm / s_parm operations
> >   5/6	OMAP1: Amstrad Delta: add support for on-board camera
> >   6/6	OMAP1: Amstrad Delta: add camera controlled LEDS trigger
>
> It is an interesting decision to use soc-camera for an OMAP SoC, as you
> most probably know OMAP3 and OMAP2 camera drivers do not use soc-camera. I
> certainly do not want to discourage you from using soc-camera, just don't
> want you to go the wrong way and then regret it or spend time re-designing
> your driver. 

If this way occures wrong, then it's only my fault, since I've taken it 
myself, without consulting it neither on omap nor media list, so I'm not 
going to blame anyone except myself.

> Have you had specific reasons for this design? 

It looked like the most simple way for me. And while implementing it, I 
haven't faced any restrictions that would lead me to changing my mind and 
doing it another way.

> Is OMAP1 so different from 2 (and 3)? 

I think so, but let's see what OMAP guys have to say.

> In any case - thanks for the patches, if you do 
> insist on going this path (;)) I'll review them and get back to you after
> that. Beware, it might be difficult to finish the review process in time
> for 2.6.36...

Since not all patches from the series are OMAP related, and those that are 
not, don't depend on others, I think you could have a look at 4/6 and see if 
it makes sense or not. You could also examine 6/6 and see if you would like 
the idea of a camera LED trigger implemented, this way or another, at the 
soc_camera framework level rather than specific machine or platform. Last, 
the sensor driver (3/6), even if soc_camera specific, could be considered, if 
accepted, for adopting it as a regular v4l2-subdev, if required by a 
different implementation of OMAP part choosen.

Thanks,
Janusz
