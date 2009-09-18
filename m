Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44869 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758175AbZIRUOB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 16:14:01 -0400
Date: Fri, 18 Sep 2009 17:13:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Akihiro TSUKADA <tskd2@yahoo.co.jp>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] dvb: add driver for 774 Friio White USB ISDB-T receiver
Message-ID: <20090918171324.055006ed@pedra.chehab.org>
In-Reply-To: <4A937927.9050409@yahoo.co.jp>
References: <4A937927.9050409@yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Aug 2009 14:39:51 +0900
Akihiro TSUKADA <tskd2@yahoo.co.jp> escreveu:

> From: Akihiro Tsukada <tskd2@yahoo.co.jp>
> 
> This patch adds driver for 774 Friio White, ISDB-T USB receiver
> 
> Friio White is an USB 2.0 ISDB-T receiver. (http://www.friio.com/)
> The device has a GL861 chip and a Comtech JDVBT90502 canned tuner module.
> This driver ignores all the frontend_parameters except frequency,
> as ISDB-T shares the same parameter configuration across the country
> and thus the device can work like an intelligent one.
> 
> As this device does not include a CAM nor hardware descrambling feature,
> the driver passes through scrambled TS streams.
> 
> There is Friio Black, a variant for ISDB-S, which shares the same USB
> Vendor/Product ID with White, but it is not supported in this driver.
> They should be identified in the initialization sequence,
> but this feature is not tested.
> 

Committed, thanks. It would be good if you could add support for ISDB-T API [1] at the driver.

[1] http://linuxtv.org/downloads/v4l-dvb-apis/ch09s03.html

Cheers,
Mauro
