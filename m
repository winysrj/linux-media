Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:39016 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab3KCAUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 20:20:02 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVN00CNPVLCVK80@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 02 Nov 2013 20:20:00 -0400 (EDT)
Date: Sat, 02 Nov 2013 22:19:56 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: CrazyCat <crazycat69@narod.ru>, linux-media@vger.kernel.org
Subject: Re: [PATCH] tda18271-fe: Fix dvb-c standard selection
Message-id: <20131102221956.1e241d02@samsung.com>
In-reply-to: <52756F4E.3030805@narod.ru>
References: <5275690A.3080108@narod.ru> <20131102192112.1bc7bbc0@samsung.com>
 <52756F4E.3030805@narod.ru>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 02 Nov 2013 23:31:58 +0200
CrazyCat <crazycat69@narod.ru> escreveu:

> Mauro Carvalho Chehab пишет:
> > This is wrong, as it breaks for 6MHz-spaced channels, like what's used
> > in Brazil and Japan.
> >
> > What happens here is that, if the tuner uses a too wide lowpass filter,
> > the interference will be higher at the demod, and it may not be able
> > to decode.
> >
> > As the bandwidth is already estimated by the DVB frontend core, the
> > tuners should be adjusted to get the closest filter for a given
> > bandwidth.
> >
> > So, the driver is correct (and it is tested under 6MHz spaced channels).
> 
> But usual applications only set cable standard (Annex A/C or B) and not set bandwidth. So for annex A/C default selected 6MHz ?

Usual applications set the symbol rate, and symbol rate is easily
converted into bandwidth. The DVB core does that. see 
dtv_set_frontend():

	switch (c->delivery_system) {
	case SYS_ATSC:
	case SYS_DVBC_ANNEX_B:
		c->bandwidth_hz = 6000000;
		break;
	case SYS_DVBC_ANNEX_A:
		rolloff = 115;
		break;
	case SYS_DVBC_ANNEX_C:
		rolloff = 113;
		break;
	default:
		break;
	}
	if (rolloff)
		c->bandwidth_hz = (c->symbol_rate * rolloff) / 100;

-- 

Cheers,
Mauro
