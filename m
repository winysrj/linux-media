Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:40629 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3G3NNR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 09:13:17 -0400
Received: by mail-oa0-f41.google.com with SMTP id j6so6572367oag.14
        for <linux-media@vger.kernel.org>; Tue, 30 Jul 2013 06:13:17 -0700 (PDT)
MIME-Version: 1.0
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 30 Jul 2013 15:12:57 +0200
Message-ID: <CAPybu_1kw0CjtJxt-ivMheJSeSEi95ppBbDcG1yXOLLRaR4tRg@mail.gmail.com>
Subject: Question about v4l2-compliance: cap->readbuffers
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I am developing a driver for a camera that supports read/write and
mmap access to the buffers.

When I am running the compliance test, I cannot pass it because of
this test on v4l2-test-formats.cpp

904                 if (!(node->caps & V4L2_CAP_READWRITE))
905                         fail_on_test(cap->readbuffers);
906                 else if (node->caps & V4L2_CAP_STREAMING)
907                         fail_on_test(!cap->readbuffers);

What should be the value of cap-readbuffers for a driver such as mine,
that supports cap_readwrite and cap_streaming? Or I cannot support
both, although at least this drivers do the same?


$ git grep CAP_READWRITE *  | grep CAP_STREAMING
pci/cx25821/cx25821-video.c: V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
pci/cx88/cx88-video.c: cap->device_caps = V4L2_CAP_READWRITE |
V4L2_CAP_STREAMING;
pci/saa7134/saa7134-video.c: cap->device_caps = V4L2_CAP_READWRITE |
V4L2_CAP_STREAMING;
platform/marvell-ccic/mcam-core.c: V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
platform/via-camera.c: V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
usb/cx231xx/cx231xx-video.c: cap->device_caps = V4L2_CAP_READWRITE |
V4L2_CAP_STREAMING;
usb/em28xx/em28xx-video.c: V4L2_CAP_READWRITE | V4L2_CAP_VIDEO_CAPTURE
| V4L2_CAP_STREAMING;
usb/stkwebcam/stk-webcam.c: | V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
usb/tlg2300/pd-video.c: V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;


Thanks!

-- 
Ricardo Ribalda
