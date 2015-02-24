Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:35553 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbbBXIFM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 03:05:12 -0500
MIME-Version: 1.0
In-Reply-To: <7125910.hm5qgSJ3zA@avalon>
References: <1424722773-20131-1-git-send-email-prabhakar.csengg@gmail.com>
 <1424722773-20131-3-git-send-email-prabhakar.csengg@gmail.com> <7125910.hm5qgSJ3zA@avalon>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 24 Feb 2015 08:04:40 +0000
Message-ID: <CA+V-a8urdZhD97m4mQu_aYLWW9Kf0PSx=ddhbvteb-HRz2hEEA@mail.gmail.com>
Subject: Re: [PATCH 2/3] media: omap3isp: ispvideo: drop driver specific isp_video_fh
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review.

On Tue, Feb 24, 2015 at 12:35 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thank you for the patch.
>
> On Monday 23 February 2015 20:19:32 Lad Prabhakar wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> this patch drops driver specific isp_video_fh, as this
>> can be handled by core.
>
> I'm afraid it's not that simple.
>
> The omap3isp driver stores video queues per file handle for a reason. This was
> design to permit creating a high-resolution still image capture queue and
> prepare buffers ahead of time, to avoid the large delay due to cache
> management as prepare time when taking the snapshot.
>
Ah I see the reason.

> Now this use case has been partially solved by VIDIOC_CREATE_BUFS, but we're
> still missing a VIDIOC_DESTROY_BUFS to make it work completely. That needs to
> be solved first.
>
I haven't used the VIDIOC_CREATE_BUFS ioctl so far in any of the apps
so cant comment
much on this.
But isn't that obvious we need VIDIOC_DESTROY_BUFS or is there any backdoor
to destroy them that I am missing ?

Regards,
--Prabhakar Lad

>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  drivers/media/platform/omap3isp/ispvideo.c | 128  ++++++++++---------------
>>  drivers/media/platform/omap3isp/ispvideo.h |  13 +--
>>  2 files changed, 49 insertions(+), 92 deletions(-)
>
> --
> Regards,
>
> Laurent Pinchart
>
