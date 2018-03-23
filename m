Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:48326 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752192AbeCWNKU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 09:10:20 -0400
Subject: Re: [PATCH v3 2/2] media: imx-media-csi: Do not propagate the error
 when pinctrl is not found
To: Fabio Estevam <festevam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-media <linux-media@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
References: <1520081790-3437-1-git-send-email-festevam@gmail.com>
 <1520081790-3437-2-git-send-email-festevam@gmail.com>
 <CAOMZO5AxTf=htB4_hMKR7R6tp7yLKdZnFdUOLm2GtJxNV20Z7w@mail.gmail.com>
 <CAOMZO5AMDpcPumGr9e_VxQQZQ5fDc0V=rEBMadqAbocZgDgyRg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2d0b4561-664f-ab5e-4e71-28a74875a609@xs4all.nl>
Date: Fri, 23 Mar 2018 14:10:14 +0100
MIME-Version: 1.0
In-Reply-To: <CAOMZO5AMDpcPumGr9e_VxQQZQ5fDc0V=rEBMadqAbocZgDgyRg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/23/18 14:03, Fabio Estevam wrote:
> Hi Mauro and Hans,
> 
> On Sat, Mar 10, 2018 at 12:53 PM, Fabio Estevam <festevam@gmail.com> wrote:
>> Hi,
>>
>> On Sat, Mar 3, 2018 at 9:56 AM, Fabio Estevam <festevam@gmail.com> wrote:
>>> From: Fabio Estevam <fabio.estevam@nxp.com>
>>>
>>> Since commit 52e17089d185 ("media: imx: Don't initialize vars that
>>> won't be used") imx_csi_probe() fails to probe after propagating the
>>> devm_pinctrl_get_select_default() error.
>>>
>>> devm_pinctrl_get_select_default() may return -ENODEV when the CSI pinctrl
>>> entry is not found, so better not to propagate the error in the -ENODEV
>>> case to avoid a regression.
>>>
>>> Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
>>> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
>>> Reviewed-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>
>> A gentle ping.
>>
>> This series fixes a regression on the imx-media-csi driver.
> 
> Could you please consider applying this series that fixes the probe of
> the imx-media-csi driver?

It's delegated to Sakari.

Sakari, if you're busy then just let me know and I can take it.

Regards,

	Hans
