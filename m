Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730458AbeKMGzg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 01:55:36 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wACKhp7l021718
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 16:00:39 -0500
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2nqd4sadaj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 16:00:39 -0500
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.ibm.com>;
        Mon, 12 Nov 2018 21:00:37 -0000
From: Eddie James <eajames@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@kernel.org,
        linux-media@vger.kernel.org, robh+dt@kernel.org, andrew@aj.id.au,
        linux-aspeed@lists.ozlabs.org, devicetree@vger.kernel.org,
        mark.rutland@arm.com, Eddie James <eajames@linux.vnet.ibm.com>
Subject: [PATCH v5 0/2] media: platform: Add Aspeed Video Engine Driver
Date: Mon, 12 Nov 2018 15:00:29 -0600
Message-Id: <1542056431-18146-1-git-send-email-eajames@linux.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Eddie James <eajames@linux.vnet.ibm.com>

The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
can capture and compress video data from digital or analog sources. With
the Aspeed chip acting as a service processor, the Video Engine can
capture the host processor graphics output.

This series adds a V4L2 driver for the VE, providing the usual V4L2 streaming
interface by way of videobuf2. Each frame, the driver triggers the hardware to
capture the host graphics output and compress it to JPEG format.

v4l-utils HEAD dd3ff81f58c4e1e6f33765dc61ad33c48ae6bb07

v4l2-compliance SHA: not available, 32 bits

Compliance test for device /dev/video0:

Driver Info:
	Driver name      : aspeed-video
	Card type        : Aspeed Video Engine
	Bus info         : platform:aspeed-video
	Driver version   : 4.18.12
	Capabilities     : 0x85200001
		Video Capture
		Read/Write
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x05200001
		Video Capture
		Read/Write
		Streaming
		Extended Pix Format

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video0 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 1 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK
	test VIDIOC_DV_TIMINGS_CAP: OK
	test VIDIOC_G/S_EDID: OK (Not Supported)

Control ioctls (Input 0):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		fail: v4l2-test-controls.cpp(823): failed to find event for control 'Chroma Subsampling'
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 3 Private Controls: 0

Format ioctls (Input 0):
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls (Input 0):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 0):
		fail: v4l2-test-buffers.cpp(422): dmabuf_valid ^ !!(caps & V4L2_BUF_CAP_SUPPORTS_DMABUF)
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
	test VIDIOC_EXPBUF: OK (Not Supported)

Test input 0:

Streaming ioctls:
	test read/write: OK
	test blocking wait: OK
	test MMAP: OK                                     
	test USERPTR: OK (Not Supported)
		fail: v4l2-test-buffers.cpp(1102): exp_q.reqbufs(expbuf_node, q.g_buffers())
		fail: v4l2-test-buffers.cpp(1192): setupDmaBuf(expbuf_node, node, q, exp_q)
	test DMABUF: FAIL

Total: 48, Succeeded: 45, Failed: 3, Warnings: 0

The apparent rate of change to the v4l2/vb2 API makes it difficult to pass
these tests. None of the failing tests even ran last time I submitted my
series. And V4L2_BUF_CAP_SUPPORTS_DMABUF is undefined in 4.19.

Changes since v4:
 - Set real min and max resolution in enum_dv_timings
 - Add check for vb2_is_busy before settings the timings
 - Set max frame rate to the actual max rather than max + 1
 - Correct the input status to 0.
 - Rework resolution change to only set the relevant h/w regs during startup or
   when set_timings is called.

Changes since v3:
 - Switch update reg function to use u32 clear rather than unsigned long mask
 - Add timing information from host VGA signal
 - Fix binding documentation mispelling
 - Fix upper case hex values
 - Add wait_prepare and wait_finish
 - Set buffer state to queued (rather than error) if streaming fails to start
 - Switch engine busy print statement to error
 - Removed a couple unecessary type assignments in v4l2 ioctls
 - Added query_dv_timings, fixed get_dv_timings
 - Corrected source change event to fire if and only if size actually changes
 - Locked open and release

Changes since v2:
 - Switch to streaming interface. This involved a lot of changes.
 - Rework memory allocation due to using videobuf2 buffers, but also only
   allocate the necessary size of source buffer rather than the max size

Changes since v1:
 - Removed le32_to_cpu calls for JPEG header data
 - Reworked v4l2 ioctls to be compliant.
 - Added JPEG controls
 - Updated devicetree docs according to Rob's suggestions.
 - Added myself to MAINTAINERS

Eddie James (2):
  dt-bindings: media: Add Aspeed Video Engine binding documentation
  media: platform: Add Aspeed Video Engine driver

 .../devicetree/bindings/media/aspeed-video.txt     |   26 +
 MAINTAINERS                                        |    8 +
 drivers/media/platform/Kconfig                     |    9 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/aspeed-video.c              | 1711 ++++++++++++++++++++
 5 files changed, 1755 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/aspeed-video.txt
 create mode 100644 drivers/media/platform/aspeed-video.c

-- 
1.8.3.1
