Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF57DC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 11:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BD8A2075D
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 11:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfCZLrp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 07:47:45 -0400
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:58274 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726171AbfCZLrp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 07:47:45 -0400
Received: from [IPv6:2001:420:44c1:2579:819c:1be6:f08c:a58c] ([IPv6:2001:420:44c1:2579:819c:1be6:f08c:a58c])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 8kYMho8HWNG8z8kYPhWrtp; Tue, 26 Mar 2019 12:47:43 +0100
Subject: Re: [PATCH v4 0/3] Add ZynqMP VCU/Allegro DVT H.264 encoder driver
To:     Michael Tretter <m.tretter@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org, dshah@xilinx.com
References: <20190301152718.23134-1-m.tretter@pengutronix.de>
 <20190326084613.405e7ed4@litschi.hi.pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <484d66c6-a2c0-6c18-6cdf-81ef647295e3@xs4all.nl>
Date:   Tue, 26 Mar 2019 12:47:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190326084613.405e7ed4@litschi.hi.pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfF7ltGMtwVXJSmY5YOApwfsf2jxdFuQmk3WieS3AbPopF3aCHoE3pygseBj4/oZAkOnLXHzO1mqSAqboOb2K9YOjeYwHht2qAMWTyVRW/xOBjEAhksMq
 8H4j6gDf1mz3BGwVQgGyAz7+eoXRQQ+3emRx8khmvg6QV8vrfH6HY7ngel9ruNPzgNuoZu+diC5PJKpXLD0LHrQv50zSA+yOaVLPHAFYNBNR3dlK8oUNxjEp
 6rv5bTqvSPfFjC75Bq2ELBepjj8vfKk2UaGEpyBHiKTn7M5r1KKpodazJBuc/5TbO85f4zns/4vxkJ1j7/mzW3dwACJwUgeGgFCna+B0A/kW99rj2OH0P98F
 tY3qLq2F0n7mV2DrMii+eNC09JDxCWBaPm14Ef7JGqXZ3uTk+eoDvf1CgMJ44V77z6XaYM+6f8p7cOIVg2aNHMcXhQHUzXzsr+GWzeN3mh6j+J24CK6KafYz
 x6pWPmOPuYAVCrIfZg+nlJP6Y/Nz7ic7piSk+g==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/26/19 8:46 AM, Michael Tretter wrote:
> On Fri, 01 Mar 2019 16:27:15 +0100, Michael Tretter wrote:
>> This is v4 of the series to add support for the Allegro DVT H.264 encoder
>> found in the EV family of the Xilinx ZynqMP platform.
> 
> Ping.

It's delegated to me in patchwork, so I'll get to it in a few days.

We were waiting for the 5.1-rc1 release.

Regards,

	Hans

> 
> Michael
> 
>>
>> The most prominent change is the added documentation in the nal_h264.h header.
>> The structs for the SPS and PPS NAL units and the function prototypes to
>> convert between RBSP and the C structs are now accompanied by kernel-doc.
>>
>> Furthermore, I went through all TODOs and FIXMEs in the driver. This resulted
>> in a cleaner handling of messages that are exchanged with the encoder
>> firmware, better documentation of the limits that are imposed by the encoder
>> firmware on the driver, fixed handling of failures during channel creation,
>> and support for 4k video.
>>
>> v4l2-compliance also seems to be happy with the new version:
>>
>> v4l2-compliance SHA: 410942e345b889d09456f5f862ee6cd415d8ae59, 64 bits
>>
>> Compliance test for allegro device /dev/video4:
>>
>> Driver Info:
>>         Driver name      : allegro
>>         Card type        : Allegro DVT Video Encoder
>>         Bus info         : platform:a0009000.video-codec
>>         Driver version   : 5.0.0
>>         Capabilities     : 0x84208000
>>                 Video Memory-to-Memory
>>                 Streaming
>>                 Extended Pix Format
>>                 Device Capabilities
>>         Device Caps      : 0x04208000
>>                 Video Memory-to-Memory
>>                 Streaming
>>                 Extended Pix Format
>>         Detected Stateful Encoder
>>
>> Required ioctls:
>>         test VIDIOC_QUERYCAP: OK
>>
>> Allow for multiple opens:
>>         test second /dev/video4 open: OK
>>         test VIDIOC_QUERYCAP: OK
>>         test VIDIOC_G/S_PRIORITY: OK
>>         test for unlimited opens: OK
>>
>> Debug ioctls:
>>         test VIDIOC_DBG_G/S_REGISTER: OK
>>         test VIDIOC_LOG_STATUS: OK (Not Supported)
>>
>> Input ioctls:
>>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>>         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>>         Inputs: 0 Audio Inputs: 0 Tuners: 0
>>
>> Output ioctls:
>>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>>         Outputs: 0 Audio Outputs: 0 Modulators: 0
>>
>> Input/Output configuration ioctls:
>>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>>         test VIDIOC_G/S_EDID: OK (Not Supported)
>>
>> Control ioctls:
>>         test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>>         test VIDIOC_QUERYCTRL: OK
>>         test VIDIOC_G/S_CTRL: OK
>>         test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>>         test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>>         test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>>         Standard Controls: 8 Private Controls: 0
>>
>> Format ioctls:
>>         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>>         test VIDIOC_G/S_PARM: OK (Not Supported)
>>         test VIDIOC_G_FBUF: OK (Not Supported)
>>         test VIDIOC_G_FMT: OK
>>         test VIDIOC_TRY_FMT: OK
>>         test VIDIOC_S_FMT: OK
>>         test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>>         test Cropping: OK (Not Supported)
>>         test Composing: OK (Not Supported)
>>         test Scaling: OK
>>
>> Codec ioctls:
>>         test VIDIOC_(TRY_)ENCODER_CMD: OK
>>         test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>>         test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>>
>> Buffer ioctls:
>>         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>         test VIDIOC_EXPBUF: OK
>>         test Requests: OK (Not Supported)
>>
>> Test input 0:
>>
>> Streaming ioctls:
>>         test read/write: OK (Not Supported)
>>         test blocking wait: OK
>>         Video Capture: Captured 10 buffers                
>>         test MMAP (no poll): OK
>>         Video Capture: Captured 10 buffers                
>>         test MMAP (select): OK
>>         Video Capture: Captured 10 buffers                
>>         test MMAP (epoll): OK
>>         test USERPTR (no poll): OK (Not Supported)
>>         test USERPTR (select): OK (Not Supported)
>>         test DMABUF: Cannot test, specify --expbuf-device
>>
>> Total for allegro device /dev/video4: 51, Succeeded: 51, Failed: 0, Warnings: 0
>>
>> Apart from that, there are a few cleanups to resolve checkpatch or compiler
>> warnings. A more detailed changelog is attached to each patch.
>>
>> Michael
>>
>> v3 -> v4:
>> - fix checkpatch and compiler warnings
>> - use v4l2_m2m_buf_copy_metadata to copy buffer metadata
>> - resolve FIXME regarding channel creation and streamon
>> - resolve various TODOs
>> - add mailbox format to firmware info
>> - add suballocator_size to firmware info
>> - use struct_size to allocate mcu_msg_push_buffers_internal
>> - handle *_response messages in a union
>> - cleanup mcu_send_msg functions
>> - increase maximum video resolution to 4k
>> - handle errors when creating a channel
>> - do not update ctrls after channel is created
>> - add documentation for nal_h264.h
>>
>> v2 -> v3:
>> - add clocks to devicetree bindings
>> - fix devicetree binding according to review comments on v2
>> - add missing v4l2 callbacks
>> - drop unnecessary v4l2 callbacks
>> - drop debug module parameter poison_capture_buffers
>> - check firmware size before loading firmware
>> - rework error handling
>>
>> v1 -> v2:
>> - clean up debug log levels
>> - fix unused variable in allegro_mbox_init
>> - fix uninitialized variable in allegro_mbox_write
>> - fix global module parameters
>> - fix Kconfig dependencies
>> - return h264 as default codec for mcu
>> - implement device reset as documented
>> - document why irq does not wait for clear
>> - rename ENCODE_ONE_FRM to ENCODE_FRAME
>> - allow error codes for mcu_channel_id
>> - move control handler to channel
>> - add fw version check
>> - add support for colorspaces
>> - enable configuration of H.264 levels
>> - enable configuration of frame size
>> - enable configuration of bit rate and CPB size
>> - enable configuration of GOP size
>> - rework response handling
>> - fix missing error handling in allegro_h264_write_sps
>>
>>
>> Michael Tretter (3):
>>   media: dt-bindings: media: document allegro-dvt bindings
>>   [media] allegro: add Allegro DVT video IP core driver
>>   [media] allegro: add SPS/PPS nal unit writer
>>
>>  .../devicetree/bindings/media/allegro.txt     |   43 +
>>  MAINTAINERS                                   |    6 +
>>  drivers/staging/media/Kconfig                 |    2 +
>>  drivers/staging/media/Makefile                |    1 +
>>  drivers/staging/media/allegro-dvt/Kconfig     |   16 +
>>  drivers/staging/media/allegro-dvt/Makefile    |    6 +
>>  .../staging/media/allegro-dvt/allegro-core.c  | 2835 +++++++++++++++++
>>  drivers/staging/media/allegro-dvt/nal-h264.c  | 1278 ++++++++
>>  drivers/staging/media/allegro-dvt/nal-h264.h  |  330 ++
>>  9 files changed, 4517 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/allegro.txt
>>  create mode 100644 drivers/staging/media/allegro-dvt/Kconfig
>>  create mode 100644 drivers/staging/media/allegro-dvt/Makefile
>>  create mode 100644 drivers/staging/media/allegro-dvt/allegro-core.c
>>  create mode 100644 drivers/staging/media/allegro-dvt/nal-h264.c
>>  create mode 100644 drivers/staging/media/allegro-dvt/nal-h264.h
>>

