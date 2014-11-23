Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48317 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaKWMtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 07:49:53 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so6584043wiv.2
        for <linux-media@vger.kernel.org>; Sun, 23 Nov 2014 04:49:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAE1c1rTnU3svGTKgv3-u0DS3Tb+KKZHmn0=4fp1CrUZZ8b8gGA@mail.gmail.com>
References: <CAE1c1rTnU3svGTKgv3-u0DS3Tb+KKZHmn0=4fp1CrUZZ8b8gGA@mail.gmail.com>
Date: Sun, 23 Nov 2014 13:49:52 +0100
Message-ID: <CAE1c1rTkF2S612YN_NAbA6UP8xVTXzA8ys6WKhPX9ZXx0j07aw@mail.gmail.com>
Subject: Re: terratec HTC XS HD USB
From: Robert N <nrobert13@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I will reply my own question. it seems that w_scan is able to find the
muxes/services if I push the antenna cable only half way into the
tuner stick. I assume my problem is related to RF signal strength. is
there a range of valid strengths?

On Fri, Nov 21, 2014 at 5:13 PM, Robert N <nrobert13@gmail.com> wrote:
> Hi,
>
> I'm trying to get my USB tuner stick working on an openwrt, but
> getting some errors.
>
> using w_scan to scan the available channels, gives:
>
> 113000: sr6900 (time: 00:11) (time: 00:12) signal ok:
>         QAM_64   f = 113000 kHz S6900C999
> start_filter:1410: ERROR: ioctl DMX_SET_FILTER failed: 97 Message too long
> Info: NIT(actual) filter timeout
>
> I know the 113Mhz is a valid MUX, because tuner works well under windows.
>
> Any hints what could be the reason of the error messages?
>
> Thanks.
