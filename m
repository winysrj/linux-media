Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:50849 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732169AbeHBO3B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Aug 2018 10:29:01 -0400
Subject: Re: [PATCH v6 00/13] media: staging/imx7: add i.MX7 media driver
To: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>, linux-clk@vger.kernel.org
References: <20180522145245.3143-1-rui.silva@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <267173c9-7235-6008-7248-ee06c0db3780@xs4all.nl>
Date: Thu, 2 Aug 2018 14:37:54 +0200
MIME-Version: 1.0
In-Reply-To: <20180522145245.3143-1-rui.silva@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rui,

On 05/22/18 16:52, Rui Miguel Silva wrote:
> Hi,
> This series introduces the Media driver to work with the i.MX7 SoC. it uses the
> already existing imx media core drivers but since the i.MX7, contrary to
> i.MX5/6, do not have an IPU and because of that some changes in the imx media
> core are made along this series to make it support that case.
> 
> This patches adds CSI and MIPI-CSI2 drivers for i.MX7, along with several
> configurations changes for this to work as a capture subsystem. Some bugs are
> also fixed along the line. And necessary documentation.
> 
> For a more detailed view of the capture paths, pads links in the i.MX7 please
> take a look at the documentation in PATCH 14.
> 
> The system used to test and develop this was the Warp7 board with an OV2680
> sensor, which output format is 10-bit bayer. So, only MIPI interface was
> tested, a scenario with an parallel input would nice to have.
> 
> *Important note*, this code depends on Steve Longerbeam series [0]:
> [PATCH v4 00/13] media: imx: Switch to subdev notifiers
> which the merging status is not clear to me, but the changes in there make
> senses to this series
> 
> Bellow goes an example of the output of the pads and links and the output of
> v4l2-compliance testing.
> 
> The v4l-utils version used is:
> v4l2-compliance SHA   : 47d43b130dc6e9e0edc900759fb37649208371e4 from Apr 4th.
> 
> The Media Driver fail some tests but this failures are coming from code out of
> scope of this series (video-mux, imx-capture), and some from the sensor OV2680
> but that I think not related with the sensor driver but with the testing and
> core.
> 
> The csi and mipi-csi entities pass all compliance tests.
> 
> Cheers,
>     Rui
> 
> [0]: https://www.mail-archive.com/linux-media@vger.kernel.org/msg131186.html

This patch series was delayed quite a bit since the patch series above
it depends on is still not merged.

But the v6 version of that series will be merged once the 4.20 cycle opens:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg133391.html

Sakari has a branch with that series on top of the latest media_tree master:
https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-fwnode

Can you rebase this imx7 series on top of that? And test it again with the
*latest* v4l2-compliance? (I've added new checks recently, so you need to
update this utility)

Please post the output of the v4l2-compliance test (after fixing any issues
it raises of course), either as a reply to this post or in the cover letter
of a v7 version of this series if you had to make changes.

This should expedite merging this series for 4.20.

Thanks!

	Hans
