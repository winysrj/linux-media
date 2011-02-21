Return-path: <mchehab@pedra>
Received: from snt0-omc2-s14.snt0.hotmail.com ([65.55.90.89]:56407 "EHLO
	snt0-omc2-s14.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141Ab1BUTvS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 14:51:18 -0500
Message-ID: <SNT130-w33C1320E405E97531EE9D5ADD90@phx.gbl>
From: Jamenson Ferreira Espindula de Almeida Melo
	<jamensonespindula@hotmail.com>
To: <linux-media@vger.kernel.org>
Subject: Re: Re: Siano SMS1140 DVB Receiver on Debian 5.0 (Lenny)
Date: Mon, 21 Feb 2011 19:51:18 +0000
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi, Mauro! Thank you for your replying.

I have had some success. I just reconfigured the kernel 2.6.37 and recompiled it. I figured out two things. First: when I compiled the Siano driver as a module, smsmdtv.ko is loaded when I attach the receiver but no adapter directory, no dvr, no demux and no frontend are created in /dev directory. Second: I compiled the Siano driver into the kernel and bingo: when I attach the receiver, frontend0, dvr0 and demux0 are created in /dev/dvb/adapter0 directory. No problem. Real problem is: scan, w_scan and dvbtune doesn't find any signal to scan, say "tunning failed". I figured out that receiver default mode is setup to DVB-T (mode 4 in smscoreapi.c) and because of that dvb_nova_12mhz_b0.inp is required. Setting default mode to 6 in smscoreapi.c makes isdbt_nova_12mhz_b0.inp be required instead and it does make me sense to be the correct driver considering ISDB-T standard in Brazil. Reading Siano's documentation I realized that ISDB-T standard only runs with SMS Host Library, that is a proprietary subsystem of Siano Mobile Silicon and, actually, I am thinking receiver will only run if I use such a library.

Any more help?

Best regards. 		 	   		  