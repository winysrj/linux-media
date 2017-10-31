Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:48514 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751565AbdJaPj6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 11:39:58 -0400
MIME-Version: 1.0
In-Reply-To: <20171029125058.5588-1-colin.king@canonical.com>
References: <20171029125058.5588-1-colin.king@canonical.com>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Tue, 31 Oct 2017 11:39:56 -0400
Message-ID: <CAOcJUbypnurqiwO0wZvaDVNLRij+_hsEiJ4eKG7G0b1-LqmEMw@mail.gmail.com>
Subject: Re: [PATCH] [media] mxl111sf: remove redundant assignment to index
To: Colin King <colin.king@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 29, 2017 at 8:50 AM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Variable index is set to zero and then set to zero again
> a few lines later in a for loop initialization. Remove the
> redundant setting of index to zero. Cleans up the clang
> warning:
>
> drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c:519:3: warning: Value
> stored to 'index' is never read
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>


Thanks for the patch!


> ---
>  drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
> index 0eb33e043079..a221bb8a12b4 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
> @@ -516,7 +516,6 @@ static int mxl111sf_i2c_hw_xfer_msg(struct mxl111sf_state *state,
>                    data required to program */
>                 block_len = (msg->len / 8);
>                 left_over_len = (msg->len % 8);
> -               index = 0;
>
>                 mxl_i2c("block_len %d, left_over_len %d",
>                         block_len, left_over_len);
> --
> 2.14.1
>
