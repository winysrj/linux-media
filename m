Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f18.google.com ([209.85.217.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <morgan.torvolt@gmail.com>) id 1KuUlg-0003Kk-0x
	for linux-dvb@linuxtv.org; Mon, 27 Oct 2008 17:16:38 +0100
Received: by gxk11 with SMTP id 11so223772gxk.17
	for <linux-dvb@linuxtv.org>; Mon, 27 Oct 2008 09:16:02 -0700 (PDT)
Message-ID: <3cc3561f0810270916y2f9e07c1v9b9f27823cead38@mail.gmail.com>
Date: Mon, 27 Oct 2008 16:16:01 +0000
From: "=?ISO-8859-1?Q?Morgan_T=F8rvolt?=" <morgan.torvolt@gmail.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1225122896.3124.13.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
	<49033440.6090609@gmx.de>
	<3cc3561f0810270337h4c33dd80n9b779a8dc3c8f8ce@mail.gmail.com>
	<20081027140348.GE9657@localhost>
	<1225122896.3124.13.camel@palomino.walls.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [RFC] SNR units in tuners
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

>> My guess is that it is possible. Actually, it is quite easy for QPSK ;-) You
>> only need to calculate the distance of the IQ-value from the ideal symbol
>> center ( (sqrt(0.5),sqrt(0.5)) or whatever) after the
>> rotator/retiming-block.
>>
>
> Isn't that just Error Vector Magnitude (EVM)?
>
> <musing>
> I suppose over a number of samples, EVM gives you an idea of the noise
> power + source transmitter deformation, if the received signal remains
> at a constant power.  I suppose you could estimate signal strength by
> examining amplifier gain settings.
> </musing>

Easy and possible as it might be, my experience, this is not done.
Since one can _very_ easily get the actual bit-error rate using FEC
error corrections, there is no need to implement anything but the very
simplest demodulator. The formula converting from BER to SNR is quite
accurate and not very calculation intensive. You could just have a
small look-up table for it if you wanted.

As for the signal level, then yes, it is usually "measured" by the
needed preamp gain. Since this is highly temperature dependent, most
professional equipment do not give you a signal level measurement.

I can list a few equipment names that does the one or the other if
anyone is interested. NEC actually measure the SNR properly in some of
their equipment, which makes it possible to compare the SNR and BER to
figure out if something is wrong (like a interference carrier hidden
inside the data carrier).

I must say that if any low-end equipment acutally measures the SNR
properly, I will be very surprised. To get this feature usually costs
thousands of dollars. If anyone could point me to a low cost DVB
receiver that actually does this right, I would very much like to
know.


Regards
Morgan

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
