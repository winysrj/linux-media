Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:40014 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab2HYJZd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Aug 2012 05:25:33 -0400
Date: Sat, 25 Aug 2012 11:25:26 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] rc: do not sleep when the driver blocks on IR
 completion
Message-ID: <20120825092526.GA4285@hardeman.nu>
References: <1345756715-17643-1-git-send-email-sean@mess.org>
 <20120824220518.GA19354@hardeman.nu>
 <20120824232625.GA24562@pequod.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120824232625.GA24562@pequod.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 25, 2012 at 12:26:25AM +0100, Sean Young wrote:
>On Sat, Aug 25, 2012 at 12:05:18AM +0200, David Härdeman wrote:
>> On Thu, Aug 23, 2012 at 10:18:35PM +0100, Sean Young wrote:
>> >Some drivers wait for the IR device to complete sending before
>> >returning, so sleeping should not be done.
>> 
>> I'm not quite sure what the purpose is. Even if a driver waits for TX to
>> finish, the lirc imposed sleep isn't harmful in any way.
>
>Due to rounding errors, clock skew and different start times, the sleep 
>might be waiting for a different amount of time than the hardware took 
>to send it. The sleep is a bit of a kludge, let alone if the driver
>can wait for the hardware to tell you when it's done.

I don't see the sleep as much of a problem right now. Whether the
hardware says its done or if we simulate the same thing in the lirc
layer, the entire concept is a bit of a kludge :)

>Also, your change calculates the amount of us to sleep after transmission, 
>so if the transmission buffer was modified by the driver, the calculated 
>sleep might not make sense. Both winbond-cir and iguanair do this.

Oh, right, I'd overlooked this. I have written patches for winbond-cir
(which makes it asynchronous and leaves the txbuffer alone) and iguanair
(to leave the txbuffer alone). I'll post them sometime today when I've
done some more tests.

>> As far as I can tell, the iguanair driver waits for the usb packet to be
>> submitted, not for IR TX to finish.
>
>The iguanair driver waits for the ack from the device (which is an urb
>you receive from the device), which is sent once the IR has been 
>transmitted. The firmware source code is available.

Ah, I see.


-- 
David Härdeman
