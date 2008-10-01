Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc1-s28.bay0.hotmail.com ([65.54.246.100])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <db260179@hotmail.com>) id 1KkzOD-0002h5-TL
	for linux-dvb@linuxtv.org; Wed, 01 Oct 2008 12:57:07 +0200
Message-ID: <BLU116-DAV10562D8CC05B81BBC261F9C2420@phx.gbl>
From: "David Bentham" <db260179@hotmail.com>
To: <darron@kewl.org>
References: <BLU116-W122752EF5297963897FDE5C2430@phx.gbl>
	<27308.1222823288@kewl.org>
Date: Wed, 1 Oct 2008 11:56:27 +0100
Message-ID: <000601c923b4$5a8daed0$380010ac@mulberry.local>
MIME-Version: 1.0
In-reply-to: <27308.1222823288@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Adding remote support to Avermedia Super 007 - more
	info needed!
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



-----Original Message-----
From: darron@kewl.org [mailto:darron@kewl.org] 
Sent: 01 October 2008 02:08
To: dabby bentam
Subject: Re: [linux-dvb] Adding remote support to Avermedia Super 007 - more
info needed! 

In message <BLU116-W122752EF5297963897FDE5C2430@phx.gbl>, dabby bentam
wrote:

hello david

>I'm currently trying to get remote support added to the Avermedia Super
007=
> card.

I have one of these cards also but I have no good news for you
unfortunately.

I am replying just to confirm that I too saw no activity in the register
logs in XP when pressing remote key presses. Nor, from what I can see
will any additions to the saa7134 code as is, aide you in reaching
remote control nirvana.

It looks as if all remotes on the saa7134 linux driver thus far are
triggered
via an interrupt and that no such interrupt is occuring when you press a key
on the remote for that board. This may require more absolute confirmation
though
as I didn't spend a great deal of time looking.

>I've turned the ir_debug on and gpio tracking on and enabled i2c_scan.
I've=
> added an entry in the saa7134-cards.c and saa7134-input.c - copying the
se=
>ttings from other avermedia cards.
>
>The polling setting makes the card print out loads of ir_builder settings=
>=2C removing the setting no output! - from this i am assuming that this
car=
>d has no gpio setting? - possible i2c?
>
>I've used regspy (from dscaler) to determine the GPIO STATUS and MASK
value=
>. Turning on/off the remote in windows has no value change? - does it
chang=
>e?
>
>Any guidance on how to determine the ir code? - without the manufacture
cod=
>e book.

I took a photo but didn't identify all the ICs on the board and write
them down, it may be worthwhie doing so and also tracing from where
the IR detector comes into the card and where it actually ends up.

If you are determined then you could explore the above but there is
still no guarantee of any eventual success of course as just knowing about
it more is only the first step in actually getting it to work.

cya!

Hello darron,

Thanks for the reply. I've established the cards IR port is not GPIO but
I2C. Similar to the hvr-1110 card. The I2C readout gives me:-

0x10
0x96

>From the other I2C cards, these functions are used to enable/disable the IR
port.

I'll take a closer look at he pins just incase.

Thanks

David


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
