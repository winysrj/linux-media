Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34982 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754943AbdCKSUo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 13:20:44 -0500
Subject: Re: [PATCH v5 21/39] UAPI: Add media UAPI Kbuild file
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-22-git-send-email-steve_longerbeam@mentor.com>
 <20170311134931.GP3220@valkosipuli.retiisi.org.uk>
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
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <184c02bf-782d-6dbe-e603-a82ac8dcc8b6@gmail.com>
Date: Sat, 11 Mar 2017 10:20:39 -0800
MIME-Version: 1.0
In-Reply-To: <20170311134931.GP3220@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/11/2017 05:49 AM, Sakari Ailus wrote:
> Hi Steve,
>
> On Thu, Mar 09, 2017 at 08:53:01PM -0800, Steve Longerbeam wrote:
>> Add an empty UAPI Kbuild file for media UAPI headers.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>
> The existing V4L2 UAPI headers are under include/uapi/linux. Could you use
> that directory instead?
>
> I actually wouldn't really object doing this but it should have been done in
> 2002 or so when the first V4L2 header was added. Now the benefit is
> questionable.
>

Agreed, I think the current headers should be moved to uapi/media
eventually, but for now I'll go ahead and put under uapi/linux.

Steve
