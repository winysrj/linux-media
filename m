Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:43355 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab1BGNea (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Feb 2011 08:34:30 -0500
Subject: Re: WL1273 FM Radio driver...
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: ext Mauro Carvalho Chehab <mchehab@redhat.com>,
	alsa-devel@alsa-project.org, lrg@slimlogic.co.uk,
	hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
In-Reply-To: <20110207132821.GI10564@opensource.wolfsonmicro.com>
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>
	 <4D4FDED0.7070008@redhat.com>
	 <20110207120234.GE10564@opensource.wolfsonmicro.com>
	 <4D4FEA03.7090109@redhat.com>
	 <1297085233.15320.39.camel@masi.mnp.nokia.com>
	 <20110207132821.GI10564@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 15:34:08 +0200
Message-ID: <1297085648.15320.42.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-02-07 at 13:28 +0000, ext Mark Brown wrote:
> On Mon, Feb 07, 2011 at 03:27:12PM +0200, Matti J. Aaltonen wrote:
> 
> > So you are suggesting a more or less complete rewrite, so that I'd
> > create a directory like media/radio/wl1273 and then place there all of
> > the driver files: wl1273-radio.c, wl1273-alsa.c and maybe wl1273-core.c?
> 
> Don't move the ASoC driver out of the ASoC code, it's a complete pain
> for maintaining it and only makes the problems with having to build v4l
> worse.

I won't do anything before we have some kind of consensus :-)

Cheers,
Matti


