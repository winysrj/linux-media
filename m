Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48444229.2020607@movial.fi>
Date: Mon, 02 Jun 2008 20:55:37 +0200
From: Dennis Noordsij <dennis.noordsij@movial.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
References: <4843B75C.7090505@movial.fi>	
	<37219a840806020838u5d46fba0xe5061ebb0f25bd9e@mail.gmail.com>	
	<4844219C.3040700@movial.fi>
	<37219a840806021137t69088d2dg19298ff56b766b5e@mail.gmail.com>
In-Reply-To: <37219a840806021137t69088d2dg19298ff56b766b5e@mail.gmail.com>
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


> I'm assuming that you didn't have to make any changes to the driver?

No, (though had to override the default from DVB-H to DVB-T and
substitute the firmware I have with the one the driver expects).


>> Can you provide a link to the "officially supported" firmware blobs ?
> 
> Unfortunately, I can not distribute the firmware at this point in
> time.  The firmware that I am working with is for the SMS1010 and
> SMS1150 -- I believe that you need different firmware for the SMS100X
> -- exactly which sms100x silicon is used in your device?

I did have the adapter open (wasn't as easy as it sounds!), but, eh, I
think it might have been the SMS1001.

In any case, the firmware I have is the one distributed by TerraTec
(with their adapter), afaict they used the Siano drivers without any
modification (but add tv-viewing/recording software etc).

1c6e220399a8b1a5d9888952134436fd  SMS100x_DabTdmb.inp  (40096 bytes)
94a9f88c12c90700898cfeef4c86857f  SMS100x_Dvbh.inp   (40324 bytes)
4c156db5762f7fc40f567729d8bfea04  SMS100x_Dvbt.inp    (38144 bytes)

These are freely available on terratec.net (those are the original names
as well, so I guess they are completely different from what you have).

Perhaps you could ask your contact if/how firmware for the SMS100X can
also be included with the release, if it's confirmed the driver supports
all of these variants ? Since they re-use the same USB product id I
guess (would hope) the firmware variants are supposed to expose the same
API anyway.

One interesting thing is that the Piranha adapter is not advertised or
documented to support DVB-H, yet the SMS100x and firmware should.

I have tried loading the Dvbh firmware, and the commands work the same,
the adapter responds normally, but can't find any channels (surprise,
there aren't any here). Promising though.

Again, please let me know if there is anything I can do to help, and
thank you for your work in general

Cheers
Dennis



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
