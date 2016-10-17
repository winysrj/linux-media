Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36428 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030205AbcJQQkb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 12:40:31 -0400
Received: by mail-oi0-f44.google.com with SMTP id m72so218957595oik.3
        for <linux-media@vger.kernel.org>; Mon, 17 Oct 2016 09:40:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476719053-17600-4-git-send-email-javier@osg.samsung.com>
References: <1476719053-17600-1-git-send-email-javier@osg.samsung.com> <1476719053-17600-4-git-send-email-javier@osg.samsung.com>
From: Kevin Hilman <khilman@baylibre.com>
Date: Mon, 17 Oct 2016 09:40:30 -0700
Message-ID: <CAOi56cWAaQ51mQG2LrQEg5B4aRcLFzOZAn9hPtGK06xXj0sHmg@mail.gmail.com>
Subject: Re: [PATCH 3/5] [media] rc: meson-ir: Fix module autoload
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Carlo Caione <carlo@caione.org>,
        linux-amlogic <linux-amlogic@lists.infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 17, 2016 at 8:44 AM, Javier Martinez Canillas
<javier@osg.samsung.com> wrote:
> If the driver is built as a module, autoload won't work because the module
> alias information is not filled. So user-space can't match the registered
> device with the corresponding module.
>
> Export the module alias information using the MODULE_DEVICE_TABLE() macro.
>
> Before this patch:
>
> $ modinfo drivers/media/rc/meson-ir.ko | grep alias
> $
>
> After this patch:
>
> $ modinfo drivers/media/rc/meson-ir.ko | grep alias
> alias:          of:N*T*Camlogic,meson-gxbb-irC*
> alias:          of:N*T*Camlogic,meson-gxbb-ir
> alias:          of:N*T*Camlogic,meson8b-irC*
> alias:          of:N*T*Camlogic,meson8b-ir
> alias:          of:N*T*Camlogic,meson6-irC*
> alias:          of:N*T*Camlogic,meson6-ir
>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Kevin Hilman <khilman@baylibre.com>
