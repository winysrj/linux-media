Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:43800 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbeACR1y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 12:27:54 -0500
MIME-Version: 1.0
In-Reply-To: <20180103171347.GF9493@w540>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org>
 <1514469681-15602-10-git-send-email-jacopo+renesas@jmondi.org>
 <CAOMZO5CjrXfzum7JgimGqvnM7kjMyZZdtpEhvYwO-DLnig=uMQ@mail.gmail.com> <20180103171347.GF9493@w540>
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 3 Jan 2018 15:27:53 -0200
Message-ID: <CAOMZO5Biwbwct_vBD3zXyFvFgW00JxVnFoDcQthARVLxdqPYhA@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] media: i2c: tw9910: Remove soc_camera dependencies
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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

On Wed, Jan 3, 2018 at 3:13 PM, jacopo mondi <jacopo@jmondi.org> wrote:

> That would be true if I would have declared the GPIO to be ACTIVE_LOW.
> See patch [5/9] in this series and search for "rstb". The GPIO (which
> is shared between two devices) is said to be active high...

Just looked at your patch 5/9 and it seems it only works because you
made two inversions :-)

Initially the rest GPIO was doing:

-       gpio_set_value(GPIO_PTT3, 0);
-       mdelay(10);
-       gpio_set_value(GPIO_PTT3, 1);
-       mdelay(10); /* wait to let chip come out of reset */

So this is an active low reset.

So you should have converted it to:

GPIO_LOOKUP("sh7722_pfc", GPIO_PTT3, "rstb", GPIO_ACTIVE_LOW),

and then in this patch you should do as I said earlier:

gpiod_set_value(priv->rstb_gpio, 1);
usleep_range(500, 1000);
gpiod_set_value(priv->rstb_gpio, 0);
