Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailsafe.webbplatsen.se ([94.247.172.109]:59839 "EHLO
	mailsafe.webbplatsen.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbaAXPnQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 10:43:16 -0500
Received: from skinbark.wpsintrax.se (unknown [83.145.49.220])
	by mailsafe.webbplatsen.se (Halon Mail Gateway) with ESMTP
	for <linux-media@vger.kernel.org>; Fri, 24 Jan 2014 16:43:00 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by skinbark.wpsintrax.se (Postfix) with ESMTP id 18D7D77D594
	for <linux-media@vger.kernel.org>; Fri, 24 Jan 2014 16:43:11 +0100 (CET)
Received: from skinbark.wpsintrax.se ([127.0.0.1])
	by localhost (skinbark.wpsintrax.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Unqu9clboV+M for <linux-media@vger.kernel.org>;
	Fri, 24 Jan 2014 16:43:11 +0100 (CET)
Received: from tor.valhalla.alchemy.lu (vodsl-4669.vo.lu [80.90.56.61])
	by skinbark.wpsintrax.se (Postfix) with ESMTPA id B33EA77D55E
	for <linux-media@vger.kernel.org>; Fri, 24 Jan 2014 16:43:10 +0100 (CET)
Date: Fri, 24 Jan 2014 16:43:09 +0100
From: Joakim Hernberg <jbh@alchemy.lu>
To: linux-media@vger.kernel.org
Subject: Re: patch to fix a tuning regression for TeVii S471
Message-ID: <20140124164309.778dcfbd@tor.valhalla.alchemy.lu>
In-Reply-To: <20140122200408.3d0fc1cf@tor.valhalla.alchemy.lu>
References: <20140122200408.3d0fc1cf@tor.valhalla.alchemy.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 22 Jan 2014 20:04:08 +0100
Joakim Hernberg <jbh@alchemy.lu> wrote:

> I recently discovered a regression in the S471 driver.  When trying to
> tune to 10818V on Astra 28E2, the system would tune to 11343V instead.
> After browsing the code it appears that a divider was changed when the
> tuning code was moved from ds3000.c to ts2020.c.    

I decided to test this a bit more thoroughly.  I scanned 28E2 with
w_scan, compared the listings for 28E2 on King Of Sat with the
resulting channels.conf, and came up with the following anomalies. I've
also verified the non/existence of the transponders with my VU+ STB.

Some anomalies are common to all tests:
No channels found on 11307H (11307V is OK)
No channels found on 11344H (11344V is OK)
No channels found on 11390V (11389H is OK)
Finds 2 channels on 11097V that aren't in KOS nor found on the STB
Transponder on 12000H duplicate of 11992H


With linux v3.8.1 (old tuning code in ds3000.c):

No channels found on 11224V (11222H is OK)


With linux v3.13.0 (new tuning code in ts2020.c):

Shows the channels from 11344V as found on 10818V
No channels found on 11224V (11222H is OK)

Transponder on 12560H duplicate of 12545H
Transponder on 12607H duplicate of 12603H
Transponder on 12643H duplicate of 12633H


With linux 3.13.0 (+ my proposed patch):

Shows the channels from 11222H as found on 11224V
No channels found on 11224V

Transponder on 12524V duplicate of 12522V
Transponder on 12560H duplicate of 12545H
Transponder on 12607H duplicate of 12603H
Transponder on 12643H duplicate of 12633H


Unless some one can directly spot what is wrong in the ts2020.c code, I
guess the next step will be to sprinkle printk statements in the tuning
code and try to tune to the problematic channels.  Then try to see if I
can figure out how the code that programs the pll oscilliator functions
and if I can come up with better dividers for it.

It would be very much appreciated if someone with a TeVii card using
the ts2020 can confirm some of my findings, it would even be
interesting to know if it's a problem common to many cards using the
ts2020...

Finally I am quite sure that my tests above are ok, but I suppose it's
possible I've made a mistake or two, since it's was a long, boring and
manual process to match the transponders scanned to the web listings. I
also suppose that there could be bugs in w_scan affecting the results,
but guess further testing will rule this out.  Also note that there
might be more frequencies that are problematic, as I've only scanned
28E2 for the moment...

-- 

   Joakim
