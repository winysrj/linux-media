Return-path: <linux-media-owner@vger.kernel.org>
Received: from web25605.mail.ukl.yahoo.com ([217.12.10.164]:28991 "HELO
	web25605.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752015AbZJTN3g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 09:29:36 -0400
Message-ID: <271534.68660.qm@web25605.mail.ukl.yahoo.com>
References: <340263.68846.qm@web25604.mail.ukl.yahoo.com> <4ADD3341.3050202@yahoo.co.jp> <alpine.LRH.1.10.0910200935120.3543@pub2.ifh.de> <750990.6802.qm@web25608.mail.ukl.yahoo.com> <alpine.LRH.1.10.0910201512430.24115@pub3.ifh.de>
Date: Tue, 20 Oct 2009 13:29:38 +0000 (GMT)
From: Romont Sylvain <psgman24@yahoo.fr>
Subject: Re : Re : ISDB-T tuner
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: linux-media@vger.kernel.org, tskd2@yahoo.co.jp
In-Reply-To: <alpine.LRH.1.10.0910201512430.24115@pub3.ifh.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ok...
so it's mean, now, all the  japanese ISDB-T tuner card are not working in linux?



----- Message d'origine ----
De : Patrick Boettcher <pboettcher@kernellabs.com>
À : Romont Sylvain <psgman24@yahoo.fr>
Cc : Linux Media Mailing List <linux-media@vger.kernel.org>; tskd2@yahoo.co.jp
Envoyé le : Mar 20 Octobre 2009, 22 h 16 min 42 s
Objet : Re: Re : ISDB-T tuner

On Tue, 20 Oct 2009, Romont Sylvain wrote:

> Dibcom's tuner is only working in brazil no?
> the Brazil's ISDB-T and Japanese one is not excatly same, no?

On the physical layer it is exactly the same. It is the content (video/audio/data inside the MPEG2 transport-stream) which differs in the two countries. This is typically not handled by the 'tuner', but by the 'backend'.

This 'backend' is either another hardware chip or a software-stack. This is what has to be different between Japan and Brazil.

--

Patrick http://www.kernellabs.com/



      
