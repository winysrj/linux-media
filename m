Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:39753 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbeLATNO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Dec 2018 14:13:14 -0500
Received: by mail-yw1-f67.google.com with SMTP id j6so3332949ywj.6
        for <linux-media@vger.kernel.org>; Sat, 01 Dec 2018 00:01:18 -0800 (PST)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id f10sm5184329ywb.26.2018.12.01.00.01.16
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Dec 2018 00:01:16 -0800 (PST)
Received: by mail-yb1-f181.google.com with SMTP id h187-v6so3248846ybg.10
        for <linux-media@vger.kernel.org>; Sat, 01 Dec 2018 00:01:16 -0800 (PST)
MIME-Version: 1.0
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com> <20181130192737.15053-9-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181130192737.15053-9-jarkko.sakkinen@linux.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Sat, 1 Dec 2018 00:01:04 -0800
Message-ID: <CAAFQd5De7sck9DoZHngd7PRM7ap8G_kO=9Bk0WpZVXjhyZhYig@mail.gmail.com>
Subject: Re: [PATCH RFC 08/15] media: replace **** with a hug
To: jarkko.sakkinen@linux.intel.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 30, 2018 at 11:28 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> In order to comply with the CoC, replace **** with a hug. In
> addition, fix a coding style issue (lines with over 80 chars).
>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  drivers/media/i2c/bt819.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/i2c/bt819.c b/drivers/media/i2c/bt819.c
> index 472e37637c8d..c0f198b764f0 100644
> --- a/drivers/media/i2c/bt819.c
> +++ b/drivers/media/i2c/bt819.c
> @@ -165,9 +165,11 @@ static int bt819_init(struct v4l2_subdev *sd)
>                 0x0f, 0x00,     /* 0x0f Hue control */
>                 0x12, 0x04,     /* 0x12 Output Format */
>                 0x13, 0x20,     /* 0x13 Vertial Scaling msb 0x00
> -                                          chroma comb OFF, line drop scaling, interlace scaling
> -                                          BUG? Why does turning the chroma comb on fuck up color?
> -                                          Bug in the bt819 stepping on my board?
> +                                          chroma comb OFF, line drop scaling,
> +                                          interlace scaling BUG? Why does
> +                                          turning the chroma comb on hug up

Putting the strong language aside, this comment could actually benefit
from rewording to make it convey more information about the problem.
For example, wouldn't

NOTE: The chroma comb causes a random color distortion on some boards
(stepping of the chip?).

be much more meaningful? I had to guess what f**king up was supposed
to mean here, which is obviously a problem with this comment. It could
be extended even more by mentioning what board and chip stepping it
was observed on.

Best regards,
Tomasz
