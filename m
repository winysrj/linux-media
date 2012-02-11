Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:38862 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079Ab2BKC3N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 21:29:13 -0500
Received: by obcva7 with SMTP id va7so4534286obc.19
        for <linux-media@vger.kernel.org>; Fri, 10 Feb 2012 18:29:12 -0800 (PST)
Subject: Re: SDR FM demodulation
From: David Hagood <david.hagood@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Antti Palosaari <crope@iki.fi>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <1328926119.16025.6.camel@palomino.walls.org>
References: <4F33DFB8.4080702@iki.fi>
	 <201202091611.21095.pboettcher@kernellabs.com> <4F33E485.10704@iki.fi>
	 <1328926119.16025.6.camel@palomino.walls.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Feb 2012 20:29:10 -0600
Message-ID: <1328927350.11652.11.camel@chumley>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2012-02-10 at 21:08 -0500, Andy Walls wrote:
> 
> Randomly checking some of the data with GNUplot, if 2.5 Msps is the
> sampling rate, then the fastest freq I saw was about 50 kHz.
How'd you analyze the data - assume it was baseband I/Q and do an FFT?
If so, and if this was digitized baseband, you should have seen the FM
stereo pilot tone at 19kHz.

If it's digitized IF, you should be able to run it through a rectangular
to polar conversion (compute mag = I^2+Q^2 and phase = arctan(I/Q) (use
a proper 4 quadrant arctan), then compute frequency by the delta between
the phase samples. Mag should be constant, frequency would then be your
audio.


