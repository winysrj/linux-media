Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:58975 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753199Ab2BKLdu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Feb 2012 06:33:50 -0500
Date: Sat, 11 Feb 2012 12:33:47 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Alistair Buxton <a.j.buxton@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: SDR FM demodulation
Message-ID: <20120211113347.GA22110@minime.bse>
References: <4F33DFB8.4080702@iki.fi>
 <CAO-Op+Fn0AxiqD4367O7H7AziR4g2vnFCMtsVcu1iRvf6P5iYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO-Op+Fn0AxiqD4367O7H7AziR4g2vnFCMtsVcu1iRvf6P5iYw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 11, 2012 at 07:00:16AM +0000, Alistair Buxton wrote:
> The source file appears to be about 2 to 2.2 million samples per
> second. Any higher than that and the person speaking sounds like a
> chipmunk. Maybe 22050 * 1000 or 1024? Does any Finnish station
> broadcast "pips" like the BBC does? That could be used to determine
> the actual rate.

The stereo carrier is at 19kHz and RDS is centered around 57kHz.
I'd say this is 2048kHz sampling rate.

  Daniel
