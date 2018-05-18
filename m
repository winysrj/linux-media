Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:41652 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbeERNlM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 09:41:12 -0400
MIME-Version: 1.0
In-Reply-To: <1526648704-16873-5-git-send-email-narmstrong@baylibre.com>
References: <1526648704-16873-1-git-send-email-narmstrong@baylibre.com> <1526648704-16873-5-git-send-email-narmstrong@baylibre.com>
From: Enric Balletbo Serra <eballetbo@gmail.com>
Date: Fri, 18 May 2018 15:41:10 +0200
Message-ID: <CAFqH_539y6jGjfvY4rc0-dzz_z9VSf75igRmf3zNUz1sGgWYuw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] mfd: cros_ec_dev: Add CEC sub-device registration
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: David Airlie <airlied@linux.ie>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lee Jones <lee.jones@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Sean Paul <seanpaul@google.com>, sadolfsson@google.com,
        Felix Ekblom <felixe@google.com>,
        Benson Leung <bleung@google.com>, darekm@google.com,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        Fabien Parent <fparent@baylibre.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-05-18 15:05 GMT+02:00 Neil Armstrong <narmstrong@baylibre.com>:
> The EC can expose a CEC bus, thus add the cros-ec-cec MFD sub-device
> when the CEC feature bit is present.
>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  drivers/mfd/cros_ec_dev.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/drivers/mfd/cros_ec_dev.c b/drivers/mfd/cros_ec_dev.c
> index 1d6dc5c..272969e 100644
> --- a/drivers/mfd/cros_ec_dev.c
> +++ b/drivers/mfd/cros_ec_dev.c
> @@ -383,6 +383,10 @@ static void cros_ec_sensors_register(struct cros_ec_dev *ec)
>         kfree(msg);
>  }
>
> +static const struct mfd_cell cros_ec_cec_cells[] = {
> +       { .name = "cros-ec-cec" }
> +};
> +
>  static const struct mfd_cell cros_ec_rtc_cells[] = {
>         { .name = "cros-ec-rtc" }
>  };
> @@ -426,6 +430,18 @@ static int ec_device_probe(struct platform_device *pdev)
>         if (cros_ec_check_features(ec, EC_FEATURE_MOTION_SENSE))
>                 cros_ec_sensors_register(ec);
>
> +       /* Check whether this EC instance has CEC host command support */
> +       if (cros_ec_check_features(ec, EC_FEATURE_CEC)) {
> +               retval = mfd_add_devices(ec->dev, PLATFORM_DEVID_AUTO,
> +                                        cros_ec_cec_cells,
> +                                        ARRAY_SIZE(cros_ec_cec_cells),
> +                                        NULL, 0, NULL);
> +               if (retval)
> +                       dev_err(ec->dev,
> +                               "failed to add cros-ec-cec device: %d\n",
> +                               retval);
> +       }
> +
>         /* Check whether this EC instance has RTC host command support */
>         if (cros_ec_check_features(ec, EC_FEATURE_RTC)) {
>                 retval = mfd_add_devices(ec->dev, PLATFORM_DEVID_AUTO,
> --
> 2.7.4
>

Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>

Thanks,
 Enric
