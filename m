Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:40961 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756694AbdLPTct (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 14:32:49 -0500
MIME-Version: 1.0
In-Reply-To: <1510253136-14153-4-git-send-email-tharvey@gateworks.com>
References: <1510253136-14153-1-git-send-email-tharvey@gateworks.com> <1510253136-14153-4-git-send-email-tharvey@gateworks.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Sat, 16 Dec 2017 17:32:47 -0200
Message-ID: <CAOMZO5BUyF_E3aQByD2=4CxB-+DP189QAXMUA=AgOnq99wzmRg@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 3/5] media: i2c: Add TDA1997x HDMI receiver driver
To: Tim Harvey <tharvey@gateworks.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Shawn Guo <shawnguo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

On Thu, Nov 9, 2017 at 4:45 PM, Tim Harvey <tharvey@gateworks.com> wrote:

> +static int tda1997x_set_power(struct tda1997x_state *state, bool on)
> +{
> +       int ret = 0;
> +
> +       if (on) {
> +               ret = regulator_bulk_enable(TDA1997X_NUM_SUPPLIES,
> +                                            state->supplies);
> +               msleep(300);

Didn't you miss a 'return ret' here?

Otherwise regulator_bulk_disable() will always be called below.

> +       }
> +
> +       ret = regulator_bulk_disable(TDA1997X_NUM_SUPPLIES,
> +                              state->supplies);
> +       return ret;
> +}
