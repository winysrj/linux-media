Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45498 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459Ab2AEAst (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 19:48:49 -0500
Received: by wgbdr13 with SMTP id dr13so18607wgb.1
        for <linux-media@vger.kernel.org>; Wed, 04 Jan 2012 16:48:48 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 4 Jan 2012 19:48:47 -0500
Message-ID: <CALzAhNVYeeAfS+RycntPyz8nhLqow5CtCdwmxJpuHU6-6Kx8hQ@mail.gmail.com>
Subject: subdev support for querying struct v4l2_input *
From: Steven Toth <stoth@kernellabs.com>
To: "Jacob Johan (Hans) Verkuil" <hverkuil@xs4all.nl>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

In the cx23885 driver as part of vidioc_enum_input call, I have a need
to return V4L2_IN_ST_NO_SIGNAL in the status
field as part of struct v4l2_input. Thus, when no signal is detected
by the video decoder it can be signalled to the calling application.

I looks like subdev_core_ops doesn't currently support this, or have I
miss-understood something?

The patch below is a snippet from a larger patch I have which:
1. Adds this support to struct v4l2_subdev_core_ops
2. Adds support to the cx25840 and cx23885 drivers and makes the
feature available.

Do you have any comments or thoughts on the subdev_ops patch below?

Regards,

- Steve

Index: v4l-dvb/include/media/v4l2-subdev.h
===================================================================
--- v4l-dvb.orig/include/media/v4l2-subdev.h    2012-01-03
17:44:24.337826817 -0500
+++ v4l-dvb/include/media/v4l2-subdev.h 2012-01-03 17:44:54.729826263 -0500
@@ -172,6 +172,7 @@
                               struct v4l2_event_subscription *sub);
        int (*unsubscribe_event)(struct v4l2_subdev *sd, struct v4l2_fh *fh,
                                 struct v4l2_event_subscription *sub);
+       int (*enum_input)(struct v4l2_subdev *sd, struct v4l2_input *i);
 };



-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
