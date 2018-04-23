Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f180.google.com ([74.125.82.180]:37126 "EHLO
        mail-ot0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755495AbeDWOLF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 10:11:05 -0400
MIME-Version: 1.0
In-Reply-To: <20180419110056.10342-2-rui.silva@linaro.org>
References: <20180419110056.10342-1-rui.silva@linaro.org> <20180419110056.10342-2-rui.silva@linaro.org>
From: Fabio Estevam <festevam@gmail.com>
Date: Mon, 23 Apr 2018 11:11:03 -0300
Message-ID: <CAOMZO5A3+WMu+U5STP-z3qdXnUQN2yTJne2OV9-SrEs70JJyDA@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] media: ov2680: dt: Add bindings for OV2680
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rui,

On Thu, Apr 19, 2018 at 8:00 AM, Rui Miguel Silva <rui.silva@linaro.org> wrote:

> +Optional Properties:
> +- powerdown-gpios: reference to the GPIO connected to the powerdown pin,
> +                    if any. This is an active high signal to the OV2680.

I looked at the OV2680 datasheet and I see a pin called XSHUTDN, which has
the following description:

XSHUTDN: reset and power down (active low with internal pull down resistor)

So it should be active low, not active high.
