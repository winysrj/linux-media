Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1706 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaIHOsK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Sep 2014 10:48:10 -0400
Message-ID: <540DC19B.30100@xs4all.nl>
Date: Mon, 08 Sep 2014 16:47:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com
Subject: Re: [RFC PATCH 00/12] vb2: improve dma-sg, expbuf.
References: <1410185681-20111-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1410185681-20111-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/08/2014 04:14 PM, Hans Verkuil wrote:
> The patch series adds an allocation context to dma-sg and uses that to move
> dma_(un)map_sg into the vb2 framework, which is where it belongs.
> 
> Related to that is the addition of buf_prepare/finish _for_cpu variants,
> where the _for_cpu ops are called when the buffer is synced for the cpu, and
> the others are called when it is synced to the device.
> 
> DMABUF export support is added to dma-sg and vmalloc, so now all memory
> models support DMABUF importing and exporting.
> 
> A new flag was added so drivers know when the DMA engine should be
> (re)programmed. This is primarily needed for the dma-sg memory model.

Note: patches for tw68 and cx23885 are missing but can be found in my repo:

http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/log/?h=vb2-prep

Those two drivers were merged/updated just after I posted my patch series :-)

Regards,

	Hans

> 
> Reviews are very welcome.
> 
> Regards,
> 
> 	Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

