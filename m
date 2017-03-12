Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02-sz.bfs.de ([194.94.69.103]:56878 "EHLO mx02-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755739AbdCLO45 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 10:56:57 -0400
Message-ID: <58C561B5.8080102@bfs.de>
Date: Sun, 12 Mar 2017 15:56:53 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Colin King <colin.king@canonical.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: atomisp: clean up return logic, remove redunant
 code
References: <20170311193205.6410-1-colin.king@canonical.com>
In-Reply-To: <20170311193205.6410-1-colin.king@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 11.03.2017 20:32, schrieb Colin King:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is no need to check if ret is non-zero, remove this
> redundant check and just return the error status from the call
> to mt9m114_write_reg_array.
> 
> Detected by CoverityScan, CID#1416577 ("Identical code for
> different branches")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/staging/media/atomisp/i2c/mt9m114.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
> index 8762124..a555aec 100644
> --- a/drivers/staging/media/atomisp/i2c/mt9m114.c
> +++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
> @@ -444,12 +444,8 @@ static int mt9m114_set_suspend(struct v4l2_subdev *sd)
>  static int mt9m114_init_common(struct v4l2_subdev *sd)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	int ret;
>  
> -	ret = mt9m114_write_reg_array(client, mt9m114_common, PRE_POLLING);
> -	if (ret)
> -		return ret;
> -	return ret;
> +	return mt9m114_write_reg_array(client, mt9m114_common, PRE_POLLING);
>  }


any use for "client" ?

re,
 wh

>  
>  static int power_ctrl(struct v4l2_subdev *sd, bool flag)
