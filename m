Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.136]:42076 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750825AbcH0Jzu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 Aug 2016 05:55:50 -0400
Cc: Kyungmin Park <kyungmin.park@samsung.com>, kamil@wypas.org,
        jtp.park@samsung.com, a.hajda@samsung.com, mchehab@kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
To: linux-media@vger.kernel.org
From: Randy Li <randy.li@rock-chips.com>
Subject: MFC: different h264 profile and level output the same size encoded
 result
Message-ID: <3c01aadb-259f-0f38-47be-8170a87a7d7b@rock-chips.com>
Date: Sat, 27 Aug 2016 17:55:40 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi:

   I have been reported that the setting the profile, level and bitrate 
through the v4l2 extra controls would not make the encoded result 
different. I tried it recently, it is true. Although the h264 parser 
would tell me the result have been applied as different h264 profile and 
level, but size is the same.

You may try this in Gstreamer.

gst-launch-1.0 -v \
videotestsrc num-buffers=500 ! video/x-raw, width=1920,height=1080 ! \
videoconvert ! \
v4l2video4h264enc 
extra-controls="controls,h264_profile=1,video_bitrate=100;" ! \
h264parse ! matroskamux ! filesink location=/tmp/1.mkv

Is there any way to reduce the size of MFC encoded data?


