Return-path: <mchehab@localhost>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32856 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab1GJXRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 19:17:06 -0400
Received: by iwn6 with SMTP id 6so3174419iwn.19
        for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 16:17:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107101645.47915.remi@remlab.net>
References: <20110710124303.26655303@susi.home.s3e.de>
	<201107101645.47915.remi@remlab.net>
Date: Mon, 11 Jul 2011 01:17:05 +0200
Message-ID: <CAJbz7-0=Sra8kSDeqdrjZGMChMGuBxA05Q_wsP6P_7drRGQ+OQ@mail.gmail.com>
Subject: Re: [Patch] dvb-apps: add test tool for DMX_OUT_TSDEMUX_TAP
From: HoP <jpetrous@gmail.com>
To: =?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

2011/7/10 Rémi Denis-Courmont <remi@remlab.net>:
> Le dimanche 10 juillet 2011 13:43:03 Stefan Seyfried, vous avez écrit :
>> Hi all,
>>
>> I patched test_dvr to use DMX_OUT_TSDEMUX_TAP and named it test_tapdmx.
>> Might be useful for others, too :-)
>> This is my first experience with mercurial, so bear with me if it's
>> totally wrong.
>
> Did it work for you? We at VideoLAN.org could not get DMX_OUT_TSDEMUX_TAP to
> work with any of three distinct device/drivers (on two different delivery
> systems). We do get TS packets, but they seem to be partly corrupt.

DMX_OUT_TSDEMUX_TAP works for me also. It worked well even
in 2.6.22 kernel with backported dvb_core from 2.6.28.

Honza
