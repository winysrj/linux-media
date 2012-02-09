Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37364 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2BIPL0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2012 10:11:26 -0500
Received: by wics10 with SMTP id s10so1297843wic.19
        for <linux-media@vger.kernel.org>; Thu, 09 Feb 2012 07:11:25 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: SDR FM demodulation
Date: Thu, 9 Feb 2012 16:11:21 +0100
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <4F33DFB8.4080702@iki.fi>
In-Reply-To: <4F33DFB8.4080702@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202091611.21095.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 09 February 2012 16:01:12 Antti Palosaari wrote:
> I have taken radio sniffs from FM capable Realtek DVB-T device. Looks
> like demodulator ADC samples IF frequency and pass all the sampled
> data to the application. Application is then responsible for
> decoding that. Device supports DVB-T, FM and DAB. I can guess  both
> FM and DAB are demodulated by software.
> 
> Here is 17 second, 83 MB, FM radio sniff:
> http://palosaari.fi/linux/v4l-dvb/rtl2832u_fm/
> Decode it and listen some Finnish speak ;)
> 
> Could someone help to decode it? I tried GNU Radio, but I failed
> likely because I didn't have enough knowledge... GNU Radio and
> Octave or Matlab are way to go.

For someone to decode it, you would need to give more information about 
the format of the stream. Like the sampling frequency, the sample-format 
and then the IF-frequency.

I never did something like myself, but from what I saw in gnuradio there 
should be everything to make a FM-demod based on the data.

regards,
--
Patrick Boettcher

Kernel Labs Inc.
http://www.kernellabs.com/
