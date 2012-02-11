Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:35790 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752413Ab2BKPPw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Feb 2012 10:15:52 -0500
Date: Sat, 11 Feb 2012 16:15:48 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Cc: Alistair Buxton <a.j.buxton@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: SDR FM demodulation
Message-ID: <20120211151548.GA23806@minime.bse>
References: <4F33DFB8.4080702@iki.fi>
 <CAO-Op+Fn0AxiqD4367O7H7AziR4g2vnFCMtsVcu1iRvf6P5iYw@mail.gmail.com>
 <4F36632A.3010700@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F36632A.3010700@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 11, 2012 at 02:46:34PM +0200, Antti Palosaari wrote:
> I did that whole last night up to 6 am. I also ended up very similar
> blocks, but failed to convert bytes as UChar. I tried to add
> constant between Deinterleave and UChar To Float but it wasn't
> possible. So my first idea was to make Python script to make for the
> sample when I wake-up. But no need anymore :)

I ended up writing a FM demodulator in C before I found Alistair's
mail in my inbox. Using a 65536 element table for arc tangent and
integer arithmetics, it is pretty fast.

> Now someone should make Linux driver that can tune that device to
> different frequencies and look what it really can do.
> 
> What kind of driver architecture should be used? Use device 100%
> userspace or make it working as Kernel driver? I suspect making it
> as Kernel driver could be too limited since V4L/DVB API
> restrictions?

There is also the CX23880/1/2/3 series with two 10 bit ADCs (usually)
sampling at 28.7MHz. The video part can be switched to raw mode, where
it provides 8 bit samples at full or 16 bit samples at half the sampling
rate from the luma ADC.

In non-Y/C mode the chroma ADC is used by the audio part, where the data
can be fed through a configurable chain of filters, demodulatos, and sample
rate converters. Just grep 0x320 cx88-reg.h to get a glimpse of its
capabilities. There is absolutely no documentation to be found about most
of these registers.

A reconfigurable silicon tuner like the XC3028 again increases the number
of possibilities by a large factor.

BT87x aka CX2587x is used for SDR as well, but its video raw mode is
good just for analog tv signals, as it expects vsyncs and the audio ADC
usually just samples the tuner's baseband sound output at 448kHz.
Some variants claim to support FM stereo and BTSC decoding capabilities,
but AFAIR there is no support in the Linux driver and the public data
sheet just tells us there is a "DAP" between the decimation filter and
the DMA FIFO.

If only there was completely open documentation...

All in all, I don't think there can be one API that fits all devices
without limiting their functionality. Maybe a UVC or LabVIEW like interface
with blocks for tuners, ADCs, decimators, DMA sinks, etc. is suitable,
but then applications will end up being tailored to a small number
of topologies or require manual configuration. For most people the
only use would probably be to listen to FM radio.

  Daniel

