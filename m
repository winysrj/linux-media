Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51607 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936274AbaH1JH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 05:07:26 -0400
Received: by mail-pa0-f41.google.com with SMTP id lj1so1720468pab.28
        for <linux-media@vger.kernel.org>; Thu, 28 Aug 2014 02:07:24 -0700 (PDT)
Message-ID: <53FEF144.6060106@gmail.com>
Date: Thu, 28 Aug 2014 18:07:16 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH v2 1/5] dvb-core: add a new tuner ops to dvb_frontend
 for APIv5
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-2-git-send-email-tskd08@gmail.com> <53FE1EF5.5060007@iki.fi>
In-Reply-To: <53FE1EF5.5060007@iki.fi>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

moikka,
thanks for the comment.

> I have feeling DVBv5 API is aimed to transfer data via property cached.
> I haven't done much driver for DVBv5 statistics, but recently I
> implemented CNR (DVBv5 stats) to Si2168 driver and it just writes all
> the values directly to property cache. I expect RF strength (RSSI) is
> just similar.

Currently, the demod of PT3 card (tc90522) gets RSSI data from
the connected tuner (mxl301rf) via tuner_ops.get_signal_strength_dbm()
and sets property cache in fe->ops.get_frontend() (which is called
before returning property cache value by dvb_frontend_ioctl_properties()). 
If the tuner driver should set property cache directly,
when is the right timing to do so?
In fe->ops.tuner_ops.get_status() ?
or in the old fe->ops.tuner_ops.get_signal_strength()?
or Should I change get_signal_strength_dbm(fe, s64 *) to
update_signal_strength(fe) and let the tuner driver set property cache there?

--
akihiro


