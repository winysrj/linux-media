Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37952 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaKZLHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 06:07:03 -0500
Date: Wed, 26 Nov 2014 09:06:57 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: =?UTF-8?B?0JHQsNGA0YIg0JPQvtC/0L3QuNC6?= <bart.gopnik@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: Compiling STK1160 driver for Android
Message-ID: <20141126090657.4b2605c9@recife.lan>
In-Reply-To: <CAL+AA1mfcFx1o=MYVCYpYQWpaB2NZkPYf4yWAoxP=Uky66zM6g@mail.gmail.com>
References: <CAL+AA1nEyE1+EX21gO8Sztknk45pVFYeVc-4+0MTMxTRJXvqHA@mail.gmail.com>
	<CAL+AA1mfcFx1o=MYVCYpYQWpaB2NZkPYf4yWAoxP=Uky66zM6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 26 Nov 2014 13:21:29 +0300
Барт Гопник <bart.gopnik@gmail.com> escreveu:

> > Hi, guys!
> >
> > I have:
> > 1. 05e1:0408 USB ID STK1160 chip GM7113 (SAA7113 clone) video processor device.
> > 2. Google Nexus 5 LG D821 Hammerhead smartphone.
> >
> > I need compile STK1160 driver for Android.
> >
> > EasyCap driver can be found in CyanogenMod (Android based OS) git
> > (https://github.com/CyanogenMod/android_kernel_lge_hammerhead/search?q=easycap)
> >
> > Looks like Ezequiel Garcia commited it (it is signed-off-by: Ezequiel
> > Garcia <elezegarcia@gmail.com> and Mauro Carvalho Chehab
> > <mchehab@redhat.com>). But it is the old driver by Mike Thomas.
> >
> > I successfully compiled this old driver by Mike Thomas as kernel
> > module (easycap.ko) for my smartphone. It is working, but very very
> > bad. It don't work without bars=0 key and I have only 12 fps (instead
> > of 25 fps as expected). Any ideas why? I think the problem is in
> > driver.

Hard to tell about a driver that is not upstream. 

With regards to the low frame rate, this is likely due to cache
coherency differences between x86 and arm. 

There are some tricks to properly allocate memory for it to work fine
on ARM. Those tricks depend on the Kernel version. On modern Kernels,
this is a way easier than on 3.4, as newer Kernels got a new DMA core
code with makes easier to make the same driver to work fine on both x86
and arm.

> >
> > What about new STK1160 driver by Ezequiel Garcia? Can I extract it
> > from latest Linux kernel (stable 3.17.3 or mainline 3.18-rc5 or
> > linux-next) and compile it for Android/CyanogenMod (without or with
> > small changes in source code)?

It is possible. Not sure what changes will be required. The linux-backport
and media_build trees may help you to identify what's needed.

> >
> > The new driver by Ezequiel Garcia can be found in AOSP git
> > (https://google.com/search?q=stk1160+site%3Aandroid.googlesource.com),
> > but, unfortunately, only for kernel versions 3.10+. But I need compile
> > the new driver for kernel version 3.4 (for my Nexus 5).

3.4 is too old. The older the Kernel, the bigger will be the changes.

> > Hope for your help. Thanks in advance!
> 
> Please anybody answer my questions.
