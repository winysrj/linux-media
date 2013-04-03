Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward4h.mail.yandex.net ([84.201.186.22]:53095 "EHLO
	forward4h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997Ab3DCD1o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 23:27:44 -0400
From: CrazyCat <crazycat69@yandex.ua>
To: Antti Palosaari <crope@iki.fi>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <514F4375.3060309@iki.fi>
References: <302151362615390@web22d.yandex.ru> <514F4375.3060309@iki.fi>
Subject: Re: [PATCH] cxd2820r_t2: Multistream support (MultiPLP)
MIME-Version: 1.0
Message-Id: <93531364959336@web20h.yandex.ru>
Date: Wed, 03 Apr 2013 06:22:16 +0300
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now confirmed in Russia - work ok.
Used my mods scan-s2 + tzap-t2 + vdr 1.7.27

https://bitbucket.org/CrazyCat/szap-s2
https://bitbucket.org/CrazyCat/scan-s2

24.03.2013, 20:19, "Antti Palosaari" <crope@iki.fi>:
> Is there anyone who could test that patch?
>
> I have no multi PLP signal here.
>
> Also there is minor issue on that patch. As stream ID validy is already
> checked there is no reason for bit AND 0xff.
