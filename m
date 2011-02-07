Return-path: <mchehab@pedra>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34536 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752145Ab1BGN2X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Feb 2011 08:28:23 -0500
Date: Mon, 7 Feb 2011 13:28:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: ext Mauro Carvalho Chehab <mchehab@redhat.com>,
	alsa-devel@alsa-project.org, lrg@slimlogic.co.uk,
	hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
Subject: Re: WL1273 FM Radio driver...
Message-ID: <20110207132821.GI10564@opensource.wolfsonmicro.com>
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>
 <4D4FDED0.7070008@redhat.com>
 <20110207120234.GE10564@opensource.wolfsonmicro.com>
 <4D4FEA03.7090109@redhat.com>
 <1297085233.15320.39.camel@masi.mnp.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297085233.15320.39.camel@masi.mnp.nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Feb 07, 2011 at 03:27:12PM +0200, Matti J. Aaltonen wrote:

> So you are suggesting a more or less complete rewrite, so that I'd
> create a directory like media/radio/wl1273 and then place there all of
> the driver files: wl1273-radio.c, wl1273-alsa.c and maybe wl1273-core.c?

Don't move the ASoC driver out of the ASoC code, it's a complete pain
for maintaining it and only makes the problems with having to build v4l
worse.
