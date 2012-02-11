Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58617 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753789Ab2BKCIt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 21:08:49 -0500
Subject: Re: SDR FM demodulation
From: Andy Walls <awalls@md.metrocast.net>
To: Antti Palosaari <crope@iki.fi>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	linux-media <linux-media@vger.kernel.org>
Date: Fri, 10 Feb 2012 21:08:38 -0500
In-Reply-To: <4F33E485.10704@iki.fi>
References: <4F33DFB8.4080702@iki.fi>
	 <201202091611.21095.pboettcher@kernellabs.com> <4F33E485.10704@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1328926119.16025.6.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2012-02-09 at 17:21 +0200, Antti Palosaari wrote:
> On 09.02.2012 17:11, Patrick Boettcher wrote:
> > On Thursday 09 February 2012 16:01:12 Antti Palosaari wrote:
> >> I have taken radio sniffs from FM capable Realtek DVB-T device. Looks
> >> like demodulator ADC samples IF frequency and pass all the sampled
> >> data to the application. Application is then responsible for
> >> decoding that. Device supports DVB-T, FM and DAB. I can guess  both
> >> FM and DAB are demodulated by software.
> >>
> >> Here is 17 second, 83 MB, FM radio sniff:
> >> http://palosaari.fi/linux/v4l-dvb/rtl2832u_fm/
> >> Decode it and listen some Finnish speak ;)
> >>
> >> Could someone help to decode it? I tried GNU Radio, but I failed
> >> likely because I didn't have enough knowledge... GNU Radio and
> >> Octave or Matlab are way to go.
> >
> > For someone to decode it, you would need to give more information about
> > the format of the stream. Like the sampling frequency, the sample-format
> > and then the IF-frequency.
> 
> You can see sampling format easily looking hexdump or open file in 
> Audacity. It is 8bit unsigned samples, 2 channels (I & Q).
> 
> No knowledge about IF... For good guess is to try some general used IFs.
> 
> Sampling freq can be calculated using sample info and the fact it is 
> about 17 sec. sample size = 86919168 Bytes, time 17 sec. 2 channels, 1 
> byte sample => 2556446,11765 sample/sec (~2.5 MHz!)

Randomly checking some of the data with GNUplot, if 2.5 Msps is the
sampling rate, then the fastest freq I saw was about 50 kHz.

Maybe you have an FM compsite baseband signal:
http://en.wikipedia.org/wiki/FM_broadcast#Other_subcarrier_services

If you low pass filter with digital filter with (an equivalent to) a 17
kHz cutoff, you may just be left with the mono L+R channel.

I am assuming the I&Q channels in the data are 8 bit LPCM so

	x = (c-128)/128.0 

normalizes an usigned byte sample value c in 0 to 255 to a float value x
in -1.0 to 1.0.

Regards,
Andy

> > I never did something like myself, but from what I saw in gnuradio there
> > should be everything to make a FM-demod based on the data.
> 
> Yes there was a lot of block and those were rather easy to connect using 
> graphical interface (gnuradio-companion). But I don't know exactly what 
> block are needed and what are parameters. I used file-sink => 
> fm-modulator => audio-sink. Likely not enough :i
> 
> Without any earlier experience it is rather challenging. But if there is 
> someone who have done that earlier using USRP SDR he could likely do it 
> easier :)
> 
> regards
> Antti


