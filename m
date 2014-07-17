Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3196 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbaGQTyx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 15:54:53 -0400
Message-ID: <53C82A05.4050202@xs4all.nl>
Date: Thu, 17 Jul 2014 21:54:45 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: davinci compiler warnings
References: <53C826DD.1050903@xs4all.nl> <CA+V-a8sAb4sO1-_R2mpcWYVMohwe1RsapWv+qMZn=B+zrySaYQ@mail.gmail.com>
In-Reply-To: <CA+V-a8sAb4sO1-_R2mpcWYVMohwe1RsapWv+qMZn=B+zrySaYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/2014 09:49 PM, Prabhakar Lad wrote:
> Hi Hans
> 
> On Thu, Jul 17, 2014 at 8:41 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Prabhakar,
>>
>> Can you take a look at these new warnings? I've just upgraded my compiler for
>> the daily build to 4.9.1, so that's probably why they weren't seen before.
>>
> Ok will look at it. BTW are these errors from the media/master branch or
> from your tree ?

media/master

> 
> Thanks,
> --Prabhakar Lad
> 
>> Regards,
>>
>>         Hans
>>
>> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c: In function 'vpif_remove':
>> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c:1389:36: warning: iteration 1u invokes undefined behavior [-Waggressive-loop-optimizations]
>>    vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
>>                                     ^
>> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_display.c:1385:2: note: containing loop
>>   for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
>>   ^
>> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_capture.c: In function 'vpif_remove':
>> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_capture.c:1581:36: warning: iteration 1u invokes undefined behavior [-Waggressive-loop-optimizations]
>>    vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
>>                                     ^
>> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_capture.c:1577:2: note: containing loop
>>   for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
>>   ^
>> /home/hans/work/build/media-git/drivers/media/platform/davinci/vpif_capture.c:1580:23: warning: array subscript is above array bounds [-Warray-bounds]
>>    common = &ch->common[i];
>>                        ^
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

