Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1Krf81-0006JH-DU
	for linux-dvb@linuxtv.org; Sun, 19 Oct 2008 22:43:58 +0200
From: Darron Broad <darron@kewl.org>
To: Georg Acher <acher@in.tum.de>
In-reply-to: <20081019195409.GW6792@braindead1.acher> 
References: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
	<2207.1224273353@kewl.org>
	<412bdbff0810171306n5f8768a2g48255db266d16aa8@mail.gmail.com>
	<5905.1224308528@kewl.org> <20081019195409.GW6792@braindead1.acher>
Date: Sun, 19 Oct 2008 21:43:53 +0100
Message-ID: <19262.1224449033@kewl.org>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [RFC] SNR units in tuners
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <20081019195409.GW6792@braindead1.acher>, Georg Acher wrote:

hi

>On Sat, Oct 18, 2008 at 06:42:08AM +0100, Darron Broad wrote:
><cx24116> 
>> The trouble there is that the scaling for the cx24116 already works
>> from an end-user perspective. The value derived in the code is
>> a possible maximum of 160 from the chip. REELBOX decided on 176
>> which may be more accurate.
>
>The reelbox code was just a heuristic approach to scale the value so that
>less than 30-40% is where the trouble starts... I've more or less matched it
>to femon's colors. There was no intention to indicate dBs, as end users
>don't understand dBs anyway ;-)

All sat receivers I see just scale to fit. We can read lots of forum
posts where people exchange % readings for sats :-)

>The docs for the 24116 say that the snr is measured in 0.1dB steps. The
>absolute range of registers a3:d5 is 0 to 300, so full scale is 30dB. I
>doubt we will see the 30dB in a real-world setup...

Okay, so we know the step size of 0.1 per bit and that's measured
within a range of 0 to 300 but that doesn't actually say what it's
value is? Ie, is 50=5dB or something else?

All the graphs I see for QPSK and 8PSK in use in the real-world
suggest the theoretical limit of esn0 is a lot less than that available
range. I don't know what is the accepted error rate to set this limit.
Perhaps someone who has authority on this subject can chime in?

On the cx24116 testing observed that a register max of 160 from QPSK
gave good approximation to that given by regular sat-kit sitting
around 100%. If that really means 16dB then it doesn't look right
compared to the graphs I see, what's wrong here?

>The signal strength in 9e/9d is the value of the AGC voltage. Register da
>seems to contain the estimated power level (-25 to -70dBm), but there's no
>further information about that (step size etc). I guess the firmware derives
>it from the AGC settings.

Okay. All that's done in cx24116.c is take that val and invert
it, which is enough I suppose.

cya!

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
