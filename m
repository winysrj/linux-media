Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34467 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab2ATQ3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 11:29:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
Date: Fri, 20 Jan 2012 17:28:58 +0100
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, m.szyprowski@samsung.com,
	rob@ti.com, daniel@ffwll.ch, patches@linaro.org
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com> <201201201711.50965.laurent.pinchart@ideasonboard.com> <4F199446.6040403@samsung.com>
In-Reply-To: <4F199446.6040403@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201201729.00230.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 20 January 2012 17:20:22 Tomasz Stanislawski wrote:
> >> IMO, One way to do this is adding field 'struct device *dev' to struct
> >> vb2_queue. This field should be filled by a driver prior to calling
> >> vb2_queue_init.
> > 
> > I haven't looked into the details, but that sounds good to me. Do we have
> > use cases where a queue is allocated before knowing which physical
> > device it will be used for ?
> 
> I don't think so. In case of S5P drivers, vb2_queue_init is called while
> opening /dev/videoX.
> 
> BTW. This struct device may help vb2 to produce logs with more
> descriptive client annotation.
> 
> What happens if such a device is NULL. It would happen for vmalloc
> allocator used by VIVI?

Good question. Should dma-buf accept NULL devices ? Or should vivi pass its 
V4L2 device to vb2 ?

-- 
Regards,

Laurent Pinchart
