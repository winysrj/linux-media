Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45704 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753679AbdGUKK1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 06:10:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 4/4] atomisp2: don't set driver_version anymore
Date: Fri, 21 Jul 2017 13:10:34 +0300
Message-ID: <2861836.LoGWVYMxAE@avalon>
In-Reply-To: <20170721090234.6501-5-hverkuil@xs4all.nl>
References: <20170721090234.6501-1-hverkuil@xs4all.nl> <20170721090234.6501-5-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 21 Jul 2017 11:02:34 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This is now set by media_device_init.
> 
> Drop the print of driver_version in the error message: the driver
> version is 1) not yet set at this point (the media_device_init call
> comes later AFAICS), and 2) irrelevant here, since it is the hw_revision
> that is important, not the driver version (which is identical to the
> kernel version anyway).
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
> b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c index
> 2f49562377e6..29387c03fae9 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
> @@ -1100,8 +1100,7 @@ atomisp_load_firmware(struct atomisp_device *isp)
> 
>  	if (!fw_path) {
>  		dev_err(isp->dev,
> -			"Unsupported driver_version 0x%x, hw_revision 0x%x\n",
> -			isp->media_dev.driver_version,
> +			"Unsupported hw_revision 0x%x\n",

Nitpicking, you can now merge the first two lines.

>  			isp->media_dev.hw_revision);
>  		return NULL;
>  	}
> @@ -1249,8 +1248,6 @@ static int atomisp_pci_probe(struct pci_dev *dev,
>  	/* This is not a true PCI device on SoC, so the delay is not needed. 
*/
>  	isp->pdev->d3_delay = 0;
> 
> -	isp->media_dev.driver_version = LINUX_VERSION_CODE;
> -
>  	switch (id->device & ATOMISP_PCI_DEVICE_SOC_MASK) {
>  	case ATOMISP_PCI_DEVICE_SOC_MRFLD:
>  		isp->media_dev.hw_revision =

-- 
Regards,

Laurent Pinchart
