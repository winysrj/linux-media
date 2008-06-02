Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1K3C7x-0002Fr-Th
	for linux-dvb@linuxtv.org; Mon, 02 Jun 2008 17:39:19 +0200
Received: by yw-out-2324.google.com with SMTP id 3so492953ywj.41
	for <linux-dvb@linuxtv.org>; Mon, 02 Jun 2008 08:38:55 -0700 (PDT)
Message-ID: <37219a840806020838u5d46fba0xe5061ebb0f25bd9e@mail.gmail.com>
Date: Mon, 2 Jun 2008 11:38:55 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Dennis Noordsij" <dennis.noordsij@movial.fi>
In-Reply-To: <4843B75C.7090505@movial.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <4843B75C.7090505@movial.fi>
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

On Mon, Jun 2, 2008 at 5:03 AM, Dennis Noordsij
<dennis.noordsij@movial.fi> wrote:
> I am finishing up the last stages of a new driver for the TerraTec
> Piranha DVB-T adapter (Sanio SMS-100x chipset), and I have some general
> questions some of the more experienced driver writers could perhaps
> provide some advice on.

Dennis,

I am currently in the process of cleaning up a public GPL'd driver
released by Siano for the SMS1010 / SMS1150 silicon.

This driver functions correctly with Siano's reference design hardware.

This is a generic driver that should probably also be backwards
compatible with the SMS1000 silicon used in your device.

I posted the work-in-progress to the following location:

http://linuxtv.org/hg/~mkrufky/siano

Please note:  This driver has been publicly available on linuxtv.org
for the past three weeks -- I recommend taking a quick look through
the individual development repositories before starting to write a
brand new driver, to prevent double-work efforts.

Please also note:  The driver has only gone through basic testing -- I
would not be surprised to find bugs in the code, and there is a
plethora of codingstyle violations.

Please feel free to send me patches against that repository to support
your device -- I will be happy to integrate them for you, although you
should be prepared to rebase your tree when I push up the next round
of updates / cleanups.

It makes more sense for you to add support for your device, rather
than writing a new driver from scratch, especially considering that
the driver I have comes directly from Siano, themselves.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
