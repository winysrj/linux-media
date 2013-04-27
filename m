Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:59320 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3D0PeA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Apr 2013 11:34:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shiyan <shc_work@mail.ru>
Subject: Re: [PATCH] media: coda: Fix compile breakage
Date: Sat, 27 Apr 2013 17:33:54 +0200
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Olof Johansson <olof@lixom.net>
References: <1367039198-28639-1-git-send-email-shc_work@mail.ru>
In-Reply-To: <1367039198-28639-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304271733.54301.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 27 April 2013, Alexander Shiyan wrote:
> Patch adds GENERIC_ALLOCATOR, if "coda" is selected.
> 
> drivers/built-in.o: In function `coda_remove':
> :(.text+0x110634): undefined reference to `gen_pool_free'
> drivers/built-in.o: In function `coda_probe':
> :(.text+0x1107d4): undefined reference to `of_get_named_gen_pool'
> :(.text+0x1108b8): undefined reference to `gen_pool_alloc'
> :(.text+0x1108d0): undefined reference to `gen_pool_virt_to_phys'
> :(.text+0x110918): undefined reference to `dev_get_gen_pool'
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

Acked-by: Arnd Bergmann <arnd@arndb.de>

I noticed the problem as well, but haven't gotten around to create
a patch. Thanks for taking care of this!

	Arnd
