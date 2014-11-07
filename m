Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38206 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbaKGJTT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Nov 2014 04:19:19 -0500
Message-ID: <545C8E92.30709@xs4all.nl>
Date: Fri, 07 Nov 2014 10:19:14 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: pawel@osciak.com, m.szyprowski@samsung.com
Subject: Re: [RFCv5 PATCH 00/15] vb2: improve dma-sg, expbuf
References: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/07/2014 09:50 AM, Hans Verkuil wrote:
> Changes since v4:
> - Rebased to latest media_tree master
> 
> Changes since v3:
> 
> - Dropped patch 02/10: succeeded by patch 10/15 in this series
> - Added patches 11-15 to correctly handle syncing/mapping dmabuf
>   buffers for CPU access. This was never done correctly before.
>   Many thanks to Pawel Osciak for helping me with this during the
>   media mini-summit last week.
> 
> The patch series adds an allocation context to dma-sg and uses that to move
> dma_(un)map_sg into the vb2 framework, which is where it belongs.
> 
> Some drivers needs to fixup the buffers before giving it back to userspace
> (or before handing it over to the kernel). Document that this can be done
> in buf_prepare and buf_finish.
> 
> The last 5 patches make this more strict by requiring all cpu access to
> be bracketed by calls to vb2_plane_begin/end_cpu_access() which replaces
> the old vb2_plane_vaddr() call.
> 
> Note: two drivers still use the vb2_plane_addr() call: coda and
> exynos4-is/fimc-capture.c. For both drivers I will need some help since
> I am not sure where to put the begin/end calls. Patch 14 removes
> the vb2_plane_vaddr call, so obviously those two drivers won't compile
> after that.
> 
> DMABUF export support is added to dma-sg and vmalloc, so now all memory
> models support DMABUF importing and exporting.
> 
> I am inclined to make a pull request for patches 1-10 if there are no
> new comments. The issues that patches 11-15 address are separate from
> the patches 1-10 and this is only an issue when using dmabuf with
> drivers that need cpu access.

To be specific: consider patches 1-10 as being patches ready to merge,
while patches 11-15 are still in the RFC stage.

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

