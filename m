Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90389C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 17:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49E7221738
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 17:15:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="ji31IxI/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfC0RPq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 13:15:46 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37740 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727632AbfC0RPq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 13:15:46 -0400
Received: by mail-qk1-f195.google.com with SMTP id c1so10382073qkk.4
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2019 10:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=TjrMIH7e8ZjT/dTsYjx/NEiDfglWeCdwJCXMhzSAC8g=;
        b=ji31IxI/7a55tJVpihMhFdRLtdchoZuoDUIUAU2a1Oxr9XNp7W8ZGuuQQNWBFkyh9u
         mw1WgIdTLhucgoxJiuHB4huClKVgPe4WDaNT6rkjEmy6h3Hmy1oHRECR3R2le3mHNN/V
         3sYjOZHTlNluY20IxT5TZbm+/m5BFglSLGAxQKvcbYW/RWjRmVUFGM4OkVa0jd/Xsz/7
         5xfD5buxURiATddCmeLKPO21/yDHI0VDEb8lMKXhlfrDue/d0FqxvyHfZjjWom/Oovc3
         868PaF1a6JvlGLV8VmLYh4o6EPJIllm/27PGaoZDwHN882vbR/bte3dTHL5HmZfZZUa1
         SYhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=TjrMIH7e8ZjT/dTsYjx/NEiDfglWeCdwJCXMhzSAC8g=;
        b=ZrKz71GCfALqBkLUzsFia/XFwjId2DJz8fTjZADzp0C0TasQXSkk42ip4bjn7Yf1j1
         MTE51T6VewRNatvL6qLSe4/d4ZboQdu8ceuj+lPd7KrP5beu0CeJNWAypHHux4HVBC9i
         1mUb31/qoYF0AwKM4NwghnHH9zVsaeZB2ys7tM6mSosZ/xyHXPs2Ns5v2sBzDTBxdBaW
         ix1cnwEajmq47sSmUNHbDEv0mNFSiy4PLWw5ht+5B7qlpPR1boFqK78ALi7hfAsmn0DR
         C0fbcfPnTw3OnlFo/Zh5b1uUQaSduvscq4RB440Qu9+eJPJjK2ifC9YsGN4N69CSHbSp
         gdHA==
X-Gm-Message-State: APjAAAVCnRWjjKHe/CFLGmgzdgzbRGBfMK9HbZKWBbUD5lS+e6dWmsMq
        swOGvk77yuIanvD/b3AxdaHx9Q==
X-Google-Smtp-Source: APXvYqzYB8mhjxnfQ9HlwAQtuhQN5KYxnGuerznBQbxUs8vELRZYSWGpeH3/3jb4zBpAJTbAqw098g==
X-Received: by 2002:a37:4f95:: with SMTP id d143mr29644826qkb.253.1553706944491;
        Wed, 27 Mar 2019 10:15:44 -0700 (PDT)
Received: from tpx230-nicolas.collaboramtl (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id p67sm12463461qkd.39.2019.03.27.10.15.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Mar 2019 10:15:43 -0700 (PDT)
Message-ID: <a72453934b54f3dfcb988084b51902a58dd0eec8.camel@ndufresne.ca>
Subject: Re: [PATCH v4 0/3] Add ZynqMP VCU/Allegro DVT H.264 encoder driver
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Michael Tretter <m.tretter@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org, dshah@xilinx.com
Date:   Wed, 27 Mar 2019 13:15:41 -0400
In-Reply-To: <025b8be1-c53d-78f3-1ce8-aaf825689037@xs4all.nl>
References: <20190301152718.23134-1-m.tretter@pengutronix.de>
         <025b8be1-c53d-78f3-1ce8-aaf825689037@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-VhJTsUldij28BLt+bqti"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-VhJTsUldij28BLt+bqti
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 27 mars 2019 =C3=A0 14:04 +0100, Hans Verkuil a =C3=A9crit :
> On 3/1/19 4:27 PM, Michael Tretter wrote:
> > This is v4 of the series to add support for the Allegro DVT H.264 encod=
er
> > found in the EV family of the Xilinx ZynqMP platform.
> >=20
> > The most prominent change is the added documentation in the nal_h264.h =
header.
> > The structs for the SPS and PPS NAL units and the function prototypes t=
o
> > convert between RBSP and the C structs are now accompanied by kernel-do=
c.
> >=20
> > Furthermore, I went through all TODOs and FIXMEs in the driver. This re=
sulted
> > in a cleaner handling of messages that are exchanged with the encoder
> > firmware, better documentation of the limits that are imposed by the en=
coder
> > firmware on the driver, fixed handling of failures during channel creat=
ion,
> > and support for 4k video.
>=20
> Is the firmware available from the linux-firmware git repo?

I haven't found it, the official binary is here:
https://github.com/Xilinx/vcu-firmware

>=20
> Regards,
>=20
> 	Hans
>=20
> > v4l2-compliance also seems to be happy with the new version:
> >=20
> > v4l2-compliance SHA: 410942e345b889d09456f5f862ee6cd415d8ae59, 64 bits
> >=20
> > Compliance test for allegro device /dev/video4:
> >=20
> > Driver Info:
> >         Driver name      : allegro
> >         Card type        : Allegro DVT Video Encoder
> >         Bus info         : platform:a0009000.video-codec
> >         Driver version   : 5.0.0
> >         Capabilities     : 0x84208000
> >                 Video Memory-to-Memory
> >                 Streaming
> >                 Extended Pix Format
> >                 Device Capabilities
> >         Device Caps      : 0x04208000
> >                 Video Memory-to-Memory
> >                 Streaming
> >                 Extended Pix Format
> >         Detected Stateful Encoder
> >=20
> > Required ioctls:
> >         test VIDIOC_QUERYCAP: OK
> >=20
> > Allow for multiple opens:
> >         test second /dev/video4 open: OK
> >         test VIDIOC_QUERYCAP: OK
> >         test VIDIOC_G/S_PRIORITY: OK
> >         test for unlimited opens: OK
> >=20
> > Debug ioctls:
> >         test VIDIOC_DBG_G/S_REGISTER: OK
> >         test VIDIOC_LOG_STATUS: OK (Not Supported)
> >=20
> > Input ioctls:
> >         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
> >         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> >         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
> >         test VIDIOC_ENUMAUDIO: OK (Not Supported)
> >         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
> >         test VIDIOC_G/S_AUDIO: OK (Not Supported)
> >         Inputs: 0 Audio Inputs: 0 Tuners: 0
> >=20
> > Output ioctls:
> >         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
> >         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> >         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
> >         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
> >         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
> >         Outputs: 0 Audio Outputs: 0 Modulators: 0
> >=20
> > Input/Output configuration ioctls:
> >         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
> >         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
> >         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
> >         test VIDIOC_G/S_EDID: OK (Not Supported)
> >=20
> > Control ioctls:
> >         test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
> >         test VIDIOC_QUERYCTRL: OK
> >         test VIDIOC_G/S_CTRL: OK
> >         test VIDIOC_G/S/TRY_EXT_CTRLS: OK
> >         test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
> >         test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> >         Standard Controls: 8 Private Controls: 0
> >=20
> > Format ioctls:
> >         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> >         test VIDIOC_G/S_PARM: OK (Not Supported)
> >         test VIDIOC_G_FBUF: OK (Not Supported)
> >         test VIDIOC_G_FMT: OK
> >         test VIDIOC_TRY_FMT: OK
> >         test VIDIOC_S_FMT: OK
> >         test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> >         test Cropping: OK (Not Supported)
> >         test Composing: OK (Not Supported)
> >         test Scaling: OK
> >=20
> > Codec ioctls:
> >         test VIDIOC_(TRY_)ENCODER_CMD: OK
> >         test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> >         test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> >=20
> > Buffer ioctls:
> >         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> >         test VIDIOC_EXPBUF: OK
> >         test Requests: OK (Not Supported)
> >=20
> > Test input 0:
> >=20
> > Streaming ioctls:
> >         test read/write: OK (Not Supported)
> >         test blocking wait: OK
> >         Video Capture: Captured 10 buffers               =20
> >         test MMAP (no poll): OK
> >         Video Capture: Captured 10 buffers               =20
> >         test MMAP (select): OK
> >         Video Capture: Captured 10 buffers               =20
> >         test MMAP (epoll): OK
> >         test USERPTR (no poll): OK (Not Supported)
> >         test USERPTR (select): OK (Not Supported)
> >         test DMABUF: Cannot test, specify --expbuf-device
> >=20
> > Total for allegro device /dev/video4: 51, Succeeded: 51, Failed: 0, War=
nings: 0
> >=20
> > Apart from that, there are a few cleanups to resolve checkpatch or comp=
iler
> > warnings. A more detailed changelog is attached to each patch.
> >=20
> > Michael
> >=20
> > v3 -> v4:
> > - fix checkpatch and compiler warnings
> > - use v4l2_m2m_buf_copy_metadata to copy buffer metadata
> > - resolve FIXME regarding channel creation and streamon
> > - resolve various TODOs
> > - add mailbox format to firmware info
> > - add suballocator_size to firmware info
> > - use struct_size to allocate mcu_msg_push_buffers_internal
> > - handle *_response messages in a union
> > - cleanup mcu_send_msg functions
> > - increase maximum video resolution to 4k
> > - handle errors when creating a channel
> > - do not update ctrls after channel is created
> > - add documentation for nal_h264.h
> >=20
> > v2 -> v3:
> > - add clocks to devicetree bindings
> > - fix devicetree binding according to review comments on v2
> > - add missing v4l2 callbacks
> > - drop unnecessary v4l2 callbacks
> > - drop debug module parameter poison_capture_buffers
> > - check firmware size before loading firmware
> > - rework error handling
> >=20
> > v1 -> v2:
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
> >=20
> >=20
> > Michael Tretter (3):
> >   media: dt-bindings: media: document allegro-dvt bindings
> >   [media] allegro: add Allegro DVT video IP core driver
> >   [media] allegro: add SPS/PPS nal unit writer
> >=20
> >  .../devicetree/bindings/media/allegro.txt     |   43 +
> >  MAINTAINERS                                   |    6 +
> >  drivers/staging/media/Kconfig                 |    2 +
> >  drivers/staging/media/Makefile                |    1 +
> >  drivers/staging/media/allegro-dvt/Kconfig     |   16 +
> >  drivers/staging/media/allegro-dvt/Makefile    |    6 +
> >  .../staging/media/allegro-dvt/allegro-core.c  | 2835 +++++++++++++++++
> >  drivers/staging/media/allegro-dvt/nal-h264.c  | 1278 ++++++++
> >  drivers/staging/media/allegro-dvt/nal-h264.h  |  330 ++
> >  9 files changed, 4517 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/allegro.txt
> >  create mode 100644 drivers/staging/media/allegro-dvt/Kconfig
> >  create mode 100644 drivers/staging/media/allegro-dvt/Makefile
> >  create mode 100644 drivers/staging/media/allegro-dvt/allegro-core.c
> >  create mode 100644 drivers/staging/media/allegro-dvt/nal-h264.c
> >  create mode 100644 drivers/staging/media/allegro-dvt/nal-h264.h
> >=20

--=-VhJTsUldij28BLt+bqti
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXJuvvQAKCRBxUwItrAao
HJaMAJ9Pb6NTHF5EituK9HZAFAFOlF4gkgCgpgo+OYCHTI3miLdDqz/cC2DjfVM=
=mZMZ
-----END PGP SIGNATURE-----

--=-VhJTsUldij28BLt+bqti--

