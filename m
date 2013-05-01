Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:37533 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab3EAJcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 May 2013 05:32:11 -0400
Received: by mail-ee0-f51.google.com with SMTP id c1so592098eek.10
        for <linux-media@vger.kernel.org>; Wed, 01 May 2013 02:32:10 -0700 (PDT)
Message-ID: <5180E117.1020006@gmail.com>
Date: Wed, 01 May 2013 11:32:07 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org
Subject: Re: [PATCH 1/4] [media] s3c-camif: Remove redundant NULL check
References: <1367302581-15478-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1367302581-15478-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/30/2013 08:16 AM, Sachin Kamat wrote:
> clk_unprepare checks for NULL pointer. Hence convert IS_ERR_OR_NULL
> to IS_ERR only.
>
> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
> ---
>   drivers/media/platform/s3c-camif/camif-core.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
> index 0d0fab1..2449f13 100644
> --- a/drivers/media/platform/s3c-camif/camif-core.c
> +++ b/drivers/media/platform/s3c-camif/camif-core.c
> @@ -341,7 +341,7 @@ static void camif_clk_put(struct camif_dev *camif)
>   	int i;
>
>   	for (i = 0; i<  CLK_MAX_NUM; i++) {
> -		if (IS_ERR_OR_NULL(camif->clock[i]))
> +		if (IS_ERR(camif->clock[i]))
>   			continue;
>   		clk_unprepare(camif->clock[i]);
>   		clk_put(camif->clock[i]);

Patch applied for 3.11 with following chunk squashed to it:

diff --git a/drivers/media/platform/s3c-camif/camif-core.c 
b/drivers/media/platform/s3c-camif/camif-core.c
index 2449f13..b385747 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -345,6 +345,7 @@ static void camif_clk_put(struct camif_dev *camif)
                         continue;
                 clk_unprepare(camif->clock[i]);
                 clk_put(camif->clock[i]);
+               camif->clock[i] = ERR_PTR(-EINVAL);
         }
  }

@@ -352,6 +353,9 @@ static int camif_clk_get(struct camif_dev *camif)
  {
         int ret, i;

+       for (i = 1; i < CLK_MAX_NUM; i++)
+               camif->clock[i] = ERR_PTR(-EINVAL);
+
         for (i = 0; i < CLK_MAX_NUM; i++) {
                 camif->clock[i] = clk_get(camif->dev, camif_clocks[i]);
                 if (IS_ERR(camif->clock[i])) {

Thanks!
Sylwester
