Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33699 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab1LSOsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 09:48:20 -0500
Received: by werm1 with SMTP id m1so1317525wer.19
        for <linux-media@vger.kernel.org>; Mon, 19 Dec 2011 06:48:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201112191259.24956.laurent.pinchart@ideasonboard.com>
References: <CACKLOr1qSpJXjyptUF3OEWR2b7XNoRdMjiVWzZ9gtuanfgJZDQ@mail.gmail.com>
	<201112190119.08008.laurent.pinchart@ideasonboard.com>
	<CACKLOr2zx_xcHS0059N0mAaZb2kiCj+xfyE1D5iDsZkNyvTwcw@mail.gmail.com>
	<201112191259.24956.laurent.pinchart@ideasonboard.com>
Date: Mon, 19 Dec 2011 15:48:18 +0100
Message-ID: <CACKLOr1QObHAQfUo5OKeQHHMzLp-bs_bVDp4AbhveLF-PFRvPQ@mail.gmail.com>
Subject: Re: Trying to figure out reasons for lost pictures in UVC driver.
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19 December 2011 12:59, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Javier,
>
> On Monday 19 December 2011 12:01:34 javier Martin wrote:
>> On 19 December 2011 01:19, Laurent Pinchart wrote:
>> > On Thursday 15 December 2011 17:02:47 javier Martin wrote:
>> >> Hi,
>> >> we are testing a logitech Webcam M/N: V-U0012 in the UVC tree (commit
>> >> ef7728797039bb6a20f22cc2d96ef72d9338cba0).
>> >> It is configured at 25fps, VGA.
>> >>
>> >> We've observed that the following debugging message appears sometimes
>> >> "Frame complete (FID bit toggled).". Whenever this happens a v4l2
>> >> frame is lost (i.e. one sequence number has been skipped).
>> >>
>> >> Is this behavior expected? What could we do to avoid frame loss?
>> >
>> > Could you check the frame intervals to see if a frame is really lost, or
>> > if the driver erroneously reports frame loss ?
>>
>> Hi Laurent,
>> sequence number in the v4l2 buffer returned is one step bigger than
>> expected, however the timestamp difference with the previous buffer is
>> 40ms which is what it is expected at 25fps.
>> So, sequence number indicates a buffer has been lost but timestamp does
>> not.
>
> Could you please test the following patch ?
>
> From e6d21947277ad7875e41a90d387db8a1160368b6 Mon Sep 17 00:00:00 2001
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Date: Mon, 19 Dec 2011 12:54:20 +0100
> Subject: [PATCH] uvcvideo: Toggle the stored FID bit when detecting a new frame
>
> The FID bit is used to detect the start of a new frame by comparing the
> value sent by the device with the last value stored in the driver. When
> a new frame is detected this way the last value isn't updated, which
> leads to the frame sequence being incremented twice. Fix this by
> toggling the stored FID bit correctly.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/uvc/uvc_video.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
> index c7e69b8..f61c36b 100644
> --- a/drivers/media/video/uvc/uvc_video.c
> +++ b/drivers/media/video/uvc/uvc_video.c
> @@ -1031,6 +1031,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
>                uvc_trace(UVC_TRACE_FRAME, "Frame complete (FID bit "
>                                "toggled).\n");
>                buf->state = UVC_BUF_STATE_READY;
> +               stream->last_fid = fid;
>                return -EAGAIN;
>        }
>
> --
> Regards,
>
> Laurent Pinchart

Hi Laurent,
after applying the patch we  keep on losing frames, sometimes a great
amount of them. And timestamps are still wrong. For instance, the
following case shows a current timestamp being lesser than the
previous:

Lost 40 frames during acquisition. Total 40 pictures lost
Previous timestamp: 902 s, 818241 us. Current timestamp: 902 s, 145941 us.

Every time those kind of issues appear we get the following message
from the kernel:
"Dropping payload (out of sync)."


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
