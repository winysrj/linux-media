Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51940 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965226Ab2JZQZc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Oct 2012 12:25:32 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3230888vcb.19
        for <linux-media@vger.kernel.org>; Fri, 26 Oct 2012 09:25:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349880405-26049-9-git-send-email-t.stanislaws@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com> <1349880405-26049-9-git-send-email-t.stanislaws@samsung.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Fri, 26 Oct 2012 09:24:50 -0700
Message-ID: <CAMm-=zB9-WJ5b6Xku1UwvG4UZOGQ_V6pKFT4C_Xf0kF-O+VDdw@mail.gmail.com>
Subject: Re: [PATCHv10 08/26] v4l: vb2-dma-contig: add support for scatterlist
 in userptr mode
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Wed, Oct 10, 2012 at 7:46 AM, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:
> This patch introduces usage of dma_map_sg to map memory behind
> a userspace pointer to a device as dma-contiguous mapping.
>

Perhaps I'm missing something, but I don't understand the purpose of
this patch. If the device can do DMA SG, why use videobuf2-dma-contig
and not videobuf2-dma-sg? What would be the difference design-wise
between them if this patch is merged?

-- 
Best regards,
Pawel Osciak
