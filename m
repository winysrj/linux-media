Return-path: <linux-media-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:27835
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753151Ab3GSGZP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 02:25:15 -0400
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: <mchehab@redhat.com>, <s.nawrocki@samsung.com>,
	<hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
	<uclinux-dist-devel@blackfin.uclinux.org>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH RFC v4 0/1] [media] blackfin: add video display device driver
Date: Fri, 19 Jul 2013 15:27:48 -0400
Message-ID: <1374262068-32563-2-git-send-email-scott.jiang.linux@gmail.com>
In-Reply-To: <1374262068-32563-1-git-send-email-scott.jiang.linux@gmail.com>
References: <1374262068-32563-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-compliance output for this driver

root:/> v4l2-compliance -d 0
Driver Info:bfin_display bfin_display.0: =================  START STATUS  =================

        Driver name   : bfin_display
        Card type     : BF609
        Bus info      : platform:bfin_display
        Driver version: 3.5.0
        Capabilities  : 0x84000002
                Video Output
                Streaming
                Device Capabilities
        Device Caps   : 0x04000002
                Video Output
                Streaming

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second video open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
        test VIDIOC_DBG_G_CHIP_IDENT: OK (Not Supported)
        test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
adv7511 0-0039: power off
adv7511 0-0039: detected hotplug, detected Rx Sense, no EDID (0 block(s))
adv7511 0-0039: state: in reset, error: no error, detect count: 0, msk/irq: c4/c0
adv7511 0-0039: RGB quantization: full range
adv7511 0-0039: timings: 1280x720p60 (1650x750). Pix freq. = 74250000 Hz. Polarities = 0x3
adv7511 0-0039: edid_i2_addr: 0x7e
bfin_display bfin_display.0: ==================  END STATUS  ==================
        test VIDIOC_LOG_STATUS: OK

Input ioctls:
        test VIDIOC_G/S_TUNER: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
        test VIDIOC_G/S_MODULATOR: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_ENUMAUDOUT: OK (Not Supported)
        test VIDIOC_G/S/ENUMOUTPUT: OK
        test VIDIOC_G/S_AUDOUT: OK (Not Supported)
        Outputs: 1 Audio Outputs: 0 Modulators: 0

Control ioctls:
        test VIDIOC_QUERYCTRL/MENU: OK
        test VIDIOC_G/S_CTRL: OK
                fail: v4l2-test-controls.cpp(511): g_ext_ctrls does not support count == 0
        test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
        Standard Controls: 0 Private Controls: 0

Input/Output configuration ioctls:
                fail: v4l2-test-io-config.cpp(65): could set standard to ATSC, which is not supported anymore
                fail: v4l2-test-io-config.cpp(148): STD failed for output 0.
        test VIDIOC_ENUM/G/S/QUERY_STD: FAIL
        test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: OK (Not Supported)
                fail: v4l2-test-io-config.cpp(287): TIMINGS cap set, but no timings can be enumerated
                fail: v4l2-test-io-config.cpp(337): Timings check failed for output 0.
        test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: FAIL
                fail: v4l2-test-io-config.cpp(350): TIMINGS cap set, but could not get timings caps
                fail: v4l2-test-io-config.cpp(401): Timings cap check failed for output 0.
        test VIDIOC_DV_TIMINGS_CAP: FAIL

Format ioctls:
        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
        test VIDIOC_G/S_PARM: OK (Not Supported)
        test VIDIOC_G_FBUF: OK (Not Supported)
        test VIDIOC_G_FMT: OK
                fail: v4l2-test-formats.cpp(379): unknown pixelformat ffffffff for buftype 2
                fail: v4l2-test-formats.cpp(566): Video Output is valid, but TRY_FMT failed to return a format
        test VIDIOC_TRY_FMT: FAIL
                fail: v4l2-test-formats.cpp(379): unknown pixelformat ffffffff for buftype 2
                fail: v4l2-test-formats.cpp(719): Video Output is valid, but no S_FMT was implemented
        test VIDIOC_S_FMT: FAIL
        test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

Codec ioctls:
        test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
        test VIDIOC_G_ENC_INDEX: OK (Not Supported)
        test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK

Total: 38, Succeeded: 32, Failed: 6, Warnings: 1


