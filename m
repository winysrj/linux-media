Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4068FC04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 22:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF5332082F
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 22:26:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF5332082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbeLJW0n (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 17:26:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727565AbeLJW0n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 17:26:43 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wBAMNmiJ083254
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 17:26:42 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2p9w9yhgqj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 17:26:42 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.ibm.com>;
        Mon, 10 Dec 2018 22:26:41 -0000
Received: from b03cxnp08027.gho.boulder.ibm.com (9.17.130.19)
        by e36.co.us.ibm.com (192.168.1.136) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Dec 2018 22:26:36 -0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id wBAMQZKl28311634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 10 Dec 2018 22:26:35 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDCB06A04F;
        Mon, 10 Dec 2018 22:26:35 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A5586A054;
        Mon, 10 Dec 2018 22:26:34 +0000 (GMT)
Received: from oc6728276242.ibm.com (unknown [9.85.155.148])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 10 Dec 2018 22:26:34 +0000 (GMT)
From:   Eddie James <eajames@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        hverkuil@xs4all.nl, Eddie James <eajames@linux.vnet.ibm.com>
Subject: [PATCH v7 0/2] media: platform: Add Aspeed Video Engine driver
Date:   Mon, 10 Dec 2018 16:26:29 -0600
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
x-cbid: 18121022-0020-0000-0000-00000E97C30C
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010210; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000270; SDB=6.01129916; UDB=6.00587095; IPR=6.00910050;
 MB=3.00024647; MTD=3.00000008; XFM=3.00000015; UTC=2018-12-10 22:26:39
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 18121022-0021-0000-0000-000064019EBD
Message-Id: <1544480791-92746-1-git-send-email-eajames@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-12-10_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1812100200
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Eddie James <eajames@linux.vnet.ibm.com>

The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
can capture and compress video data from digital or analog sources. With
the Aspeed chip acting as a service processor, the Video Engine can
capture the host processor graphics output.

This series adds a V4L2 driver for the VE, providing the usual V4L2 streaming
interface by way of videobuf2. Each frame, the driver triggers the hardware to
capture the host graphics output and compress it to JPEG format.

v4l2-compliance SHA: d039b47a108596ca004b11e52989054882d45888, 32 bits

Compliance test for device /dev/video0:

Driver Info:
	Driver name      : aspeed-video
	Card type        : Aspeed Video Engine
	Bus info         : platform:aspeed-video
	Driver version   : 4.19.6
	Capabilities     : 0x85200001
		Video Capture
		Read/Write
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x05200001
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
		warn: v4l2-test-controls.cpp(853): V4L2_CID_DV_RX_POWER_PRESENT not found for input 0
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
	test VIDIOC_EXPBUF: OK
	test Requests: OK (Not Supported)

Test input 0:

Streaming ioctls:
	test read/write: OK
	test blocking wait: OK
	test MMAP: OK                                     
	test USERPTR: OK (Not Supported)
	test DMABUF: Cannot test, specify --expbuf-device

Total: 48, Succeeded: 48, Failed: 0, Warnings: 1

I'm unable to run linux-next or the media tree as our system doesn't boot
without quite a few patches that aren't yet upstreamed, so I can't grab the
fix for that warning Hans mentioned.

Changes since v6:
 - Refactor open/start process such that the file handle can be opened without
   a video signal present
 - Added standards and capabilities
 - Removed used of VB2_BUF_FLAG_LAST
 - Added a few comments
 - Removed a couple of functions that were only used once
 - Removed client counter

Changes since v5:
 - Rework resolution change and v4l2 timings functions again with active and
   detected timings.
 - Renamed a few things.
 - Fixed polarities in the timings.

Changes since v4:
 - Set real min and max resolution in enum_dv_timings
 - Add check for vb2_is_busy before settings the timings
 - Set max frame rate to the actual max rather than max + 1
 - Correct the input status to 0.
 - Rework resolution change to only set the relevant h/w regs during startup or
   when set_timings is called.

Changes since v3:
 - Switch update reg function to use u32 clear rather than unsigned long mask
 - Add timing information from host VGA signal
 - Fix binding documentation mispelling
 - Fix upper case hex values
 - Add wait_prepare and wait_finish
 - Set buffer state to queued (rather than error) if streaming fails to start
 - Switch engine busy print statement to error
 - Removed a couple unecessary type assignments in v4l2 ioctls
 - Added query_dv_timings, fixed get_dv_timings
 - Corrected source change event to fire if and only if size actually changes
 - Locked open and release

Changes since v2:
 - Switch to streaming interface. This involved a lot of changes.
 - Rework memory allocation due to using videobuf2 buffers, but also only
   allocate the necessary size of source buffer rather than the max size

Changes since v1:
 - Removed le32_to_cpu calls for JPEG header data
 - Reworked v4l2 ioctls to be compliant.
 - Added JPEG controls
 - Updated devicetree docs according to Rob's suggestions.
 - Added myself to MAINTAINERS

Eddie James (2):
  dt-bindings: media: Add Aspeed Video Engine binding documentation
  media: platform: Add Aspeed Video Engine driver

 .../devicetree/bindings/media/aspeed-video.txt     |   26 +
 MAINTAINERS                                        |    8 +
 drivers/media/platform/Kconfig                     |    9 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/aspeed-video.c              | 1717 ++++++++++++++++++++
 5 files changed, 1761 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/aspeed-video.txt
 create mode 100644 drivers/media/platform/aspeed-video.c

-- 
1.8.3.1

