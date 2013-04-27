Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:65363 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3D0RNv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Apr 2013 13:13:51 -0400
Received: by mail-vb0-f50.google.com with SMTP id w16so4315018vbb.37
        for <linux-media@vger.kernel.org>; Sat, 27 Apr 2013 10:13:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201304271733.54301.arnd@arndb.de>
References: <1367039198-28639-1-git-send-email-shc_work@mail.ru>
	<201304271733.54301.arnd@arndb.de>
Date: Sat, 27 Apr 2013 14:13:50 -0300
Message-ID: <CAOMZO5CYZoe9Z_eAWZ5Wit2o-+9hq3xWjHPF_ZLszN7bbDJrBA@mail.gmail.com>
Subject: Re: [PATCH] media: coda: Fix compile breakage
From: Fabio Estevam <festevam@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Olof Johansson <olof@lixom.net>,
	Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alexander/Arnd,

On Sat, Apr 27, 2013 at 12:33 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 27 April 2013, Alexander Shiyan wrote:
>> Patch adds GENERIC_ALLOCATOR, if "coda" is selected.
>>
>> drivers/built-in.o: In function `coda_remove':
>> :(.text+0x110634): undefined reference to `gen_pool_free'
>> drivers/built-in.o: In function `coda_probe':
>> :(.text+0x1107d4): undefined reference to `of_get_named_gen_pool'
>> :(.text+0x1108b8): undefined reference to `gen_pool_alloc'
>> :(.text+0x1108d0): undefined reference to `gen_pool_virt_to_phys'
>> :(.text+0x110918): undefined reference to `dev_get_gen_pool'
>>
>> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> I noticed the problem as well, but haven't gotten around to create
> a patch. Thanks for taking care of this!

I fixed this issue in a different way:
https://patchwork.kernel.org/patch/2432841/

And Shawn has already queued it.
