Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42896 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2IXRFa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 13:05:30 -0400
Received: from eusync1.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAV00F256634T90@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 18:06:03 +0100 (BST)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MAV00HUO6539I50@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 18:05:28 +0100 (BST)
Message-id: <506092D7.9040807@samsung.com>
Date: Mon, 24 Sep 2012 19:05:27 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	a.hajda@samsung.com, hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com
Subject: Re: [PATCH RFC] V4L: Add s_rx_buffer subdev video operation
References: <1348493213-32278-1-git-send-email-s.nawrocki@samsung.com>
 <20120924134453.GH12025@valkosipuli.retiisi.org.uk> <8816374.onnX7s7R5d@avalon>
In-reply-to: <8816374.onnX7s7R5d@avalon>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 09/24/2012 03:58 PM, Laurent Pinchart wrote:
>> How about useing a separate video buffer queue for the purpose? That would
>> provide a nice way to pass it to the user space where it's needed. It'd also
>> play nicely together with the frame layout descriptors.
> 
> Beside, a void *buf wouldn't support DMA. Only subdevs that use PIO to 
> transfer meta data could be supported by this.

I guess most of MIPI-CSI2 receivers out there support data capture
from distinct Data Types into separate DMA buffers. But not this one.
In case of multi-context DMA engine I guess MIPI-CSI2 receiver driver
would expose video node anyway and it wouldn't need such a callback
at all ?

Perhaps using struct v4l2_subdev_core_ops::ioctl would be more
appropriate here ?

--

Regards,
Sylwester
