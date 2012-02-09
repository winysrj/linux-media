Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58443 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab2BIPVn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Feb 2012 10:21:43 -0500
Message-ID: <4F33E485.10704@iki.fi>
Date: Thu, 09 Feb 2012 17:21:41 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: SDR FM demodulation
References: <4F33DFB8.4080702@iki.fi> <201202091611.21095.pboettcher@kernellabs.com>
In-Reply-To: <201202091611.21095.pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09.02.2012 17:11, Patrick Boettcher wrote:
> On Thursday 09 February 2012 16:01:12 Antti Palosaari wrote:
>> I have taken radio sniffs from FM capable Realtek DVB-T device. Looks
>> like demodulator ADC samples IF frequency and pass all the sampled
>> data to the application. Application is then responsible for
>> decoding that. Device supports DVB-T, FM and DAB. I can guess  both
>> FM and DAB are demodulated by software.
>>
>> Here is 17 second, 83 MB, FM radio sniff:
>> http://palosaari.fi/linux/v4l-dvb/rtl2832u_fm/
>> Decode it and listen some Finnish speak ;)
>>
>> Could someone help to decode it? I tried GNU Radio, but I failed
>> likely because I didn't have enough knowledge... GNU Radio and
>> Octave or Matlab are way to go.
>
> For someone to decode it, you would need to give more information about
> the format of the stream. Like the sampling frequency, the sample-format
> and then the IF-frequency.

You can see sampling format easily looking hexdump or open file in 
Audacity. It is 8bit unsigned samples, 2 channels (I & Q).

No knowledge about IF... For good guess is to try some general used IFs.

Sampling freq can be calculated using sample info and the fact it is 
about 17 sec. sample size = 86919168 Bytes, time 17 sec. 2 channels, 1 
byte sample => 2556446,11765 sample/sec (~2.5 MHz!)

> I never did something like myself, but from what I saw in gnuradio there
> should be everything to make a FM-demod based on the data.

Yes there was a lot of block and those were rather easy to connect using 
graphical interface (gnuradio-companion). But I don't know exactly what 
block are needed and what are parameters. I used file-sink => 
fm-modulator => audio-sink. Likely not enough :i

Without any earlier experience it is rather challenging. But if there is 
someone who have done that earlier using USRP SDR he could likely do it 
easier :)

regards
Antti
-- 
http://palosaari.fi/
