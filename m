Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:37498 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbaKHJwo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Nov 2014 04:52:44 -0500
Received: by mail-la0-f41.google.com with SMTP id s18so5672956lam.0
        for <linux-media@vger.kernel.org>; Sat, 08 Nov 2014 01:52:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415350234-9826-4-git-send-email-hverkuil@xs4all.nl>
References: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl> <1415350234-9826-4-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Sat, 8 Nov 2014 18:44:45 +0900
Message-ID: <CAMm-=zDr-cfOptyGb-Qs3S4KEdA9hWShiqPZBb658zDEoc=9Pg@mail.gmail.com>
Subject: Re: [RFCv5 PATCH 03/15] vb2-dma-sg: move dma_(un)map_sg here
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Thank you for the patch.

On Fri, Nov 7, 2014 at 5:50 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This moves dma_(un)map_sg to the get_userptr/put_userptr and alloc/put
> memops of videobuf2-dma-sg.c and adds dma_sync_sg_for_device/cpu to the
> prepare/finish memops.
>
> Now that vb2-dma-sg will sync the buffers for you in the prepare/finish
> memops we can drop that from the drivers that use dma-sg.
>
> For the solo6x10 driver that was a bit more involved because it needs to
> copy JPEG or MPEG headers to the buffer before returning it to userspace,
> and that cannot be done in the old place since the buffer there is still
> setup for DMA access, not for CPU access. However, the buf_finish
> op is the ideal place to do this. By the time buf_finish is called
> the buffer is available for CPU access, so copying to the buffer is fine.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

-- 
Best regards,
Pawel Osciak
