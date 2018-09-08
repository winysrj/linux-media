Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:60927 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbeIHNdP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Sep 2018 09:33:15 -0400
Subject: Re: Query on V4L2 interlaced "height"
To: Satish Nagireddy <satish.nagireddy1@gmail.com>,
        linux-media@vger.kernel.org
References: <CADsxt07mLmNxKc==D2BcoZwjJPcPAXgmcMRcsVkcE5xyQtNZQQ@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <26c3ff09-3676-4113-5eb6-ba11a36e8a7f@xs4all.nl>
Date: Sat, 8 Sep 2018 10:48:12 +0200
MIME-Version: 1.0
In-Reply-To: <CADsxt07mLmNxKc==D2BcoZwjJPcPAXgmcMRcsVkcE5xyQtNZQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/2018 11:40 PM, Satish Nagireddy wrote:
> Hi,
> 
> I am working on interlaced capture devices. There is some confusion in
> handling height parameter between application and driver.
> 
> Capture device is able to produce 1920x1080i, where one field
> (top/bottom) resolution is 1920x540.
> 
> Query 1:
> What should be the height passed by application to driver to capture
> 1920x1080i resolution?
> According to v4l2 specification:
> https://www.kernel.org/doc/html/v4.16/media/uapi/v4l/pixfmt-v4l2.html
> 
> Image height in pixels. If field is one of V4L2_FIELD_TOP,
> V4L2_FIELD_BOTTOM or V4L2_FIELD_ALTERNATE then height refers to
> 
> the number of lines in the field, otherwise it refers to the number of
> lines in the frame (which is twice the field height for interlaced
> formats).

Assuming that the HDMI receiver uses FIELD_ALTERNATE (i.e. it delivers
first the top field, then the bottom field), then height is 540.

> 
> Query 2:
> I can think of 4 possible cases here:
> 
> i) If application calling VIDIOC_TRY_FMT with filed as
> V4L2_FIELD_ALTERNATE and capture hardware supports same
>
> ii) If application calling VIDIOC_TRY_FMT with filed as
> V4L2_FIELD_NONE and capture hardware supports same
> 
> iii) If application calling VIDIOC_TRY_FMT with field as
> V4L2_FIELD_NONE (progressive) and capture hardware supports
> V4L2_FIELD_ALTERNATE
> 
> iv) If application calling VIDIOC_TRY_FMT with field as
> V4L2_FIELD_ALTERNATE (progressive) and capture hardware supports
> V4L2_FIELD_NONE
> 
> The first 2 cases are straightforward. What should be the driver
> behavior for iii and iv ? Should it alter height passed by the
> application accordingly?
> 
> I see some of the capture drivers are dividing height by 2 if field is
> V4L2_FIELD_ALTERNATE. Is this the right behavior?

Yes.

What the driver does depends on the digital video timings (i.e. what
VIDIOC_G_DV_TIMINGS gives you). If that is progressive, then the driver
will set field to NONE and height to the frame height, regardless of
what the application asks for. If that is interlaced, then the driver
will set field to ALTERNATE and height to the frame height, again
regardless of what the application asks for.

Things can get more complicated if the driver can scale and/or
de-interlace. If that's the case we can go into more detail.

Check the vivid driver: it can emulate an HDMI input and 1080i. That
driver does the right thing.

Make sure you implement the DV_TIMINGS ioctls correctly. Check with other
drivers how to do that. The most common mistake is trying to autodetect
when the received video timings change and automatically reconfigure the
receiver for the new resolution. This is wrong: the driver should send
the V4L2_EVENT_SOURCE_CHANGE event, userspace will call QUERY_DV_TIMINGS
upon receipt of the event, and reconfigure the pipeline according to
the result.

Regards,

	Hans
