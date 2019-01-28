Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70981C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 14:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 420D420989
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 14:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfA1OKV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 09:10:21 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:45059 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726647AbfA1OKV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 09:10:21 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id o7c8gss5ORO5Zo7cBgKPNm; Mon, 28 Jan 2019 15:10:19 +0100
Subject: Re: [PATCH] : media : hackrf : memory leak
To:     "Yavuz, Tuba" <tuba@ece.ufl.edu>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc:     Greg KH <greg@kroah.com>
References: <1548629863510.35899@ece.ufl.edu>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c99c66e0-54b5-1f4d-8ad9-412286fce6be@xs4all.nl>
Date:   Mon, 28 Jan 2019 15:10:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1548629863510.35899@ece.ufl.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDPWMgH1eMnmvavyQtznufyT7h0YRCId84YoF5BPAhQW5eCNR5GKtdFbFDhWjl7HuYHukUUbZ6syMqKsHdeCB2hAOl+YwQuCb4ouf/Vyy0cvBtePVWvn
 UKLn/57uN+2k4AVXAfxHIhd+WnjaV/GnPv4UqDmsWxZ308jGo3xCbWuRBA3KHbgXWAn6/OmZfSXemoNjD/tk9T7KByIqMamoasb3YaXuS8Vpc7WpUzdVLmIo
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Tuba,

On 1/27/19 11:57 PM, Yavuz, Tuba wrote:
> 
>      
> Due to a missing v4l2_device_get function in the hackrf_probe function, 
> the reference count of the v4l2_device object reaches zero inside the 
> wrong API function (video_unregister_device) instead of v4l2_device_put. 
> This causes a memory leak as the release callback would not get called.

The refcount is 1 after calling v4l2_device_register(). Each video_register_device
call will increment the refcount by 1. When a video node is released (v4l2_device_release)
the refcount is decremented, and when the device is disconnected (hackrf_disconnect)
the refcount is decremented again.

So I don't see where there is a memory leak, and neither do I understand how
incrementing the refcount would prevent a memory leak. I would expect that it
causes a memory leak!

Is there something else going on here?

Regards,

	Hans

> 
> 
> Reported-by: Tuba Yavuz <tuba@ece.ufl.edu>
> Signed-off-by: Tuba Yavuz <tuba@ece.ufl.edu>
> ---
> 
> 
> --- drivers/media/usb/hackrf/hackrf.c.orig	2019-01-26 11:37:18.912210823 -0500
> +++ drivers/media/usb/hackrf/hackrf.c	2019-01-27 17:50:41.660736688 -0500
> @@ -1524,6 +1524,7 @@ static int hackrf_probe(struct usb_inter
>  			"Failed to register as video device (%d)\n", ret);
>  		goto err_video_unregister_device_rx;
>  	}
> +	v4l2_device_get(&dev->v4l2_dev);
>  	dev_info(dev->dev, "Registered as %s\n",
>  		 video_device_node_name(&dev->tx_vdev));​
>  
> 

