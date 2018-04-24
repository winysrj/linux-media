Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34707 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756023AbeDXHz5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 03:55:57 -0400
MIME-Version: 1.0
In-Reply-To: <d8bdf4a080d4655d20b532a37ae22ca7e3483cc4.1524245455.git.mchehab@s-opensource.com>
References: <cover.1524245455.git.mchehab@s-opensource.com> <d8bdf4a080d4655d20b532a37ae22ca7e3483cc4.1524245455.git.mchehab@s-opensource.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 24 Apr 2018 09:55:55 +0200
Message-ID: <CAK8P3a1c044Tx9oCHyhR=-d4v67ijuwgubZPx52e4NDDETRe0Q@mail.gmail.com>
Subject: Re: [PATCH 1/7] asm-generic, media: allow COMPILE_TEST with virt_to_bus
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        mjpeg-users@lists.sourceforge.net,
        linux-arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 7:42 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> The virt_to_bus/bus_to_virt macros are arch-specific. Some
> archs don't support it. Yet, as it is interesting to allow
> doing compilation tests on non-ia32/ia64 archs, provide a
> fallback for such archs.
>
> While here, enable COMPILE_TEST for two media drivers that
> depends on it.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

I'd prefer not to do this: virt_to_bus() is deprecated for good reasons,
and I'd rather see the drivers fixed to use dma-mapping.h correctly.

One problem with your patch is that not all architectures include
asm-generic/io.h, so it likely breaks allmodconfig builds on architectures
that don't use that file and don't provide virt_to_bus() either.

      Arnd
