Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62688 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2LCXud (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2012 18:50:33 -0500
Received: by mail-ob0-f174.google.com with SMTP id ta14so3186771obb.19
        for <linux-media@vger.kernel.org>; Mon, 03 Dec 2012 15:50:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352898282-21576-1-git-send-email-fabio.estevam@freescale.com>
References: <1352898282-21576-1-git-send-email-fabio.estevam@freescale.com>
Date: Mon, 3 Dec 2012 21:50:32 -0200
Message-ID: <CAOMZO5DyqFnJeonLm6PLAn50yg-BFgK3yAzQxJnPgwnjhTZcFA@mail.gmail.com>
Subject: Re: [PATCH] [media] coda: Fix build due to iram.h rename
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@infradead.org
Cc: kernel@pengutronix.de, p.zabel@pengutronix.de,
	javier.martin@vista-silicon.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Nov 14, 2012 at 11:04 AM, Fabio Estevam
<fabio.estevam@freescale.com> wrote:
> commit c045e3f13 (ARM: imx: include iram.h rather than mach/iram.h) changed the
> location of iram.h, which causes the following build error when building the coda
> driver:
>
> drivers/media/platform/coda.c:27:23: error: mach/iram.h: No such file or directory
> drivers/media/platform/coda.c: In function 'coda_probe':
> drivers/media/platform/coda.c:2000: error: implicit declaration of function 'iram_alloc'
> drivers/media/platform/coda.c:2001: warning: assignment makes pointer from integer without a cast
> drivers/media/platform/coda.c: In function 'coda_remove':
> drivers/media/platform/coda.c:2024: error: implicit declaration of function 'iram_free
>
> Since the content of iram.h is not imx specific, move it to include/linux/iram.h
> instead.
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Any comments on this one, please?

coda driver does not build currently.

Thanks,

Fabio Estevam
