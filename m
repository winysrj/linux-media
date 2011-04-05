Return-path: <mchehab@pedra>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46251 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab1DEUDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 16:03:14 -0400
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Issa Gorissen'" <flop.m@usa.net>, <linux-media@vger.kernel.org>
References: <632PDek8o1744S03.1302001214@web03.cms.usa.net>
In-Reply-To: <632PDek8o1744S03.1302001214@web03.cms.usa.net>
Subject: RE: TT-budget S2-3200 cannot tune on HB13E DVBS2 transponder
Date: Tue, 5 Apr 2011 22:03:12 +0200
Message-ID: <004701cbf3cc$7f1fa790$7d5ef6b0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Issa Gorissen
> Sent: mardi 5 avril 2011 13:00
> To: linux-media@vger.kernel.org
> Subject: TT-budget S2-3200 cannot tune on HB13E DVBS2 transponder
> 
> Hi,
> 
> Eutelsat made a recent migration from DVB-S to DVB-S2 (since 31/3/2011)
> on two transponders on HB13E
> 
> - HOT BIRD 6 13° Est TP 159 Freq 11,681 Ghz DVB-S2 FEC 3/4 27500 Msymb/s
> 0.2 Pilot off Polar H
> 
> - HOT BIRD 9 13° Est TP 99 Freq 12,692 Ghz DVB-S2 FEC 3/4 27500 Msymb/s
> 0.2 Pilot off Polar H
> 

I can confirm that we have a lot of problem with these two transponders and
the TT-S2-3200 card.

Here are some observations:

- It seems that going from DVB-S to DVB-S2 make the antenna settings very
sensitive. We have some sites where everything is working correctly and on
some other sites where we needed to redo the antenna setup, especially the
LNB tilt.

- The STB0899 driver doesn't seem to work correctly: if the reception isn't
really good, we are missing a lot of TS packets and these packets are
altered (mainly garbage). But, the BER returned from the demodulator stay at
zero! (using FE_READ_BER ioctl). By the way, the FE_READ_UNCORRECTED_BLOCKS
ioctl isn't implemented in this driver.

Does anyone can confirm these observations?


> 
> Before those changes, with my TT S2 3200, I was able to watch TV on
> those transponders. Now, I cannot even tune on those transponders. I
> have tried with
> scan-s2 and w_scan and the latest drivers from git. They both find the
> transponders but cannot tune onto it.
> 
> Something noteworthy is that my other card, a DuoFlex S2 can tune fine
> on those transponders.
> 
> My question is; can someone try this as well with a TT S2 3200 and post
> the results ?
> 
> Thank you a lot,
> --
> Issa
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

