Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:54307 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3KDMMk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 07:12:40 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVQ00F96N93AF40@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 04 Nov 2013 07:12:39 -0500 (EST)
Date: Mon, 04 Nov 2013 10:12:34 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Maik Broemme <mbroemme@parallels.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/12] tda18212dd: Support for NXP TDA18212 (DD) silicon
 tuner
Message-id: <20131104101234.04a180d6@samsung.com>
In-reply-to: <52768126.603@iki.fi>
References: <20131103002235.GD7956@parallels.com>
 <20131103003104.GH7956@parallels.com> <20131103075605.74afce3c@samsung.com>
 <52768126.603@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 03 Nov 2013 19:00:22 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 03.11.2013 11:56, Mauro Carvalho Chehab wrote:
> > Hi Maik,
> >
> > Em Sun, 3 Nov 2013 01:31:04 +0100
> > Maik Broemme <mbroemme@parallels.com> escreveu:
> >
> >> Added support for the NXP TDA18212 silicon tuner used by recent
> >> Digital Devices hardware. This will allow update of ddbridge driver
> >> to support newer devices.
> >>
> >> Signed-off-by: Maik Broemme <mbroemme@parallels.com>
> >> ---
> >>   drivers/media/dvb-frontends/Kconfig      |   9 +
> >>   drivers/media/dvb-frontends/Makefile     |   1 +
> >>   drivers/media/dvb-frontends/tda18212dd.c | 934 +++++++++++++++++++++++++++++++
> >>   drivers/media/dvb-frontends/tda18212dd.h |  37 ++
> >
> > I'm not sure if support for this tuner is not provided already by one of
> > the existing drivers. If not, it is ok to submit a driver for it, but you
> > should just call it as tda18212.
> >
> > I'm c/c Antti, as he worked on some NXP drivers recently, and may be aware
> > if a driver already supports TDA18212.
> 
> Existing tda18212 driver I made is reverse-engineered and it is used 
> only for Anysee devices, which I am also responsible. That new tuner 
> driver is much more complete than what I have made and single driver is 
> naturally the correct approach.
> 
> But one thing which annoys nowadays is that endless talking of 
> regressions, which has led to situation it is very hard to make changes 
> drivers that are used for multiple devices and you don't have all those 
> devices to test. It is also OK to remove my old driver and use that, but 
> then I likely lose my possibility to make changes, as I am much 
> dependent on new driver maintainer. That is one existing problem which 
> is seen multiple times during recent years... So I am perfectly happy 
> with two drivers too.

I really prefer to have just one driver for each hardware component. That
makes life easier at long term. Of course, the driver needs to be properly
maintained.

Regards,
Mauro
