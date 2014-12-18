Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52213 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaLRLji (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 06:39:38 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so1461966wiw.1
        for <linux-media@vger.kernel.org>; Thu, 18 Dec 2014 03:39:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141218090053.68a0aad6@recife.lan>
References: <1418873833-5084-1-git-send-email-zhang.chunyan@linaro.org>
	<1685288.Gd2P1eSoIW@wuerfel>
	<CAG2=9p9eL6kx8AfrLMw3Ct+eQcsQq5KJt=TkJ8ySmaWsWOmQ5A@mail.gmail.com>
	<20141218090053.68a0aad6@recife.lan>
Date: Thu, 18 Dec 2014 19:39:37 +0800
Message-ID: <CAG2=9p_-=pDeU5C0On5Qt8fRJuW6o_zZEECvvAgPVoMgrc_5JA@mail.gmail.com>
Subject: Re: [PATCH] media: rc: Replace timeval with ktime_t in imon.c
From: Chunyan Zhang <zhang.chunyan@linaro.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Arnd Bergmann <arnd@linaro.org>, david@hardeman.nu,
	uli-lirc@uli-eckhardt.de, hans.verkuil@cisco.com,
	julia.lawall@lip6.fr, Himangi Saraogi <himangi774@gmail.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>, joe@perches.com,
	John Stultz <john.stultz@linaro.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Lyra Zhang <zhang.lyra@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 18, 2014 at 7:00 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Em Thu, 18 Dec 2014 17:38:14 +0800
> Chunyan Zhang <zhang.chunyan@linaro.org> escreveu:
>
>> On Thu, Dec 18, 2014 at 3:50 PM, Arnd Bergmann <arnd@linaro.org> wrote:
>> > On Thursday 18 December 2014 11:37:13 Chunyan Zhang wrote:
>> >> This patch changes the 32-bit time type (timeval) to the 64-bit one
>> >> (ktime_t), since 32-bit time types will break in the year 2038.
>> >>
>> >> I use ktime_t instead of all uses of timeval in imon.c
>> >>
>> >> This patch also changes do_gettimeofday() to ktime_get() accordingly,
>> >> since ktime_get returns a ktime_t, but do_gettimeofday returns a
>> >> struct timeval, and the other reason is that ktime_get() uses
>> >> the monotonic clock.
>> >>
>> >> This patch use a new function which is provided by another patch listed below
>> >> to get the millisecond time difference.
>> >
>> > The patch looks great. Just a few small details that could still be
>> > improved:
>
> Yes, patch looks OK. After addressing the bits pointed by Arnd:
>
> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> Feel free to merge via y2038 tree.
>
Ok, thank you, I'll send the updated patch-set soon.

Chunyan
