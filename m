Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40692 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933293AbeCGOCh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 09:02:37 -0500
Date: Wed, 7 Mar 2018 11:02:31 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Antti Palosaari <crope@iki.fi>
Cc: Nigel Kettlewell <nigel.kettlewell@googlemail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix for hanging si2168 in PCTV 292e, making the code
 match
Message-ID: <20180307110231.10f5b6ef@vento.lan>
In-Reply-To: <e169f37e-8ca9-bd28-74c8-b8e7a12beb54@iki.fi>
References: <59C10A00.2070000@googlemail.com>
        <20171214124841.7943b325@vento.lan>
        <e169f37e-8ca9-bd28-74c8-b8e7a12beb54@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 7 Mar 2018 15:23:52 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 12/14/2017 04:48 PM, Mauro Carvalho Chehab wrote:
> > Em Tue, 19 Sep 2017 13:13:52 +0100
> > Nigel Kettlewell <nigel.kettlewell@googlemail.com> escreveu:
> >   
> >> [re-sending as plain text]
> >>
> >> Fix for hanging si2168 in PCTV 292e USB, making the code match the comment.
> >>
> >> Using firmware v4.0.11 the 292e would work once and then hang on
> >> subsequent attempts to view DVB channels, until physically unplugged and
> >> plugged back in.
> >>
> >> With this patch, the warm state is reset for v4.0.11 and it appears to
> >> work both on the first attempt and on subsequent attempts.  
> 
> It is comment which is wrong. With firmware 4.0.11 it works well without 
> need of download it every time. But firmware 4.0.19 needs to be 
> downloaded every time after device is put to sleep.

Ok. Let's then apply the enclosed patch (or something similar to it).

> Probably your issue is coming from some other reason.

I've no idea why Nigel proposed this patch. From my side, all I
want is to update the status of this patch:

	https://patchwork.linuxtv.org/patch/44304/

and keep cleaning up my patch queue ;-)

Thanks,
Mauro

[PATCH] media: si2168: fix a comment about firmware version

There's a comment there at s82168 that it is wrong.

With firmware 4.0.11, sleep/resume works well without
need of download it every time. But firmware 4.0.19
needs to be downloaded again after sleep.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index a91947784842..324493e05f9f 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -614,7 +614,7 @@ static int si2168_sleep(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	/* Firmware B 4.0-11 or later loses warm state during sleep */
+	/* Firmware later than B 4.0-11 loses warm state during sleep */
 	if (dev->version > ('B' << 24 | 4 << 16 | 0 << 8 | 11 << 0))
 		dev->warm = false;
 
