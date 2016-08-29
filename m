Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29045 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750738AbcH2Fth (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 01:49:37 -0400
Subject: Re: MFC: different h264 profile and level output the same size encoded
 result
To: Randy Li <randy.li@rock-chips.com>, linux-media@vger.kernel.org
References: <3c01aadb-259f-0f38-47be-8170a87a7d7b@rock-chips.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, kamil@wypas.org,
        jtp.park@samsung.com, mchehab@kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <75aa1b3d-9270-3af1-f74b-dba4ceeb41a0@samsung.com>
Date: Mon, 29 Aug 2016 07:49:18 +0200
MIME-version: 1.0
In-reply-to: <3c01aadb-259f-0f38-47be-8170a87a7d7b@rock-chips.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/27/2016 11:55 AM, Randy Li wrote:
> Hi:
>
>    I have been reported that the setting the profile, level and bitrate 
> through the v4l2 extra controls would not make the encoded result 
> different. I tried it recently, it is true. Although the h264 parser 
> would tell me the result have been applied as different h264 profile and 
> level, but size is the same.
>
> You may try this in Gstreamer.
>
> gst-launch-1.0 -v \
> videotestsrc num-buffers=500 ! video/x-raw, width=1920,height=1080 ! \
> videoconvert ! \
> v4l2video4h264enc 
> extra-controls="controls,h264_profile=1,video_bitrate=100;" ! \
> h264parse ! matroskamux ! filesink location=/tmp/1.mkv
>
> Is there any way to reduce the size of MFC encoded data?
>

There is control called rc_enable (rate control enable), it must be set
to one if you want to control bitrate.
This control confuses many users, I guess it cannot be removed as it
is already part of UAPI, but enabling it internally by the driver
if user sets bitrate, profille, etc, would make it more saner.

Regards
Andrzej

