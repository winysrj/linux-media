Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6CDC65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 05:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 158BA20672
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 05:30:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 158BA20672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbeLMFaA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 00:30:00 -0500
Received: from mga06.intel.com ([134.134.136.31]:3481 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726542AbeLMFaA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 00:30:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Dec 2018 21:29:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,347,1539673200"; 
   d="scan'208";a="118401309"
Received: from ipu5-build.bj.intel.com (HELO [10.238.232.171]) ([10.238.232.171])
  by orsmga001.jf.intel.com with ESMTP; 12 Dec 2018 21:29:57 -0800
Subject: Re: [PATCH 1/1] ipu3-cio2: Use MEDIA_ENT_F_VID_IF_BRIDGE as receiver
 entity function
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, bingbu.cao@intel.com, tian.shu.qiu@intel.com
References: <20181212114923.22557-1-sakari.ailus@linux.intel.com>
From:   Bingbu Cao <bingbu.cao@linux.intel.com>
Message-ID: <f08f96a1-7f9f-d119-4c9d-d14fb366ad07@linux.intel.com>
Date:   Thu, 13 Dec 2018 13:35:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181212114923.22557-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 12/12/2018 07:49 PM, Sakari Ailus wrote:
> Address the following warnings by setting the entity's function to an
> appropriate value.
>
> [    5.043377] ipu3-cio2 0000:00:14.3: Entity type for entity ipu3-csi2 0 was not initialized!
> [    5.043427] ipu3-cio2 0000:00:14.3: Entity type for entity ipu3-csi2 1 was not initialized!
> [    5.043463] ipu3-cio2 0000:00:14.3: Entity type for entity ipu3-csi2 2 was not initialized!
> [    5.043502] ipu3-cio2 0000:00:14.3: Entity type for entity ipu3-csi2 3 was not initialized!
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>   drivers/media/pci/intel/ipu3/ipu3-cio2.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> index 447baaebca448..e827e12b9718f 100644
> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> @@ -1597,6 +1597,7 @@ static int cio2_queue_init(struct cio2_device *cio2, struct cio2_queue *q)
>   
>   	/* Initialize subdev */
>   	v4l2_subdev_init(subdev, &cio2_subdev_ops);
> +	subdev->entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
I am wondering what is the difference between VID_IF_BRIDGE and PROC_VIDEO_PIXEL_FORMATTER.
Some CSI-2 receiver is using PIXEL_FORMATTER now.
>   	subdev->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
>   	subdev->owner = THIS_MODULE;
>   	snprintf(subdev->name, sizeof(subdev->name),

