Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:56987 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752522AbeEOPfj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 11:35:39 -0400
Subject: Re: [PATCH v2 5/5] media: platform: Add Chrome OS EC CEC driver
To: Neil Armstrong <narmstrong@baylibre.com>, airlied@linux.ie,
        hans.verkuil@cisco.com, lee.jones@linaro.org, olof@lixom.net,
        seanpaul@google.com
Cc: sadolfsson@google.com, felixe@google.com, bleung@google.com,
        darekm@google.com, marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1526395342-15481-1-git-send-email-narmstrong@baylibre.com>
 <1526395342-15481-6-git-send-email-narmstrong@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ec0506cf-2c7a-ebb6-3f40-2dffd30367f2@xs4all.nl>
Date: Tue, 15 May 2018 17:35:34 +0200
MIME-Version: 1.0
In-Reply-To: <1526395342-15481-6-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/15/2018 04:42 PM, Neil Armstrong wrote:
> The Chrome OS Embedded Controller can expose a CEC bus, this patch add the
> driver for such feature of the Embedded Controller.
> 
> This driver is part of the cros-ec MFD and will be add as a sub-device when
> the feature bit is exposed by the EC.
> 
> The controller will only handle a single logical address and handles
> all the messages retries and will only expose Success or Error.
> 
> The controller will be tied to the HDMI CEC notifier by using the platform
> DMI Data and the i915 device name and connector name.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---

<snip>

> +static SIMPLE_DEV_PM_OPS(cros_ec_cec_pm_ops,
> +	cros_ec_cec_suspend, cros_ec_cec_resume);
> +
> +/*
> + * The Firmware only handles single CEC interface tied to a single HDMI

single CEC -> a single CEC

> + * connector we specify along the DRM device name handling the HDMI output

along -> along with

> + */
> +
> +struct cec_dmi_match {
> +	char *sys_vendor;
> +	char *product_name;
> +	char *devname;
> +	char *conn;
> +};
> +

Looks good!

Regards,

	Hans
