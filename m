Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44783 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaH2KpN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Aug 2014 06:45:13 -0400
Received: by mail-pd0-f170.google.com with SMTP id r10so187574pdi.1
        for <linux-media@vger.kernel.org>; Fri, 29 Aug 2014 03:45:13 -0700 (PDT)
Message-ID: <540059B5.8050100@gmail.com>
Date: Fri, 29 Aug 2014 19:45:09 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	m.chehab@samsung.com
Subject: Re: [PATCH v2 1/5] dvb-core: add a new tuner ops to dvb_frontend
 for APIv5
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-2-git-send-email-tskd08@gmail.com> <53FE1EF5.5060007@iki.fi> <53FEF144.6060106@gmail.com> <53FFD1F0.9050306@iki.fi>
In-Reply-To: <53FFD1F0.9050306@iki.fi>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

moikka,

> Start polling thread, which polls once per 2 sec or so, which reads RSSI
> and writes value to struct dtv_frontend_properties. That it is, in my
> understanding. Same for all those DVBv5 stats. Mauro knows better as he
> designed that functionality.

I understand that RSSI property should be set directly in the tuner driver,
but I'm afraid that creating a kthread just for updating RSSI would be
overkill and complicate matters.

Would you give me an advice? >> Mauro

regards,
akihiro
