Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm7.bullet.mail.ird.yahoo.com ([77.238.189.21]:27758 "HELO
	nm7.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757899Ab2DFUTY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Apr 2012 16:19:24 -0400
References: <1333401917-27203-1-git-send-email-gennarone@gmail.com>
Message-ID: <1333743562.817.YahooMailNeo@web171404.mail.ir2.yahoo.com>
Date: Fri, 6 Apr 2012 21:19:22 +0100 (BST)
From: Sril <willy_the_cat@yahoo.com>
Reply-To: Sril <willy_the_cat@yahoo.com>
Subject: Re : [PATCH 0/5] af9035: support for tda18218 tuner, new USB IDs and more
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <1333401917-27203-1-git-send-email-gennarone@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hi,

Card : A835 from AverTV Media Green HD.


> My A867 and A835 sticks works pretty well with this new driver.
> The driver is fast and responsive and there is no problem tuning all the
> channels available in my area: a full scan finds all of them.

Confirmed : build on the top of 3.3.1 with all recently patch applied,
I found nearly 29 patches from last past few days to cover af9035 from linuxtv.org media_build tree,
and 4 more at begining to satisfy (more or less) drivers/media/dvb/dvb-usb/Kconfig,

only end cflags file done by hand in drivers/media/dvb/dvb-usb/Makefile.
And that is _not_ the first time I particularily see this : anyway.

!!!!! To all people woked on that driver : Thanks you !!!!!

> After a quick test I couldn't find any difference between the 3 firmwares.
I only test dvb-usb-af9035-02.fw so ... sorry.


Best regards.
See ya.



> ----- Mail original -----
> De : Gianluca Gennari <gennarone@gmail.com>
> À : linux-media@vger.kernel.org; crope@iki.fi
> Cc : m@bues.ch; hfvogt@gmx.net; mchehab@redhat.com; Gianluca Gennari <gennarone@gmail.com>
> Envoyé le : Lundi 2 avril 2012 23h25
> Objet : [PATCH 0/5] af9035: support for tda18218 tuner, new USB IDs and more

> Hi all,
> this is a series of small patches for the new af9035 driver.
> It adds basic support for the tda18218 tuner (and the related devices of the
> Avermedia A835 serie), including a small patch to tune VHF channels.
> Also, there is new USB ID for the 07ca:a867 device (Avermedia A867).
> Finally, there are a couple of clean-ups.

> My A867 and A835 sticks works pretty well with this new driver.
> The driver is fast and responsive and there is no problem tuning all the
> channels available in my area: a full scan finds all of them.

> The only minor issue is that the signal strength is stuck to 100% with all
> channels, with both sticks and with all the 3 firmwares.
> SNR works properly.

> After a quick test I couldn't find any difference between the 3 firmwares.
> Anyway, the A867 seems a bit faster than the A835, and also it locked a very
> weak mux that previously I was able to lock only with the PCTV 290e.

> Best regards,
> Gianluca Gennari
[...]
>

