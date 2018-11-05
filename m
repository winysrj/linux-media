Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:6881 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726358AbeKEVlT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 16:41:19 -0500
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id wA5CD8I4001882
        for <linux-media@vger.kernel.org>; Mon, 5 Nov 2018 12:21:48 GMT
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
        by mx07-00252a01.pphosted.com with ESMTP id 2nh1y5h059-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Mon, 05 Nov 2018 12:21:47 +0000
Received: by mail-pg1-f198.google.com with SMTP id d8-v6so8325963pgq.3
        for <linux-media@vger.kernel.org>; Mon, 05 Nov 2018 04:21:47 -0800 (PST)
MIME-Version: 1.0
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Mon, 5 Nov 2018 12:21:35 +0000
Message-ID: <CAAoAYcOuXvryXaXTMETDwKeVTooc2f6aCFp3u0FLvB=ETrgXow@mail.gmail.com>
Subject: VIDIOC_SUBSCRIBE_EVENT for V4L2_EVENT_CTRL regression?
To: LMML <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All

I'm testing with 4.19 and finding that testEvents in v4l2-compliance
is failing with ""failed to find event for control '%s' type %u", ie
it hasn't got the event for the inital values. This is with the
various BCM2835 drivers that I'm involved with.

Having looked at the v4l2-core history I tried reverting "ad608fb
media: v4l: event: Prevent freeing event subscriptions while
accessed". The test passes again.

Enabling all logging, and adding a couple of logging messages at the
beginning and end of v4l2_ctrl_add_event and __v4l2_event_queue_fh
error path, I get the following logs:

[   90.629999] v4l2_ctrl_add_event: ctrl a2b86fa8 "User Controls" type
6, flags 0001
[   90.630002] video0: VIDIOC_SUBSCRIBE_EVENT: type=0x3, id=0x980001, flags=0x1
[   91.630166] videodev: v4l2_poll: video0: poll: 00000000
[   91.630311] videodev: v4l2_poll: video0: poll: 00000000
[   91.630325] video0: VIDIOC_UNSUBSCRIBE_EVENT: type=0x3,
id=0x980001, flags=0x1
[   91.630396] v4l2_ctrl_add_event: ctrl 8f6fcc61 "Brightness" type 1,
flags 0001
[   91.630403] __v4l2_event_queue_fh: Not subscribed to event type 3 id 0x980001
[   91.630407] v4l2_ctrl_add_event: ctrl 8f6fcc61 "Brightness" type 1
- initial values queued
[   91.630409] video0: VIDIOC_SUBSCRIBE_EVENT: type=0x3, id=0x980900, flags=0x1
[   92.630513] videodev: v4l2_poll: video0: poll: 00000000
[   92.630660] videodev: v4l2_poll: video0: poll: 00000000
[   92.630729] videodev: v4l2_release: video0: release

So __v4l2_event_queue_fh is dropping the event as we aren't subscribed
at the point that the initial values are queued.

Sorry, I don't have any other devices that support subscribing for
events to hand (uvcvideo passes the test as it reports unsupported). I
don't have a media tree build immediately available either, but I
can't see anything related to this in the recent history. I can go
down that route if needed.
v4l-utils repo was synced today - head at "f9881444e8 cec-compliance:
wake-up on Active Source is warn for <2.0"

Could someone test on other hardware to confirm that it's not the
drivers I'm using? I'm fairly certain it isn't as that patch does call
sev->ops->add(sev, elems); before list_add(&sev->list,
&fh->subscribed), and that is guaranteed to fail if sev->ops->add
immediately queues an event.

Thanks
  Dave
