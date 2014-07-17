Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59775 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaGQTtz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 15:49:55 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so8307597wib.15
        for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 12:49:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53C826DD.1050903@xs4all.nl>
References: <53C826DD.1050903@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 17 Jul 2014 20:49:24 +0100
Message-ID: <CA+V-a8sAb4sO1-_R2mpcWYVMohwe1RsapWv+qMZn=B+zrySaYQ@mail.gmail.com>
Subject: Re: davinci compiler warnings
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On Thu, Jul 17, 2014 at 8:41 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Prabhakar,
>
> Can you take a look at these new warnings? I've just upgraded my compiler for
> the daily build to 4.9.1, so that's probably why they weren't seen before.
>
Ok will look at it. BTW are these errors from the media/master branch or
from your tree ?

Thanks,
--Prabhakar Lad

> Regards,
>
>         Hans
>
> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c: In function 'vpif_remove':
> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c:1389:36: warning: iteration 1u invokes undefined behavior [-Waggressive-loop-optimizations]
>    vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
>                                     ^
> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c:1385:2: note: containing loop
>   for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
>   ^
> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_capture.c: In function 'vpif_remove':
> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_capture.c:1581:36: warning: iteration 1u invokes undefined behavior [-Waggressive-loop-optimizations]
>    vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
>                                     ^
> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_capture.c:1577:2: note: containing loop
>   for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
>   ^
> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_capture.c:1580:23: warning: array subscript is above array bounds [-Warray-bounds]
>    common = &ch->common[i];
>                        ^
