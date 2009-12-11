Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:51906 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbZLKD00 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 22:26:26 -0500
Received: by ywh6 with SMTP id 6so504262ywh.4
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2009 19:26:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0912101359060.4487@axis700.grange>
References: <20091209131624.8044.18187.sendpatchset@rxone.opensource.se>
	 <Pine.LNX.4.64.0912101359060.4487@axis700.grange>
Date: Fri, 11 Dec 2009 12:26:31 +0900
Message-ID: <aec7e5c30912101926ka845165se35016ded278266f@mail.gmail.com>
Subject: Re: [PATCH] sh_mobile_ceu_camera: Remove frame size page alignment
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, m-karicheri2@ti.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 10, 2009 at 10:06 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 9 Dec 2009, Magnus Damm wrote:
>
>> From: Magnus Damm <damm@opensource.se>
>>
>> This patch updates the SuperH Mobile CEU driver to
>> not page align the frame size. Useful in the case of
>> USERPTR with non-page aligned frame sizes and offsets.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
>
> Please, correct me if I'm wrong. Currently most (all?) sh platforms, using
> this driver, and wishing to use V4L2_MEMORY_MMAP, reserve contiguous
> memory in their platform code. In this case pcdev->video_limit is set to
> the size of that area. videobuf-dma-contig.c::__videobuf_mmap_mapper()
> will anyway allocate page-aligned buffers for V4L2_MEMORY_MMAP, so, even
> for the case of a platform, not reserving RAM at boot-time, it should
> work. Similarly it should work for the V4L2_MEMORY_USERPTR case. So, looks
> ok to me, queued, thanks.

Correct. On SuperH Mobile the amount of reserved physically contiguous
memory for the CEU can be overridden on the kernel command line, and
in the case of systems only using USERPTR it is wise to set it to the
reserved memory to zero since the memory will be unused anyway when
the V4L2 buffers come from elsewhere.

If there is no physically contiguous memory reserved for the CEU and
V4L2 MMAP is used then there is a risk of physically contiguous memory
allocation failure due to memory fragmentation. Nothing out of the
ordinary, to play it safe just reserve physically contiguous memory
during boot up time and be done with it.

/ magnus
