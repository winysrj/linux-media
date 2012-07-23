Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58033 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab2GWJpg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 05:45:36 -0400
Received: by wibhm11 with SMTP id hm11so2688385wib.1
        for <linux-media@vger.kernel.org>; Mon, 23 Jul 2012 02:45:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207231045.48762.hverkuil@xs4all.nl>
References: <1342782515-24992-1-git-send-email-javier.martin@vista-silicon.com>
	<201207231036.21120.hverkuil@xs4all.nl>
	<CACKLOr36MnD8fpiJDmDWGir=nWWZEQdrZjvVJTfEBORARMrmGA@mail.gmail.com>
	<201207231045.48762.hverkuil@xs4all.nl>
Date: Mon, 23 Jul 2012 11:45:34 +0200
Message-ID: <CACKLOr312a=KTrm9=N48=SHN5Z=0yTPceopG9MJBu8he_3yjrw@mail.gmail.com>
Subject: Re: [PATCH v6] media: coda: Add driver for Coda video codec.
From: javier Martin <javier.martin@vista-silicon.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	s.hauer@pengutronix.de, p.zabel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, I had a problem with my buildroot environment. This is the
v4l2-compliance output with the most recent version:

# v4l2-compliance -d /dev/video2
Driver Info:
        Driver name   : coda
        Card type     : coda
        Bus info      : coda
        Driver version: 0.0.0
        Capabilities  : 0x84000003
                Video Capture
                Video Output
                Streaming
                Device Capabilities
        Device Caps   : 0x04000003
                Video Capture
                Video Output
                Streaming

Compliance test for device /dev/video2 (not using libv4l2):

Required ioctls:
                fail: v4l2-compliance.cpp(270): (vcap.version >> 16) < 3
        test VIDIOC_QUERYCAP: FAIL

Allow for multiple opens:
        test second video open: OK
                fail: v4l2-compliance.cpp(270): (vcap.version >> 16) < 3
        test VIDIOC_QUERYCAP: FAIL
                fail: v4l2-compliance.cpp(311): doioctl(node,
VIDIOC_G_PRIORITY, &prio)
        test VIDIOC_G/S_PRIORITY: FAIL

Debug ioctls:
        test VIDIOC_DBG_G_CHIP_IDENT: Not Supported
        test VIDIOC_DBG_G/S_REGISTER: Not Supported
        test VIDIOC_LOG_STATUS: Not Supported

Input ioctls:
        test VIDIOC_G/S_TUNER: Not Supported
        test VIDIOC_G/S_FREQUENCY: Not Supported
        test VIDIOC_S_HW_FREQ_SEEK: Not Supported
        test VIDIOC_ENUMAUDIO: Not Supported
        test VIDIOC_G/S/ENUMINPUT: Not Supported
        test VIDIOC_G/S_AUDIO: Not Supported
        Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
        test VIDIOC_G/S_MODULATOR: Not Supported
        test VIDIOC_G/S_FREQUENCY: Not Supported
        test VIDIOC_ENUMAUDOUT: Not Supported
        test VIDIOC_G/S/ENUMOUTPUT: Not Supported
        test VIDIOC_G/S_AUDOUT: Not Supported
        Outputs: 0 Audio Outputs: 0 Modulators: 0

Control ioctls:
        test VIDIOC_QUERYCTRL/MENU: OK
        test VIDIOC_G/S_CTRL: OK
                fail: v4l2-test-controls.cpp(565): try_ext_ctrls did
not check the read-only flag
        test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
                fail: v4l2-test-controls.cpp(698): subscribe event for
control 'MPEG Encoder Controls' failed
        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
        test VIDIOC_G/S_JPEGCOMP: Not Supported
        Standard Controls: 10 Private Controls: 0

Input/Output configuration ioctls:
        test VIDIOC_ENUM/G/S/QUERY_STD: Not Supported
        test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: Not Supported
        test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: Not Supported
        test VIDIOC_DV_TIMINGS_CAP: Not Supported

Format ioctls:
        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                fail: v4l2-test-formats.cpp(558): cap->readbuffers
        test VIDIOC_G/S_PARM: FAIL
        test VIDIOC_G_FBUF: Not Supported
                fail: v4l2-test-formats.cpp(382): !pix.width || !pix.height
        test VIDIOC_G_FMT: FAIL
        test VIDIOC_G_SLICED_VBI_CAP: Not Supported
Buffer ioctls:
                fail: v4l2-test-buffers.cpp(111): doioctl(node->node2,
VIDIOC_REQBUFS, &bufs) != EBUSY
        test VIDIOC_REQBUFS/CREATE_BUFS: FAIL
        test read/write: OK
Total: 34 Succeeded: 26 Failed: 8 Warnings: 0




-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
