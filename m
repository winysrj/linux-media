Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3129 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbaGODvI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 23:51:08 -0400
Message-ID: <53C4A51F.9000500@xs4all.nl>
Date: Tue, 15 Jul 2014 05:50:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] airspy: AirSpy SDR driver
References: <1405366031-31937-1-git-send-email-crope@iki.fi> <53C430AC.9030204@xs4all.nl> <53C435A9.8020004@iki.fi> <53C43705.8020207@xs4all.nl> <53C4938A.3000308@iki.fi>
In-Reply-To: <53C4938A.3000308@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/15/2014 04:35 AM, Antti Palosaari wrote:
> On 07/14/2014 11:01 PM, Hans Verkuil wrote:
>> On 07/14/2014 09:55 PM, Antti Palosaari wrote:
>>> I actually ran v4l2-compliance and there was problem with ADC band
>>> enumeration. v4l2-compliance didn't liked as ADC freq was just 20MHz,
>>> both upper and lower limit. Due to that I added even small hack to driver,
>>>
>>> +		.rangelow   = 20000000,
>>> +		.rangehigh  = 20000001, /* FIXME: make v4l2-compliance happy */
>>
>> Hmm, does the latest v4l2-compliance (direct from the git repo) still fail on
>> that? That shouldn't be a problem, and I don't see that here either if I try that
>> myself.
>>
>> If it still fails, can you show me the error message?
> 
> [crope@localhost gr-analog]$ ls -l /usr/local/bin/v4l2-compliance
> -rwxr-xr-x. 1 root root 1497964 Jul 14 22:50 /usr/local/bin/v4l2-compliance
> [crope@localhost gr-analog]$ /usr/local/bin/v4l2-compliance -S 
> /dev/swradio0 -s
> Driver Info:
> 	Driver name   : airspy
> 	Card type     : AirSpy SDR
> 	Bus info      : usb-0000:00:13.2-2
> 	Driver version: 3.15.0
> 	Capabilities  : 0x85110000
> 		SDR Capture
> 		Tuner
> 		Read/Write
> 		Streaming
> 		Device Capabilities
> 	Device Caps   : 0x05110000
> 		SDR Capture
> 		Tuner
> 		Read/Write
> 		Streaming
> 
> Compliance test for device /dev/swradio0 (not using libv4l2):
> 
> Required ioctls:
> 	test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
> 	test second sdr open: OK
> 	test VIDIOC_QUERYCAP: OK
> 	test VIDIOC_G/S_PRIORITY: OK
> 
> Debug ioctls:
> 	test VIDIOC_DBG_G/S_REGISTER: OK
> 	test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
> 		fail: v4l2-test-input-output.cpp(107): rangelow >= rangehigh
> 		fail: v4l2-test-input-output.cpp(190): invalid tuner 0
> 	test VIDIOC_G/S_TUNER: FAIL
> 		fail: v4l2-test-input-output.cpp(290): could get frequency for invalid 

Try again, it should be fixed now.

Regards,

	Hans

> tuner 0
> 	test VIDIOC_G/S_FREQUENCY: FAIL
> 	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
> 	test VIDIOC_ENUMAUDIO: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
> 	test VIDIOC_G/S_AUDIO: OK (Not Supported)
> 	Inputs: 0 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
> 	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK
> 	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
> 	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
> 	Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
> 	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
> 	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
> 	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
> 	test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> 	Control ioctls:
> 		test VIDIOC_QUERYCTRL/MENU: OK
> 		test VIDIOC_G/S_CTRL: OK
> 		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
> 		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
> 		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> 		Standard Controls: 6 Private Controls: 0
> 
> 	Format ioctls:
> 		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> 		test VIDIOC_G/S_PARM: OK (Not Supported)
> 		test VIDIOC_G_FBUF: OK (Not Supported)
> 		test VIDIOC_G_FMT: OK
> 		test VIDIOC_TRY_FMT: OK
> 		test VIDIOC_S_FMT: OK
> 		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> 
> 	Codec ioctls:
> 		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
> 		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> 		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> 	Buffer ioctls:
> 		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> 		test VIDIOC_EXPBUF: OK (Not Supported)
> 
> Streaming ioctls:
> 	test read/write: OK
> 	test MMAP: OK
> 	test USERPTR: OK
> 	test DMABUF: OK
> 
> Total: 42, Succeeded: 40, Failed: 2, Warnings: 0
> [crope@localhost gr-analog]$
> 
> 
> regards
> Antti
> 

