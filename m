Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44217 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177Ab2BKQDU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Feb 2012 11:03:20 -0500
Subject: Re: SDR FM demodulation
From: Andy Walls <awalls@md.metrocast.net>
To: David Hagood <david.hagood@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	linux-media <linux-media@vger.kernel.org>
Date: Sat, 11 Feb 2012 11:03:08 -0500
In-Reply-To: <1328927350.11652.11.camel@chumley>
References: <4F33DFB8.4080702@iki.fi>
	 <201202091611.21095.pboettcher@kernellabs.com> <4F33E485.10704@iki.fi>
	 <1328926119.16025.6.camel@palomino.walls.org>
	 <1328927350.11652.11.camel@chumley>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1328976189.12883.4.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2012-02-10 at 20:29 -0600, David Hagood wrote:
> On Fri, 2012-02-10 at 21:08 -0500, Andy Walls wrote:
> > 
> > Randomly checking some of the data with GNUplot, if 2.5 Msps is the
> > sampling rate, then the fastest freq I saw was about 50 kHz.
> How'd you analyze the data - assume it was baseband I/Q and do an FFT?
> If so, and if this was digitized baseband, you should have seen the FM
> stereo pilot tone at 19kHz.

Well,  I was examining the data in the time-domain using 'od' to decode
the bytes to text and using gnuplot to visualize.  I looked for "high"
frequency contant envelope cycles.  Pretty lame, I know.

I did this in octave this morning and noted a carrier/pilot of some
sort:

fid = fopen('rtl2832u_fm_sample_FIXED.bin');
N=2^20;
fseek(fid, N*10, SEEK_SET);
[v, count] = fread(fid,[2,N],'unsigned char');
v = (v-128)/128;
w = v(1,:) + j*v(2,:);
f = fft(v(1,:),N);
fw = fft(v(1,:),N);
Fs = 2.5e6;

freqs = [1:(N/24)-1]*Fs/N;
bins = [2:N/24];
plot(freqs, abs(f(bins))/N, '.');
plot(freqs, abs(fw(bins))/N, '.');

[m,mi] = max(abs(fw)/N);
freqs(mi)
   ans =  9534.4
[m,mi] = max(abs(f)/N);
freqs(mi)
   ans =  9534.4
ans*2/1000
   ans =  19.069

I must have Fs wrong.

Anyway not much happens in the data above 100 kHz, but to see the whol
spectrum: 
bins = [2:N/2];
freqs = [1:(N/2)-1]*Fs/N;
semilogy(freqs, abs(f(bins))/N, '.');
semilogy(freqs, abs(fw(bins))/N, '.');


But it appears someone has now already solved the decoding problem.

Regards,
Andy


> 
> If it's digitized IF, you should be able to run it through a rectangular
> to polar conversion (compute mag = I^2+Q^2 and phase = arctan(I/Q) (use
> a proper 4 quadrant arctan), then compute frequency by the delta between
> the phase samples. Mag should be constant, frequency would then be your
> audio.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


