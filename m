Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:63052 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933529Ab3E1ImH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 04:42:07 -0400
Received: by mail-oa0-f41.google.com with SMTP id n9so9589536oag.28
        for <linux-media@vger.kernel.org>; Tue, 28 May 2013 01:42:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369725976-7828-4-git-send-email-a.hajda@samsung.com>
References: <1369725976-7828-1-git-send-email-a.hajda@samsung.com>
	<1369725976-7828-4-git-send-email-a.hajda@samsung.com>
Date: Tue, 28 May 2013 14:12:05 +0530
Message-ID: <CAK9yfHzoGmMi4JRbAbYZxbipFgB=TkdcBvSnZ0E7CjEJS7UZNA@mail.gmail.com>
Subject: Re: [PATCH 3/3] s5p-mfc: added missing end-of-lines in debug messages
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	Jeongtae Park <jtp.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

On 28 May 2013 12:56, Andrzej Hajda <a.hajda@samsung.com> wrote:
> Many debug messages missed end-of-line.
>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c        |  2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_debug.h  |  4 ++--
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 16 ++++++++--------
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |  4 ++--
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 16 ++++++++--------
>  drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     |  4 ++--
>  6 files changed, 23 insertions(+), 23 deletions(-)

Instead of changing in so many places, can't we add it in the macro
itself, something like this?
 #define mfc_debug(level, fmt, args...)                         \
        do {                                                    \
                if (debug >= level)                             \
-                       printk(KERN_DEBUG "%s:%d: " fmt,        \
+                       printk(KERN_DEBUG "%s:%d: " fmt "\n",   \
                                __func__, __LINE__, ##args);    \
        } while (0)


-- 
With warm regards,
Sachin
