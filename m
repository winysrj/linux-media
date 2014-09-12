Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36052 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaILWCI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Sep 2014 18:02:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 09/14] vb2: replace 'write' by 'dma_dir'
Date: Sat, 13 Sep 2014 01:02:11 +0300
Message-ID: <1451773.l8tAPSQMui@avalon>
In-Reply-To: <1410526803-25887-10-git-send-email-hverkuil@xs4all.nl>
References: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl> <1410526803-25887-10-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 12 September 2014 14:59:58 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The 'write' argument is very ambiguous. I first assumed that if it is 1,
> then we're doing video output but instead it meant the reverse.
> 
> Since it is used to setup the dma_dir value anyway it is now replaced by
> the correct dma_dir value which is unambiguous.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Given my comments to one of your earlier patches, I can only agree with you 
here :-)

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

However, how about moving this patch up in the series, before adding the write 
argument to the alloc function ?

> ---
>  drivers/media/v4l2-core/videobuf2-core.c       | 15 +++++----
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 46 ++++++++++++-----------
>  drivers/media/v4l2-core/videobuf2-dma-sg.c     | 46 +++++++++++------------
>  drivers/media/v4l2-core/videobuf2-vmalloc.c    | 20 ++++++-----
>  include/media/videobuf2-core.h                 | 11 +++---
>  5 files changed, 73 insertions(+), 65 deletions(-)

-- 
Regards,

Laurent Pinchart

