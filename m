Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17349C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 14:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0BD42083F
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 14:25:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0BD42083F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbeLEOZu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:25:50 -0500
Received: from mga06.intel.com ([134.134.136.31]:23574 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbeLEOZu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 09:25:50 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Dec 2018 06:25:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,317,1539673200"; 
   d="scan'208";a="127327128"
Received: from raj-desk2.iind.intel.com ([10.223.107.30])
  by fmsmga001.fm.intel.com with ESMTP; 05 Dec 2018 06:25:47 -0800
Date:   Wed, 5 Dec 2018 19:45:04 +0530
From:   Rajneesh Bhardwaj <rajneesh.bhardwaj@intel.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, yong.zhi@intel.com,
        tian.shu.qiu@intel.com, bingbu.cao@intel.com
Subject: Re: [PATCH 1/1] ipu3-cio2: Allow probe to succeed if there are no
 sensors connected
Message-ID: <20181205141504.GA25402@raj-desk2.iind.intel.com>
References: <20181205141517.7433-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205141517.7433-1-sakari.ailus@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Dec 05, 2018 at 04:15:17PM +0200, Sakari Ailus wrote:
> The device won't be powered off on systems that have no sensors connected
> unless it has a driver bound to it. Allow that to happen even if there are
> no sensors connected to cio2.

Thanks for sending this. It helps to put the pci device to suspend which
otherwise remains active after the probe for cio2 fails. I have verified it
on HP Elitebook that has BIOS/DSDT more suitable for Windows.

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-and-tested-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>

> ---
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> index 447baaebca448..e281e55cdca4a 100644
> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> @@ -1810,7 +1810,8 @@ static int cio2_pci_probe(struct pci_dev *pci_dev,
>  
>  	/* Register notifier for subdevices we care */
>  	r = cio2_notifier_init(cio2);
> -	if (r)
> +	/* Proceed without sensors connected to allow the device to suspend. */
> +	if (r && r != -ENODEV)
>  		goto fail_cio2_queue_exit;
>  
>  	r = devm_request_irq(&pci_dev->dev, pci_dev->irq, cio2_irq,
> -- 
> 2.11.0
> 

-- 
Best Regards,
Rajneesh
