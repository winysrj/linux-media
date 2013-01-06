Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:33599 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab3AFXaS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2013 18:30:18 -0500
Received: by mail-la0-f41.google.com with SMTP id em20so13982738lab.14
        for <linux-media@vger.kernel.org>; Sun, 06 Jan 2013 15:30:16 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 7 Jan 2013 00:30:16 +0100
Message-ID: <CAExBR=sihci-AJtq3SEPEM2a+y=G6BC+ZNAa0bgrRsNcBphruw@mail.gmail.com>
Subject: When closing my webcam grabber app with CTRL+C, my /dev/video0 disappears
From: Diederick Huijbers <diederickh@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear list,

I've been working on a simple test application where I grab video frames, in yuv
from my Logitech Quickcam pro 9000 using v4l2. I'm getting the frames
(although I haven;t
decoded them yet) correctly.  I'm using mmap for io.

When I start my application, the LEDs of my cam turn on too. But when
I press CTRL+C, and
force my app to exit, the device disappears from /dev/video0 and my
keyboard which is
on the same usb bus stops working too.

I'm now rebooting to enable my keyboard and webcam again. I'm new with v4l and
wondering if someone knows about this problem or if someone has any
pointers for me
where I could look to figure out what's going on.

I've been looking at /var/log/dmesg but couldn't find anything in
there. When I press
CTRL+C nothing is logged to dmesg.

Best and thanks
roxlu
