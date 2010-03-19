Return-path: <linux-media-owner@vger.kernel.org>
Received: from vbox10718.hkn.net ([213.9.107.18]:56666 "EHLO
	mail.pab-software.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab0CSSz6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 14:55:58 -0400
Subject: Re: Terratec Cinergy Hybrid T USB XS (no audio)
From: Philippe Bourdin <richel@AngieBecker.ch>
To: linux-media@vger.kernel.org
Cc: video4linux-list@redhat.com
In-Reply-To: <1268701030.2510.26.camel@andromeda>
References: <1268701030.2510.26.camel@andromeda>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Mar 2010 19:55:56 +0100
Message-ID: <1269024956.2573.13.camel@andromeda>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


	Hello all,

just want to let you know, that I found a "bug" in the em28xx driver,
which prevents the audio part of mentioned USB card to work.

Basically it is (to the best of my knowledge) just a typo in 'em28xx.h'
where the define for card #55 "EM2880_BOARD_TERRATEC_HYBRID_XS" should
be replaced by "EM2882_BOARD_TERRATEC_HYBRID_XS".

Btw. the USB-ID is: "0ccd:0042".
The correct product name is:
"Terratec Cinnergy Hybrid T USB XS (em2882)"
which should be corrected in 'em28xx-cards.c' for
"EM2882_BOARD_TERRATEC_HYBRID_XS".

After recompiling, reinstalling, rebooting *and* then first doing a
# modprobe em28xx-alsa
I can get sound by redirecting the cards output with a command like:
# padsp sox -r 48000 -c 2 -t alsa hw:1,0 -t alsa hw:0,0

I hope this information helps others to get their cards working, since
you see quiet some of these cards on auction sites these days...

(Sorry for corss-posting this to linux-media@vger and
video4linux-list@redhat but I want to reach all responsible people.)

Best regards, I will have to unsubscribe now,

	Philippe Bourdin.


