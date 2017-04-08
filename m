Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:34690 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbdDHSM1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 14:12:27 -0400
MIME-Version: 1.0
In-Reply-To: <1491245884-15852-18-git-send-email-labbott@redhat.com>
References: <1491245884-15852-1-git-send-email-labbott@redhat.com> <1491245884-15852-18-git-send-email-labbott@redhat.com>
From: Emil Velikov <emil.l.velikov@gmail.com>
Date: Sat, 8 Apr 2017 19:12:25 +0100
Message-ID: <CACvgo52qr=oBoiMnrww3cgoKozEMi3DwBV55c_GMi0mR_p0GcA@mail.gmail.com>
Subject: Re: [PATCHv3 17/22] staging: android: ion: Collapse internal header files
To: Laura Abbott <labbott@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        devel@driverdev.osuosl.org, Rom Lemarchand <romlem@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        Mark Brown <broonie@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laura,

Couple of trivial nitpicks below.

On 3 April 2017 at 19:57, Laura Abbott <labbott@redhat.com> wrote:

> --- a/drivers/staging/android/ion/ion.h
> +++ b/drivers/staging/android/ion/ion.h
> @@ -1,5 +1,5 @@
>  /*
> - * drivers/staging/android/ion/ion.h
> + * drivers/staging/android/ion/ion_priv.h
Does not match the actual filename.

>   *
>   * Copyright (C) 2011 Google, Inc.
>   *
> @@ -14,24 +14,26 @@
>   *
>   */
>
> -#ifndef _LINUX_ION_H
> -#define _LINUX_ION_H
> +#ifndef _ION_PRIV_H
> +#define _ION_PRIV_H
>
Ditto.

> +#include <linux/device.h>
> +#include <linux/dma-direction.h>
> +#include <linux/kref.h>
> +#include <linux/mm_types.h>
> +#include <linux/mutex.h>
> +#include <linux/rbtree.h>
> +#include <linux/sched.h>
> +#include <linux/shrinker.h>
>  #include <linux/types.h>
> +#include <linux/miscdevice.h>
>
>  #include "../uapi/ion.h"
>
You don't want to use "../" in includes. Perhaps address with another
patch, if you haven't already ?

Regards,
Emil
