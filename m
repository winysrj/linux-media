Return-path: <linux-media-owner@vger.kernel.org>
Received: from web25608.mail.ukl.yahoo.com ([217.12.10.167]:30313 "HELO
	web25608.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751721AbZJTNDT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 09:03:19 -0400
Message-ID: <750990.6802.qm@web25608.mail.ukl.yahoo.com>
References: <340263.68846.qm@web25604.mail.ukl.yahoo.com> <4ADD3341.3050202@yahoo.co.jp> <alpine.LRH.1.10.0910200935120.3543@pub2.ifh.de>
Date: Tue, 20 Oct 2009 13:03:23 +0000 (GMT)
From: Romont Sylvain <psgman24@yahoo.fr>
Subject: Re : ISDB-T tuner
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: linux-media@vger.kernel.org, tskd2@yahoo.co.jp
In-Reply-To: <alpine.LRH.1.10.0910200935120.3543@pub2.ifh.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dibcom's tuner is only working in brazil no?
the Brazil's ISDB-T and Japanese one is not excatly same, no?



----- Message d'origine ----
De : Patrick Boettcher <pboettcher@kernellabs.com>
À : Akihiro TSUKADA <tskd2@yahoo.co.jp>
Cc : Romont Sylvain <psgman24@yahoo.fr>; linux-media@vger.kernel.org
Envoyé le : Mar 20 Octobre 2009, 16 h 43 min 34 s
Objet : Re: ISDB-T tuner

Hi all,

On Tue, 20 Oct 2009, Akihiro TSUKADA wrote:
> And just  for you information, in addition to EarthSoft PT1,
> there is a driver for 'Friio' ISDB-T USB receiver (which I wrote;) ,
> and it is already included in the main repository.
> Dibcom is maybe for Brazil and may or may not work in Japan.

I'm just stepping in here to clarify Dibcom's ISDB-T support: it's purely limited to demodulation with the dib8000-driver. Meaning, using a Dibcom reference-design in Japan will give you the BCAS encrypted transport stream, not more. This way is primarily used in set-top-boxes and car-receivers and things like that.

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      
