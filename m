Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbbLVLn6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 06:43:58 -0500
Subject: Re: [PATCH] [media] rc: sunxi-cir: Initialize the spinlock properly
To: Chen-Yu Tsai <wens@csie.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
References: <1450758455-22945-1-git-send-email-wens@csie.org>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <5679377B.3030004@redhat.com>
Date: Tue, 22 Dec 2015 12:43:55 +0100
MIME-Version: 1.0
In-Reply-To: <1450758455-22945-1-git-send-email-wens@csie.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 22-12-15 05:27, Chen-Yu Tsai wrote:
> The driver allocates the spinlock but fails to initialize it correctly.
> The kernel reports a BUG indicating bad spinlock magic when spinlock
> debugging is enabled.
>
> Call spin_lock_init() on it to initialize it correctly.
>
> Fixes: b4e3e59fb59c ("[media] rc: add sunxi-ir driver")
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Good catch:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> ---
>   drivers/media/rc/sunxi-cir.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
> index 7830aef3db45..40f77685cc4a 100644
> --- a/drivers/media/rc/sunxi-cir.c
> +++ b/drivers/media/rc/sunxi-cir.c
> @@ -153,6 +153,8 @@ static int sunxi_ir_probe(struct platform_device *pdev)
>   	if (!ir)
>   		return -ENOMEM;
>
> +	spin_lock_init(&ir->ir_lock);
> +
>   	if (of_device_is_compatible(dn, "allwinner,sun5i-a13-ir"))
>   		ir->fifo_size = 64;
>   	else
>
