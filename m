Return-path: <mchehab@pedra>
Received: from sysphere.org ([97.107.129.246]:48046 "EHLO mail.sysphere.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab1ECWwO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 18:52:14 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.sysphere.org (Postfix) with ESMTP id 9C1F980AD
	for <linux-media@vger.kernel.org>; Wed,  4 May 2011 00:42:10 +0200 (CEST)
Date: Wed, 4 May 2011 00:42:10 +0200
From: "Adrian C." <anrxc@sysphere.org>
To: linux-media@vger.kernel.org
Subject: Re: Remote control not working for Terratec Cinergy C (2.6.37 Mantis
 driver)
Message-ID: <alpine.LNX.2.00.1105040038430.10167@flfcurer.bet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2 Mar 2011, Marko Ristola wrote:

> So this means, that my remote control works, pressing key with hex 
> value 0x26 works.

It works.

> Unfortunately mantis_uart.c doesn't have IR input initialization at 
> all

But it does not work. How can it work and not work at the same time?


I have the Skystar HD2 (b), subsystem: 1ae4:0003 now, same chipset as 
Cinergy S2 and some others, VP-1041. Lirc failed with my old COM 
receiver so I tried to use the cards IR as fall-back, and of course I 
failed again. This was on 2.6.38.4.

Only information I found is 1 year old[1]. "IR was in flux" but it still 
doesn't work even though mantis pulls in all those ir-* modules, no 
input device is created.

Can someone fill us in, please, will it be supported this year?


1. http://www.mail-archive.com/linux-media@vger.kernel.org/msg14641.html
