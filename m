Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:46450 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab2ATQUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 11:20:25 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LY300AGUUPZ6W70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 20 Jan 2012 16:20:23 +0000 (GMT)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LY300BV2UPY8X@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 20 Jan 2012 16:20:23 +0000 (GMT)
Date: Fri, 20 Jan 2012 17:20:22 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
In-reply-to: <201201201711.50965.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, m.szyprowski@samsung.com,
	rob@ti.com, daniel@ffwll.ch, patches@linaro.org
Message-id: <4F199446.6040403@samsung.com>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
 <201201201612.31821.laurent.pinchart@ideasonboard.com>
 <4F198DF0.7000801@samsung.com>
 <201201201711.50965.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>
>> IMO, One way to do this is adding field 'struct device *dev' to struct
>> vb2_queue. This field should be filled by a driver prior to calling
>> vb2_queue_init.
>
> I haven't looked into the details, but that sounds good to me. Do we have use
> cases where a queue is allocated before knowing which physical device it will
> be used for ?
>

I don't think so. In case of S5P drivers, vb2_queue_init is called while 
opening /dev/videoX.

BTW. This struct device may help vb2 to produce logs with more 
descriptive client annotation.

What happens if such a device is NULL. It would happen for vmalloc 
allocator used by VIVI?

Regards,
Tomasz Stanislawski
