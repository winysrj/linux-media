Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:60498 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752095AbdCMXhZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 19:37:25 -0400
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steve Longerbeam <slongerbeam@gmail.com>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170310201356.GA21222@n2100.armlinux.org.uk>
 <47542ef8-3e91-b4cd-cc65-95000105f172@gmail.com>
 <20170312195741.GS21222@n2100.armlinux.org.uk>
 <ea3ccdb8-903f-93ab-6875-90da440fc52a@gmail.com>
 <20170312202240.GT21222@n2100.armlinux.org.uk>
 <f1807742-012f-249e-1ad8-22d8434695cb@gmail.com>
 <20170313081625.GX21222@n2100.armlinux.org.uk>
CC: <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <shawnguo@kernel.org>, <kernel@pengutronix.de>,
        <fabio.estevam@nxp.com>, <mchehab@kernel.org>,
        <hverkuil@xs4all.nl>, <nick@shmanahar.org>,
        <markus.heiser@darmarIT.de>, <p.zabel@pengutronix.de>,
        <laurent.pinchart+renesas@ideasonboard.com>, <bparrot@ti.com>,
        <geert@linux-m68k.org>, <arnd@arndb.de>,
        <sudipm.mukherjee@gmail.com>, <minghsiu.tsai@mediatek.com>,
        <tiffany.lin@mediatek.com>, <jean-christophe.trotin@st.com>,
        <horms+renesas@verge.net.au>,
        <niklas.soderlund+renesas@ragnatech.se>, <robert.jarzmik@free.fr>,
        <songjun.wu@microchip.com>, <andrew-ct.chen@mediatek.com>,
        <gregkh@linuxfoundation.org>, <shuah@kernel.org>,
        <sakari.ailus@linux.intel.com>, <pavel@ucw.cz>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <devel@driverdev.osuosl.org>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <faf90d92-63d8-e5b6-df0f-de0c5a44de33@mentor.com>
Date: Mon, 13 Mar 2017 16:37:06 -0700
MIME-Version: 1.0
In-Reply-To: <20170313081625.GX21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/13/2017 01:16 AM, Russell King - ARM Linux wrote:
> On Sun, Mar 12, 2017 at 09:26:41PM -0700, Steve Longerbeam wrote:
>> On 03/12/2017 01:22 PM, Russell King - ARM Linux wrote:
>>> What I had was this patch for your v3.  I never got to testing your
>>> v4 because of the LP-11 problem.
>>>
>>> In v5, you've changed to propagate the ipu_cpmem_set_image() error
>>> code to avoid the resulting corruption, but that leaves the other bits
>>> of this patch unaddressed, along my "media: imx: smfc: add support
>>> for bayer formats" patch.
>>>
>>> Your driver basically has no support for bayer formats.
>> You added the patches to this driver that adds the bayer support,
>> I don't think there is anything more required of the driver at this
>> point to support bayer, the remaining work needs to happen in the IPUv3
>> driver.
> There is more work, because the way you've merged my changes to
> imx_smfc_setup_channel() into csi_idmac_setup_channel() is wrong with
> respect to the burst size.
>
> You always set it to 8 or 16 depending on the width:
>
> 	burst_size = (image.pix.width & 0xf) ? 8 : 16;
>
> 	ipu_cpmem_set_burstsize(priv->idmac_ch, burst_size);
>
> and then you have my switch() statement which assigns burst_size.
> My _tested_ code removed the above, added the switch, which had
> a default case which reflected the above setting:
>
> 	default:
> 		burst_size = (outfmt->width & 0xf) ? 8 : 16;
>
> and then went on to set the burst size _after_ the switch statement:
>
> 	ipu_cpmem_set_burstsize(priv->smfc_ch, burst_size);
>
> The effect is unchanged for non-bayer formats.  For bayer formats, the
> burst size is determined by the bayer data size.
>
> So, even if it's appropriate to fix ipu_cpmem_set_image(), fixing the
> above is still required.

Oops, sorry missed that. I'll fix.

>
> I'm not convinced that fixing ipu_cpmem_set_image() is even the best
> solution - it's not as trivial as it looks on the surface:
>
>          ipu_cpmem_set_resolution(ch, image->rect.width, image->rect.height);
>          ipu_cpmem_set_stride(ch, pix->bytesperline);
>
> this is fine, it doesn't depend on the format.  However, the next line:
>
>          ipu_cpmem_set_fmt(ch, v4l2_pix_fmt_to_drm_fourcc(pix->pixelformat));
>
> does - v4l2_pix_fmt_to_drm_fourcc() is a locally defined function (it
> isn't v4l2 code) that converts a v4l2 pixel format to a DRM fourcc.
> DRM knows nothing about bayer formats, there aren't fourcc codes in
> DRM for it.

right, yeah that's a problem.

>    The result is that v4l2_pix_fmt_to_drm_fourcc() returns
> -EINVAL cast to a u32, which gets passed unchecked into ipu_cpmem_set_fmt().

Ugh.

>
> ipu_cpmem_set_fmt() won't recognise that, and also returns -EINVAL - and
> it's a bug that this is not checked and propagated.  If it is checked and
> propagated, then we need this to support bayer formats, and I don't see
> DRM people wanting bayer format fourcc codes added without there being
> a real DRM driver wanting to use them.

true.

>
> Then there's the business of calculating the top-left offset of the image,
> which for bayer always needs to be an even number of pixels - as this
> function takes the top-left offset, it ought to respect it, but if it
> doesn't meet this criteria, what should it do?  csi_idmac_setup_channel()
> always sets them to zero, but that's not really something that
> ipu_cpmem_set_image() should assume.

Well, I will integrate your patch above. Thanks for doing this
work for me.

We do need to address the issues you brought up in ipu_cpmem at
some point.

Steve
