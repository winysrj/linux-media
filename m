Return-path: <linux-media-owner@vger.kernel.org>
Received: from relaycp04.dominioabsoluto.net ([217.116.26.100]:55509 "EHLO
	relaycp04.dominioabsoluto.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277AbbBCN7Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 08:59:25 -0500
Date: Tue, 3 Feb 2015 14:59:24 +0100 (CET)
From: "DCRYPT@telefonica.net" <DCRYPT@telefonica.net>
Reply-To: DCRYPT@telefonica.net
To: stoth@kernellabs.com
Cc: linux-media@vger.kernel.org
Message-ID: <8039614.312436.1422971964080.JavaMail.defaultUser@defaultHost>
In-Reply-To: <CALzAhNXPne4_0vs80Y26Yia8=jYh8EqA0phJm31UzATdAvPvDg@mail.gmail.com>
References: <14641294.293916.1422889477503.JavaMail.defaultUser@defaultHost>
	<1842309.294410.1422891194529.JavaMail.defaultUser@defaultHost> <CALzAhNXPne4_0vs80Y26Yia8=jYh8EqA0phJm31UzATdAvPvDg@mail.gmail.com>
Subject: Re: Re: [BUG, workaround] HVR-2200/saa7164 problem with C7 power
 state
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>---- Mensaje original ----
>De : stoth@kernellabs.com
>Fecha : 02/02/2015 - 16:39 (GMT)
>Para : DCRYPT@telefonica.net
>CC : linux-media@vger.kernel.org
>Asunto : Re: [BUG, workaround] HVR-2200/saa7164 problem with C7 power state
>
>>>Basically, it starts working but after a while I get an "Event timed out" message and several i2c errors and VDR shuts down (some hours after reboot). As the web page mentions, I tested downgrading the PCIe bandwith from GEN2 to GEN1 without success. But after playing with different BIOS options, what did the trick was limiting the power-saving C-states. If I select "C7" as the maximum C-state, the card fails as described. After limiting the maximum C-state to "C6", it has been working for a whole weekend.
>
>Good feedback on the C7 vs C6 power state, thanks.

You are welcome, Steve. Happy to be helpful.

I will be at your disposal for testing purposes, if you need.

BR
