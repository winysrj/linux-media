Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:55760 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752333AbZEJOQ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 May 2009 10:16:29 -0400
To: Anders Eriksson <aeriksson@fastmail.fm>
cc: hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>
Subject: Re: saa7134/2.6.26 regression, noisy output
In-reply-to: <20090507130055.E49D32C4165@tippex.mynet.homeunix.org>
References: <20090503075609.0A73B2C4152@tippex.mynet.homeunix.org> <1241389925.4912.32.camel@pc07.localdom.local> <20090504091049.D931B2C4147@tippex.mynet.homeunix.org> <1241438755.3759.100.camel@pc07.localdom.local> <20090504195201.6ECF52C415B@tippex.mynet.homeunix.org> <1241565988.16938.15.camel@pc07.localdom.local> <20090507130055.E49D32C4165@tippex.mynet.homeunix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 10 May 2009 16:16:14 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20090510141614.D4A9C2C416C@tippex.mynet.homeunix.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


An update:

>hermann-pitton@arcor.de said:
>> hmm, the idea eventually was, to download these two snapshots, or make the
>> last few changes manually on the first and try on 2.6.25.
>>
>> Then we might know, if the problem is already visible within Hartmut's latest
>> fix attempts or even more and other stuff is involved. 

I wrote:
>I see. I'll dig myself into hand applying those patches. It seems quite some 
>stuff changed between 2.6.25 and what those patches assumes. Let's see what I
>dig up.


Dragging the following patch along,
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index 6fde042..938bdf5 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5249,7 +5249,7 @@ static int saa7134_tda8290_callback(struct saa7134_dev *dev,
 int saa7134_tuner_callback(void *priv, int command, int arg)
 {
        struct i2c_algo_bit_data *i2c_algo = priv;
-       struct saa7134_dev *dev = i2c_algo->data;
+       struct saa7134_dev *dev = priv;
 
        switch (dev->tuner_type) {
        case TUNER_PHILIPS_TDA8290:

.. I could actually bisect my way to the offending commit. And of course, it's 
the one you suspected: git 7bff4b4d3ad2b9ff42b4087f409076035af1d165.


I'm right now applying that commit piece by piece, to isolate the offending
change (Some changes are just rearrangements, others may change the way hw is
touched). I'll keep you posted.

-Anders




