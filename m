Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39570 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbbCKXsA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 19:48:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 15/18] omap3isp: Add support for the Device Tree
Date: Thu, 12 Mar 2015 01:48:02 +0200
Message-ID: <1977501.nIrQKlrSI0@avalon>
In-Reply-To: <1425764475-27691-16-git-send-email-sakari.ailus@iki.fi>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi> <1425764475-27691-16-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Saturday 07 March 2015 23:41:12 Sakari Ailus wrote:
> Add the ISP device to omap3 DT include file and add support to the driver to
> use it.
> 
> Also obtain information on the external entities and the ISP configuration
> related to them through the Device Tree in addition to the platform data.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/platform/omap3isp/isp.c       |  206 ++++++++++++++++++++++--
>  drivers/media/platform/omap3isp/isp.h       |   11 ++
>  drivers/media/platform/omap3isp/ispcsiphy.c |    7 +
>  3 files changed, 213 insertions(+), 11 deletions(-)

[snip]

> @@ -2358,14 +2541,6 @@ static int isp_probe(struct platform_device *pdev)
>  	isp->mmio_hist_base_phys =
>  		mem->start + isp_res_maps[m].offset[OMAP3_ISP_IOMEM_HIST];
> 
> -	isp->syscon = syscon_regmap_lookup_by_pdevname("syscon.0");
> -	isp->syscon_offset = isp_res_maps[m].syscon_offset;

You're removing syscon_offset initialization here but not adding it anywhere 
else. This patch doesn't match the commit in your rm696-053-upstream branch, 
could you send the right version ? I'll then review it.

> -	isp->phy_type = isp_res_maps[m].phy_type;
> -	if (IS_ERR(isp->syscon)) {
> -		ret = PTR_ERR(isp->syscon);
> -		goto error_isp;
> -	}
> -
>  	/* IOMMU */
>  	ret = isp_attach_iommu(isp);
>  	if (ret < 0) {

-- 
Regards,

Laurent Pinchart

