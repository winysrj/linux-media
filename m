Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3274 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924AbZKYRfF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 12:35:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] davinci: add missing vpif_capture.c/h files
Date: Wed, 25 Nov 2009 18:34:57 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <E1NCyyk-0003Ju-Nh@mail.linuxtv.org>
In-Reply-To: <E1NCyyk-0003Ju-Nh@mail.linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911251834.57816.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 24 November 2009 18:15:02 Patch from Hans Verkuil wrote:
> The patch number 13462 was added via Mauro Carvalho Chehab <mchehab@redhat.com>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
> 
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
> 
> If anyone has any objections, please let us know by sending a message to:
> 	Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> ------
> 
> From: Hans Verkuil  <hverkuil@xs4all.nl>
> davinci: add missing vpif_capture.c/h files
> 
> 
> For some reason these files were never added to v4l-dvb from the
> mainline tree.
> 
> Priority: normal
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 
> ---
> 
>  linux/linux/drivers/media/video/davinci/vpif_capture.c | 2168 ++++++++++
>  linux/linux/drivers/media/video/davinci/vpif_capture.h |  165 

Hi Mauro,

Note the linux/linux path! This commit ended up in the wrong place!

Can you fix this?

Thanks,

	Hans


>  2 files changed, 2333 insertions(+)
> 
> <diff discarded since it is too big>
> 
> ---
> 
> Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/c6e33c9ead8652f68de624b39d3dea40b6ac20b7
> 
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
