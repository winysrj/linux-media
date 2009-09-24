Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:42139 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZIXSqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2009 14:46:03 -0400
Received: by ey-out-2122.google.com with SMTP id d26so451162eyd.19
        for <linux-media@vger.kernel.org>; Thu, 24 Sep 2009 11:46:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090922210500.GA8661@systol-ng.god.lan>
References: <20090922210500.GA8661@systol-ng.god.lan>
Date: Thu, 24 Sep 2009 14:46:06 -0400
Message-ID: <37219a840909241146q72af5395hc028b91b6a97ada1@mail.gmail.com>
Subject: Re: [PATCH 1/4] tda18271_set_analog_params major bugfix
From: Michael Krufky <mkrufky@kernellabs.com>
To: Henk.Vergonet@gmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 22, 2009 at 5:05 PM,  <spam@systol-ng.god.lan> wrote:
>
> Multiplication by 62500 causes an overflow in the 32 bits "freq" register when
> using radio. FM radio reception on a Zolid Hybrid PCI is now working. Other
> tda18271 configurations may also benefit from this change ;)
>
> Signed-off-by: Henk.Vergonet@gmail.com
>
> diff -r 29e4ba1a09bc linux/drivers/media/common/tuners/tda18271-fe.c
> --- a/linux/drivers/media/common/tuners/tda18271-fe.c   Sat Sep 19 09:45:22 2009 -0300
> +++ b/linux/drivers/media/common/tuners/tda18271-fe.c   Tue Sep 22 22:06:31 2009 +0200
> @@ -1001,38 +1020,43 @@
>        struct tda18271_std_map_item *map;
>        char *mode;
>        int ret;
> -       u32 freq = params->frequency * 62500;
> +       u32 freq;
>
>        priv->mode = TDA18271_ANALOG;
>
>        if (params->mode == V4L2_TUNER_RADIO) {
> -               freq = freq / 1000;
> +               freq = params->frequency * 625;
> +               freq = freq / 10;
>                map = &std_map->fm_radio;
>                mode = "fm";
> -       } else if (params->std & V4L2_STD_MN) {
> -               map = &std_map->atv_mn;
> -               mode = "MN";
> -       } else if (params->std & V4L2_STD_B) {
> -               map = &std_map->atv_b;
> -               mode = "B";
> -       } else if (params->std & V4L2_STD_GH) {
> -               map = &std_map->atv_gh;
> -               mode = "GH";
> -       } else if (params->std & V4L2_STD_PAL_I) {
> -               map = &std_map->atv_i;
> -               mode = "I";
> -       } else if (params->std & V4L2_STD_DK) {
> -               map = &std_map->atv_dk;
> -               mode = "DK";
> -       } else if (params->std & V4L2_STD_SECAM_L) {
> -               map = &std_map->atv_l;
> -               mode = "L";
> -       } else if (params->std & V4L2_STD_SECAM_LC) {
> -               map = &std_map->atv_lc;
> -               mode = "L'";
>        } else {
> -               map = &std_map->atv_i;
> -               mode = "xx";
> +               freq = params->frequency * 62500;
> +
> +               if (params->std & V4L2_STD_MN) {
> +                       map = &std_map->atv_mn;
> +                       mode = "MN";
> +               } else if (params->std & V4L2_STD_B) {
> +                       map = &std_map->atv_b;
> +                       mode = "B";
> +               } else if (params->std & V4L2_STD_GH) {
> +                       map = &std_map->atv_gh;
> +                       mode = "GH";
> +               } else if (params->std & V4L2_STD_PAL_I) {
> +                       map = &std_map->atv_i;
> +                       mode = "I";
> +               } else if (params->std & V4L2_STD_DK) {
> +                       map = &std_map->atv_dk;
> +                       mode = "DK";
> +               } else if (params->std & V4L2_STD_SECAM_L) {
> +                       map = &std_map->atv_l;
> +                       mode = "L";
> +               } else if (params->std & V4L2_STD_SECAM_LC) {
> +                       map = &std_map->atv_lc;
> +                       mode = "L'";
> +               } else {
> +                       map = &std_map->atv_i;
> +                       mode = "xx";
> +               }
>        }
>
>        tda_dbg("setting tda18271 to system %s\n", mode);
>

Nice catch, Henk -- Thank you for this fix...  I will have this one
merged as soon as I can.

Signed-off-by: Michael Krufky <mkrufky@kernellabs.com>

Mauro, please do not merge the tda18271 / tda829x patches until I send
you a pull request -- there is a patch-order dependency with other
pending changes and I would prefer to send this to you in the proper
order.

Thanks,

Mike Krufky
