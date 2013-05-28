Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:38114 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933806Ab3E1JiU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 05:38:20 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNI00BKV5B5VEC0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 28 May 2013 10:38:18 +0100 (BST)
Message-id: <51A47B07.2090707@samsung.com>
Date: Tue, 28 May 2013 11:38:15 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	Jeongtae Park <jtp.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 3/3] s5p-mfc: added missing end-of-lines in debug messages
References: <1369725976-7828-1-git-send-email-a.hajda@samsung.com>
 <1369725976-7828-4-git-send-email-a.hajda@samsung.com>
 <CAK9yfHzoGmMi4JRbAbYZxbipFgB=TkdcBvSnZ0E7CjEJS7UZNA@mail.gmail.com>
In-reply-to: <CAK9yfHzoGmMi4JRbAbYZxbipFgB=TkdcBvSnZ0E7CjEJS7UZNA@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thanks for comment.

On 05/28/2013 10:42 AM, Sachin Kamat wrote:
> Hi Andrzej,
>
> On 28 May 2013 12:56, Andrzej Hajda <a.hajda@samsung.com> wrote:
>> Many debug messages missed end-of-line.
>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc.c        |  2 +-
>>  drivers/media/platform/s5p-mfc/s5p_mfc_debug.h  |  4 ++--
>>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 16 ++++++++--------
>>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |  4 ++--
>>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 16 ++++++++--------
>>  drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     |  4 ++--
>>  6 files changed, 23 insertions(+), 23 deletions(-)
> Instead of changing in so many places, can't we add it in the macro
> itself, something like this?
>  #define mfc_debug(level, fmt, args...)                         \
>         do {                                                    \
>                 if (debug >= level)                             \
> -                       printk(KERN_DEBUG "%s:%d: " fmt,        \
> +                       printk(KERN_DEBUG "%s:%d: " fmt "\n",   \
>                                 __func__, __LINE__, ##args);    \
>         } while (0)
Enforcing EOL in mfc_debug will result in removing EOL from above 120 places
where it is currently used :) Also similar change probably should be
made with
mfc_err to make it consistent.
Anyway such change seems to be not consistent with other printk related
functions.

Regards
Andrzej
