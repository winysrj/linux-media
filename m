Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 147DEC282F6
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 10:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D277520663
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 10:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfAUKmy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 05:42:54 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58929 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfAUKmy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 05:42:54 -0500
Received: from litschi.hi.pengutronix.de ([2001:67c:670:100:feaa:14ff:fe6a:8db5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <m.tretter@pengutronix.de>)
        id 1glX2a-00022x-5Q; Mon, 21 Jan 2019 11:42:52 +0100
Date:   Mon, 21 Jan 2019 11:42:51 +0100
From:   Michael Tretter <m.tretter@pengutronix.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org
Subject: Re: [PATCH v2 0/3] Add ZynqMP VCU/Allegro DVT H.264 encoder driver
Message-ID: <20190121114251.0d062b56@litschi.hi.pengutronix.de>
In-Reply-To: <38660b5f-bce3-8ffb-8804-1fb145ed6703@xs4all.nl>
References: <20190118133716.29288-1-m.tretter@pengutronix.de>
        <38660b5f-bce3-8ffb-8804-1fb145ed6703@xs4all.nl>
Organization: Pengutronix
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:feaa:14ff:fe6a:8db5
X-SA-Exim-Mail-From: m.tretter@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Fri, 18 Jan 2019 15:11:32 +0100, Hans Verkuil wrote:
> Hi Michael,
> 
> On 1/18/19 2:37 PM, Michael Tretter wrote:
> > This is v2 of the series to add support for the Allegro DVT H.264 encoder
> > found in the EV family of the Xilinx ZynqMP platform.
> > 
> > See v1 [0] of the patch series for a description of the hardware.
> > 
> > I fixed the handling of frames with various sizes and driver is now able to
> > encode H.264 video in the baseline profile up to 1920x1080 pixels. I also
> > addressed the issues reported by the kbuild robot for the previous series,
> > implemented a few extended controls and changed the interface to the mcu to
> > follow the register documentation rather than the downstream driver
> > implementation.
> > 
> > I would especially appreciate feedback to the device tree bindings and the
> > overall architecture of the driver.  
> 
> I'll try to review this next week. Ping me if you didn't see a review by the
> end of next week.
> 
> BTW, can you post the output of 'v4l2-compliance -s'? (make sure you use the
> very latest version of v4l2-compliance!)

Thanks, here is the output of v4l2-compliance. I haven't used
v4l2-compliance with the -s switch yet and will look into the reported
failures for the streaming ioctls.

v4l2-compliance SHA: e07d1b90190f2b98fe4f5be20406b49ecbe5b3e7, 64 bits

Compliance test for allegro device /dev/video4:

Driver Info:
	Driver name      : allegro
	Card type        : Allegro DVT Video Encoder
	Bus info         : platform:a0009000.al5e
	Driver version   : 5.0.0
	Capabilities     : 0x84208000
		Video Memory-to-Memory
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04208000
		Video Memory-to-Memory
		Streaming
		Extended Pix Format

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video4 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
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
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

Control ioctls:
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 8 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK
	test Requests: OK (Not Supported)

Test input 0:

Streaming ioctls:
	test read/write: OK (Not Supported)
		fail: v4l2-test-buffers.cpp(1920): pid != pid_streamoff
		fail: v4l2-test-buffers.cpp(1953): testBlockingDQBuf(node, q)
	test blocking wait: FAIL
		fail: v4l2-test-buffers.cpp(253): g_field() == V4L2_FIELD_ANY
		fail: v4l2-test-buffers.cpp(1157): buf.qbuf(node)
	test MMAP (no poll): FAIL
		fail: v4l2-test-buffers.cpp(253): g_field() == V4L2_FIELD_ANY
		fail: v4l2-test-buffers.cpp(1157): buf.qbuf(node)
	test MMAP (select): FAIL
	test USERPTR (no poll): OK (Not Supported)
	test USERPTR (select): OK (Not Supported)
	test DMABUF: Cannot test, specify --expbuf-device

Total for allegro device /dev/video4: 50, Succeeded: 47, Failed: 3, Warnings: 0

Michael

> 
> Regards,
> 
> 	Hans
> 
> > 
> > The driver still only works with the vcu-firmware release 2018.2. I am not yet
> > sure how to address the different firmware versions, because in addition to
> > the mailbox sizes, there are also changes within the messages themselves.
> > 
> > I also did not address the integration with the xlnx-vcu driver, yet.
> > 
> > Michael
> > 
> > [0] https://lore.kernel.org/linux-media/20190109113037.28430-1-m.tretter@pengutronix.de/
> > 
> > Changes since v1:
> > - clean up debug log levels
> > - fix unused variable in allegro_mbox_init
> > - fix uninitialized variable in allegro_mbox_write
> > - fix global module parameters
> > - fix Kconfig dependencies
> > - return h264 as default codec for mcu
> > - implement device reset as documented
> > - document why irq does not wait for clear
> > - rename ENCODE_ONE_FRM to ENCODE_FRAME
> > - allow error codes for mcu_channel_id
> > - move control handler to channel
> > - add fw version check
> > - add support for colorspaces
> > - enable configuration of H.264 levels
> > - enable configuration of frame size
> > - enable configuration of bit rate and CPB size
> > - enable configuration of GOP size
> > - rework response handling
> > - fix missing error handling in allegro_h264_write_sps
> > 
> > Michael Tretter (3):
> >   media: dt-bindings: media: document allegro-dvt bindings
> >   [media] allegro: add Allegro DVT video IP core driver
> >   [media] allegro: add SPS/PPS nal unit writer
> > 
> >  .../devicetree/bindings/media/allegro.txt     |   35 +
> >  MAINTAINERS                                   |    6 +
> >  drivers/staging/media/Kconfig                 |    2 +
> >  drivers/staging/media/Makefile                |    1 +
> >  drivers/staging/media/allegro-dvt/Kconfig     |   16 +
> >  drivers/staging/media/allegro-dvt/Makefile    |    6 +
> >  .../staging/media/allegro-dvt/allegro-core.c  | 2828 +++++++++++++++++
> >  drivers/staging/media/allegro-dvt/nal-h264.c  | 1278 ++++++++
> >  drivers/staging/media/allegro-dvt/nal-h264.h  |  188 ++
> >  9 files changed, 4360 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/allegro.txt
> >  create mode 100644 drivers/staging/media/allegro-dvt/Kconfig
> >  create mode 100644 drivers/staging/media/allegro-dvt/Makefile
> >  create mode 100644 drivers/staging/media/allegro-dvt/allegro-core.c
> >  create mode 100644 drivers/staging/media/allegro-dvt/nal-h264.c
> >  create mode 100644 drivers/staging/media/allegro-dvt/nal-h264.h
> >   
> 
> 
