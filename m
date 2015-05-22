Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:35712 "EHLO
	mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbbEVOV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 10:21:28 -0400
Received: by qkdn188 with SMTP id n188so12231613qkd.2
        for <linux-media@vger.kernel.org>; Fri, 22 May 2015 07:21:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432303184-8594-12-git-send-email-hverkuil@xs4all.nl>
References: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
	<1432303184-8594-12-git-send-email-hverkuil@xs4all.nl>
Date: Fri, 22 May 2015 10:21:27 -0400
Message-ID: <CALzAhNUmUm0XyKtVnSF7QP0jSbZaC_1yDzb4ajnLg220eTYVjg@mail.gmail.com>
Subject: Re: [PATCH 11/11] saa7164: fix sparse warning
From: Steven Toth <stoth@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux-Media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 22, 2015 at 9:59 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> drivers/media/pci/saa7164/saa7164-i2c.c:45:33: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/pci/saa7164/saa7164-i2c.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/pci/saa7164/saa7164-i2c.c b/drivers/media/pci/saa7164/saa7164-i2c.c
> index 6ea9d4f..0342d84 100644
> --- a/drivers/media/pci/saa7164/saa7164-i2c.c
> +++ b/drivers/media/pci/saa7164/saa7164-i2c.c
> @@ -42,7 +42,7 @@ static int i2c_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs, int num)
>                         retval = saa7164_api_i2c_read(bus,
>                                 msgs[i].addr,
>                                 0 /* reglen */,
> -                               0 /* reg */, msgs[i].len, msgs[i].buf);
> +                               NULL /* reg */, msgs[i].len, msgs[i].buf);
>                 } else if (i + 1 < num && (msgs[i + 1].flags & I2C_M_RD) &&
>                            msgs[i].addr == msgs[i + 1].addr) {
>                         /* write then read from same address */

Reviewed-By: Steven Toth <stoth@kernellabs.com>

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
