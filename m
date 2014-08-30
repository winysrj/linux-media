Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:45762 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaH3MEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Aug 2014 08:04:04 -0400
Received: by mail-la0-f48.google.com with SMTP id gl10so3927477lab.21
        for <linux-media@vger.kernel.org>; Sat, 30 Aug 2014 05:04:02 -0700 (PDT)
MIME-Version: 1.0
From: Isaac Nickaein <nickaein.i@gmail.com>
Date: Sat, 30 Aug 2014 16:33:42 +0430
Message-ID: <CA+NJmkew9qJW9+MKs2n+o2p6mCHBqG2bZxE72EdVZdkKqjW0VA@mail.gmail.com>
Subject: Actual framerate is always divided by 2.5
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am working on a ARM board and have patched its kernel to support
V4L2 with help of Mr. Hans Verkuil (here is the discussion:
http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/80350).

The problem I have now is the actual frame rate is divided by a factor
of 2.5. For instance, when I set the framerate to be @25fps, I can
capture images at exact 10fps. Here is more results showing the
framerate reported by "v4l2-ctl -P" command vs. the measured framerate
inside my C++ code (I capture each image and throw them away to
eliminate irrelevant times in measuring fps):

Reported by v4l2-ctl: 10 fps  ->  Actual: 4 fps
Reported by v4l2-ctl: 15 fps  ->  Actual: 6 fps
Reported by v4l2-ctl: 25 fps  ->  Actual: 10 fps
Reported by v4l2-ctl: 30 fps  ->  Actual: 12 fps

This seems to be a clocking issue. Is there any constant multiplier in
V4L2 (or UVC?) code which depends on the hardware and be cause of this
problem?

Thanks,
Isaac
