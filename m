Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:36736 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbcALMVx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2016 07:21:53 -0500
Received: by mail-ig0-f176.google.com with SMTP id z14so124124942igp.1
        for <linux-media@vger.kernel.org>; Tue, 12 Jan 2016 04:21:53 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 12 Jan 2016 14:21:52 +0200
Message-ID: <CAJ2oMhJAHEqZTUC9Y-0jFqcw_JdfTxRsWH3eOSHWbFab+VnngA@mail.gmail.com>
Subject: vivid - video output
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I would please like to ask about vivid video output:
I've been trying to understand everything from source code and
documentation, but still not quite sure about its purpose .

Vivid is good example for demonstration of how to write video output driver.
But is it also to be used as a way to test/validate correctness of
application video output   (just as done with vivid capture video,
before using the real output HW) ?

On delving in source code,  I see in vivid-kthread-out.c file

vivid_thread_vid_out() -> vivid_thread_vid_out_tick() ->

{....
dequeue buffer(vid_out_buf)
....
v4l2_get_timestamp(&vid_out_buf->vb.timestamp);
vid_out_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
...}

What's the purpose of timestamp modification for the output frames ?
Is it relevant only when using vivid in loopback mode ?

I also encounter old patch of video output loopback (viloop.c), but I
did't find it in released kernel.

Application's video output frames can just be written into file and
played later (as a way to validate the correctness of frames given to
the video output driver), so I wander if there is any other purpose in
vivid video output which I don't see yet.

Best Regards,
Ran
