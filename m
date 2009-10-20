Return-path: <linux-media-owner@vger.kernel.org>
Received: from web25603.mail.ukl.yahoo.com ([217.12.10.162]:27427 "HELO
	web25603.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751177AbZJTMyw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 08:54:52 -0400
Message-ID: <459385.60767.qm@web25603.mail.ukl.yahoo.com>
References: <340263.68846.qm@web25604.mail.ukl.yahoo.com> <4ADD3341.3050202@yahoo.co.jp>
Date: Tue, 20 Oct 2009 12:54:56 +0000 (GMT)
From: Romont Sylvain <psgman24@yahoo.fr>
Subject: Re : ISDB-T tuner
To: Akihiro TSUKADA <tskd2@yahoo.co.jp>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4ADD3341.3050202@yahoo.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you for the explain!
so, which device can I buy, working in Japan, in linux, and in digital (working after 2011)?
really NOTHING is working??
Thank you very much for your help!




----- Message d'origine ----
De : Akihiro TSUKADA <tskd2@yahoo.co.jp>
À : Romont Sylvain <psgman24@yahoo.fr>
Cc : linux-media@vger.kernel.org
Envoyé le : Mar 20 Octobre 2009, 12 h 49 min 21 s
Objet : Re: ISDB-T tuner

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



      
