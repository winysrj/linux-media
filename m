Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:46697 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbeCWND5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 09:03:57 -0400
Received: by mail-ot0-f196.google.com with SMTP id g97-v6so13119678otg.13
        for <linux-media@vger.kernel.org>; Fri, 23 Mar 2018 06:03:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5AxTf=htB4_hMKR7R6tp7yLKdZnFdUOLm2GtJxNV20Z7w@mail.gmail.com>
References: <1520081790-3437-1-git-send-email-festevam@gmail.com>
 <1520081790-3437-2-git-send-email-festevam@gmail.com> <CAOMZO5AxTf=htB4_hMKR7R6tp7yLKdZnFdUOLm2GtJxNV20Z7w@mail.gmail.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Fri, 23 Mar 2018 10:03:55 -0300
Message-ID: <CAOMZO5AMDpcPumGr9e_VxQQZQ5fDc0V=rEBMadqAbocZgDgyRg@mail.gmail.com>
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

Hi Mauro and Hans,

On Sat, Mar 10, 2018 at 12:53 PM, Fabio Estevam <festevam@gmail.com> wrote:
> Hi,
>
> On Sat, Mar 3, 2018 at 9:56 AM, Fabio Estevam <festevam@gmail.com> wrote:
>> From: Fabio Estevam <fabio.estevam@nxp.com>
>>
>> Since commit 52e17089d185 ("media: imx: Don't initialize vars that
>> won't be used") imx_csi_probe() fails to probe after propagating the
>> devm_pinctrl_get_select_default() error.
>>
>> devm_pinctrl_get_select_default() may return -ENODEV when the CSI pinctrl
>> entry is not found, so better not to propagate the error in the -ENODEV
>> case to avoid a regression.
>>
>> Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
>> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
>> Reviewed-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>
> A gentle ping.
>
> This series fixes a regression on the imx-media-csi driver.

Could you please consider applying this series that fixes the probe of
the imx-media-csi driver?

Thanks
