Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61460 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab3CFWKL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 17:10:11 -0500
Received: by mail-we0-f174.google.com with SMTP id r6so8811146wey.5
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 14:10:10 -0800 (PST)
Message-ID: <5137BEBF.7060608@gmail.com>
Date: Wed, 06 Mar 2013 23:10:07 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, k.debski@samsung.com,
	jtp.park@samsung.com, s.nawrocki@samsung.com
Subject: Re: [PATCH] [media] s5p-mfc: Fix encoder control 15 issue
References: <1362575757-22839-1-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1362575757-22839-1-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 03/06/2013 02:15 PM, Arun Kumar K wrote:
> mfc-encoder is not working in the latest kernel giving the
> erorr "Adding control (15) failed". Adding the missing step
> parameter in this control to fix the issue.

Do you mean this problem was not observed in 3.8 kernel and something
has changed in the v4l2 core so it fails in 3.9-rc now ? Or is it
related to some change in the driver itself ?

> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> ---
>   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index 2356fd5..4f6b553 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -232,6 +232,7 @@ static struct mfc_control controls[] = {
>   		.minimum = 0,
>   		.maximum = 1,
>   		.default_value = 0,
> +		.step = 1,
>   		.menu_skip_mask = 0,
>   	},
>   	{

Regards,
Sylwester
