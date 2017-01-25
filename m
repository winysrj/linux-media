Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34217 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750984AbdAYCjd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jan 2017 21:39:33 -0500
Subject: Re: [PATCH v3 19/24] media: imx: Add IC subdev drivers
To: Hans Verkuil <hverkuil@xs4all.nl>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-20-git-send-email-steve_longerbeam@mentor.com>
 <07f4bc9e-22ef-a925-f4ee-c14df65e4f0d@xs4all.nl>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <aa230b31-39f0-524d-3ce5-05827360ea95@gmail.com>
Date: Tue, 24 Jan 2017 18:39:30 -0800
MIME-Version: 1.0
In-Reply-To: <07f4bc9e-22ef-a925-f4ee-c14df65e4f0d@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/20/2017 06:29 AM, Hans Verkuil wrote:
> On 01/07/2017 03:11 AM, Steve Longerbeam wrote:
>> +
>> +static const struct v4l2_ctrl_config prpenc_std_ctrl[] = {
>> +	{
>> +		.id = V4L2_CID_HFLIP,
>> +		.name = "Horizontal Flip",
>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
>> +		.def =  0,
>> +		.min =  0,
>> +		.max =  1,
>> +		.step = 1,
>> +	}, {
>> +		.id = V4L2_CID_VFLIP,
>> +		.name = "Vertical Flip",
>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
>> +		.def =  0,
>> +		.min =  0,
>> +		.max =  1,
>> +		.step = 1,
>> +	}, {
>> +		.id = V4L2_CID_ROTATE,
>> +		.name = "Rotation",
>> +		.type = V4L2_CTRL_TYPE_INTEGER,
>> +		.def =   0,
>> +		.min =   0,
>> +		.max = 270,
>> +		.step = 90,
>> +	},
>> +};
> Use v4l2_ctrl_new_std() instead of this array: this avoids duplicating information
> like the name and type.
>
> If this is also done elsewhere, then it should be changed there as well.

done.

Steve

