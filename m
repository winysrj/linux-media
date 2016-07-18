Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:36608 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844AbcGRMTN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 08:19:13 -0400
Message-ID: <1468844346.2994.16.camel@pengutronix.de>
Subject: Re: [PATCH] [media] dw2102: Add support for Terratec Cinergy S2 USB
 BOX
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Olli Salonen <olli.salonen@iki.fi>,
	Benjamin Larsson <benjamin@southpole.se>,
	linux-media <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>,
	Christian Zippel <namerp@gmail.com>
Date: Mon, 18 Jul 2016 14:19:06 +0200
In-Reply-To: <20160718085911.7bbbd38c@recife.lan>
References: <1451935971-31402-1-git-send-email-p.zabel@pengutronix.de>
	 <CAAZRmGz5vS8vMBEQeMo6BS0XijoCj655jha5vCsiy2P8TcgSoQ@mail.gmail.com>
	 <20160716134707.6cf426ea@recife.lan>
	 <CAAZRmGyo7wRjENT_o8ezdjrBb2xU-zxmRKWakC6H4zVNm+YDeA@mail.gmail.com>
	 <20160718085911.7bbbd38c@recife.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 18.07.2016, 08:59 -0300 schrieb Mauro Carvalho Chehab:
> Em Mon, 18 Jul 2016 07:49:49 +0200
> Olli Salonen <olli.salonen@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > I have a feeling that this device equals DVBSky S960 (driver
> > dvb-usb-dvbsky) which might be equal to TechnoTrend S2-4600 (driver
> > dvb-usb-dw2102).
> > 
> > If so, I think it would be good to move all devices to the dvbsky driver as
> > that's dvb-usb-v2 unlike the dw2102 driver. I've got the S2-4600 myself, so
> > I can take a look at that later on when not travelling.
> 
> If the driver is identical, then yeah, the best is to move everything
> to the one based on dvb-usb-v2. I would really love to get rid of the
> old dvb-usb driver, but, unfortunately, I don't have all devices.
> 
> I may try to port dib0700 some day, as this is likely the most complex
> one, and may require some adjustments at dvb-usb-v2 that only the
> dibcom drivers are currently using.
> 
> With regards to Terratec Cinergy S2 USB BOX, let's remove it from one
> of the drivers. Could someone send me a patch doing that? It would be
> nice if both Philipp and Benjamin test such patch, for us to be sure
> that it would work for both.

I'll test dvbsky next time I have access to the device.

regards
Philipp

