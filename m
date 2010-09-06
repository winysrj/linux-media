Return-path: <mchehab@gaivota>
Received: from mailout4.samsung.com ([203.254.224.34]:62505 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0IFHOV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 03:14:21 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Received: from epmmp1 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Sun Java(tm) System Messaging Server 7u3-15.01 64bit (built Feb 12 2010))
 with ESMTP id <0L8B006LPDFVUNC0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 16:14:19 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0L8B000HUDFVD0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 16:14:19 +0900 (KST)
Date: Mon, 06 Sep 2010 16:14:19 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH 8/8] v4l: radio: si470x: fix unneeded free_irq() call
In-reply-to: <1283756030-28634-9-git-send-email-m.szyprowski@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	p.osciak@samsung.com, s.nawrocki@samsung.com,
	Tobias Lorenz <tobias.lorenz@gmx.net>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	Jean Delvare <khali@linux-fr.org>
Message-id: <4C8494CB.4020007@samsung.com>
Content-transfer-encoding: 8BIT
References: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
 <1283756030-28634-9-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 2010-09-06 오후 3:53, Marek Szyprowski wrote:
> In case of error during probe() the driver calls free_irq() function
> on not yet allocated irq. This patches fixes the call sequence in case of
> the error.
>

I sent this fix patch but it didn't go to linux-media ML by certain
reason. Anyway this is good catch.

Acked-by: Joonyoung Shim <jy0922.shim@samsung.com>

> Signed-off-by: Marek Szyprowski<m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> CC: Tobias Lorenz<tobias.lorenz@gmx.net>
> CC: Joonyoung Shim<jy0922.shim@samsung.com>
> CC: Douglas Schilling Landgraf<dougsland@redhat.com>
> CC: Jean Delvare<khali@linux-fr.org>
> ---
>   drivers/media/radio/si470x/radio-si470x-i2c.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
> index 67a4ec8..4ce541a 100644
> --- a/drivers/media/radio/si470x/radio-si470x-i2c.c
> +++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
> @@ -395,7 +395,7 @@ static int __devinit si470x_i2c_probe(struct i2c_client *client,
>   	radio->registers[POWERCFG] = POWERCFG_ENABLE;
>   	if (si470x_set_register(radio, POWERCFG)<  0) {
>   		retval = -EIO;
> -		goto err_all;
> +		goto err_video;
>   	}
>   	msleep(110);
>

