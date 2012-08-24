Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:38064 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483Ab2HXX00 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 19:26:26 -0400
Date: Sat, 25 Aug 2012 00:26:25 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] rc: do not sleep when the driver blocks on IR
 completion
Message-ID: <20120824232625.GA24562@pequod.mess.org>
References: <1345756715-17643-1-git-send-email-sean@mess.org>
 <20120824220518.GA19354@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120824220518.GA19354@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 25, 2012 at 12:05:18AM +0200, David Härdeman wrote:
> On Thu, Aug 23, 2012 at 10:18:35PM +0100, Sean Young wrote:
> >Some drivers wait for the IR device to complete sending before
> >returning, so sleeping should not be done.
> 
> I'm not quite sure what the purpose is. Even if a driver waits for TX to
> finish, the lirc imposed sleep isn't harmful in any way.

Due to rounding errors, clock skew and different start times, the sleep 
might be waiting for a different amount of time than the hardware took 
to send it. The sleep is a bit of a kludge, let alone if the driver
can wait for the hardware to tell you when it's done.

Also, your change calculates the amount of us to sleep after transmission, 
so if the transmission buffer was modified by the driver, the calculated 
sleep might not make sense. Both winbond-cir and iguanair do this.

> As far as I can tell, the iguanair driver waits for the usb packet to be
> submitted, not for IR TX to finish.

The iguanair driver waits for the ack from the device (which is an urb
you receive from the device), which is sent once the IR has been 
transmitted. The firmware source code is available.

> As for winbond-cir, it would be simple enough to change it so that it
> doesn't wait for TX to finish (which seems to be a better solution).
>
> Having the TX methods as asynchronous as possible is probably a better
> way to go...as I expect a future TX API to be asynchronous.

I agree that a future TX API should be asynchronous and I like your
ideas around that; however that won't be ready for v3.7.


Sean
