Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:45915 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933284Ab1CWVK7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 17:10:59 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3] SoC Camera: add driver for OMAP1 camera interface
Date: Wed, 23 Mar 2011 17:13:34 +0100
Cc: linux-media@vger.kernel.org,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201009301335.51643.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1103231056360.6836@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1103231056360.6836@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103231713.50667.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, 23 March 2011, at 11:00:06, Guennadi Liakhovetski wrote:
> Hi Janusz
> 
> You might want to retest ams-delta with the camera on the current
> (next or
> 
> git://linuxtv.org/media_tree.git staging/for_v2.6.39
> 
> ) kernel - I suspect, you'll need something similar to
> 
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructu
> re/30728

Hi Guennadi,
Thanks for bringing this issue to my attention. However, we alread have 
something like 

		.dev		= {
			...
			.coherent_dma_mask      = DMA_BIT_MASK(32),
		},

defined inside the platform_device structure registered for our OMAP1 
camera device, so shouldn't be affected.

Anyway, I have the camera driver review/upgrade task already sitting in 
my todo list for a few weeks, and hope to find some spare time to deal 
with it soon, so will verify that as well.

Thanks,
Janusz
