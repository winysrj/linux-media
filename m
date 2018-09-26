Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34026 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726230AbeI0AT1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 20:19:27 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8QHt01R009493
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2018 14:05:18 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2mrekc1e05-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2018 14:05:17 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Wed, 26 Sep 2018 14:05:17 -0400
Subject: Re: [PATCH v3 0/2] media: platform: Add Aspeed Video Engine Driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Eddie James <eajames@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, andrew@aj.id.au,
        openbmc@lists.ozlabs.org, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org
References: <1537903629-14003-1-git-send-email-eajames@linux.ibm.com>
 <337a1869-4c16-edb0-976e-755f786afb01@xs4all.nl>
From: Eddie James <eajames@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2018 13:05:10 -0500
MIME-Version: 1.0
In-Reply-To: <337a1869-4c16-edb0-976e-755f786afb01@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Message-Id: <f033e988-e46f-b232-8ea5-a287cd48ef84@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/26/2018 07:03 AM, Hans Verkuil wrote:
> On 09/25/2018 09:27 PM, Eddie James wrote:
>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>> can capture and compress video data from digital or analog sources. With
>> the Aspeed chip acting as a service processor, the Video Engine can
>> capture the host processor graphics output.
>>
>> This series adds a V4L2 driver for the VE, providing the usual V4L2 streaming
>> interface by way of videobuf2. Each frame, the driver triggers the hardware to
>> capture the host graphics output and compress it to JPEG format.
>>
>> I was unable to cross compile v4l2-compliance for ARM with our OpenBMC
>> toolchain. Although bootstrap, configure, and make were successful, no binaries
>> were generated... I was able to build v4l-utils 1.12.3 from the OpenEmbedded
>> project, with the output below:
> You can also try to build it manually:
>
> g++ -o v4l2-compliance -DNO_LIBV4L2 v4l2-compliance.cpp v4l2-test-debug.cpp v4l2-test-input-output.cpp v4l2-test-controls.cpp v4l2-test-io-config.cpp v4l2-test-formats.cpp v4l2-test-buffers.cpp
> v4l2-test-codecs.cpp v4l2-test-colors.cpp v4l2-test-media.cpp v4l2-test-subdevs.cpp media-info.cpp v4l2-info.cpp -I../.. -I../../include -I../common
>
> (replace g++ with your cross compiler)
>
> Hopefully that will work since 1.12.3 is way too old.
>
> Regards,
>
> 	Hans

Yea I got it built. Still no SHA :( But this is with HEAD at commit 
3874aa8eb1ff0c2e103d024ba5af915b1b26f098

FYI I am also patching out the JPEG thing I mentioned, so that the 
streaming test will run:
diff --git a/utils/v4l2-compliance/v4l2-test-formats.cpp 
b/utils/v4l2-compliance
index 02c2ce9..1f6eaa5 100644
--- a/utils/v4l2-compliance/v4l2-test-formats.cpp
+++ b/utils/v4l2-compliance/v4l2-test-formats.cpp
@@ -330,7 +330,7 @@ static int testColorspace(__u32 pixelformat, __u32 
colorspac
         fail_on_test(!colorspace);
         fail_on_test(colorspace == V4L2_COLORSPACE_BT878);
         fail_on_test(pixelformat == V4L2_PIX_FMT_JPEG &&
-                    colorspace != V4L2_COLORSPACE_JPEG);
+                    colorspace != V4L2_COLORSPACE_SRGB);
         fail_on_test(pixelformat != V4L2_PIX_FMT_JPEG &&
                      colorspace == V4L2_COLORSPACE_JPEG);
         fail_on_test(colorspace >= 0xff);


v4l2-compliance SHA: not available, 32 bits

Compliance test for device /dev/video0:

Driver Info:
     Driver name      : aspeed-video
     Card type        : Aspeed Video Engine
     Bus info         : platform:aspeed-video
     Driver version   : 4.18.8
     Capabilities     : 0x85200001
         Video Capture
         Read/Write
         Streaming
         Extended Pix Format
         Device Capabilities
     Device Caps      : 0x05200001
         Video Capture
         Read/Write
         Streaming
         Extended Pix Format

Required ioctls:
     test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
     test second /dev/video0 open: OK
     test VIDIOC_QUERYCAP: OK
     test VIDIOC_G/S_PRIORITY: OK
     test for unlimited opens: OK

Debug ioctls:
     test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
     test VIDIOC_LOG_STATUS: OK (Not Supported)

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
     test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK
     test VIDIOC_DV_TIMINGS_CAP: OK
     test VIDIOC_G/S_EDID: OK (Not Supported)

Control ioctls (Input 0):
     test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
     test VIDIOC_QUERYCTRL: OK
     test VIDIOC_G/S_CTRL: OK
     test VIDIOC_G/S/TRY_EXT_CTRLS: OK
         warn: v4l2-test-controls.cpp(845): V4L2_CID_DV_RX_POWER_PRESENT 
not found for input 0
     test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
     test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
     Standard Controls: 3 Private Controls: 0

Format ioctls (Input 0):
     test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
     test VIDIOC_G/S_PARM: OK
     test VIDIOC_G_FBUF: OK (Not Supported)
     test VIDIOC_G_FMT: OK
     test VIDIOC_TRY_FMT: OK
     test VIDIOC_S_FMT: OK
     test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
     test Cropping: OK (Not Supported)
     test Composing: OK (Not Supported)
     test Scaling: OK (Not Supported)

Codec ioctls (Input 0):
     test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
     test VIDIOC_G_ENC_INDEX: OK (Not Supported)
     test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 0):
     test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
     test VIDIOC_EXPBUF: OK (Not Supported)

Test input 0:

Streaming ioctls:
     test read/write: OK
         fail: v4l2-test-buffers.cpp(1245): pid != pid_streamoff
         fail: v4l2-test-buffers.cpp(1278): testBlockingDQBuf(node, q)
     test blocking wait: FAIL
     test MMAP: OK
     test USERPTR: OK (Not Supported)
     test DMABUF: OK (Not Supported)

Total: 48, Succeeded: 47, Failed: 1, Warnings: 1

Will probably have to get another patch setup for that blocking dequeue 
I guess, but would appreciate any feedback on this patch.

Thanks,
Eddie

>
>> v4l2-compliance SHA   : not available
>>
>> Driver Info:
>> 	Driver name   : aspeed-video
>> 	Card type     : Aspeed Video Engine
>> 	Bus info      : platform:aspeed-video
>> 	Driver version: 4.18.8
>> 	Capabilities  : 0x85200001
>> 		Video Capture
>> 		Read/Write
>> 		Streaming
>> 		Extended Pix Format
>> 		Device Capabilities
>> 	Device Caps   : 0x05200001
>> 		Video Capture
>> 		Read/Write
>> 		Streaming
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
>> 	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK
>> 	test VIDIOC_DV_TIMINGS_CAP: OK
>> 	test VIDIOC_G/S_EDID: OK
>>
>> Test input 0:
>>
>> 	Control ioctls:
>> 		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>> 		test VIDIOC_QUERYCTRL: OK
>> 		test VIDIOC_G/S_CTRL: OK
>> 		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>> 		warn: ../../../v4l-utils-1.12.3/utils/v4l2-compliance/v4l2-test-controls.cpp(811): V4L2_CID_DV_RX_POWER_PRESENT not found for input 0
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
>> 		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>> 		test VIDIOC_EXPBUF: OK (Not Supported)
>>
>> Test input 0:
>>
>> Streaming ioctls:
>> 	test read/write: OK
>> 	test MMAP: OK
>> 	test USERPTR: OK (Not Supported)
>> 	test DMABUF: OK (Not Supported)
>>
>>
>> Total: 47, Succeeded: 47, Failed: 0, Warnings: 1
>>
>> Changes since v2:
>>   - Switch to streaming interface. This involved a lot of changes.
>>   - Rework memory allocation due to using videobuf2 buffers, but also only
>>     allocate the necessary size of source buffer rather than the max size
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
>>   drivers/media/platform/aspeed-video.c              | 1645 ++++++++++++++++++++
>>   5 files changed, 1688 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/aspeed-video.txt
>>   create mode 100644 drivers/media/platform/aspeed-video.c
>>
