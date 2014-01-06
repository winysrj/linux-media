Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:58456 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaAFLsd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 06:48:33 -0500
Received: by mail-ob0-f181.google.com with SMTP id uy5so17817709obc.26
        for <linux-media@vger.kernel.org>; Mon, 06 Jan 2014 03:48:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1387885325-17639-1-git-send-email-sachin.kamat@linaro.org>
References: <1387885325-17639-1-git-send-email-sachin.kamat@linaro.org>
Date: Mon, 6 Jan 2014 17:18:33 +0530
Message-ID: <CAK9yfHyw8VM1oPKsVig3hKDqLG5qfXMAq9p0Fq2U9GiW_KcTBw@mail.gmail.com>
Subject: Re: [PATCH 1/3] [media] s5k5baf: Fix build warning
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media <linux-media@vger.kernel.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24 December 2013 17:12, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Fixes the following warnings:
> drivers/media/i2c/s5k5baf.c: In function 's5k5baf_fw_parse':
> drivers/media/i2c/s5k5baf.c:362:3: warning:
> format '%d' expects argument of type 'int', but argument 3 has type 'size_t' [-Wformat=]
> drivers/media/i2c/s5k5baf.c:383:4: warning:
> format '%d' expects argument of type 'int', but argument 4 has type 'size_t' [-Wformat=]
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> ---
>  drivers/media/i2c/s5k5baf.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
> index e3b44a87460b..139bdd4f5dde 100644
> --- a/drivers/media/i2c/s5k5baf.c
> +++ b/drivers/media/i2c/s5k5baf.c
> @@ -359,7 +359,7 @@ static int s5k5baf_fw_parse(struct device *dev, struct s5k5baf_fw **fw,
>         int ret;
>
>         if (count < S5K5BAG_FW_TAG_LEN + 1) {
> -               dev_err(dev, "firmware file too short (%d)\n", count);
> +               dev_err(dev, "firmware file too short (%zu)\n", count);
>                 return -EINVAL;
>         }
>
> @@ -379,7 +379,7 @@ static int s5k5baf_fw_parse(struct device *dev, struct s5k5baf_fw **fw,
>
>         f = (struct s5k5baf_fw *)d;
>         if (count < 1 + 2 * f->count) {
> -               dev_err(dev, "invalid firmware header (count=%d size=%d)\n",
> +               dev_err(dev, "invalid firmware header (count=%d size=%zu)\n",
>                         f->count, 2 * (count + S5K5BAG_FW_TAG_LEN));
>                 return -EINVAL;
>         }
> --
> 1.7.9.5
>

Gentle ping on this series :)

-- 
With warm regards,
Sachin
