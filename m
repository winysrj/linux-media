Return-path: <mchehab@pedra>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:52531 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1EUQTI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 12:19:08 -0400
Message-ID: <4DD7E5F5.4090503@kolumbus.fi>
Date: Sat, 21 May 2011 19:19:01 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: "Adrian C." <anrxc@sysphere.org>
CC: Christoph Pinkl <christoph.pinkl@gmail.com>,
	abraham.manu@gmail.com, linux-media@vger.kernel.org
Subject: Re: AW: Remote control not working for Terratec Cinergy C (2.6.37
 Mantis driver)
References: <alpine.LNX.2.00.1105040038430.10167@flfcurer.bet> <4DC431C6.1010605@kolumbus.fi> <alpine.LNX.2.00.1105102329290.12340@flfcurer.bet> <4dcd3ef7.dc06df0a.52b1.5d88@mx.google.com> <alpine.LNX.2.00.1105210314230.26477@flfcurer.bet> <alpine.LNX.2.00.1105210922290.31652@flfcurer.bet>
In-Reply-To: <alpine.LNX.2.00.1105210922290.31652@flfcurer.bet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


I noticed that too on the C code:

If keypress comes from the remote control,
driver does both "push down" and "release" immediately.

Some years ago I made a version that did something like this:

I measured that a remote control sends "key pressed" in about 20ms cycles.

Thus I decided that the driver can do following:

Whe key '1' is pressed initially, send "key 1 pressed to input layer".

If within 30ms a '1 pressed' comes from the remote control, driver keeps '1' as pressed (do nothing for input layer).
If there won't come a '1 pressed' from remote within 30ms, then driver sends "key 1 unpressed to input layer".

I don't know if there is any reusable algorithm (easilly usable code) for remote control drivers for this.

Regards,
Marko Ristola


21.05.2011 10:23, Adrian C. kirjoitti:
> Haven't noticed earlier that every button press is executed twice, until 
> I did some testing with Oxine. Not sure how much Lirc is to blame for 
> this, and for button 0 not working. I will move to the Lirc list.
> 
> Thanks again for the patch.
> 

