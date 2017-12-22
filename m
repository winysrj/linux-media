Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39327 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752485AbdLVNlT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Dec 2017 08:41:19 -0500
Received: by mail-wm0-f68.google.com with SMTP id i11so21680916wmf.4
        for <linux-media@vger.kernel.org>; Fri, 22 Dec 2017 05:41:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171222102156.cfemen6ouxxxbrem@plaes.org>
References: <1513936020-35569-1-git-send-email-yong.deng@magewell.com> <20171222102156.cfemen6ouxxxbrem@plaes.org>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Fri, 22 Dec 2017 14:40:37 +0100
Message-ID: <CAOFm3uEfD4G2cLWNBhtB0tfD0A0e47div0RNGFioNCm-b108bg@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v4 2/2] media: V3s: Add support for
 Allwinner CSI.
To: Yong Deng <yong.deng@magewell.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
        <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com, Priit Laes <plaes@plaes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yong,

On Fri, Dec 22, 2017 at 11:21 AM, Priit Laes <plaes@plaes.org> wrote:
> On Fri, Dec 22, 2017 at 05:47:00PM +0800, Yong Deng wrote:
>> Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
>> and CSI1 is used for parallel interface. This is not documented in
>> datasheet but by testing and guess.
>>
>> This patch implement a v4l2 framework driver for it.
>>
>> Currently, the driver only support the parallel interface. MIPI-CSI2,
>> ISP's support are not included in this patch.
>>
>> Signed-off-by: Yong Deng <yong.deng@magewell.com>

<snip>

>> --- /dev/null
>> +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
>> @@ -0,0 +1,878 @@
>> +/*
>> + * Copyright (c) 2017 Magewell Electronics Co., Ltd. (Nanjing).
>> + * All rights reserved.
>> + * Author: Yong Deng <yong.deng@magewell.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */


Would you mind using the new SPDX tags documented in Thomas patch set
[1] rather than this fine but longer legalese?

>> +MODULE_LICENSE("GPL v2");

Per module.h this means GPL2 only. This is not matching your top
license above which is GPL2 or later.
Please  make sure your MODULE_LICENSE is consistent with the top level license.


[1] https://lkml.org/lkml/2017/12/4/934

--
Cordially
Philippe Ombredanne
