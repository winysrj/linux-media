Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34572 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751805AbdBGByf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2017 20:54:35 -0500
Subject: Re: [PATCH v3 16/24] media: Add i.MX media core driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-17-git-send-email-steve_longerbeam@mentor.com>
 <20170202225004.GZ27312@n2100.armlinux.org.uk>
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
Message-ID: <681b06c9-48b9-7336-ae89-c8816fe8033a@gmail.com>
Date: Mon, 6 Feb 2017 17:54:31 -0800
MIME-Version: 1.0
In-Reply-To: <20170202225004.GZ27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/02/2017 02:50 PM, Russell King - ARM Linux wrote:
> On Fri, Jan 06, 2017 at 06:11:34PM -0800, Steve Longerbeam wrote:
>> +/* register an internal subdev as a platform device */
>> +static struct imx_media_subdev *
>> +add_internal_subdev(struct imx_media_dev *imxmd,
>> +		    const struct internal_subdev *isd,
>> +		    int ipu_id)
>> +{
>> +	struct imx_media_internal_sd_platformdata pdata;
>> +	struct platform_device_info pdevinfo = {0};
>> +	struct imx_media_subdev *imxsd;
>> +	struct platform_device *pdev;
>> +
>> +	switch (isd->id->grp_id) {
>> +	case IMX_MEDIA_GRP_ID_CAMIF0...IMX_MEDIA_GRP_ID_CAMIF1:
>> +		pdata.grp_id = isd->id->grp_id +
>> +			((2 * ipu_id) << IMX_MEDIA_GRP_ID_CAMIF_BIT);
>> +		break;
>> +	default:
>> +		pdata.grp_id = isd->id->grp_id;
>> +		break;
>> +	}
>> +
>> +	/* the id of IPU this subdev will control */
>> +	pdata.ipu_id = ipu_id;
>> +
>> +	/* create subdev name */
>> +	imx_media_grp_id_to_sd_name(pdata.sd_name, sizeof(pdata.sd_name),
>> +				    pdata.grp_id, ipu_id);
>> +
>> +	pdevinfo.name = isd->id->name;
>> +	pdevinfo.id = ipu_id * num_isd + isd->id->index;
>> +	pdevinfo.parent = imxmd->dev;
>> +	pdevinfo.data = &pdata;
>> +	pdevinfo.size_data = sizeof(pdata);
>> +	pdevinfo.dma_mask = DMA_BIT_MASK(32);
>> +
>> +	pdev = platform_device_register_full(&pdevinfo);
>> +	if (IS_ERR(pdev))
>> +		return ERR_CAST(pdev);
>> +
>> +	imxsd = imx_media_add_async_subdev(imxmd, NULL, dev_name(&pdev->dev));
>> +	if (IS_ERR(imxsd))
>> +		return imxsd;
>> +
>> +	imxsd->num_sink_pads = isd->num_sink_pads;
>> +	imxsd->num_src_pads = isd->num_src_pads;
>> +
>> +	return imxsd;
>> +}
> You seem to create platform devices here, but I see nowhere that you
> ever remove them - so if you get to the lucky point of being able to
> rmmod imx-media and then try to re-insert it, you end up with a load
> of kernel warnings, one for each device created this way, and
> platform_device_register_full() fails:

Right, I never free the platform devices for the internal subdevs.
Fixed.

Steve

