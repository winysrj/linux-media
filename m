Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:44554 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287Ab0JDPg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Oct 2010 11:36:26 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3] SoC Camera: add driver for OMAP1 camera interface
Date: Mon, 4 Oct 2010 17:35:44 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201009301335.51643.jkrzyszt@tis.icnet.pl> <201010021445.14567.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1010030439550.15920@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1010030439550.15920@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201010041735.46371.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sunday 03 October 2010 04:42:53 Guennadi Liakhovetski napisał(a):
> On Sat, 2 Oct 2010, Janusz Krzysztofik wrote:
> > Saturday 02 October 2010 08:07:28 Guennadi Liakhovetski napisał(a):
> > > Same with this one - let's take it as is and address a couple of
> > > clean-ups later.
> >
> > Guennadi,
> > Thanks for taking them both.
> >
> > BTW, what are your intentions about the last patch from my series still
> > left not commented, "SoC Camera: add support for g_parm / s_parm
> > operations", http://www.spinics.net/lists/linux-media/msg22887.html ?
>
> Yes, taking that one too, thanks. I see it right, that I have to apply 3
> of your patches: omap1 camera driver, ov6650 and default .[gs]_fmt for
> soc_camera, the rest will go via the OMAP / ARM tree, right?

Right.
Janusz
