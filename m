Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35309 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752830AbdBASwj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 13:52:39 -0500
Subject: Re: [PATCH v3 18/24] media: imx: Add SMFC subdev driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-19-git-send-email-steve_longerbeam@mentor.com>
 <20170201183918.GP27312@n2100.armlinux.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <af7f27be-827d-548f-5b26-1e987069a6c0@gmail.com>
Date: Wed, 1 Feb 2017 10:52:35 -0800
MIME-Version: 1.0
In-Reply-To: <20170201183918.GP27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/01/2017 10:39 AM, Russell King - ARM Linux wrote:
> Hi Steve,
>
> On Fri, Jan 06, 2017 at 06:11:36PM -0800, Steve Longerbeam wrote:
>> +/*
>> + * Min/Max supported width and heights.
>> + *
>> + * We allow planar output from the SMFC, so we have to align
>> + * output width by 16 pixels to meet IDMAC alignment requirements,
>> + * which also means input width must have the same alignment.
>> + */
>> +#define MIN_W       176
>> +#define MIN_H       144
>> +#define MAX_W      8192
>> +#define MAX_H      4096
>> +#define W_ALIGN    4 /* multiple of 16 pixels */
> Does this only apply to planar formats?
>
> I notice Philipp's driver allows 8 pixel alignment.  If it's only for
> planar formats, it ought to determine the alignment based on the
> requested format rather than hard-coding it to the maximum alignment
> of all the supported formats.

yeah, I got lazy/tired there. I will fix this.

Steve

