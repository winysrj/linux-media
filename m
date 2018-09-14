Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51168 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727640AbeINUXy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 16:23:54 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8EF4fx0030178
        for <linux-media@vger.kernel.org>; Fri, 14 Sep 2018 11:08:58 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mge9xkafe-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Fri, 14 Sep 2018 11:08:57 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Fri, 14 Sep 2018 09:08:56 -0600
Subject: Re: [PATCH v2 0/2] media: platform: Add Aspeed Video Engine Driver
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, andrew@aj.id.au,
        openbmc@lists.ozlabs.org, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org
References: <1536866964-71593-1-git-send-email-eajames@linux.vnet.ibm.com>
 <3fe3a367-5e63-446b-faba-fa6ac7a007cd@xs4all.nl>
From: Eddie James <eajames@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2018 10:08:51 -0500
MIME-Version: 1.0
In-Reply-To: <3fe3a367-5e63-446b-faba-fa6ac7a007cd@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Message-Id: <1436d8d6-25ab-4bb8-5558-3e02fbe95e58@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/14/2018 01:59 AM, Hans Verkuil wrote:
> On 09/13/2018 09:29 PM, Eddie James wrote:
>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>> can capture and compress video data from digital or analog sources. With
>> the Aspeed chip acting as a service processor, the Video Engine can
>> capture the host processor graphics output.
>>
>> This series adds a V4L2 driver for the VE, providing a read() interface
>> only. The driver triggers the hardware to capture the host graphics output
>> and compress it to JPEG format.
>>
>>
>> v4l2-compliance output:
>>
>> v4l2-compliance SHA   : not available
> There should be a SHA here. "not available" indicates that you didn't compile
> from the git repository directly, and now I do not know how old this compliance
> test is. Always compile from the latest git repo, never use a version from e.g.
> a distro as they tend to be old and missing tests.
>
> It would be great if you can do this and reply with the new compliance output.

Hmm, I did compile from the latest git repo (maybe a week old now), but 
maybe our cross complication setup is preventing that hash from being 
generated. Will try and get it.

>
> Thanks!
>
> 	Hans
>
>> Driver Info:
>> 	Driver name   : aspeed-video
>> 	Card type     : Aspeed Video Engine
>> 	Bus info      : platform:aspeed-video
>> 	Driver version: 4.18.7
>> 	Capabilities  : 0x81200001
>> 		Video Capture
>> 		Read/Write
>> 		Extended Pix Format
>> 		Device Capabilities
>> 	Device Caps   : 0x01200001
>> 		Video Capture
>> 		Read/Write
>> 		Extended Pix Format
>>
>> Compliance test for device /dev/video0 (not using libv4l2):
>>
>> Required ioctls:
>> 	test VIDIOC_QUERYCAP: OK
>>
>> Allow for multiple opens:
>> 	test second video open: OK
>> 	test VIDIOC_QUERYCAP: OK
>> 	test VIDIOC_G/S_PRIORITY: OK
>> 	test for unlimited opens: OK
>>
>> Debug ioctls:
>> 	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>> 	test VIDIOC_LOG_STATUS: OK (Not Supported)
>>
>> Input ioctls:
>> 	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>> 	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>> 	test VIDIOC_ENUMAUDIO: OK (Not Supported)
>> 	test VIDIOC_G/S/ENUMINPUT: OK
>> 	test VIDIOC_G/S_AUDIO: OK (Not Supported)
>> 	Inputs: 1 Audio Inputs: 0 Tuners: 0
>>
>> Output ioctls:
>> 	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>> 	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>> 	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>> 	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>> 	Outputs: 0 Audio Outputs: 0 Modulators: 0
>>
>> Input/Output configuration ioctls:
>> 	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>> 	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>> 	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>> 	test VIDIOC_G/S_EDID: OK (Not Supported)
>>
>> Test input 0:
>>
>> 	Control ioctls:
>> 		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>> 		test VIDIOC_QUERYCTRL: OK
>> 		test VIDIOC_G/S_CTRL: OK
>> 		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>> 		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>> 		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>> 		Standard Controls: 3 Private Controls: 0
>>
>> 	Format ioctls:
>> 		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>> 		test VIDIOC_G/S_PARM: OK
>> 		test VIDIOC_G_FBUF: OK (Not Supported)
>> 		test VIDIOC_G_FMT: OK
>> 		test VIDIOC_TRY_FMT: OK
>> 		test VIDIOC_S_FMT: OK
>> 		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>> 		test Cropping: OK (Not Supported)
>> 		test Composing: OK (Not Supported)
>> 		test Scaling: OK (Not Supported)
>>
>> 	Codec ioctls:
>> 		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>> 		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>> 		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>>
>> 	Buffer ioctls:
>> 		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
>> 		test VIDIOC_EXPBUF: OK (Not Supported)
>>
>> Test input 0:
>>
>> Streaming ioctls:
>> 	test read/write: OK
>> 	test MMAP: OK (Not Supported)
>> 	test USERPTR: OK (Not Supported)
>> 	test DMABUF: OK (Not Supported)
>>
>>
>> Total: 47, Succeeded: 47, Failed: 0, Warnings: 0
>>
>>
>> Changes since v1:
>>   - Removed le32_to_cpu calls for JPEG header data
>>   - Reworked v4l2 ioctls to be compliant.
>>   - Added JPEG controls
>>   - Updated devicetree docs according to Rob's suggestions.
>>   - Added myself to MAINTAINERS
>>
>> Eddie James (2):
>>    dt-bindings: media: Add Aspeed Video Engine binding documentation
>>    media: platform: Add Aspeed Video Engine driver
>>
>>   .../devicetree/bindings/media/aspeed-video.txt     |   26 +
>>   MAINTAINERS                                        |    8 +
>>   drivers/media/platform/Kconfig                     |    8 +
>>   drivers/media/platform/Makefile                    |    1 +
>>   drivers/media/platform/aspeed-video.c              | 1469 ++++++++++++++++++++
>>   5 files changed, 1512 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/aspeed-video.txt
>>   create mode 100644 drivers/media/platform/aspeed-video.c
>>
