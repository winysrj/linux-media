Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:49739 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752889AbcALMeV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2016 07:34:21 -0500
Subject: Re: vivid - video output
To: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
References: <CAJ2oMhJAHEqZTUC9Y-0jFqcw_JdfTxRsWH3eOSHWbFab+VnngA@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5694F3B4.7060405@xs4all.nl>
Date: Tue, 12 Jan 2016 13:38:12 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhJAHEqZTUC9Y-0jFqcw_JdfTxRsWH3eOSHWbFab+VnngA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/12/16 13:21, Ran Shalit wrote:
> Hello,
> 
> I would please like to ask about vivid video output:
> I've been trying to understand everything from source code and
> documentation, but still not quite sure about its purpose .
> 
> Vivid is good example for demonstration of how to write video output driver.
> But is it also to be used as a way to test/validate correctness of
> application video output   (just as done with vivid capture video,
> before using the real output HW) ?

Yes, it can be used for that purpose. Specifically with respect to the
handling of negotiating timings (G/S_DV_TIMINGS).

> 
> On delving in source code,  I see in vivid-kthread-out.c file
> 
> vivid_thread_vid_out() -> vivid_thread_vid_out_tick() ->
> 
> {....
> dequeue buffer(vid_out_buf)
> ....
> v4l2_get_timestamp(&vid_out_buf->vb.timestamp);
> vid_out_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
> ...}
> 
> What's the purpose of timestamp modification for the output frames ?
> Is it relevant only when using vivid in loopback mode ?

Are you talking about adding time_wrap_offset? The goal of that offset
is to be able to test what happens in the application if the timestamp
wraps around. Normally very hard to test, but with vivid it is easy to do.

> 
> I also encounter old patch of video output loopback (viloop.c), but I
> did't find it in released kernel.

That functionality is now integrated in vivid as the loopback mode.

> Application's video output frames can just be written into file and
> played later (as a way to validate the correctness of frames given to
> the video output driver), so I wander if there is any other purpose in
> vivid video output which I don't see yet.

It's not so much the frame content, it's about negotiating timings etc. where
vivid is useful to test v4l2 output applications.

Regards,

	Hans

> 
> Best Regards,
> Ran
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
