Return-path: <linux-media-owner@vger.kernel.org>
Received: from web25602.mail.ukl.yahoo.com ([217.12.10.161]:36568 "HELO
	web25602.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752392AbZJTOtz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 10:49:55 -0400
Message-ID: <38955.60379.qm@web25602.mail.ukl.yahoo.com>
References: <340263.68846.qm@web25604.mail.ukl.yahoo.com> <4ADD3341.3050202@yahoo.co.jp> <459385.60767.qm@web25603.mail.ukl.yahoo.com> <4ADDC39A.1080002@yahoo.co.jp>
Date: Tue, 20 Oct 2009 14:49:58 +0000 (GMT)
From: Romont Sylvain <psgman24@yahoo.fr>
Subject: Re : Re : ISDB-T tuner
To: Akihiro TSUKADA <tskd2@yahoo.co.jp>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4ADDC39A.1080002@yahoo.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for your answer!
I will give back my pixela to the shop!
and I think I will choose the SKNet MonsterTV HDUS.
I don't have BCAS card because I will give back the pixela!
Do you think than SKNet MonsterTV HDUS is good?
Can I use it with Mythtv? (if you know mythtv)

Thank you very much for your help!



----- Message d'origine ----
De : Akihiro TSUKADA <tskd2@yahoo.co.jp>
À : Romont Sylvain <psgman24@yahoo.fr>
Cc : linux-media@vger.kernel.org
Envoyé le : Mar 20 Octobre 2009, 23 h 05 min 14 s
Objet : Re: Re : ISDB-T tuner

> so, which device can I buy, working in Japan, in linux, and in digital (working after 2011)?
known to work devices

0. 774 Friio white
http://www.friio.com/  (in Japanese)
USB2.0 ISDB-T, with a card-reader device, without BCAS card
DVB driver: in v4l-dvb main repository

direct net shopping only, pretty expensive.
card reader is very unstable due to its large initial
power consumption,  and pratically needs a self-powered USB hub
to used this reader. (receiver itself is OK in bus-powered)

1. Earthsoft PT1
http://earthsoft.jp/PT/index.html  (in Japanese)
PCI 2xISDB-T + 2xISDB-S, 4 concurrent streaming
no BCAS card, no card-reader.
DVB driver: in v4l-dvb main repository

very popular in this area but discontinued.
PT2 has been released but highly out of stock, and no driver yet.

2. SKNet MonsterTV HDUS, or HDUSF
http://www.sknet-web.co.jp/product/mtvhdus.html
USB2.0 ISDB-T, with BCAS card&reader, remote-controller

a bit old but maybe most available in stores.
I don't know much about this device, but it is reported to
work in Linux, (with some firmware hack?)
and some people seems to have written DVB driver.
you may find it from
  http://2sen.dip.jp/cgi-bin/hdusup/upload.cgi
  (up0432.zip??)
I heard that some another version(series?) have internal encryption and
are difficult to make it work in Linux.


note 0.
  DVB drivers output scrambled streams as is.
  an user-land application is necessary to descramble.
  stand-alone descrambler:
    http://www.marumo.ne.jp/junk/arib_std_b25-0.2.4.lzh
  patch to mplayer/gstreamer demuxer:
    http://2sen.dip.jp/cgi-bin/dtvup/source/up0176.zip

note 1.
  you have to prepare yourself PC/SC card reader and
  a BCAS card if the device does not bundle them.
  I guess  you already have a BCAS card in hand already;)
  Card reader must be supported by PC/SC to be used with the
  above descrambling applications.
  for example,

http://www.amazon.co.jp/gp/switch-language/product/B001NEIRH0/ref=dp_change_lang?ie=UTF8&language=en_JP
  is told to work, but I'm not sure.

note 2.
  re-using a BCAS card for non-autorized (bundeled) devices
  is probably against the EULA of the card.
  (one seg. programs are not scrambled and can be viewed
   without a BCAS card).

---------
akihiro
--------------------------------------
GyaO! - Anime, Dramas, Movies, and Music videos [FREE]
http://pr.mail.yahoo.co.jp/gyao/



      
