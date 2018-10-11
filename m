Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:20084 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727305AbeJKQim (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 12:38:42 -0400
Subject: Re: [PATCH 2/2] ipu3-cio2: Use cio2_queues_exit
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: rajmohan.mani@intel.com, yong.zhi@intel.com, bingbu.cao@intel.com,
        tian.shu.qiu@intel.com, jian.xu.zheng@intel.com
References: <20181010083231.27492-1-sakari.ailus@linux.intel.com>
 <20181010083231.27492-3-sakari.ailus@linux.intel.com>
From: Bing Bu Cao <bingbu.cao@linux.intel.com>
Message-ID: <044f336d-657e-2a02-f5b2-1437589c8537@linux.intel.com>
Date: Thu, 11 Oct 2018 17:16:30 +0800
MIME-Version: 1.0
In-Reply-To: <20181010083231.27492-3-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested-by: Bingbu Cao <bingbu.cao@intel.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>

On 10/10/2018 04:32 PM, Sakari Ailus wrote:
> The ipu3-cio2 driver has a function to tear down video devices as well as
> the associated video buffer queues. Use it.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> index 723022ef3662..447baaebca44 100644
> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> @@ -1844,12 +1844,10 @@ static int cio2_pci_probe(struct pci_dev *pci_dev,
>  static void cio2_pci_remove(struct pci_dev *pci_dev)
>  {
>  	struct cio2_device *cio2 = pci_get_drvdata(pci_dev);
> -	unsigned int i;
>  
>  	media_device_unregister(&cio2->media_dev);
>  	cio2_notifier_exit(cio2);
> -	for (i = 0; i < CIO2_QUEUES; i++)
> -		cio2_queue_exit(cio2, &cio2->queue[i]);
> +	cio2_queues_exit(cio2);
>  	cio2_fbpt_exit_dummy(cio2);
>  	v4l2_device_unregister(&cio2->v4l2_dev);
>  	media_device_cleanup(&cio2->media_dev);
