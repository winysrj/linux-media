Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp02.mail.tnz.yahoo.co.jp ([203.216.246.65]:27650 "HELO
	smtp02.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754461AbZJTDtS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 23:49:18 -0400
Message-ID: <4ADD3341.3050202@yahoo.co.jp>
Date: Tue, 20 Oct 2009 12:49:21 +0900
From: Akihiro TSUKADA <tskd2@yahoo.co.jp>
MIME-Version: 1.0
To: Romont Sylvain <psgman24@yahoo.fr>
CC: linux-media@vger.kernel.org
Subject: Re: ISDB-T tuner
References: <340263.68846.qm@web25604.mail.ukl.yahoo.com>
In-Reply-To: <340263.68846.qm@web25604.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> My tuner card is a Pixela PIXDT090-PE0

Hi Romont,

As you might know, all Japanese DTV programs are scrambled with BCAS.
BCAS scrambling algorithm itself is opend in the standard,
but in addition to that, PC devices have to encrypt received data
locally in order to get authorized for BCAS.
So most DTV devices sold in Japan cannot be used in Linux.

Some self-started vendors have sold their devices without BCAS
authentication (thus without local encryption).
They don't/can't include a BCAS PC-card necessary for descrambling,
and users must bring it from elsewhere, which is against the EULA
with the exclusive and private card issuer organization,
or just live with qcif-sized non scrambled 'one seg.' programs in TS.

This is why so few ISDB-T/S devices are supported in Linux.
And Pixela is one of the major vendors with BCAS authentication.
So I'm afraid there is almost no possibility to be supported in Linux.

And just  for you information, in addition to EarthSoft PT1,
there is a driver for 'Friio' ISDB-T USB receiver (which I wrote;) ,
and it is already included in the main repository.
Dibcom is maybe for Brazil and may or may not work in Japan.
(Some of the SKnet HDUS series USB receivers are known to be
 hack-able to avoid local encryption, but of course it's underground.)
----------
  tsukada
--------------------------------------
GyaO! - Anime, Dramas, Movies, and Music videos [FREE]
http://pr.mail.yahoo.co.jp/gyao/
