Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54580 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2BKHAS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Feb 2012 02:00:18 -0500
Received: by iacb35 with SMTP id b35so1334570iac.19
        for <linux-media@vger.kernel.org>; Fri, 10 Feb 2012 23:00:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F33DFB8.4080702@iki.fi>
References: <4F33DFB8.4080702@iki.fi>
Date: Sat, 11 Feb 2012 07:00:16 +0000
Message-ID: <CAO-Op+Fn0AxiqD4367O7H7AziR4g2vnFCMtsVcu1iRvf6P5iYw@mail.gmail.com>
Subject: Re: SDR FM demodulation
From: Alistair Buxton <a.j.buxton@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9 February 2012 15:01, Antti Palosaari <crope@iki.fi> wrote:

> Decode it and listen some Finnish speak ;)

Done. grc and output.wav here: http://al.robotfuzz.com/~al/rtl2832/

The trick was realising that the UChar to Float converter does not
adjust it's output to the range -1.0,1.0 that the wideband FM
demodulator block expects as input. Once I figured that out the rest
was easy. Just set the quadrature rate to the samples per second in
the source file, and the decimation to quadrature rate/output sink
rate. The source file appears to be about 2 to 2.2 million samples per
second. Any higher than that and the person speaking sounds like a
chipmunk. Maybe 22050 * 1000 or 1024? Does any Finnish station
broadcast "pips" like the BBC does? That could be used to determine
the actual rate.

-- 
Alistair Buxton
a.j.buxton@gmail.com
