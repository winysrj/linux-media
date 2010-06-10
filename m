Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54325 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759710Ab0FJTG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jun 2010 15:06:56 -0400
Received: by wyb40 with SMTP id 40so192546wyb.19
        for <linux-media@vger.kernel.org>; Thu, 10 Jun 2010 12:06:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilE1UKkTBeNHSStKo6ibs-7Hun87HfFbF7JdNig@mail.gmail.com>
References: <loom.20100610T052202-829@post.gmane.org>
	<20100610095338.35d46e1c@tele>
	<AANLkTinoHhuPRV8m7vf38lKiwOXV7WNFd36MmBmuRhNQ@mail.gmail.com>
	<AANLkTilE1UKkTBeNHSStKo6ibs-7Hun87HfFbF7JdNig@mail.gmail.com>
Date: Thu, 10 Jun 2010 20:06:54 +0100
Message-ID: <AANLkTimyeuGP6NrTwJj4W6e2A-PfFPnVvxc8iBQstS9B@mail.gmail.com>
Subject: Re: V4L Camera frame timestamp question
From: Paulo Assis <pj.assis@gmail.com>
To: Jiajun Zhu <zhujiajun@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2010/6/10 Jiajun Zhu <zhujiajun@gmail.com>:
> Thanks for the discussion.
> Based on my testing, the image timestamps or ktime is the system uptime in
> nanosecond, is this correct?
> For my application, I need to synchronize the camera image with other data
> which are all timestamped by gettimeofday().

Like I explained gettimeofday is not the proper way to set timestamps,
you should use a monotonic clock:

e.g.:

//timestamps in nanosec
uint64_t ns_time_monotonic()
{
	static struct timespec ts;
	clock_gettime(CLOCK_MONOTONIC, &ts);
	return ((uint64_t) ts.tv_sec * G_NSEC_PER_SEC + (uint64_t) ts.tv_nsec);
}

This will give you a similar timestamp to ktime.

> How would you suggest me to do this?
> I can think of two options:
> 1.  Get the system uptime and compute the offset between gettimeofday() at
> the start of my program, and then use this offset
>      to correct all the image timestamps.
>      The only linux userspace function I can find to get system uptime is to
> read /proc/uptime file, which resolution is 0.01 seconds.
> 2.  Hack the camera driver to use do_getimeofday() instead of ktime, and
> ignore all the problems you guys mentioned earlier.
> Any comments?

In my case to sync audio and video timestamps I just take the first
video ts and check it against the
initial audio ts (taken with the above function) , remember that for
timestamps the important thing is the delta between them,
so you can store the first one and just use the difference for the
next  ones. e.g.:

//timestamps in nanosec

if (first_frame)
     ts_ref = (uint64_t) buf.timestamp.tv_sec * 1000000000 +
buf.timestamp.tv_usec *1000;

frame_ts =  ((uint64_t) buf.timestamp.tv_sec * 1000000000 +
buf.timestamp.tv_usec *1000)  - ts_ref;

now you can also use ts_ref for audio timestamps.

If you really need to use getttimeofday (very bad idea), you just need
the timeofday for the first (ref_ts) timestamp
for the others just use the delta.

so when you grab the first frame also get the value of getimeofday()
(in the same time base), that's that simple, from then on just do:

 initial_frame_timeofday + frame_ts


Best Regards,
Paulo
