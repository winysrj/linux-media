Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0046.outbound.protection.outlook.com ([104.47.38.46]:25568
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751230AbeC2R25 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 13:28:57 -0400
Subject: Re: [linux-sunxi] [PATCH v9 0/2] Initial Allwinner V3s CSI Support
To: yong.deng@magewell.com
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
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
 <9b60dee0-2504-6ae3-fda3-64c4458025c3@xevo.com>
 <20180329090256.e9621262cf069c475a706087@magewell.com>
From: Martin Kelly <mkelly@xevo.com>
Message-ID: <a6205796-ee42-1ecc-dfaa-74c196bcadd1@xevo.com>
Date: Thu, 29 Mar 2018 10:28:43 -0700
MIME-Version: 1.0
In-Reply-To: <20180329090256.e9621262cf069c475a706087@magewell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/28/2018 06:02 PM, Yong wrote:
> 
> AFAIK, there is no document about MIPI CSI-2. You can take a look at the
> source code in BSP:
> https://github.com/friendlyarm/h3_lichee/tree/master/linux-3.4/drivers/media/video/sunxi-vfe/mipi_csi
> And try to port it to mainline.
> 

Yep, I see there's lots of magic constants in that code. I might try to 
forward-port it, but it won't be very maintainable or easy to change 
without a datasheet. That's too bad.

Thanks for the information, Yong.
