Return-path: <linux-media-owner@vger.kernel.org>
Received: from exsmtp03.microchip.com ([198.175.253.49]:16512 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933530AbdCHCff (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 21:35:35 -0500
Subject: Re: [PATCH] [media] atmel-isc: fix off-by-one comparison and out of
 bounds read issue
To: Colin King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-media@vger.kernel.org>
References: <20170307143047.30082-1-colin.king@canonical.com>
CC: <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "Wu, Songjun" <Songjun.Wu@microchip.com>
Message-ID: <5dc9d025-31d5-b129-09df-5de19758e886@microchip.com>
Date: Wed, 8 Mar 2017 10:25:59 +0800
MIME-Version: 1.0
In-Reply-To: <20170307143047.30082-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Colin,

Thank you for your comment.
It is a bug, will be fixed in the next patch.

On 3/7/2017 22:30, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> The are only HIST_ENTRIES worth of entries in  hist_entry however the
> for-loop is iterating one too many times leasing to a read access off
> the end off the array ctrls->hist_entry.  Fix this by iterating by
> the correct number of times.
>
> Detected by CoverityScan, CID#1415279 ("Out-of-bounds read")
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/media/platform/atmel/atmel-isc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
> index b380a7d..7dacf8c 100644
> --- a/drivers/media/platform/atmel/atmel-isc.c
> +++ b/drivers/media/platform/atmel/atmel-isc.c
> @@ -1298,7 +1298,7 @@ static void isc_hist_count(struct isc_device *isc)
>  	regmap_bulk_read(regmap, ISC_HIS_ENTRY, hist_entry, HIST_ENTRIES);
>
>  	*hist_count = 0;
> -	for (i = 0; i <= HIST_ENTRIES; i++)
> +	for (i = 0; i < HIST_ENTRIES; i++)
>  		*hist_count += i * (*hist_entry++);
>  }
>
>
