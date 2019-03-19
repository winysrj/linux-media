Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872FEC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 02:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A08520850
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 02:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfCSCv5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 22:51:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:63415 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727109AbfCSCv5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 22:51:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Mar 2019 19:51:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,496,1544515200"; 
   d="scan'208";a="132740472"
Received: from ipu5-build.bj.intel.com (HELO [10.238.232.171]) ([10.238.232.171])
  by fmsmga008.fm.intel.com with ESMTP; 18 Mar 2019 19:51:54 -0700
Subject: Re: [PATCH 1/1] ipu3-cio2: Set CSI-2 receiver sub-device entity
 function
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc:     rajmohan.mani@intel.com, tfiga@chromium.org
References: <20190318155509.29279-1-sakari.ailus@linux.intel.com>
From:   Bingbu Cao <bingbu.cao@linux.intel.com>
Message-ID: <5c46f27d-3adc-c1f6-a830-cd4005b17391@linux.intel.com>
Date:   Tue, 19 Mar 2019 10:58:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190318155509.29279-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>

On 3/18/19 11:55 PM, Sakari Ailus wrote:
> Set the entity function for the four CSI-2 receiver sub-devices the driver
> creates. This avoids a kernel warning from each as well.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> index 617fb2e944dc3..b76dff851f3d2 100644
> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> @@ -1601,6 +1601,7 @@ static int cio2_queue_init(struct cio2_device *cio2, struct cio2_queue *q)
>  	subdev->owner = THIS_MODULE;
>  	snprintf(subdev->name, sizeof(subdev->name),
>  		 CIO2_ENTITY_NAME " %td", q - cio2->queue);
> +	subdev->entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
>  	v4l2_set_subdevdata(subdev, cio2);
>  	r = v4l2_device_register_subdev(&cio2->v4l2_dev, subdev);
>  	if (r) {
> 
