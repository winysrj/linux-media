Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:42670 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728452AbeIHCXG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2018 22:23:06 -0400
Received: by mail-qt0-f180.google.com with SMTP id z8-v6so17767690qto.9
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2018 14:40:12 -0700 (PDT)
MIME-Version: 1.0
From: Satish Nagireddy <satish.nagireddy1@gmail.com>
Date: Fri, 7 Sep 2018 14:40:01 -0700
Message-ID: <CADsxt07mLmNxKc==D2BcoZwjJPcPAXgmcMRcsVkcE5xyQtNZQQ@mail.gmail.com>
Subject: Query on V4L2 interlaced "height"
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am working on interlaced capture devices. There is some confusion in
handling height parameter between application and driver.

Capture device is able to produce 1920x1080i, where one field
(top/bottom) resolution is 1920x540.

Query 1:
What should be the height passed by application to driver to capture
1920x1080i resolution?
According to v4l2 specification:
https://www.kernel.org/doc/html/v4.16/media/uapi/v4l/pixfmt-v4l2.html

Image height in pixels. If field is one of V4L2_FIELD_TOP,
V4L2_FIELD_BOTTOM or V4L2_FIELD_ALTERNATE then height refers to

the number of lines in the field, otherwise it refers to the number of
lines in the frame (which is twice the field height for interlaced
formats).

Query 2:
I can think of 4 possible cases here:

i) If application calling VIDIOC_TRY_FMT with filed as
V4L2_FIELD_ALTERNATE and capture hardware supports same

ii) If application calling VIDIOC_TRY_FMT with filed as
V4L2_FIELD_NONE and capture hardware supports same

iii) If application calling VIDIOC_TRY_FMT with field as
V4L2_FIELD_NONE (progressive) and capture hardware supports
V4L2_FIELD_ALTERNATE

iv) If application calling VIDIOC_TRY_FMT with field as
V4L2_FIELD_ALTERNATE (progressive) and capture hardware supports
V4L2_FIELD_NONE

The first 2 cases are straightforward. What should be the driver
behavior for iii and iv ? Should it alter height passed by the
application accordingly?

I see some of the capture drivers are dividing height by 2 if field is
V4L2_FIELD_ALTERNATE. Is this the right behavior?

Regards,
Satish
