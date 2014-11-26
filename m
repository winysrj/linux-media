Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:61473 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaKZKVb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 05:21:31 -0500
Received: by mail-lb0-f179.google.com with SMTP id z11so2153435lbi.10
        for <linux-media@vger.kernel.org>; Wed, 26 Nov 2014 02:21:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL+AA1nEyE1+EX21gO8Sztknk45pVFYeVc-4+0MTMxTRJXvqHA@mail.gmail.com>
References: <CAL+AA1nEyE1+EX21gO8Sztknk45pVFYeVc-4+0MTMxTRJXvqHA@mail.gmail.com>
Date: Wed, 26 Nov 2014 13:21:29 +0300
Message-ID: <CAL+AA1mfcFx1o=MYVCYpYQWpaB2NZkPYf4yWAoxP=Uky66zM6g@mail.gmail.com>
Subject: Re: Compiling STK1160 driver for Android
From: =?UTF-8?B?0JHQsNGA0YIg0JPQvtC/0L3QuNC6?= <bart.gopnik@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hi, guys!
>
> I have:
> 1. 05e1:0408 USB ID STK1160 chip GM7113 (SAA7113 clone) video processor device.
> 2. Google Nexus 5 LG D821 Hammerhead smartphone.
>
> I need compile STK1160 driver for Android.
>
> EasyCap driver can be found in CyanogenMod (Android based OS) git
> (https://github.com/CyanogenMod/android_kernel_lge_hammerhead/search?q=easycap)
>
> Looks like Ezequiel Garcia commited it (it is signed-off-by: Ezequiel
> Garcia <elezegarcia@gmail.com> and Mauro Carvalho Chehab
> <mchehab@redhat.com>). But it is the old driver by Mike Thomas.
>
> I successfully compiled this old driver by Mike Thomas as kernel
> module (easycap.ko) for my smartphone. It is working, but very very
> bad. It don't work without bars=0 key and I have only 12 fps (instead
> of 25 fps as expected). Any ideas why? I think the problem is in
> driver.
>
> What about new STK1160 driver by Ezequiel Garcia? Can I extract it
> from latest Linux kernel (stable 3.17.3 or mainline 3.18-rc5 or
> linux-next) and compile it for Android/CyanogenMod (without or with
> small changes in source code)?
>
> The new driver by Ezequiel Garcia can be found in AOSP git
> (https://google.com/search?q=stk1160+site%3Aandroid.googlesource.com),
> but, unfortunately, only for kernel versions 3.10+. But I need compile
> the new driver for kernel version 3.4 (for my Nexus 5).
>
> Hope for your help. Thanks in advance!

Please anybody answer my questions.
