Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2452 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793AbaGNUBX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 16:01:23 -0400
Message-ID: <53C43705.8020207@xs4all.nl>
Date: Mon, 14 Jul 2014 22:01:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] airspy: AirSpy SDR driver
References: <1405366031-31937-1-git-send-email-crope@iki.fi> <53C430AC.9030204@xs4all.nl> <53C435A9.8020004@iki.fi>
In-Reply-To: <53C435A9.8020004@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/14/2014 09:55 PM, Antti Palosaari wrote:
> Moikka Hans!
> 
> On 07/14/2014 10:34 PM, Hans Verkuil wrote:
>> On 07/14/2014 09:27 PM, Antti Palosaari wrote:
>>> AirSpy SDR driver.
>>>
>>> Thanks to Youssef Touil and Benjamin Vernoux for support, help and
>>> hardware!
>>> http://airspy.com/
>>>
>>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>>> ---
>>>   drivers/staging/media/Kconfig         |    1 +
>>>   drivers/staging/media/Makefile        |    1 +
>>>   drivers/staging/media/airspy/Kconfig  |    5 +
>>>   drivers/staging/media/airspy/Makefile |    1 +
>>>   drivers/staging/media/airspy/airspy.c | 1120 +++++++++++++++++++++++++++++++++
>>>   5 files changed, 1128 insertions(+)
>>>   create mode 100644 drivers/staging/media/airspy/Kconfig
>>>   create mode 100644 drivers/staging/media/airspy/Makefile
>>>   create mode 100644 drivers/staging/media/airspy/airspy.c
>>>
>>
>> It's a new driver, so the usual question: can you post the output from the
>> latest v4l2-compliance? 'v4l2-compliance -S /dev/swradioX -s'
>>
>> It looks good, but I always like to see the output of that as a record and
>> as a verification that someone actually ran it :-)
> 
> I actually ran v4l2-compliance and there was problem with ADC band 
> enumeration. v4l2-compliance didn't liked as ADC freq was just 20MHz, 
> both upper and lower limit. Due to that I added even small hack to driver,
> 
> +		.rangelow   = 20000000,
> +		.rangehigh  = 20000001, /* FIXME: make v4l2-compliance happy */

Hmm, does the latest v4l2-compliance (direct from the git repo) still fail on
that? That shouldn't be a problem, and I don't see that here either if I try that
myself.

If it still fails, can you show me the error message?

> But here is new ran, brand new v4l2-compliance:

Thanks, 0 fails, that's what I like to see :-)

Regards,

	Hans

> 
> [crope@localhost v4l-utils]$ which v4l2-compliance
> /usr/local/bin/v4l2-compliance
> [crope@localhost v4l-utils]$ ls -l /usr/local/bin/v4l2-compliance
> -rwxr-xr-x. 1 root root 1497964 Jul 14 22:50 /usr/local/bin/v4l2-compliance
> [crope@localhost v4l-utils]$ /usr/local/bin/v4l2-compliance -S 
> /dev/swradio0 -s
> Driver Info:
> 	Driver name   : airspy
> 	Card type     : AirSpy SDR
> 	Bus info      : usb-0000:00:13.2-1
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
> 	test VIDIOC_G/S_TUNER: OK
> 	test VIDIOC_G/S_FREQUENCY: OK
> 	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
> 	test VIDIOC_ENUMAUDIO: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
> 	test VIDIOC_G/S_AUDIO: OK (Not Supported)
> 	Inputs: 0 Audio Inputs: 0 Tuners: 2
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
> Total: 42, Succeeded: 42, Failed: 0, Warnings: 0
> [crope@localhost v4l-utils]$
> 
> regards
> Antti
> 

