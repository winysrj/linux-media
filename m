Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:35523 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755174Ab2BKPzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Feb 2012 10:55:40 -0500
Date: Sat, 11 Feb 2012 16:55:37 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Cc: Alistair Buxton <a.j.buxton@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: SDR FM demodulation
Message-ID: <20120211155537.GA24193@minime.bse>
References: <4F33DFB8.4080702@iki.fi>
 <CAO-Op+Fn0AxiqD4367O7H7AziR4g2vnFCMtsVcu1iRvf6P5iYw@mail.gmail.com>
 <4F36632A.3010700@iki.fi>
 <20120211151548.GA23806@minime.bse>
 <4F368A31.7010607@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F368A31.7010607@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 11, 2012 at 05:33:05PM +0200, Antti Palosaari wrote:
> I opened my device and there is Elonics E4000 [1] silicon tuner.
> That tuner seems to be a little crazy beast! Supports frequencies
> from 64 to 1678 MHz and very many modulations. So for my eyes it is
> almost idea cheap SDR. No idea what is supported max bw ADC can
> sample...

I just tried to find the XC3028 product brief.
It seems XCeive has recently been bought by a company called CrestaTech
that have a USB/PCIe chipset for a small universal receiver and a PC
based SDR suite for TV/radio/GPS decoding.

  Daniel
