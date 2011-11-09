Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms16-1.1blu.de ([89.202.0.34]:38846 "EHLO ms16-1.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab1KIV2T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Nov 2011 16:28:19 -0500
Received: from [93.215.212.139] (helo=hana.gusto)
	by ms16-1.1blu.de with esmtpsa (TLS-1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.69)
	(envelope-from <gusto@guttok.net>)
	id 1ROFgt-0002v3-0a
	for linux-media@vger.kernel.org; Wed, 09 Nov 2011 22:28:16 +0100
Date: Wed, 9 Nov 2011 22:27:24 +0100
From: Lars Schotte <gusto@guttok.net>
To: linux-media <linux-media@vger.kernel.org>
Subject: DAB+ prague and terratec noxon dab stick support
Message-ID: <20111109222724.4e9691ca@hana.gusto>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

well, i see that there has been some v4l workshop in prague.

there are two things in prague that are relevant:
	1.) they have a testing DVB-T2 mux running
	2.) they have DAB/DAB+ mux running

i have a terratec noxon dab stick. it doesnt run on windows well, but
it is a terratec device and terratec devices are usually supported on
linux, but this one is not and not even a DAB/DAB+ support i ve seen in
the kernel, so the question is, what now?

there are a lot of countries in europe that jumped on DAB+, like
Germany, czech republic, austria, and in the future also slovakia.
and not to forget the non-eu ones, like Swizerland and the eu-"experts"
in united kingdom.

one reason why i bought that terratec noxon dab stick is, that i surely
know that it will be supported on linux someday, the question only is
when. the sooner, the better. and i got it for 20 eur.

that device seems to be (co-)developed with Frauenhofer Institut, or
what they call themselves (you can check on the website by yourself, if
interested). that means that there should be some technical
documentation on that device (or at least its chipset). if there is
none, that would be rude, because that instutute is like a state
university, but without the teaching part, so they only do research
for ... ehm ... it should be for the people.

i will take a closer look at that device by myself, i already tried it
to get to work with windows (wasnt much success, it works but after
unpluging it says, that there is no signal and have to replug again ...
in short - their driver is not of the smartest genere).

so i just wanted to announce it here. i am not a developer, so i dont
have the capability to write the driver by myself, at least not in
reasonable timeframe. maybe in the future.
but i can help with testing, if someone already tampers with it.

-- 
Lars Schotte
@ Hana (F16)
