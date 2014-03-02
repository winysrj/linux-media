Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f173.google.com ([209.85.128.173]:41942 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaCBG1K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Mar 2014 01:27:10 -0500
Received: by mail-ve0-f173.google.com with SMTP id oy12so360966veb.18
        for <linux-media@vger.kernel.org>; Sat, 01 Mar 2014 22:27:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393519488-5427-1-git-send-email-p.zabel@pengutronix.de>
References: <1393519488-5427-1-git-send-email-p.zabel@pengutronix.de>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 2 Mar 2014 11:56:48 +0530
Message-ID: <CA+V-a8sjibFouLHc_iNxXOdThgQ1PbKu6FhuLMspayPc3YhecA@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] tvp5150: Fix type mismatch warning in clamp macro
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thanks for the patch.

On Thu, Feb 27, 2014 at 10:14 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> This patch fixes the following warning:
>
> drivers/media/i2c/tvp5150.c: In function '__tvp5150_try_crop':
> include/linux/kernel.h:762:17: warning: comparison of distinct pointer types lacks a cast [enabled by default]
>   (void) (&__val == &__min);  \
>                  ^
> drivers/media/i2c/tvp5150.c:886:16: note: in expansion of macro 'clamp'
>   rect->width = clamp(rect->width,
>                 ^
> include/linux/kernel.h:763:17: warning: comparison of distinct pointer types lacks a cast [enabled by default]
>   (void) (&__val == &__max);  \
>                  ^
> drivers/media/i2c/tvp5150.c:886:16: note: in expansion of macro 'clamp'
>   rect->width = clamp(rect->width,
>                 ^
> include/linux/kernel.h:762:17: warning: comparison of distinct pointer types lacks a cast [enabled by default]
>   (void) (&__val == &__min);  \
>                  ^
> drivers/media/i2c/tvp5150.c:904:17: note: in expansion of macro 'clamp'
>   rect->height = clamp(rect->height,
>                  ^
> include/linux/kernel.h:763:17: warning: comparison of distinct pointer types lacks a cast [enabled by default]
>   (void) (&__val == &__max);  \
>                  ^
> drivers/media/i2c/tvp5150.c:904:17: note: in expansion of macro 'clamp'
>   rect->height = clamp(rect->height,
>                  ^
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks,
--Prabhakar Lad
