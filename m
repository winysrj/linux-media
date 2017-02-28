Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6843 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752462AbdB1NeV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 08:34:21 -0500
Subject: Re: [PATCH 1/6] omap3isp: Don't rely on devm for memory resource
 management
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
References: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487604142-27610-2-git-send-email-sakari.ailus@linux.intel.com>
 <17312150.yLXnxzLeiM@avalon>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <a199bb19-bfae-9191-b74c-5be175ba79c7@linux.intel.com>
Date: Tue, 28 Feb 2017 15:21:48 +0200
MIME-Version: 1.0
In-Reply-To: <17312150.yLXnxzLeiM@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Sakari,
>
> Thank you for the patch.
>
> On Monday 20 Feb 2017 17:22:17 Sakari Ailus wrote:
...
>> @@ -516,9 +516,12 @@ int omap3isp_hist_init(struct isp_device *isp)
>>  	hist->event_type = V4L2_EVENT_OMAP3ISP_HIST;
>>
>>  	ret = omap3isp_stat_init(hist, "histogram", &hist_subdev_ops);
>> +
>> +err:
>>  	if (ret) {
>> -		if (hist->dma_ch)
>> +		if (!IS_ERR(hist->dma_ch))
>
> I think this change is wrong. dma_ch is initialize to NULL by kzalloc(). You
> will end up calling dma_release_channel() on a NULL channel if
> omap3isp_stat_init() fails and HIST_CONFIG_DMA is false. The check should be
>
> 	if (!IS_ERR_OR_NULL(hist->dma_ch))

Good catch! I'll fix that.

>
> Apart from that,
>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!


-- 
Sakari Ailus
sakari.ailus@linux.intel.com
