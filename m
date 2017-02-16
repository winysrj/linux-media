Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36813 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933081AbdBPSQW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 13:16:22 -0500
Subject: Re: [PATCH v4 28/36] media: imx: csi: fix crop rectangle changes in
 set_fmt
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-29-git-send-email-steve_longerbeam@mentor.com>
 <20170216110531.GJ27312@n2100.armlinux.org.uk>
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
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <8285778f-ea44-a968-d2d1-b1a286edbfd8@gmail.com>
Date: Thu, 16 Feb 2017 10:16:10 -0800
MIME-Version: 1.0
In-Reply-To: <20170216110531.GJ27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/16/2017 03:05 AM, Russell King - ARM Linux wrote:
> On Wed, Feb 15, 2017 at 06:19:30PM -0800, Steve Longerbeam wrote:
>> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
>> index ae24b42..3cb97e2 100644
>> --- a/drivers/staging/media/imx/imx-media-csi.c
>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>> @@ -531,6 +531,10 @@ static int csi_setup(struct csi_priv *priv)
>>
>>  	ipu_csi_set_window(priv->csi, &priv->crop);
>>
>> +	ipu_csi_set_downsize(priv->csi,
>> +			     priv->crop.width == 2 * outfmt->width,
>> +			     priv->crop.height == 2 * outfmt->height);
>> +
>
> This fails to build:
>
> ERROR: "ipu_csi_set_downsize" [drivers/staging/media/imx/imx-media-csi.ko] undefined!
>
> ipu_csi_set_downsize needs to be exported if we're going to use it in
> a module:
>

Yes I encountered the missing export too, forgot to mention it.
Philipp submitted a patch to dri-devel separately.

Steve
