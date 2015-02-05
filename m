Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61908 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648AbbBELK0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2015 06:10:26 -0500
Message-id: <54D34F93.8050809@samsung.com>
Date: Thu, 05 Feb 2015 12:10:11 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Kiran Padwal <kiran.padwal@smartplayin.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kiran.padwal21@gmail.com
Subject: Re: [PATCH] [media] s5k5baf: Add missing error check for devm_kzalloc
References: <1423130950-3922-1-git-send-email-kiran.padwal@smartplayin.com>
In-reply-to: <1423130950-3922-1-git-send-email-kiran.padwal@smartplayin.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kiran,

Thanks for spotting it.

On 02/05/2015 11:09 AM, Kiran Padwal wrote:
> This patch add a missing a check on the return value of devm_kzalloc,
> which would cause a NULL pointer dereference in a OOM situation.
>
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
> ---
>  drivers/media/i2c/s5k5baf.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
> index 60a74d8..156b975 100644
> --- a/drivers/media/i2c/s5k5baf.c
> +++ b/drivers/media/i2c/s5k5baf.c
> @@ -374,6 +374,8 @@ static int s5k5baf_fw_parse(struct device *dev, struct s5k5baf_fw **fw,
>  	count -= S5K5BAG_FW_TAG_LEN;
>  
>  	d = devm_kzalloc(dev, count * sizeof(u16), GFP_KERNEL);
> +	if (!d)
> +		return -ENOMEM;
>  
>  	for (i = 0; i < count; ++i)
>  		d[i] = le16_to_cpu(data[i]);
Acked-by: Andrzej Hajda <a.hajda@samsung.com>

Regards
Andrzej
