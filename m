Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0087.outbound.protection.outlook.com ([104.47.32.87]:13344
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750774AbeC1XaB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 19:30:01 -0400
Subject: Re: [linux-sunxi] [PATCH v9 0/2] Initial Allwinner V3s CSI Support
To: yong.deng@magewell.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
References: <1520301070-48769-1-git-send-email-yong.deng@magewell.com>
From: Martin Kelly <mkelly@xevo.com>
Message-ID: <9b60dee0-2504-6ae3-fda3-64c4458025c3@xevo.com>
Date: Wed, 28 Mar 2018 16:29:47 -0700
MIME-Version: 1.0
In-Reply-To: <1520301070-48769-1-git-send-email-yong.deng@magewell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/05/2018 05:51 PM, Yong Deng wrote:
> This patchset add initial support for Allwinner V3s CSI.
> 
> Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> interface and CSI1 is used for parallel interface. This is not
> documented in datasheet but by test and guess.
> 
> This patchset implement a v4l2 framework driver and add a binding
> documentation for it.
> 
> Currently, the driver only support the parallel interface. And has been
> tested with a BT1120 signal which generating from FPGA. The following
> fetures are not support with this patchset:
>    - ISP
>    - MIPI-CSI2
>    - Master clock for camera sensor
>    - Power regulator for the front end IC
> 

Hi Yong,

Thanks so much, this driver is a great contribution!

Unfortunately the board I'm working with (nanopi neo air) uses the MIPI 
CSI-2 CSI0 interface rather than CSI1. Do you have any plans to support 
the MIPI CSI-2 interface at some point? If not, do you know the scope of 
what would be involved?
