Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50968 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2BFWEg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2012 17:04:36 -0500
Received: by wgbdt10 with SMTP id dt10so6665719wgb.1
        for <linux-media@vger.kernel.org>; Mon, 06 Feb 2012 14:04:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADfx-VT0ygk7=KTxUZ5HN49R3earJ_i188NSX1rZV136KF4r-Q@mail.gmail.com>
References: <CAEBdq3G0A-9WKCh-WY9OgaPi_wd4OUUGfLv-LAyUPaJp6uzF6w@mail.gmail.com>
	<CADfx-VT0ygk7=KTxUZ5HN49R3earJ_i188NSX1rZV136KF4r-Q@mail.gmail.com>
Date: Mon, 6 Feb 2012 20:04:34 -0200
Message-ID: <CAEBdq3GWCGFFc5x4O5E-QT1Lit0gj6B0a_pqdHK4c45_NDR=HQ@mail.gmail.com>
Subject: Re: ISDB-T Tuner stopped working...
From: Bruno Lima <bslima19@gmail.com>
To: Felipe Magno de Almeida <felipe.m.almeida@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi Felipe,
I am using the same USB dongle as you.
Same Linux version and firmware dibcom 1.20, i think there is no new
version available.

in the tuner i am using the struct isdbt_parameters; presented in the
other struct frontend_parameters;
that's why i am asking about some changes in the API, because it stopped work.

Thanks :D


Bruno Seabra Mendonça Lima




On Mon, Feb 6, 2012 at 7:17 PM, Felipe Magno de Almeida
<felipe.m.almeida@gmail.com> wrote:
> On Mon, Feb 6, 2012 at 6:48 PM, Bruno Lima <bslima19@gmail.com> wrote:
>> Hi,
>
> Hello Bruno Lima,
>
>> I made a tuner last year for the ISDB-T and was working fine until december.
>> Now that i am back at work, the tuner is only getting 1SEG signal.
>
> What is your tuner? What is your tuner driver? What firmware version
> is it using?
> What kernel version are you using? Did you dvbscan it? With what frequencies?
>
> I can use my PixelView dib0700 ISDB-Tb with Linux 3.2.2 very well. Both
> One-seg and Full-seg channels.
>
>> Did something changed in the API ?
>>
>> Att,
>>
>> Bruno Seabra Mendonça Lima
>> --
>
>
> --
> Felipe Magno de Almeida
