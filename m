Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37376 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaIXNci (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 09:32:38 -0400
Date: Wed, 24 Sep 2014 10:32:33 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v4 3/4] tc90522: add driver for Toshiba TC90522 quad
 demodulator
Message-ID: <20140924103233.2efc00ed@recife.lan>
In-Reply-To: <5422B3D3.80209@gmail.com>
References: <1410196843-26168-1-git-send-email-tskd08@gmail.com>
	<1410196843-26168-4-git-send-email-tskd08@gmail.com>
	<20140923170730.4d5d167e@recife.lan>
	<542233E5.5070201@gmail.com>
	<20140924062812.6308f584@recife.lan>
	<5422A779.8030901@gmail.com>
	<20140924083030.3fdcfe3e@recife.lan>
	<5422B3D3.80209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 24 Sep 2014 21:06:43 +0900
Akihiro TSUKADA <tskd08@gmail.com> escreveu:

> > And TMCC returns it as 0, 1, 2, 3, 4, instead of 0, 1, 2, 4, 8.
> 
> According to ARIB STD B31 3.15.6.7 (table 3.30),
> The value is encoded and depends on the "mode".
> so demods have to encode/decode anyway.

Ok, but see the definition at the API spec:

	http://linuxtv.org/downloads/v4l-dvb-apis/FE_GET_SET_PROPERTY.html#isdb-hierq-layers

Basically, we use 0, 1, 2, 4 no matter what mode, e. g.

DTV_ISDBT_LAYERA_TIME_INTERLEAVING	1

means:
	Interleave = 4 for mode 1
	Interleave = 2 for mode 2
	Interleave = 1 for mode 3

> > AFAIKT, that doesn't work in Sound Broadcast mode, as the demod won't
> > be able to read the TMCC (at least on most demods - don't have any
> > details about tc90522).
> 
> I forgat ISDB-Tsb;P, as in Japan terrestrial digital sound broadcast
> was cancelled in 2011 and it was unpopular.

Ah, I wasn't aware that ISDB-Tsb was cancelled in Japan.

Regards,
Mauro
