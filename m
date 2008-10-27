Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <morgan.torvolt@gmail.com>) id 1KuPUS-0005f2-2O
	for linux-dvb@linuxtv.org; Mon, 27 Oct 2008 11:38:29 +0100
Received: by gxk9 with SMTP id 9so2050995gxk.17
	for <linux-dvb@linuxtv.org>; Mon, 27 Oct 2008 03:37:53 -0700 (PDT)
Message-ID: <3cc3561f0810270337h4c33dd80n9b779a8dc3c8f8ce@mail.gmail.com>
Date: Mon, 27 Oct 2008 10:37:52 +0000
From: "=?ISO-8859-1?Q?Morgan_T=F8rvolt?=" <morgan.torvolt@gmail.com>
To: wk <handygewinnspiel@gmx.de>
In-Reply-To: <49033440.6090609@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
	<49033440.6090609@gmx.de>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
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

> In response to Steven Toth's suggestion regarding figuring out what
> the various units are across demodulators, I took a quick inventory
> and came up with the following list.  Note that this is just a first
> pass by taking a quick look at the source for each demodulator (I
> haven't looked for the datasheets for any of them yet or done sample
> captures to see what the reported ranges are).
>
> Could everybody who is responsible for a demod please take a look at
> the list and see if you can fill in the holes?
>
> Having a definitive list of the current state is important to being
> able to provide unified reporting of SNR.

As I used to work with satellite signals on an earth station, and was
responsible for the development of measurement techniques, I thought I
should join in here for some hopefully revelaing info.

I am guessing here of course, but I believe that there is no real SNR
measurement in any of the tuners available for computers. It is quite
easy to calculate SNR from BER, and even some professional satellite
modems in the 10kUSD price range and up uses the received BER to
calculate SNR. The received BER is calculated from how many bit errors
the FEC fixes. On a QPSK, a SNR of 16 would generally mean that the
time between biterrors is so long that it is near impossible to
calculate a SNR from the ber unless you run an average of multiple
days, or even weeks. I remember doing a test for a week on a satellite
mux without getting a single biterror. This means that you might never
get a reading above 16 on the SNR. Looking at the curves on wikipedia
(http://en.wikipedia.org/wiki/Image:PSK_BER_curves.svg), you can
assume that with an EbNo of 12 db, on a 27500MS 3/4 QPSK mux, the
average raw biterror will arrive every ( 27500 * 2 * (3/4) * (188/204)
= 38015*10^6 Mb/s ) 10^8 / 38015*10^6 = 0.0026 s.
If we then use EbNo at 13dB, the snr is 10^-10, at EbNo at 14 it is
10^-13. At this point, you have one bit-error each 260s on the same
mux. Suddenly the internal SNR calculation algorithm has a zero
element, and it gets impossible to calculate SNR.

Conclusion is, that no matter what you do on most tuners, you will not
get more than roughly 16-17dB SNR on QPSK signals. If they say that
they will give a range og 0-30dB, then the higher numbers will most
probably never happen. On other modulations this highest number is
different of course, and on lower bandwidth signals, this number is
reduced somewhat as a ber of 10^-9 will happen less frequently with
fewer bits per second coming trough the receiver.

Hope this made any sense (and was correct).

-Morgan-

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
