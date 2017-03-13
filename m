Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:33363 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751144AbdCMJzh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 05:55:37 -0400
Subject: Re: [PATCH v5 21/39] UAPI: Add media UAPI Kbuild file
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-22-git-send-email-steve_longerbeam@mentor.com>
 <20170311134931.GP3220@valkosipuli.retiisi.org.uk>
 <184c02bf-782d-6dbe-e603-a82ac8dcc8b6@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a1e9f0b2-0dff-db5e-a2a3-5b34230fb1c3@xs4all.nl>
Date: Mon, 13 Mar 2017 10:55:19 +0100
MIME-Version: 1.0
In-Reply-To: <184c02bf-782d-6dbe-e603-a82ac8dcc8b6@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/2017 07:20 PM, Steve Longerbeam wrote:
> 
> 
> On 03/11/2017 05:49 AM, Sakari Ailus wrote:
>> Hi Steve,
>>
>> On Thu, Mar 09, 2017 at 08:53:01PM -0800, Steve Longerbeam wrote:
>>> Add an empty UAPI Kbuild file for media UAPI headers.
>>>
>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>
>> The existing V4L2 UAPI headers are under include/uapi/linux. Could you use
>> that directory instead?
>>
>> I actually wouldn't really object doing this but it should have been done in
>> 2002 or so when the first V4L2 header was added. Now the benefit is
>> questionable.
>>
> 
> Agreed, I think the current headers should be moved to uapi/media
> eventually, but for now I'll go ahead and put under uapi/linux.

No, while in staging it shouldn't be exported.

Put it in include/linux and move it to uapi when this driver is mainlined.

I don't think we can move headers from uapi/linux to uapi/media, I'm sure it's
too late for that.

Regards,

	Hans
