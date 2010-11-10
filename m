Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:38559 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874Ab0KJOpF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 09:45:05 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1PGBv6-0006Ml-Lo
	for linux-media@vger.kernel.org; Wed, 10 Nov 2010 15:45:04 +0100
Received: from 93-172-48-16.bb.netvision.net.il ([93.172.48.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 10 Nov 2010 15:45:04 +0100
Received: from baruch by 93-172-48-16.bb.netvision.net.il with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 10 Nov 2010 15:45:04 +0100
To: linux-media@vger.kernel.org
From: Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH] =?utf-8?b?bXgyX2NhbWVyYTo=?= fix pixel clock polarity configuration
Date: Wed, 10 Nov 2010 14:37:52 +0000 (UTC)
Message-ID: <loom.20101110T152629-530@post.gmane.org>
References: <a54ec7e539912fd6009803cffa331b028fdb9a67.1288162873.git.baruch@tkos.co.il> <Pine.LNX.4.64.1010272336290.13615@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Guennadi Liakhovetski <g.liakhovetski <at> gmx.de> writes:

> On Wed, 27 Oct 2010, Baruch Siach wrote:
> > When SOCAM_PCLK_SAMPLE_FALLING, just leave CSICR1_REDGE unset, 
> > otherwise we get
> > the inverted behaviour.
> Seems logical to me, that if this is true, then you need the inverse:
> 
> 	if (!(common_flags & SOCAM_PCLK_SAMPLE_FALLING))
> 		csicr1 |= CSICR1_INV_PCLK;

No. Doing so you'll get the inverted behaviour of SAMPLE_RISING. When
common_flags have SAMPLE_RISING set and SAMPLE_FALLING unset you get
CSICR1_REDGE set, which triggers on the rising edge, and then also
CSICR1_INV_PCLK set, which invert this. Thus you get the expected 
behaviour of SAMPLE_FALLING.

Currently you get the inverted behaviour only for SAMPLE_FALLING.

IMO, we should just use CSICR1_REDGE to set the sample timing, and leave
CSICR1_INV_PCLK alone.

baruch

> >  	if (common_flags & SOCAM_PCLK_SAMPLE_RISING)
> >  		csicr1 |= CSICR1_REDGE;
> > -	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
> > -		csicr1 |= CSICR1_INV_PCLK;
> >  	if (common_flags & SOCAM_VSYNC_ACTIVE_HIGH)
> >  		csicr1 |= CSICR1_SOF_POL;
> >  	if (common_flags & SOCAM_HSYNC_ACTIVE_HIGH)


