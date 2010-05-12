Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:42682 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab0ELMbq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 May 2010 08:31:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH 7/7] v4l: videobuf: Rename vmalloc fields to vaddr
Date: Wed, 12 May 2010 14:32:11 +0200
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com
References: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com> <1273584994-14211-8-git-send-email-laurent.pinchart@ideasonboard.com> <000e01caf1ae$34f0f2d0$9ed2d870$%osciak@samsung.com>
In-Reply-To: <000e01caf1ae$34f0f2d0$9ed2d870$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005121432.13852.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

On Wednesday 12 May 2010 10:36:24 Pawel Osciak wrote:
> > Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >
> >The videobuf_dmabuf and videobuf_vmalloc_memory fields have a vmalloc
> >field to store the kernel virtual address of vmalloc'ed buffers. Rename
> >the field to vaddr.

[snip]

> I am not 100% sure about this, it is a bit different from the rename
> of vmalloc to vaddr for functions made by Hans earlier. Those functions
> were supposed to return kernel addresses to buffers and callers did not
> need to know where did those pointers had come from, but keeping that
> information here might be useful/prevent confusion...

I'd still rename the field, but I have no strong opinion about it. If you 
think the patch should be dropped, that's fine.

-- 
Regards,

Laurent Pinchart
