Return-path: <linux-media-owner@vger.kernel.org>
Received: from relaycp01.dominioabsoluto.net ([217.116.26.68]:46384 "EHLO
	relaycp01.dominioabsoluto.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754363AbbBBPdP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 10:33:15 -0500
Received: from smtp.movistar.es (smtp08.acens.net [86.109.99.132])
	by relaycp01.dominioabsoluto.net (Postfix) with ESMTP id 1109A4274
	for <linux-media@vger.kernel.org>; Mon,  2 Feb 2015 16:33:14 +0100 (CET)
Date: Mon, 2 Feb 2015 16:33:14 +0100 (CET)
From: "DCRYPT@telefonica.net" <DCRYPT@telefonica.net>
Reply-To: DCRYPT@telefonica.net
To: DCRYPT@telefonica.net
Cc: linux-media@vger.kernel.org
Message-ID: <1842309.294410.1422891194529.JavaMail.defaultUser@defaultHost>
In-Reply-To: <14641294.293916.1422889477503.JavaMail.defaultUser@defaultHost>
References: <14641294.293916.1422889477503.JavaMail.defaultUser@defaultHost>
Subject: Re: [BUG, workaround] HVR-2200/saa7164 problem with C7 power state
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm sorry, I resend the message with a descriptive subject 

>---- Mensaje original ----
>De : DCRYPT@telefonica.net
>Fecha : 02/02/2015 - 16:04 (GMT)
>Para : linux-media@vger.kernel.org
>Asunto : 
>
>Hi,
>
>As I faced problems with my Terratec Cinergy T PCIe Dual and was unable to solve it (yet), I recently purchased a used Hauppauge HVR-2200 PCIe dual tuner. I immediately ran into problems with the HVR-2200 as well, perfectly described here:
>
>http://whirlpool.net.au/wiki/n54l_all_in_one
>(scroll down or search "saa7164_cmd_send() No free sequences")
>
>Basically, it starts working but after a while I get an "Event timed out" message and several i2c errors and VDR shuts down (some hours after reboot). As the web page mentions, I tested downgrading the PCIe bandwith from GEN2 to GEN1 without success. But after playing with different BIOS options, what did the trick was limiting the power-saving C-states. If I select "C7" as the maximum C-state, the card fails as described. After limiting the maximum C-state to "C6", it has been working for a whole weekend.
>
>The HVR-2200 was also tested in a GA-H67MA-UD2H-B3 board with an G1610 Celeron, working without problems (although maximum C-state setup was not checked).
>
>Probably the error is present in other saa7164 boards.
>
>My VDR server is based on BayTrail J1900 (Asrock Q1900M).
>
>PS: I'm still waiting for advice regarding my Cinergy T/cx23885 problems and debugging. 

--
-------------------------------
dCrypt
