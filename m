Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:36278 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181AbcECVxe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2016 17:53:34 -0400
MIME-Version: 1.0
In-Reply-To: <20160503233859.0f6506fa@mir>
References: <20160315080552.3cc5d146@recife.lan>
	<20160503233859.0f6506fa@mir>
Date: Tue, 3 May 2016 14:53:33 -0700
Message-ID: <CA+55aFxAor=MJSGFkynu72AQN75bNTh9kewLR4xe8CpjHQQvZQ@mail.gmail.com>
Subject: Re: [GIT PULL for v4.6-rc1] media updates
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 3, 2016 at 2:38 PM, Stefan Lippers-Hollmann <s.l-h@gmx.de> wrote:
> Hi
> [...]
>> Mauro Carvalho Chehab (95):
> [...]
>>       [media] use v4l2_mc_usb_media_device_init() on most USB devices
> [...]
>
> This change, as part of v4.6-rc6-85-g1248ded, breaks two systems, each
> equipped with a TeVii s480 (dvb_usb_dw2102) DVB-S2 card, for me (kernel
> v4.5.3-rc1 is fine):

>From the oops it looks like the "->prev" pointer in one of the list
heads in 'mdev' is NULL.

> [    5.041915] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    5.041921] IP: [<ffffffffa0017b18>] media_gobj_create+0xb8/0x100 [media]

I can't tell *which* list head it is, but it looks like there's a
missing call to media_device_init() which is what should have
initialized those list heads.

Of course, maybe that list pointer got initialized but then
overwritten by NULL for some other reason.

                     Linus
