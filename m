Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45454 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab1DZNdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2011 09:33:19 -0400
Received: by iwn34 with SMTP id 34so502947iwn.19
        for <linux-media@vger.kernel.org>; Tue, 26 Apr 2011 06:33:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104260853.03817.hverkuil@xs4all.nl>
References: <BANLkTim7AONexeEm-E8iLQA5+TMDRUy36w@mail.gmail.com>
	<201104231256.25263.hverkuil@xs4all.nl>
	<BANLkTikneMOMVUQ07mLBZZTDYrKTJ1dfPw@mail.gmail.com>
	<201104260853.03817.hverkuil@xs4all.nl>
Date: Tue, 26 Apr 2011 07:33:18 -0600
Message-ID: <BANLkTimk=PHkYpOjPk8CLB=DNxRC=5CDAQ@mail.gmail.com>
Subject: Re: Regression with suspend from "msp3400: convert to the new control framework"
From: Jesse Allen <the3dfxdude@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Apr 26, 2011 at 12:53 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> OK, whatever is causing the problems is *not* msp3400 since your card does not
> have one :-)
>
> This card uses gpio to handle audio.
>
>> i2c-core: driver [tuner] using legacy suspend method
>> i2c-core: driver [tuner] using legacy resume method
>> tuner 0-0061: chip found @ 0xc2 (bt878 #0 [sw])
>> tuner-simple 0-0061: creating new instance
>> tuner-simple 0-0061: type set to 2 (Philips NTSC (FI1236,FM1236 and
>> compatibles))
>
> It is more likely to be the tuner driver. But I would have expected to see
> more bug reports since this is a bog-standard tuner so I have my doubts there
> as well.
>
> Regards,
>
>        Hans
>


OK, then. I will look at the other source file changes during 2.6.37.
It may be a while before I get more info though. These were on my list
to check:

i2c-core.c
tda7432.c
msp3400-driver.c
bttv-cards.c
bttv-driver.c
bttv-input.c (probably not)
bttv-risc.c (probably not?)

So we know that msp3400 is a sound chip that I don't have. tda7432
also looks like one. I understand the audio is fed right off of the
tuner directly to the phono jack?

Jesse
