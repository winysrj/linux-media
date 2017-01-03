Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:53669 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752723AbdACUus (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 15:50:48 -0500
Subject: Re: [PATCH 00/20] i.MX Media Driver
To: Fabio Estevam <festevam@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <1483050455-10683-1-git-send-email-steve_longerbeam@mentor.com>
 <CAOMZO5DM4aRwzCWkRoZLmbCxn155YL+CUR_gJyDh+FjzSKD3PQ@mail.gmail.com>
CC: Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        <devel@driverdev.osuosl.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <183d9b6e-c195-128b-e74b-9103a3402dab@mentor.com>
Date: Tue, 3 Jan 2017 12:50:35 -0800
MIME-Version: 1.0
In-Reply-To: <CAOMZO5DM4aRwzCWkRoZLmbCxn155YL+CUR_gJyDh+FjzSKD3PQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,


On 01/02/2017 01:09 PM, Fabio Estevam wrote:
> Hi Steve,
>
> On Thu, Dec 29, 2016 at 8:27 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
>> This is a media driver for video capture on i.MX.
>>
>> Refer to Documentation/media/v4l-drivers/imx.rst for example capture
>> pipelines on SabreSD, SabreAuto, and SabreLite reference platforms.
>>
>> This patchset includes the OF graph layout as proposed by Philipp Zabel,
>> with only minor changes which are enumerated in the patch header.
> Patches 13, 14 and 19 miss your Signed-off-by tag.

thanks for catching. I've added them to version 2.

Steve

>
> Tested the whole series on a mx6qsabresd:
>
> Tested-by: Fabio Estevam <fabio.estevam@nxp.com>


