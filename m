Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:59908 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaKZRQN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 12:16:13 -0500
Received: by mail-lb0-f172.google.com with SMTP id u10so2819478lbd.31
        for <linux-media@vger.kernel.org>; Wed, 26 Nov 2014 09:16:12 -0800 (PST)
Date: Wed, 26 Nov 2014 19:16:10 +0200 (EET)
From: Olli Salonen <olli.salonen@iki.fi>
To: Nibble Max <nibble.max@gmail.com>
cc: Olli Salonen <olli.salonen@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH 3/3] dvb-usb-dvbsky: add TechnoTrend CT2-4400 and CT2-4650
 devices support
In-Reply-To: <201411262035251093366@gmail.com>
Message-ID: <alpine.DEB.2.10.1411261913190.1900@dl160.lan>
References: <201411262035251093366@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 26 Nov 2014, Nibble Max wrote:

> Signed-off-by: Nibble Max <nibble.max@gmail.com>
> ---
> drivers/media/usb/dvb-usb-v2/dvbsky.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c

Hi Max,

I tested your patch with Technotrend CT2-4400v2 and CT2-4650 CI. Seems to 
work ok and the code looks ok for me as well.

Reviewed-by: Olli Salonen <olli.salonen@iki.fi>
Tested-by: Olli Salonen <olli.salonen@iki.fi>

Cheers,
-olli

