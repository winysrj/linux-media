Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35616 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352AbbEEJ6s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 05:58:48 -0400
MIME-Version: 1.0
In-Reply-To: <553A151B.7010907@xs4all.nl>
References: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
	<CAHG8p1AZMnV_ZLA1Ou=wejxwaHRObX1aAgO=xbXiwwEsJZ9EZA@mail.gmail.com>
	<551D4220.7070303@xs4all.nl>
	<CAHG8p1AezvQk1Z0tQzFKXZa3Qnd4+MV53F7VP69vwvXVYaqmkg@mail.gmail.com>
	<553A151B.7010907@xs4all.nl>
Date: Tue, 5 May 2015 17:58:46 +0800
Message-ID: <CAHG8p1Afkvnmw4m=i=10g5R1kPO3PeDEnXj5_PchBbGv1nKo=A@mail.gmail.com>
Subject: Re: [PATCH v4 00/17] media: blackfin: bfin_capture enhancements
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Lad Prabhakar <prabhakar.csengg@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	adi-buildroot-devel@lists.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-04-24 18:04 GMT+08:00 Hans Verkuil <hverkuil@xs4all.nl>:
> On 04/10/2015 12:42 PM, Scott Jiang wrote:
>> Hi Hans,
>>
>>>>
>>>> Hans, I tried to use v4l2-compliance but it failed to compile. Sorry
>>>> for telling you it have passed compilation because I forgot to use
>>>> blackfin toolchain.
>>>> ./configure --without-jpeg  --host=bfin-linux-uclibc --disable-libv4l
>>>>
>>>> The main problem is there is no argp.h in uClibc, how to disable checking this?
>>>>
>>>> checking for argp.h... no
>>>> configure: error: Cannot continue: argp.h not found
>>>>
>>>> Scott
>>>>
>>>
>>> Hi Scott,
>>>
>>> Can you try this patch for v4l-utils? It makes argp optional, and it should
>>> allow v4l2-compliance to compile with uclibc (unless there are more problems).
>>>
>>> I'm no autoconf guru, so I'm not certain if everything is correct, but it
>>> seemed to do its job when I remove argp.h from my system.
>>>
>>
>> Yes, I can pass configure now. But there is another error when make
>>
>> make[3]: Entering directory
>> `/home/scott/projects/git-kernel/v4l-utils/lib/libdvbv5'
>>   CC     libdvbv5_la-parse_string.lo
>> parse_string.c:26:19: error: iconv.h: No such file or directory
>> parse_string.c: In function 'dvb_iconv_to_charset':
>> parse_string.c:316: error: 'iconv_t' undeclared (first use in this function)
>>
>> I tried to pass this library, while --without-libdvbv5 is not supported.
>>
>
> If you can pass the configure step, then you should be able to run this:
>
> cd utils/v4l2-compliance
> cat *.cpp >x.cpp
> g++ -o v4l2-compliance x.cpp -I . -I ../../include/ -DNO_LIBV4L2
>
> (you need to use the right toolchain here, of course)
>
> If this compiles OK, then you have a v4l2-compliance tool that you can
> use.
>
Yes, this method works. The test results of v4l2-compliance are below,
I'm sorry the kernel has not upgraded to 4.0.
root:/> ./v4l2-compliance -d 0
Driver Info:bfin_capture bfin_capture.0: =================  START
STATUS  =================

        Driver name   : bfin_capture
        Card type     :bfin_capture bfin_capture.0: ==================
 END STATUS  ==================
 BF609
        Bus info      : Blackfin Platform
        Driver version: 3.17.0
        Capabilities  : 0x04200001
                Video Capture
                Streaming
                Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
                fail: x.cpp(306): missing bus_info prefix ('Blackfin Platform')
        test VIDIOC_QUERYCAP: FAIL

Allow for multiple opens:
        test second video open: OK
                fail: x.cpp(306): missing bus_info prefix ('Blackfin Platform')
        test VIDIOC_QUERYCAP: FAIL
        test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
        test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
        test VIDIOC_LOG_STATUS: OK

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
        test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
        test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
        test VIDIOC_G/S_EDID: OK (Not Supported)

Test input 0:

        Control ioctls:
                test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
                test VIDIOC_QUERYCTRL: OK
                test VIDIOC_G/S_CTRL: OK
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                fail: x.cpp(2944): subscribe event for control 'User
Controls' failed
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 3 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK
                test VIDIOC_G_FBUF: OK (Not Supported)
                fail: x.cpp(3405): pixelformat != V4L2_PIX_FMT_JPEG &&
colorspace == V4L2_COLORSPACE_JPEG
                fail: x.cpp(3508): testColorspace(pix.pixelformat,
pix.colorspace, pix.ycbcr_enc, pix.quantization)
                test VIDIOC_G_FMT: FAIL
                test VIDIOC_TRY_FMT: OK (Not Supported)
                test VIDIOC_S_FMT: OK (Not Supported)
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                test Cropping: OK (Not Supported)
                test Composing: OK (Not Supported)
                test Scaling: OK

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

        Buffer ioctls:
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                fail: x.cpp(1436): q.has_expbuf(node)
                test VIDIOC_EXPBUF: FAIL


Total: 42, Succeeded: 37, Failed: 5, Warnings: 0
