Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:51165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab1BVAXr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 19:23:47 -0500
Message-ID: <4D630210.9070604@redhat.com>
Date: Mon, 21 Feb 2011 21:23:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jamenson Ferreira Espindula de Almeida Melo
	<jamensonespindula@hotmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Siano SMS1140 DVB Receiver on Debian 5.0 (Lenny)
References: <SNT130-w33C1320E405E97531EE9D5ADD90@phx.gbl>
In-Reply-To: <SNT130-w33C1320E405E97531EE9D5ADD90@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jamenson,

Em 21-02-2011 16:51, Jamenson Ferreira Espindula de Almeida Melo escreveu:
> 
> Hi, Mauro! Thank you for your replying.
> 
> I have had some success. I just reconfigured the kernel 2.6.37 and recompiled it. I figured out two things.
> First: when I compiled the Siano driver as a module, smsmdtv.ko is loaded when I attach the receiver but no adapter directory, 
> no dvr, no demux and no frontend are created in /dev directory. Second: I compiled the Siano driver into the kernel and bingo:
> when I attach the receiver, frontend0, dvr0 and demux0 are created in /dev/dvb/adapter0 directory. No problem. Real problem is:
> scan, w_scan and dvbtune doesn't find any signal to scan, say "tunning failed". I figured out that receiver default mode is 
> setup to DVB-T (mode 4 in smscoreapi.c) and because of that dvb_nova_12mhz_b0.inp is required. Setting default mode to 6 in 
> smscoreapi.c makes isdbt_nova_12mhz_b0.inp be required instead and it does make me sense to be the correct driver considering ISDB-T
> standard in Brazil. Reading Siano's documentation I realized that ISDB-T standard only runs with SMS Host Library, that is a 
> proprietary subsystem of Siano Mobile Silicon and, actually, I am thinking receiver will only run if I use such a library.
> 
> Any more help?

Yes, you need to force it to mode 6, if you want to use it with ISDB-T.

It works fine with ISDB-T, provided that you use a good antenna. Here, I need
to use a "Sagna Baby" antenna, that gives me an additional gain of
18 dB, and put it on my window. Notice that sms1140 only works with 1seg/3seg.

Abraços,
Mauro
