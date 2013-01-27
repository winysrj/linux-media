Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:48866 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab3A0Tpb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jan 2013 14:45:31 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/7] saa7134: improve v4l2-compliance
Date: Sun, 27 Jan 2013 20:45:05 +0100
Message-Id: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
this patch series improves v4l2-compliance of saa7134 driver. There are still
some problems. Controls require conversion to control framework which I was
unable to finish (because the driver accesses other controls and also the
file handle from within s_ctrl).

Radio is now OK except for controls.
Video has problems with controls, debugging, formats and buffers:
Debug ioctls:
        test VIDIOC_DBG_G_CHIP_IDENT: OK (Not Supported)
                fail: v4l2-test-debug.cpp(84): doioctl(node, VIDIOC_DBG_G_CHIP_IDENT, &chip)
Format ioctls:
        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                fail: v4l2-test-formats.cpp(836): !cap->readbuffers
        test VIDIOC_G/S_PARM: FAIL
                fail: v4l2-test-formats.cpp(335): !fmt.width || !fmt.height
        test VIDIOC_G_FBUF: FAIL
                fail: v4l2-test-formats.cpp(382): !pix.colorspace
Buffer ioctls:
                fail: v4l2-test-buffers.cpp(109): can_stream && !mmap_valid && !userptr_valid && !dmabuf_valid
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL


Haven't looked into VBI yet:
Format ioctls:
                fail: v4l2-test-formats.cpp(914): G/S_PARM is only allowed for video capture/output
        test VIDIOC_G/S_PARM: FAIL
                fail: v4l2-test-formats.cpp(432): vbi.reserved not zeroed
                fail: v4l2-test-formats.cpp(570): VBI Capture is valid, but TRY_FMT failed to return a format
        test VIDIOC_TRY_FMT: FAIL
                fail: v4l2-test-formats.cpp(432): vbi.reserved not zeroed
                fail: v4l2-test-formats.cpp(728): VBI Capture is valid, but no S_FMT was implemented
        test VIDIOC_S_FMT: FAIL

-- 
Ondrej Zary


