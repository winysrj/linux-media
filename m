Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34759 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab3JDPeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 11:34:25 -0400
Received: by mail-pa0-f54.google.com with SMTP id kx10so4346083pab.27
        for <linux-media@vger.kernel.org>; Fri, 04 Oct 2013 08:34:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380895312-30863-5-git-send-email-hverkuil@xs4all.nl>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
	<1380895312-30863-5-git-send-email-hverkuil@xs4all.nl>
Date: Fri, 4 Oct 2013 11:34:25 -0400
Message-ID: <CAOcJUbz-fYRSrtzt+6e5fVwjB0NxF5HmYJWd4yoxdMELOUN2ng@mail.gmail.com>
Subject: Re: [PATCH 04/14] tuner-xs2028.c: fix sparse warnings
From: Michael Krufky <mkrufky@linuxtv.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 4, 2013 at 10:01 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> drivers/media/tuners/tuner-xc2028.c:575:24: warning: cast to restricted __le16
> drivers/media/tuners/tuner-xc2028.c:686:21: warning: cast to restricted __le16
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/tuners/tuner-xc2028.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
> index 878d2c4..e287a74 100644
> --- a/drivers/media/tuners/tuner-xc2028.c
> +++ b/drivers/media/tuners/tuner-xc2028.c
> @@ -572,7 +572,7 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
>                         return -EINVAL;
>                 }
>
> -               size = le16_to_cpu(*(__u16 *) p);
> +               size = le16_to_cpu(*(__le16 *) p);
>                 p += sizeof(size);
>
>                 if (size == 0xffff)
> @@ -683,7 +683,7 @@ static int load_scode(struct dvb_frontend *fe, unsigned int type,
>                 /* 16 SCODE entries per file; each SCODE entry is 12 bytes and
>                  * has a 2-byte size header in the firmware format. */
>                 if (priv->firm[pos].size != 14 * 16 || scode >= 16 ||
> -                   le16_to_cpu(*(__u16 *)(p + 14 * scode)) != 12)
> +                   le16_to_cpu(*(__le16 *)(p + 14 * scode)) != 12)
>                         return -EINVAL;
>                 p += 14 * scode + 2;
>         }
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
