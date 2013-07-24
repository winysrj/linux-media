Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22792 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3GXJjj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 05:39:39 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=windows-1252
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQF003KJPD6CRC0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Jul 2013 10:39:38 +0100 (BST)
Message-id: <51EFA0D7.9030308@samsung.com>
Date: Wed, 24 Jul 2013 11:39:35 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com
Subject: Re: [PATCH RFC 4/5] V4L2: Rename subdev field of struct
 v4l2_async_notifier
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
 <1374516287-7638-5-git-send-email-s.nawrocki@samsung.com>
 <CA+V-a8t+tqvJXZrFUJ2sA2TM=7AM1U50h7aAfHze+yKnAzsYMw@mail.gmail.com>
In-reply-to: <CA+V-a8t+tqvJXZrFUJ2sA2TM=7AM1U50h7aAfHze+yKnAzsYMw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On 07/23/2013 05:50 PM, Prabhakar Lad wrote:
> On Mon, Jul 22, 2013 at 11:34 PM, Sylwester Nawrocki
> <s.nawrocki@samsung.com> wrote:
>> This is a purely cosmetic change. Since the 'subdev' member
>> points to an array of subdevs it seems more intuitive to name
>> it in plural form.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/media/platform/soc_camera/soc_camera.c |    2 +-
>>  drivers/media/v4l2-core/v4l2-async.c           |    2 +-
>>  include/media/v4l2-async.h                     |    4 ++--
>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>
> 
> can you include the following changes in the same patch ?
> so that git bisect doesn’t break.
> 
> (maybe you need to rebase the patches on
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/for-v3.12)

Thanks for your testing and Ack. I'll wait couple days to also
let other take a look and review the patches. I'm not going to
try to merge that without at least Guennadi's Ack ;)

I think the best is to wait until the above patches from Hans'
tree get merged to the media master branch. Then I would rebase
my series on top of that before sending any pull request.

Regards,
Sylwester

> diff --git a/drivers/media/platform/davinci/vpif_capture.c
> b/drivers/media/platform/davinci/vpif_capture.c
> index b11d7a7..7fbde6d 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -2168,7 +2168,7 @@ static __init int vpif_probe(struct platform_device *pdev)
>  		}
>  		vpif_probe_complete();
>  	} else {
> -		vpif_obj.notifier.subdev = vpif_obj.config->asd;
> +		vpif_obj.notifier.subdevs = vpif_obj.config->asd;
>  		vpif_obj.notifier.num_subdevs = vpif_obj.config->asd_sizes[0];
>  		vpif_obj.notifier.bound = vpif_async_bound;
>  		vpif_obj.notifier.complete = vpif_async_complete;
> diff --git a/drivers/media/platform/davinci/vpif_display.c
> b/drivers/media/platform/davinci/vpif_display.c
> index c2ff067..6336dfc 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -1832,7 +1832,7 @@ static __init int vpif_probe(struct platform_device *pdev)
>  		}
>  		vpif_probe_complete();
>  	} else {
> -		vpif_obj.notifier.subdev = vpif_obj.config->asd;
> +		vpif_obj.notifier.subdevs = vpif_obj.config->asd;
>  		vpif_obj.notifier.num_subdevs = vpif_obj.config->asd_sizes[0];
>  		vpif_obj.notifier.bound = vpif_async_bound;
>  		vpif_obj.notifier.complete = vpif_async_complete;
