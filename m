Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KYEI4-0003Dg-CA
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 08:14:02 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	31DCC18001AC
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 06:13:20 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: "Thomas Goerke" <tom@goeng.com.au>
Date: Wed, 27 Aug 2008 16:13:20 +1000
Message-Id: <20080827061320.298E2104F0@ws1-3.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
 TV/FM capture card
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


> ----- Original Message -----
> From: "Thomas Goerke" <tom@goeng.com.au>
> To: stev391@email.com
> Subject: RE: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog TV/FM capture card
> Date: Tue, 26 Aug 2008 21:40:40 +0800
> 
> 
> > From: stev391@email.com [mailto:stev391@email.com]
> ---snip---
> > Thomas,
> >
> > I'm happy to give it a go...
> >
> > The Zarlink demod is the exact same chip as the Intel one mentioned
> > previously.  Zarlink sold there demodulator (and possibly others) to
> > Intel.  The driver in Linux is still known as the Zarlink 10353, this
> > is not going to be a problem.
> >
> > The same windows driver controls both of these cards (and the E300,
> > E500 both normal and F versions), so they should be pretty similar
> > (except got for the HW mpeg encoder, and the power on support). (The
> > driver is based on the reference design as well)
> >
> > Create a wiki page for this card with the same information I need for
> > the E650, hopefully when I get the DVB-T going in one it will be a
> > simple matter for the other.
> >
> > I don't want to get your hopes up with the analog side yet, as I have
> > not managed to quite work out what I need to do there.
> >
> > Thanks for the email
> >
> > Regards,
> >
> > Stephen
> >
> > P.S. Please do not top post, reply to the email at the bottom. This
> > will help people who are catching up with this thread...
> >
> >
> > --
> > Be Yourself @ mail.com!
> > Choose From 200+ Email Addresses
> > Get a Free Account at www.mail.com
> Stephen,
> 
> I have created the page as requested:
> http://linuxtv.org/wiki/index.php/Compro_VideoMate_E800F.
> 
> I was able to run the regspy as requested but it was unclear to me how I was
> supposed to provide you with registry outputs.  Using the save command only
> seemed to provide vb or java script which didn't include anything specific
> as to registry contents.  If you can let me know the specific registry entry
> you are interested in (or a rough description) I can reboot under XP and
> find these values for you.
> 
> Thanks in advance
> 
> Tom

Tom,

Thanks for doing that, it appears that the two cards (E800F and E650) have the same subvendor and product ids. Also the same i2c output...

So this means that if I make a patch for DVB support in one, it will automatically be loaded for the other.  This however does pose a dilemma when looking at the analog side of the card.  However this can be hopefully tackled at a later stage.

The key registers that I'm after are the states of:
VID_A_INT_MSK
VID_B_INT_MSK
VID_C_INT_MSK

As I need to determine which port has the digital stream connected to it.

Typically these are zero when not in use, so if you run the program when the tuner is not in use then run the DVB program you should see a change in state of one of these only.

Can you also tune to an analog channel as well and let me know which one it is on (a, b or c).

Thanks,

Stephen.


-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
