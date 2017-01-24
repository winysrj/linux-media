Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:39133 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdAXBqS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jan 2017 20:46:18 -0500
Subject: Re: [PATCH v3 16/24] media: Add i.MX media core driver
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-17-git-send-email-steve_longerbeam@mentor.com>
 <1484320822.31475.96.camel@pengutronix.de>
 <a94025b4-c4dd-de51-572e-d2615a7246e4@gmail.com>
 <1484574468.8415.136.camel@pengutronix.de>
 <e38feca9-ed6f-8288-e006-768d6ba2fe5a@gmail.com>
 <1485170006.2874.63.camel@pengutronix.de>
 <481289bb-424f-4ac4-66f1-7e1b4a0b7065@gmail.com>
CC: <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <shawnguo@kernel.org>, <kernel@pengutronix.de>,
        <fabio.estevam@nxp.com>, <linux@armlinux.org.uk>,
        <mchehab@kernel.org>, <hverkuil@xs4all.nl>, <nick@shmanahar.org>,
        <markus.heiser@darmarIT.de>,
        <laurent.pinchart+renesas@ideasonboard.com>, <bparrot@ti.com>,
        <geert@linux-m68k.org>, <arnd@arndb.de>,
        <sudipm.mukherjee@gmail.com>, <minghsiu.tsai@mediatek.com>,
        <tiffany.lin@mediatek.com>, <jean-christophe.trotin@st.com>,
        <horms+renesas@verge.net.au>,
        <niklas.soderlund+renesas@ragnatech.se>, <robert.jarzmik@free.fr>,
        <songjun.wu@microchip.com>, <andrew-ct.chen@mediatek.com>,
        <gregkh@linuxfoundation.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <devel@driverdev.osuosl.org>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <c6087342-f61f-0b4c-f67e-4239f861e974@mentor.com>
Date: Mon, 23 Jan 2017 17:45:59 -0800
MIME-Version: 1.0
In-Reply-To: <481289bb-424f-4ac4-66f1-7e1b4a0b7065@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/23/2017 05:38 PM, Steve Longerbeam wrote:
>
>>
>>> Second, ignoring the above locking issue for a moment,
>>> v4l2_pipeline_pm_use()
>>> will call s_power on the sensor _first_, then the mipi csi-2 s_power,
>>> when executing
>>> media-ctl -l '"ov5640 1-003c":0 -> "imx6-mipi-csi2":0[1]'. Which is the
>>> wrong order.
>>> In my version which enforces the correct power on order, the mipi csi-2
>>> s_power
>>> is called first in that link setup, followed by the sensor.
>> I don't understand why you want to power up subdevs as soon as the links
>> are established.
>
> Because that is the precedence, all other media drivers do pipeline
> power on/off at link_notify. And v4l2_pipeline_link_notify() was written
> as a link_notify method.
>
>>   Shouldn't that rather be done for all subdevices in the
>> pipeline when the corresponding capture device is opened?
>
> that won't work. There's no guarantee the links will be established
> at capture device open time.

ugh, maybe v4l2_pipeline_pm_use() would work at open/release. If there are
no links yet, it would basically be a no-op. And stream on requires 
opening the
device, and the pipeline links should be established by then, so this 
might be
fine, looking into this too.

Steve

>
>> It seems to me that powering up the pipeline should be the last step
>> before userspace actually starts the capture.
>
> Well, I'm ok with moving pipeline power on/off to start/stop streaming.
> I would actually prefer to do it then, I only chose at link_notify 
> because
> of precedence. I'll look into it.

