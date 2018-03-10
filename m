Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:39838 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932150AbeCJPxr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Mar 2018 10:53:47 -0500
Received: by mail-ot0-f193.google.com with SMTP id h8so11446167oti.6
        for <linux-media@vger.kernel.org>; Sat, 10 Mar 2018 07:53:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1520081790-3437-2-git-send-email-festevam@gmail.com>
References: <1520081790-3437-1-git-send-email-festevam@gmail.com> <1520081790-3437-2-git-send-email-festevam@gmail.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Sat, 10 Mar 2018 12:53:46 -0300
Message-ID: <CAOMZO5AxTf=htB4_hMKR7R6tp7yLKdZnFdUOLm2GtJxNV20Z7w@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] media: imx-media-csi: Do not propagate the error
 when pinctrl is not found
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-media <linux-media@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sat, Mar 3, 2018 at 9:56 AM, Fabio Estevam <festevam@gmail.com> wrote:
> From: Fabio Estevam <fabio.estevam@nxp.com>
>
> Since commit 52e17089d185 ("media: imx: Don't initialize vars that
> won't be used") imx_csi_probe() fails to probe after propagating the
> devm_pinctrl_get_select_default() error.
>
> devm_pinctrl_get_select_default() may return -ENODEV when the CSI pinctrl
> entry is not found, so better not to propagate the error in the -ENODEV
> case to avoid a regression.
>
> Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
> Reviewed-by: Steve Longerbeam <steve_longerbeam@mentor.com>

A gentle ping.

This series fixes a regression on the imx-media-csi driver.

Thanks
