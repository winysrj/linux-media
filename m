Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:52259 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754271Ab2BIVr2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Feb 2012 16:47:28 -0500
References: <4F33DFB8.4080702@iki.fi> <201202091611.21095.pboettcher@kernellabs.com> <4F33E485.10704@iki.fi>
In-Reply-To: <4F33E485.10704@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: SDR FM demodulation
From: Andy Walls <awalls@md.metrocast.net>
Date: Thu, 09 Feb 2012 16:47:13 -0500
To: Antti Palosaari <crope@iki.fi>,
	Patrick Boettcher <pboettcher@kernellabs.com>
CC: linux-media <linux-media@vger.kernel.org>
Message-ID: <53fd5fba-9207-4703-b1b8-b39b19e70551@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari <crope@iki.fi> wrote:

>On 09.02.2012 17:11, Patrick Boettcher wrote:
>> On Thursday 09 February 2012 16:01:12 Antti Palosaari wrote:
>>> I have taken radio sniffs from FM capable Realtek DVB-T device.
>Looks
>>> like demodulator ADC samples IF frequency and pass all the sampled
>>> data to the application. Application is then responsible for
>>> decoding that. Device supports DVB-T, FM and DAB. I can guess  both
>>> FM and DAB are demodulated by software.
>>>
>>> Here is 17 second, 83 MB, FM radio sniff:
>>> http://palosaari.fi/linux/v4l-dvb/rtl2832u_fm/
>>> Decode it and listen some Finnish speak ;)
>>>
>>> Could someone help to decode it? I tried GNU Radio, but I failed
>>> likely because I didn't have enough knowledge... GNU Radio and
>>> Octave or Matlab are way to go.
>>
>> For someone to decode it, you would need to give more information
>about
>> the format of the stream. Like the sampling frequency, the
>sample-format
>> and then the IF-frequency.
>
>You can see sampling format easily looking hexdump or open file in 
>Audacity. It is 8bit unsigned samples, 2 channels (I & Q).
>
>No knowledge about IF... For good guess is to try some general used
>IFs.
>
>Sampling freq can be calculated using sample info and the fact it is 
>about 17 sec. sample size = 86919168 Bytes, time 17 sec. 2 channels, 1 
>byte sample => 2556446,11765 sample/sec (~2.5 MHz!)
>
>> I never did something like myself, but from what I saw in gnuradio
>there
>> should be everything to make a FM-demod based on the data.
>
>Yes there was a lot of block and those were rather easy to connect
>using 
>graphical interface (gnuradio-companion). But I don't know exactly what
>
>block are needed and what are parameters. I used file-sink => 
>fm-modulator => audio-sink. Likely not enough :i
>
>Without any earlier experience it is rather challenging. But if there
>is 
>someone who have done that earlier using USRP SDR he could likely do it
>
>easier :)
>
>regards
>Antti
>-- 
>http://palosaari.fi/
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


Implement a phased locked loop (phase comparator, low pass filter, and VCO) that is centered reasonably close to the IF.  The output of the LPF of the PLL should be the demodulated signal, IIRC.

Maybe this matlab (octave) file will help you:
http://www.mathworks.com/matlabcentral/fileexchange/24167-simple-pll-demostration

Regards,
Andy
