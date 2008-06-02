Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <4844219C.3040700@movial.fi>
Date: Mon, 02 Jun 2008 18:36:44 +0200
From: Dennis Noordsij <dennis.noordsij@movial.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
References: <4843B75C.7090505@movial.fi>
	<37219a840806020838u5d46fba0xe5061ebb0f25bd9e@mail.gmail.com>
In-Reply-To: <37219a840806020838u5d46fba0xe5061ebb0f25bd9e@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Driver TerraTec Piranha functional,
 need some advice to finish up
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Michael Krufky schreef:

> Dennis,
> 
> I am currently in the process of cleaning up a public GPL'd driver
> released by Siano for the SMS1010 / SMS1150 silicon.


Hi Mike,

Ehh, D'OH I guess! I wrote to Siano in April when I bought this adapter,
but never got any reply. I know it was advertised as a mobile linux
chipset, but couldn't find any reference to any actual drivers.

At first try it seems to work in DVB-T mode with my device.

And at first glance it does the same things for DVB-T (only about 8
commands are really needed to function, though it is interesting to know
the real meaning behind all the bits).


> It makes more sense for you to add support for your device, rather
> than writing a new driver from scratch, especially considering that
> the driver I have comes directly from Siano, themselves.

Yes, of course. Well, at least it was interesting to reverse engineer
the protocol :-)

Goodluck with the many coding style violations, and please let me know
if you would like me to try or test something.

I will switch to this driver, and if I run into any issues with the
SMS1000 chipset I will send you a patch.

Can you provide a link to the "officially supported" firmware blobs ?

Thanks for your reply,
Dennis


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
