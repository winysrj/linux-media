Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:43494 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbeLAFSn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Dec 2018 00:18:43 -0500
Received: by mail-yb1-f194.google.com with SMTP id h187-v6so2555272ybg.10
        for <linux-media@vger.kernel.org>; Fri, 30 Nov 2018 10:08:37 -0800 (PST)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id a72sm2491933ywh.42.2018.11.30.10.08.35
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Nov 2018 10:08:35 -0800 (PST)
Received: by mail-yb1-f170.google.com with SMTP id h187-v6so2555233ybg.10
        for <linux-media@vger.kernel.org>; Fri, 30 Nov 2018 10:08:35 -0800 (PST)
MIME-Version: 1.0
References: <1543291261-26174-1-git-send-email-bingbu.cao@intel.com>
In-Reply-To: <1543291261-26174-1-git-send-email-bingbu.cao@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 30 Nov 2018 10:08:23 -0800
Message-ID: <CAAFQd5Dzk2AxMXA+QUFJ+LqRudVe6T6-tt2wY1q4Zpw2Hhhhrw@mail.gmail.com>
Subject: Re: [PATCH] media: unify some sony camera sensors pattern naming
To: Cao Bing Bu <bingbu.cao@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>, bingbu.cao@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bingbu,

On Mon, Nov 26, 2018 at 7:56 PM <bingbu.cao@intel.com> wrote:
>
> From: Bingbu Cao <bingbu.cao@intel.com>
>
> Some Sony camera sensors have same test pattern
> definitions, this patch unify the pattern naming
> to make it more clear to the userspace.
>
> Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> ---
>  drivers/media/i2c/imx258.c | 8 ++++----
>  drivers/media/i2c/imx319.c | 8 ++++----
>  drivers/media/i2c/imx355.c | 8 ++++----
>  3 files changed, 12 insertions(+), 12 deletions(-)
>

Thanks for the patch! One comment inline.

> diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
> index 31a1e2294843..a8a2880c6b4e 100644
> --- a/drivers/media/i2c/imx258.c
> +++ b/drivers/media/i2c/imx258.c
> @@ -504,10 +504,10 @@ struct imx258_mode {
>
>  static const char * const imx258_test_pattern_menu[] = {
>         "Disabled",
> -       "Color Bars",
> -       "Solid Color",
> -       "Grey Color Bars",
> -       "PN9"
> +       "Solid Colour",
> +       "Eight Vertical Colour Bars",

Is it just me or "solid color" and "color bars" are being swapped
here? Did the driver had the names mixed up before or the order of
modes is different between these sensors?

Best regards,
Tomasz
