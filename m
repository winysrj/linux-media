Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:36037 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbeACQlV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 11:41:21 -0500
MIME-Version: 1.0
In-Reply-To: <1514469681-15602-10-git-send-email-jacopo+renesas@jmondi.org>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org> <1514469681-15602-10-git-send-email-jacopo+renesas@jmondi.org>
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 3 Jan 2018 14:41:20 -0200
Message-ID: <CAOMZO5CjrXfzum7JgimGqvnM7kjMyZZdtpEhvYwO-DLnig=uMQ@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] media: i2c: tw9910: Remove soc_camera dependencies
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>, geert@glider.be,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        linux-sh@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Thu, Dec 28, 2017 at 12:01 PM, Jacopo Mondi
<jacopo+renesas@jmondi.org> wrote:

> +       if (priv->rstb_gpio) {
> +               gpiod_set_value(priv->rstb_gpio, 0);
> +               usleep_range(500, 1000);
> +               gpiod_set_value(priv->rstb_gpio, 1);
> +               usleep_range(500, 1000);

This seems to be inverted.

Consider you have an active low GPIO reset.

In order to reset it:

Put the GPIO to logic level 0
Wait some time
Put the GPIO to logic level 1

gpiod_set_value(priv->rstb_gpio, 1), means the GPIO in the active
state (0 in this example).

, so this should be:

gpiod_set_value(priv->rstb_gpio, 1);
usleep_range(500, 1000);
gpiod_set_value(priv->rstb_gpio, 0);
