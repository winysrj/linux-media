Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4566 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1AUWh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jan 2011 17:37:56 -0500
Received: from tschai.localnet (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id p0LMbsgm075582
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 21 Jan 2011 23:37:55 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: v4l2-compliance utility
Date: Fri, 21 Jan 2011 23:37:54 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101212337.54213.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

As you may have seen I have been adding a lot of tests to the v4l2-compliance
utility in v4l-utils lately. It is now getting to the state that is becomes
quite useful even though there is no full coverage yet.

Currently the following ioctls are being tested:

General ioctls:

VIDIOC_QUERYCAP
VIDIOC_G/S_PRIORITY

Debug ioctls:

VIDIOC_DBG_G_CHIP_IDENT
VIDIOC_DBG_G/S_REGISTER
VIDIOC_LOG_STATUS

Input ioctls:

VIDIOC_G/S_TUNER
VIDIOC_G/S_FREQUENCY
VIDIOC_G/S/ENUMAUDIO
VIDIOC_G/S/ENUMINPUT

Output ioctls:

VIDIOC_G/S_MODULATOR
VIDIOC_G/S_FREQUENCY
VIDIOC_G/S/ENUMAUDOUT
VIDIOC_G/S/ENUMOUTPUT

Control ioctls:

VIDIOC_QUERYCTRL/MENU
VIDIOC_G/S_CTRL
VIDIOC_G/S/TRY_EXT_CTRLS

I/O configuration ioctls:

VIDIOC_ENUM/G/S/QUERY_STD
VIDIOC_ENUM/G/S/QUERY_DV_PRESETS
VIDIOC_G/S_DV_TIMINGS

Not yet implemented:

VIDIOC_CROPCAP, VIDIOC_G/S_CROP
VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS
VIDIOC_G/S_FBUF/OVERLAY
VIDIOC_G/S/TRY_FMT
VIDIOC_G/S_PARM
VIDIOC_G/S_JPEGCOMP
VIDIOC_SLICED_VBI_CAP
VIDIOC_S_HW_FREQ_SEEK
VIDIOC_SUBSCRIBE_EVENT/UNSUBSCRIBE_EVENT/DQEVENT
VIDIOC_(TRY_)ENCODER_CMD
VIDIOC_G_ENC_INDEX
VIDIOC_REQBUFS/QBUF/DQBUF/QUERYBUF
VIDIOC_STREAMON/OFF
Interactive tests with e.g. hotplugging

Also tested is whether you can open device nodes multiple times.

These tests are pretty exhaustive and more strict than the spec itself.

The main goal is to get consistent behavior for all drivers that applications
can rely on. For example, if a driver has controls then the compliance tool
checks if *all* control functions are supported. So apps do not have to guess
whether a driver does or does not support extended controls. Ditto for priority
handling: the compliance test requires support for this.

The control framework gives an easy way to support the full control API and
the upcoming priority core patches will make it trivial to support the priority
API.

Most other tests check carefully whether the information returned by the driver
is consistent. E.g. if you support S_INPUT, then you must also support ENUMINPUT.
And if ENUMINPUT says that you support certain standards, then S_STD is also
checked for that, etc. etc.

By default the output looks like this:

$ ./v4l2-compliance -d1
Running on 2.6.37

Driver Info:
        Driver name   : ivtv
        Card type     : Hauppauge WinTV PVR-350
        Bus info      : PCI:0000:04:05.0
        Driver version: 1.4.2
        Capabilities  : 0x010702D3
                Video Capture
                Video Output
                Video Output Overlay
                VBI Capture
                Sliced VBI Capture
                Sliced VBI Output
                Tuner
                Audio
                Radio
                Read/Write

Compliance test for device /dev/video1 (not using libv4l2):

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second video open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
        test VIDIOC_DBG_G_CHIP_IDENT: OK
        test VIDIOC_DBG_G/S_REGISTER: OK
        test VIDIOC_LOG_STATUS: OK

Input ioctls:
                fail: rangelow >= rangehigh
                fail: invalid tuner 0
        test VIDIOC_G/S_TUNER: FAIL
                fail: could get frequency for invalid tuner 0
        test VIDIOC_G/S_FREQUENCY: FAIL
        test VIDIOC_G/S/ENUMAUDIO: OK
        test VIDIOC_G/S/ENUMINPUT: OK
        Inputs: 6 Audio Inputs: 3 Tuners: 0

Output ioctls:
        test VIDIOC_G/S_MODULATOR: Not Supported
                fail: could get frequency for invalid modulator 0
        test VIDIOC_G/S_FREQUENCY: FAIL
        test VIDIOC_G/S/ENUMAUDOUT: OK
        test VIDIOC_G/S/ENUMOUTPUT: OK
        Outputs: 6 Audio Outputs: 1 Modulators: 0

Control ioctls:
        test VIDIOC_QUERYCTRL/MENU: OK
        test VIDIOC_G/S_CTRL: OK
        test VIDIOC_G/S/TRY_EXT_CTRLS: OK
        Standard Controls: 32 Private Controls: 12

Input/Output configuration ioctls:
        test VIDIOC_ENUM/G/S/QUERY_STD: OK
        test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: Not Supported
        test VIDIOC_G/S_DV_TIMINGS: Not Supported

Total: 21 Succeeded: 18 Failed: 3 Warnings: 4

Each test will bail out as soon as the first error appears. There are three
possible results: OK, FAIL and "Not Supported", which means that the driver
does not support these ioctls and gives the correct error code back to the
application if it tries to use it anyway.

With -v you set the verbosity level: -v1 shows warnings as well, -v2 also shows
info messages.

Other options:

$ ./v4l2-compliance -h
Usage:
Common options:
  -D, --info         show driver info [VIDIOC_QUERYCAP]
  -d, --device=<dev> use device <dev> as the video device
                     if <dev> is a single digit, then /dev/video<dev> is used
  -r, --radio-device=<dev> use device <dev> as the radio device
                     if <dev> is a single digit, then /dev/radio<dev> is used
  -V, --vbi-device=<dev> use device <dev> as the vbi device
                     if <dev> is a single digit, then /dev/vbi<dev> is used
  -h, --help         display this help message
  -v, --verbose=<level> turn on verbose reporting.
                     level 1: show warnings
                     level 2: show warnings and info messages
  -T, --trace        trace all called ioctls.
  -w, --wrapper      use the libv4l2 wrapper library.

The tool is still under heavy development, so I'm sure these options will
change in the future.

Anyway, try it out and let me know if you find errors, corner cases that are not
tested, etc. etc.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
