Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33595 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab2E3Tnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 May 2012 15:43:42 -0400
Received: by yhmm54 with SMTP id m54so191479yhm.19
        for <linux-media@vger.kernel.org>; Wed, 30 May 2012 12:43:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338059923-4989-1-git-send-email-volokh84@gmail.com>
References: <1338059923-4989-1-git-send-email-volokh84@gmail.com>
Date: Wed, 30 May 2012 16:43:41 -0300
Message-ID: <CALF0-+WUJO830rm277Eyo5SD6cD=c+=+4jGBN8aECDNFB0Z1Bw@mail.gmail.com>
Subject: Re: [PATCH 3/3] I don`t know for what, but there`s dublicate item.
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Volokh Konstantin <volokh84@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sat, May 26, 2012 at 4:18 PM, Volokh Konstantin <volokh84@gmail.com> wrote:
> Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
> ---
>  drivers/media/video/bt8xx/bttv-driver.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
> index e581b37..b4ee7de 100644
> --- a/drivers/media/video/bt8xx/bttv-driver.c
> +++ b/drivers/media/video/bt8xx/bttv-driver.c
> @@ -558,12 +558,6 @@ static const struct bttv_format formats[] = {
>                .depth    = 16,
>                .flags    = FORMAT_FLAGS_PACKED,
>        },{
> -               .name     = "4:2:2, packed, YUYV",
> -               .fourcc   = V4L2_PIX_FMT_YUYV,
> -               .btformat = BT848_COLOR_FMT_YUY2,
> -               .depth    = 16,
> -               .flags    = FORMAT_FLAGS_PACKED,
> -       },{
>                .name     = "4:2:2, packed, UYVY",
>                .fourcc   = V4L2_PIX_FMT_UYVY,
>                .btformat = BT848_COLOR_FMT_YUY2,
> --
> 1.7.7.6
>

The patch looks correct to me.

But the subject is *very* wrong. You should set it to something like:
"[bt8xx] Remove duplicated pixel format entry".

Also, the subject says [PATCH 3/3], where are the other patches?

As a newbie I used to do this kind of mistakes often. Now I try to let patches
sleep for a couple of days, and then review them once again before send them.

Also send them once to yourself before sending to the list,
so you get another chance to catch mistakes.

Hope it helps,
Ezequiel.
