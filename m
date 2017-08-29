Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38091 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753651AbdH2Lth (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 07:49:37 -0400
Received: by mail-wm0-f51.google.com with SMTP id t201so431064wmt.1
        for <linux-media@vger.kernel.org>; Tue, 29 Aug 2017 04:49:37 -0700 (PDT)
Subject: Re: [PATCH][media-next] media: qcom: camss: Make function
 vfe_set_selection static
To: Colin King <colin.king@canonical.com>
Cc: Todor Tomov <todor.tomov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170829102110.25657-1-colin.king@canonical.com>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <043e2533-e1fd-4823-4dc7-b21483c5f560@linaro.org>
Date: Tue, 29 Aug 2017 14:49:34 +0300
MIME-Version: 1.0
In-Reply-To: <20170829102110.25657-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29.08.2017 13:21, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The function vfe_set_selection is local to the source and does
> not need to be in global scope, so make it static.
> 
> Cleans up sparse warning:
> warning: symbol 'vfe_set_selection' was not declared. Should it be static?
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thank you!
Acked-by: Todor Tomov <todor.tomov@linaro.org>

> ---
>  drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
> index b21b3c2dc77f..b22d2dfcd3c2 100644
> --- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
> +++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
> @@ -2660,7 +2660,7 @@ static int vfe_get_selection(struct v4l2_subdev *sd,
>   *
>   * Return -EINVAL or zero on success
>   */
> -int vfe_set_selection(struct v4l2_subdev *sd,
> +static int vfe_set_selection(struct v4l2_subdev *sd,
>  			     struct v4l2_subdev_pad_config *cfg,
>  			     struct v4l2_subdev_selection *sel)
>  {
> 

-- 
Best regards,
Todor Tomov
