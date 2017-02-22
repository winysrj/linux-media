Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34943 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932578AbdBVRUQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 12:20:16 -0500
Subject: Re: [PATCH v4 12/36] add mux and video interface bridge entity
 functions
To: Pavel Machek <pavel@ucw.cz>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-13-git-send-email-steve_longerbeam@mentor.com>
 <20170219212812.GA28347@amd>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <1fdb3bb6-46fc-40d9-0011-3f53aa2ac899@gmail.com>
Date: Wed, 22 Feb 2017 09:19:27 -0800
MIME-Version: 1.0
In-Reply-To: <20170219212812.GA28347@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/19/2017 01:28 PM, Pavel Machek wrote:
> On Wed 2017-02-15 18:19:14, Steve Longerbeam wrote:
>> From: Philipp Zabel <p.zabel@pengutronix.de>
>>
>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>>
>> - renamed MEDIA_ENT_F_MUX to MEDIA_ENT_F_VID_MUX
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>
> This is slightly "interesting" format of changelog. Normally signoffs
> go below.
>
>> diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
>> index 3e03dc2..023be29 100644
>> --- a/Documentation/media/uapi/mediactl/media-types.rst
>> +++ b/Documentation/media/uapi/mediactl/media-types.rst
>> @@ -298,6 +298,28 @@ Types and flags used to represent the media graph elements
>>  	  received on its sink pad and outputs the statistics data on
>>  	  its source pad.
>>
>> +    -  ..  row 29
>> +
>> +       ..  _MEDIA-ENT-F-MUX:
>> +
>> +       -  ``MEDIA_ENT_F_MUX``
>
> And you probably want to rename it here, too.

Done, thanks.
Steve

>
> With that fixed:
>
> Reviewed-by: Pavel Machek <pavel@ucw.cz>
>
