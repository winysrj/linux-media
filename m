Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.swsoft.eu ([109.70.220.8]:45227 "EHLO relay.swsoft.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab3KDMt0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Nov 2013 07:49:26 -0500
Date: Mon, 4 Nov 2013 13:49:24 +0100
From: Maik Broemme <mbroemme@parallels.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/12] tda18212dd: Support for NXP TDA18212 (DD) silicon
 tuner
Message-ID: <20131104124924.GM10912@parallels.com>
References: <20131103002235.GD7956@parallels.com>
 <20131103003104.GH7956@parallels.com>
 <20131103075605.74afce3c@samsung.com>
 <52768126.603@iki.fi>
 <20131104101234.04a180d6@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131104101234.04a180d6@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:
> Em Sun, 03 Nov 2013 19:00:22 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
> 
> > On 03.11.2013 11:56, Mauro Carvalho Chehab wrote:
> > > Hi Maik,
> > >
> > > Em Sun, 3 Nov 2013 01:31:04 +0100
> > > Maik Broemme <mbroemme@parallels.com> escreveu:
> > >
> > >> Added support for the NXP TDA18212 silicon tuner used by recent
> > >> Digital Devices hardware. This will allow update of ddbridge driver
> > >> to support newer devices.
> > >>
> > >> Signed-off-by: Maik Broemme <mbroemme@parallels.com>
> > >> ---
> > >>   drivers/media/dvb-frontends/Kconfig      |   9 +
> > >>   drivers/media/dvb-frontends/Makefile     |   1 +
> > >>   drivers/media/dvb-frontends/tda18212dd.c | 934 +++++++++++++++++++++++++++++++
> > >>   drivers/media/dvb-frontends/tda18212dd.h |  37 ++
> > >
> > > I'm not sure if support for this tuner is not provided already by one of
> > > the existing drivers. If not, it is ok to submit a driver for it, but you
> > > should just call it as tda18212.
> > >
> > > I'm c/c Antti, as he worked on some NXP drivers recently, and may be aware
> > > if a driver already supports TDA18212.
> > 
> > Existing tda18212 driver I made is reverse-engineered and it is used 
> > only for Anysee devices, which I am also responsible. That new tuner 
> > driver is much more complete than what I have made and single driver is 
> > naturally the correct approach.
> > 
> > But one thing which annoys nowadays is that endless talking of 
> > regressions, which has led to situation it is very hard to make changes 
> > drivers that are used for multiple devices and you don't have all those 
> > devices to test. It is also OK to remove my old driver and use that, but 
> > then I likely lose my possibility to make changes, as I am much 
> > dependent on new driver maintainer. That is one existing problem which 
> > is seen multiple times during recent years... So I am perfectly happy 
> > with two drivers too.
> 
> I really prefer to have just one driver for each hardware component. That
> makes life easier at long term. Of course, the driver needs to be properly
> maintained.
> 

I agree. Antti do you know which Anysee device you've used for reverse
engineering?

> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Maik
