Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD664C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 12:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 926482081B
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 12:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfBEM21 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 07:28:27 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:51880 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725947AbfBEM20 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Feb 2019 07:28:26 -0500
Received: from [IPv6:2001:983:e9a7:1:2989:f759:211b:c8a5] ([IPv6:2001:983:e9a7:1:2989:f759:211b:c8a5])
        by smtp-cloud8.xs4all.net with ESMTPA
        id qzptgPX5CNR5yqzpugp5M8; Tue, 05 Feb 2019 13:28:23 +0100
Subject: Re: [PATCH v12 00/13] media: staging/imx7: add i.MX7 media driver
To:     Rui Miguel Silva <rui.silva@linaro.org>,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20190204120039.1198-1-rui.silva@linaro.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e13e5b24-3dbd-a813-d8d6-6d21667e1314@xs4all.nl>
Date:   Tue, 5 Feb 2019 13:28:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190204120039.1198-1-rui.silva@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfHxECW06hXaj2LYLNE/37p4z146EF+nclKbsqQiEK091REqMd6Yj6RUhqXw06mWCddGK+GTio1gYeTpyGgmfhFzl4Qy/exfLoVCitK6+JmztMcuH5lS7
 S3c/u8Yuo84tVB0H6APjkBADi1+lj9fnLrmzU33iuj/AsgOzJk8M8XD1riEhew/YhrjYOBqWkQiY+pYDbX0sz2hErujZPMxsh4kKzWnU1LFM4JstCeTzbz8c
 osZFErYtvezM7hHgZAF5Whb0cBaCuASXJ78m64IISK4Eml+OfTQMDx6Z4pWPxS3hH6Fw5FKDYc9Dq5zNX1HKXOmkPbghbpSZoS1sUT55RXjPa1PEZuGGecgX
 fAEndhFm4AvfVOcxTigtJYmFcLxhxi5WhzRNamQGzyO0iGSd5VXs5ECpdS9ySU+PbpoxRIf8T7zcHKAP2t7XSl3t43LdxN11E15FzsdxsyQ2UV6HqpZ3J3qd
 PFAxQAOtzNTfmrvR8BrU/jlB/RiiLCIkL6yeI/kl/3DTOiNDnHNuNeCGnkAHBif8AD+STnqN/TDuxawC
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/4/19 1:00 PM, Rui Miguel Silva wrote:
> Hi,
> This series introduces the Media driver to work with the i.MX7 SoC. it uses the
> already existing imx media core drivers but since the i.MX7, contrary to
> i.MX5/6, do not have an IPU and because of that some changes in the imx media
> core are made along this series to make it support that case.
> 
> This patches adds CSI and MIPI-CSI2 drivers for i.MX7, along with several
> configurations changes for this to work as a capture subsystem. Some bugs are
> also fixed along the line. And necessary documentation.
> 
> For a more detailed view of the capture paths, pads links in the i.MX7 please
> take a look at the documentation in PATCH 10.
> 
> The system used to test and develop this was the Warp7 board with an OV2680
> sensor, which output format is 10-bit bayer. So, only MIPI interface was
> tested, a scenario with an parallel input would nice to have.
> 
> Bellow goes an example of the output of the pads and links and the output of
> v4l2-compliance testing.
> 
> The v4l-utils version used is:
> v4l2-compliance SHA: 1a6c8fe9a65c26e78ba34bd4aa2df28ede7d00cb, 32 bits
> 
> The Media Driver fail some tests but this failures are coming from code out of
> scope of this series (imx-capture), and some from the sensor OV2680
> but that I think not related with the sensor driver but with the testing and
> core.
> 
> The csi and mipi-csi entities pass all compliance tests.

Darn, I was hoping to merge this, but this series is out of date with the
latest imx code in the master branch. Can you rebase this series?

Thanks!

	Hans

> 
> Cheers,
>     Rui
> 
> v11->v12:
>   Sakari:
>     - check v4l2_ctrl_handler_free and init when exposed to userspace
>     - check csi_remove missing v4l2_async_notifier_unregister
>     - media device unregister before ctrl_handler_free
>     - GPL => GPL v2
>     - Fix squash of CSI patches, issue on v11
>     - add Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com> 10--13
>     - mipi_s_stream check for ret < 0 and call pm_runtime_put_noidle
>     - use __maybe_unused in pm functions
>     - Extra space before labels
> 
> v10->v11:
>   Sakari:
>     - Remove cleanup functions in dev-common and do direct calls
>     - Fix notifier cleanup on error path
> 
>   Philipp Zabel:
>     - Add reviewed tag to video mux patch 12/13
> 
> v9->v10:
>   Hans:
>   - move dt-bindings patch up in the series to avoid checkpatch warnings
>   - Fix SPDX tag
> 
>   Sakari:
>   - use debugfs and drop driver parameters
>   - use dev_*() macros all over the place, drop v4l2_*() ones
>   - use clk_bulk
>   - give control to power state to runtime PM
>   - unsigned and const for some objects
> 
> v8->v9:
> Hans Verkuil:
>  - Fix issues detected by checkpatch strict, still some left:
>      - bigger kconfig option description
>      - some alignement parenthesis that were left as they are, to be more
>      readable 
>      - added new patch (PATCH13) for Maintainers update
>      - SPDX in documentation rst file
> Sakari Ailus:
>  - remove pad check in csi, this is done by core already
>  - destroy mutex in probe error path (add label)
>  - swap order in driver release
>  - initialize endpoint in stack
>  - use clk_bulk
> kbuild test robot:
>  - add the missing imx-media-dev-common.c in patch 1/13
>  - remove OWNER of module csis
> Myself:
>  - add MAINTAINERS entries - new patch
> 
> v7->v8:
> Myself:
>  - rebase to latest linux-next (s/V4L2_MBUS_CSI2/V4L2_MBUS_CSI2_DPHY/)
>  - Rebuild and test with latest v4l2-compliance
>  - add Sakari reviewed-by tag to dt-bindings
> 
> v6->v7:
> Myself:
>  - Clock patches removed from this version since they were already merged
>  - Rebuild and test with the latest v4l2-compliance
>  - Add patch to video-mux regarding bayer formats
>  - remove reference to dependent patch serie (was already merged)
> 
> Sakari Ailus:
>  - add port and endpoint explanantions
>  - fix some wording should -> shall
> 
> v5->v6:
> Rob Herring:
>  - rename power-domain node name from: pgc-power-domain to power-domain
>  - change mux-control-cells to 0
>  - remove bus-width from mipi bindings and dts
>  - remove err... regarding clock names line
>  - remove clk-settle from example
>  - split mipi-csi2 and csi bindings per file
>  - add OF graph description to CSI
> 
> Philipp Zabel:
>  - rework group IDs and rename them with an _IPU_ prefix, this allowed to remove
>    the ipu_present flag need.
> 
> v4->v5:
> Sakari Ailus:
>  - fix remove of the capture entries in dts bindings in the right patch
> 
> Stephen Boyd:
>  - Send all series to clk list
> 
> v3->v4:
> Philipp Zabel:
>  - refactor initialization code from media device probe to be possible to used
>    from other modules
>  - Remove index of csi from all accurrencs (dts, code, documentation)
>  - Remove need for capture node for imx7
>  - fix pinctrl for ov2680
>  - add reviewed tag to add multiplexer controls patch
> 
> Fabio Estevam:
>  - remove always on from new regulator
> 
> Randy Dunlap:
>  - several text editing fixes in documentation
> 
> Myself:
>  - rebase on top of v4 of Steve series
>  - change CSI probe to initialize imx media device
>  - remove csi mux parallel endpoint from mux to avoid warning message
> 
> v2->v3:
> Philipp Zabel:
>  - use of_match_device in imx-media-dev instead of of_device_match
>  - fix number of data lanes from 4 to 2
>  - change the clock definitions and use of mipi
>  - move hs-settle from endpoint
> 
> Rob Herring:
>  - fix phy-supply description
>  - add vendor properties
>  - fix examples indentations
> 
> Stephen Boyd: patch 3/14
>  - fix double sign-off
>  - add fixes tag
> 
> Dong Aisheng: patch 3/14
>  - fix double sign-off
>  - add Acked-by tag
> 
> Shawn Guo:
> patch 4/14
>  - remove line breakage in parent redifiniton
>  - added Acked-by tag
> 
>  - dropped CMA area increase and add more verbose information in case of
>    dma allocation failure
> patch 9/14
>  - remove extra line between cells and reg masks
> 
> Myself:
>  - rework on frame end in csi
>  - add rxcount in csi driver
>  - add power supplies to ov2680 node and fix gpio polarity
> 
> v1->v2:
> Dan Carpenter:
>  - fix return paths and codes;
>  - fix clk_frequency validation and return code;
>  - handle the csi remove (release resources that was missing)
>  - revert the logic arround the ipu_present flag
> 
> Philipp Zabel:
>  - drop patch that changed the rgb formats and address the pixel/bus format in
>    mipi_csis code.
> 
> MySelf:
>  - add patch that add ov2680 node to the warp7 dts, so the all data path is
>    complete.
>  - add linux-clk mailing list to the clock patches cc:
> 
> 
> v4l2-compliance SHA: 1a6c8fe9a65c26e78ba34bd4aa2df28ede7d00cb, 32 bits
> 
> Compliance test for imx7-csi device /dev/media0:
> 
> Media Driver Info:
>         Driver name      : imx7-csi
>         Model            : imx-media
>         Serial           : 
>         Bus info         : 
>         Media version    : 5.0.0
>         Hardware revision: 0x00000000 (0)
>         Driver version   : 5.0.0
> 
> Required ioctls:
>         test MEDIA_IOC_DEVICE_INFO: OK
> 
> Allow for multiple opens:
>         test second /dev/media0 open: OK
>         test MEDIA_IOC_DEVICE_INFO: OK
>         test for unlimited opens: OK
> 
> Media Controller ioctls:
>                 Entity: 0x00000001 (Name: 'csi', Function: Video Interface Bridge)
>                 Entity: 0x00000004 (Name: 'csi capture', Function: V4L2 I/O)
>                 Entity: 0x0000000a (Name: 'csi_mux', Function: Video Muxer)
>                 Entity: 0x0000000e (Name: 'imx7-mipi-csis.0', Function: Video Interface Bridge)
>                 Entity: 0x00000011 (Name: 'ov2680 1-0036', Function: Camera Sensor)
>                 Interface: 0x03000005 (Type: V4L Video, DevPath: /dev/video0)
>                 Interface: 0x03000019 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev0)
>                 Interface: 0x0300001b (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev1)
>                 Interface: 0x0300001d (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev2)
>                 Interface: 0x0300001f (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev3)
>                 Pad: 0x01000002 (0, csi, Sink)
>                 Pad: 0x01000003 (1, csi, Source)
>                 Pad: 0x01000007 (0, csi capture, Sink)
>                 Pad: 0x0100000b (0, csi_mux, Sink)
>                 Pad: 0x0100000c (1, csi_mux, Sink)
>                 Pad: 0x0100000d (2, csi_mux, Source)
>                 Pad: 0x0100000f (0, imx7-mipi-csis.0, Sink)
>                 Pad: 0x01000010 (1, imx7-mipi-csis.0, Source)
>                 Pad: 0x01000012 (0, ov2680 1-0036, Source)
>                 Link: 0x02000006 (csi capture to interface /dev/video0)
>                 Link: 0x02000008 (csi -> csi capture, Data, Enabled)
>                 Link: 0x02000013 (imx7-mipi-csis.0 -> csi_mux, Data, Enabled)
>                 Link: 0x02000015 (csi_mux -> csi, Data, Enabled)
>                 Link: 0x02000017 (ov2680 1-0036 -> imx7-mipi-csis.0, Data, Enabled)
>                 Link: 0x0200001a (csi to interface /dev/v4l-subdev0)
>                 Link: 0x0200001c (csi_mux to interface /dev/v4l-subdev1)
>                 Link: 0x0200001e (imx7-mipi-csis.0 to interface /dev/v4l-subdev2)
>                 Link: 0x02000020 (ov2680 1-0036 to interface /dev/v4l-subdev3)
>         test MEDIA_IOC_G_TOPOLOGY: OK
>         Entities: 5 Interfaces: 5 Pads: 9 Links: 9
>                 Entity: 0x00000001 (Name: 'csi', Type: Unknown V4L2 Sub-Device, DevPath: /dev/v4l-subdev0)
>                 Entity: 0x00000004 (Name: 'csi capture', Type: V4L2 I/O, DevPath: /dev/video0)
>                 Entity: 0x0000000a (Name: 'csi_mux', Type: Unknown V4L2 Sub-Device, DevPath: /dev/v4l-subdev1)
>                 Entity: 0x0000000e (Name: 'imx7-mipi-csis.0', Type: Unknown V4L2 Sub-Device, DevPath: /dev/v4l-subdev2)
>                 Entity: 0x00000011 (Name: 'ov2680 1-0036', Type: Camera Sensor, DevPath: /dev/v4l-subdev3)
>         test MEDIA_IOC_ENUM_ENTITIES/LINKS: OK
>         test MEDIA_IOC_SETUP_LINK: OK
> 
> Total for imx7-csi device /dev/media0: 7, Succeeded: 7, Failed: 0, Warnings: 0
> --------------------------------------------------------------------------------
> Compliance test for imx-media-captu device /dev/video0:
> 
> Driver Info:
>         Driver name      : imx-media-captu
>         Card type        : imx-media-capture
>         Bus info         : platform:csi
>         Driver version   : 5.0.0
>         Capabilities     : 0x84200001
>                 Video Capture
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps      : 0x04200001
>                 Video Capture
>                 Streaming
>                 Extended Pix Format
> Media Driver Info:
>         Driver name      : imx7-csi
>         Model            : imx-media
>         Serial           : 
>         Bus info         : 
>         Media version    : 5.0.0
>         Hardware revision: 0x00000000 (0)
>         Driver version   : 5.0.0
> Interface Info:
>         ID               : 0x03000005
>         Type             : V4L Video
> Entity Info:
>         ID               : 0x00000004 (4)
>         Name             : csi capture
>         Function         : V4L2 I/O
>         Pad 0x01000007   : 0: Sink
>           Link 0x02000008: from remote pad 0x1000003 of entity 'csi': Data, Enabled
> 
> Required ioctls:
>         test MC information (see 'Media Driver Info' above): OK
>         test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>         test second /dev/video0 open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
>         test for unlimited opens: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>         test VIDIOC_LOG_STATUS: OK (Not Supported)
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 0 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Control ioctls:
>                 info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
>                 info: checking v4l2_queryctrl of control 'Exposure' (0x00980911)
>                 info: checking v4l2_queryctrl of control 'Gain, Automatic' (0x00980912)
>                 info: checking v4l2_queryctrl of control 'Gain' (0x00980913)
>                 info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
>                 info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
>                 info: checking v4l2_queryctrl of control 'Camera Controls' (0x009a0001)
>                 info: checking v4l2_queryctrl of control 'Auto Exposure' (0x009a0901)
>                 info: checking v4l2_queryctrl of control 'Image Processing Controls' (0x009f0001)
>                 info: checking v4l2_queryctrl of control 'Test Pattern' (0x009f0903)
>                 info: checking v4l2_queryctrl of control 'Exposure' (0x00980911)
>                 info: checking v4l2_queryctrl of control 'Gain, Automatic' (0x00980912)
>                 info: checking v4l2_queryctrl of control 'Gain' (0x00980913)
>                 info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
>                 info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
>         test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>         test VIDIOC_QUERYCTRL: OK
>                 info: checking control 'User Controls' (0x00980001)
>                 info: checking control 'Exposure' (0x00980911)
>                 info: checking control 'Gain, Automatic' (0x00980912)
>                 info: checking control 'Gain' (0x00980913)
>                 info: checking control 'Horizontal Flip' (0x00980914)
>                 info: checking control 'Vertical Flip' (0x00980915)
>                 info: checking control 'Camera Controls' (0x009a0001)
>                 info: checking control 'Auto Exposure' (0x009a0901)
>                 info: checking control 'Image Processing Controls' (0x009f0001)
>                 info: checking control 'Test Pattern' (0x009f0903)
>         test VIDIOC_G/S_CTRL: OK
>                 info: checking extended control 'User Controls' (0x00980001)
>                 info: checking extended control 'Exposure' (0x00980911)
>                 info: checking extended control 'Gain, Automatic' (0x00980912)
>                 info: checking extended control 'Gain' (0x00980913)
>                 info: checking extended control 'Horizontal Flip' (0x00980914)
>                 info: checking extended control 'Vertical Flip' (0x00980915)
>                 info: checking extended control 'Camera Controls' (0x009a0001)
>                 info: checking extended control 'Auto Exposure' (0x009a0901)
>                 info: checking extended control 'Image Processing Controls' (0x009f0001)
>                 info: checking extended control 'Test Pattern' (0x009f0903)
>         test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 info: checking control event 'User Controls' (0x00980001)
>                 fail: ../../../../../../../../../../v4l-utils/utils/v4l2-compliance/v4l2-test-controls.cpp(824): subscribe event for control 'User Controls' failed
>         test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
>         test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>         Standard Controls: 10 Private Controls: 0
> 
> Format ioctls:
>                 info: found 1 formats for buftype 1
>         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>         test VIDIOC_G/S_PARM: OK (Not Supported)
>         test VIDIOC_G_FBUF: OK (Not Supported)
>         test VIDIOC_G_FMT: OK
>         test VIDIOC_TRY_FMT: OK
>         test VIDIOC_S_FMT: OK
>         test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>         test Cropping: OK (Not Supported)
>         test Composing: OK (Not Supported)
>         test Scaling: OK (Not Supported)
> 
> Codec ioctls:
>         test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>         test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>         test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> Buffer ioctls:
>                 info: test buftype Video Capture
>         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>         test VIDIOC_EXPBUF: OK
>         test Requests: OK (Not Supported)
> 
> Total for imx-media-captu device /dev/video0: 45, Succeeded: 44, Failed: 1, Warnings: 0
> --------------------------------------------------------------------------------
> Compliance test for imx7-csi device /dev/v4l-subdev0:
> 
> Media Driver Info:
>         Driver name      : imx7-csi
>         Model            : imx-media
>         Serial           : 
>         Bus info         : 
>         Media version    : 5.0.0
>         Hardware revision: 0x00000000 (0)
>         Driver version   : 5.0.0
> Interface Info:
>         ID               : 0x03000019
>         Type             : V4L Sub-Device
> Entity Info:
>         ID               : 0x00000001 (1)
>         Name             : csi
>         Function         : Video Interface Bridge
>         Pad 0x01000002   : 0: Sink
>           Link 0x02000015: from remote pad 0x100000d of entity 'csi_mux': Data, Enabled
>         Pad 0x01000003   : 1: Source
>           Link 0x02000008: to remote pad 0x1000007 of entity 'csi capture': Data, Enabled
> 
> Required ioctls:
>         test MC information (see 'Media Driver Info' above): OK
> 
> Allow for multiple opens:
>         test second /dev/v4l-subdev0 open: OK
>         test for unlimited opens: OK
> 
> Debug ioctls:
>         test VIDIOC_LOG_STATUS: OK (Not Supported)
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 0 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Sub-Device ioctls (Sink Pad 0):
>         test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
>         test Try VIDIOC_SUBDEV_G/S_FMT: OK
>         test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
>         test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
>         test Active VIDIOC_SUBDEV_G/S_FMT: OK
>         test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
>         test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)
> 
> Sub-Device ioctls (Source Pad 1):
>         test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
>         test Try VIDIOC_SUBDEV_G/S_FMT: OK
>         test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
>         test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
>         test Active VIDIOC_SUBDEV_G/S_FMT: OK
>         test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
>         test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)
> 
> Control ioctls:
>         test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>         test VIDIOC_QUERYCTRL: OK
>         test VIDIOC_G/S_CTRL: OK
>         test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>         test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
>         test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>         Standard Controls: 0 Private Controls: 0
> 
> Format ioctls:
>         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
>         test VIDIOC_G/S_PARM: OK (Not Supported)
>         test VIDIOC_G_FBUF: OK (Not Supported)
>         test VIDIOC_G_FMT: OK (Not Supported)
>         test VIDIOC_TRY_FMT: OK (Not Supported)
>         test VIDIOC_S_FMT: OK (Not Supported)
>         test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>         test Cropping: OK (Not Supported)
>         test Composing: OK (Not Supported)
>         test Scaling: OK (Not Supported)
> 
> Codec ioctls:
>         test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>         test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>         test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> Buffer ioctls:
>         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
>         test VIDIOC_EXPBUF: OK (Not Supported)
>                 info: could not test the Request API, no suitable control found
>         test Requests: OK (Not Supported)
> 
> Total for imx7-csi device /dev/v4l-subdev0: 55, Succeeded: 55, Failed: 0, Warnings: 0
> --------------------------------------------------------------------------------
> Compliance test for device /dev/v4l-subdev1:
> 
> 
> Required ioctls:
> 
> Allow for multiple opens:
>         test second /dev/v4l-subdev1 open: OK
>         test for unlimited opens: OK
> 
> Debug ioctls:
>         test VIDIOC_LOG_STATUS: OK (Not Supported)
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 0 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Control ioctls:
>         test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
>         test VIDIOC_QUERYCTRL: OK (Not Supported)
>         test VIDIOC_G/S_CTRL: OK (Not Supported)
>         test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
>         test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
>         test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>         Standard Controls: 0 Private Controls: 0
> 
> Format ioctls:
>         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
>         test VIDIOC_G/S_PARM: OK (Not Supported)
>         test VIDIOC_G_FBUF: OK (Not Supported)
>         test VIDIOC_G_FMT: OK (Not Supported)
>         test VIDIOC_TRY_FMT: OK (Not Supported)
>         test VIDIOC_S_FMT: OK (Not Supported)
>         test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>         test Cropping: OK (Not Supported)
>         test Composing: OK (Not Supported)
>         test Scaling: OK (Not Supported)
> 
> Codec ioctls:
>         test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>         test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>         test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> Buffer ioctls:
>         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
>         test VIDIOC_EXPBUF: OK (Not Supported)
>                 info: could not test the Request API, no suitable control found
>         test Requests: OK (Not Supported)
> 
> Total for device /dev/v4l-subdev1: 40, Succeeded: 40, Failed: 0, Warnings: 0
> --------------------------------------------------------------------------------
> Compliance test for device /dev/v4l-subdev2:
> 
> 
> Required ioctls:
> 
> Allow for multiple opens:
>         test second /dev/v4l-subdev2 open: OK
>         test for unlimited opens: OK
> 
> Debug ioctls:
>         test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 0 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Control ioctls:
>         test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
>         test VIDIOC_QUERYCTRL: OK (Not Supported)
>         test VIDIOC_G/S_CTRL: OK (Not Supported)
>         test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
>         test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
>         test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>         Standard Controls: 0 Private Controls: 0
> 
> Format ioctls:
>         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
>         test VIDIOC_G/S_PARM: OK (Not Supported)
>         test VIDIOC_G_FBUF: OK (Not Supported)
>         test VIDIOC_G_FMT: OK (Not Supported)
>         test VIDIOC_TRY_FMT: OK (Not Supported)
>         test VIDIOC_S_FMT: OK (Not Supported)
>         test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>         test Cropping: OK (Not Supported)
>         test Composing: OK (Not Supported)
>         test Scaling: OK (Not Supported)
> 
> Codec ioctls:
>         test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>         test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>         test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> Buffer ioctls:
>         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
>         test VIDIOC_EXPBUF: OK (Not Supported)
>                 info: could not test the Request API, no suitable control found
>         test Requests: OK (Not Supported)
> 
> Total for device /dev/v4l-subdev2: 40, Succeeded: 40, Failed: 0, Warnings: 0
> --------------------------------------------------------------------------------
> Compliance test for device /dev/v4l-subdev3:
> 
> 
> Required ioctls:
> 
> Allow for multiple opens:
>         test second /dev/v4l-subdev3 open: OK
>         test for unlimited opens: OK
> 
> Debug ioctls:
>         test VIDIOC_LOG_STATUS: OK (Not Supported)
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 0 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Control ioctls:
>                 info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
>                 info: checking v4l2_queryctrl of control 'Exposure' (0x00980911)
>                 info: checking v4l2_queryctrl of control 'Gain, Automatic' (0x00980912)
>                 info: checking v4l2_queryctrl of control 'Gain' (0x00980913)
>                 info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
>                 info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
>                 info: checking v4l2_queryctrl of control 'Camera Controls' (0x009a0001)
>                 info: checking v4l2_queryctrl of control 'Auto Exposure' (0x009a0901)
>                 info: checking v4l2_queryctrl of control 'Image Processing Controls' (0x009f0001)
>                 info: checking v4l2_queryctrl of control 'Test Pattern' (0x009f0903)
>                 info: checking v4l2_queryctrl of control 'Exposure' (0x00980911)
>                 info: checking v4l2_queryctrl of control 'Gain, Automatic' (0x00980912)
>                 info: checking v4l2_queryctrl of control 'Gain' (0x00980913)
>                 info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
>                 info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
>         test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>         test VIDIOC_QUERYCTRL: OK
>                 info: checking control 'User Controls' (0x00980001)
>                 info: checking control 'Exposure' (0x00980911)
>                 info: checking control 'Gain, Automatic' (0x00980912)
>                 info: checking control 'Gain' (0x00980913)
>                 info: checking control 'Horizontal Flip' (0x00980914)
>                 info: checking control 'Vertical Flip' (0x00980915)
>                 info: checking control 'Camera Controls' (0x009a0001)
>                 info: checking control 'Auto Exposure' (0x009a0901)
>                 info: checking control 'Image Processing Controls' (0x009f0001)
>                 info: checking control 'Test Pattern' (0x009f0903)
>         test VIDIOC_G/S_CTRL: OK
>                 info: checking extended control 'User Controls' (0x00980001)
>                 info: checking extended control 'Exposure' (0x00980911)
>                 info: checking extended control 'Gain, Automatic' (0x00980912)
>                 info: checking extended control 'Gain' (0x00980913)
>                 info: checking extended control 'Horizontal Flip' (0x00980914)
>                 info: checking extended control 'Vertical Flip' (0x00980915)
>                 info: checking extended control 'Camera Controls' (0x009a0001)
>                 info: checking extended control 'Auto Exposure' (0x009a0901)
>                 info: checking extended control 'Image Processing Controls' (0x009f0001)
>                 info: checking extended control 'Test Pattern' (0x009f0903)
>         test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 info: checking control event 'User Controls' (0x00980001)
>                 fail: ../../../../../../../../../../v4l-utils/utils/v4l2-compliance/v4l2-test-controls.cpp(824): subscribe event for control 'User Controls' failed
>         test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
>         test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>         Standard Controls: 10 Private Controls: 0
> 
> Format ioctls:
>         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
>         test VIDIOC_G/S_PARM: OK (Not Supported)
>         test VIDIOC_G_FBUF: OK (Not Supported)
>         test VIDIOC_G_FMT: OK (Not Supported)
>         test VIDIOC_TRY_FMT: OK (Not Supported)
>         test VIDIOC_S_FMT: OK (Not Supported)
>         test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>         test Cropping: OK (Not Supported)
>         test Composing: OK (Not Supported)
>         test Scaling: OK (Not Supported)
> 
> Codec ioctls:
>         test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>         test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>         test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> Buffer ioctls:
>         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
>         test VIDIOC_EXPBUF: OK (Not Supported)
>         test Requests: OK (Not Supported)
> 
> Total for device /dev/v4l-subdev3: 40, Succeeded: 39, Failed: 1, Warnings: 0
> 
> Grand Total for imx7-csi device /dev/media0: 227, Succeeded: 225, Failed: 2, Warnings: 0
> 
> Rui Miguel Silva (13):
>   media: staging/imx: refactor imx media device probe
>   media: staging/imx: rearrange group id to take in account IPU
>   media: dt-bindings: add bindings for i.MX7 media driver
>   media: staging/imx7: add imx7 CSI subdev driver
>   media: staging/imx7: add MIPI CSI-2 receiver subdev for i.MX7
>   ARM: dts: imx7s: add mipi phy power domain
>   ARM: dts: imx7s: add multiplexer controls
>   ARM: dts: imx7: Add video mux, csi and mipi_csi and connections
>   ARM: dts: imx7s-warp: add ov2680 sensor node
>   media: imx7.rst: add documentation for i.MX7 media driver
>   media: staging/imx: add i.MX7 entries to TODO file
>   media: video-mux: add bayer formats
>   media: MAINTAINERS: add entry for Freescale i.MX7 media driver
> 
>  .../devicetree/bindings/media/imx7-csi.txt    |   45 +
>  .../bindings/media/imx7-mipi-csi2.txt         |   90 ++
>  Documentation/media/v4l-drivers/imx7.rst      |  157 ++
>  Documentation/media/v4l-drivers/index.rst     |    1 +
>  MAINTAINERS                                   |   11 +
>  arch/arm/boot/dts/imx7s-warp.dts              |   95 ++
>  arch/arm/boot/dts/imx7s.dtsi                  |   44 +-
>  drivers/media/platform/video-mux.c            |   20 +
>  drivers/staging/media/imx/Kconfig             |    9 +-
>  drivers/staging/media/imx/Makefile            |    4 +
>  drivers/staging/media/imx/TODO                |    9 +
>  drivers/staging/media/imx/imx-ic-common.c     |    6 +-
>  drivers/staging/media/imx/imx-ic-prp.c        |   16 +-
>  drivers/staging/media/imx/imx-media-csi.c     |    6 +-
>  .../staging/media/imx/imx-media-dev-common.c  |   89 ++
>  drivers/staging/media/imx/imx-media-dev.c     |  103 +-
>  .../staging/media/imx/imx-media-internal-sd.c |   20 +-
>  drivers/staging/media/imx/imx-media-of.c      |    6 +-
>  drivers/staging/media/imx/imx-media-utils.c   |   12 +-
>  drivers/staging/media/imx/imx-media.h         |   35 +-
>  drivers/staging/media/imx/imx7-media-csi.c    | 1365 +++++++++++++++++
>  drivers/staging/media/imx/imx7-mipi-csis.c    | 1186 ++++++++++++++
>  22 files changed, 3210 insertions(+), 119 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/imx7-csi.txt
>  create mode 100644 Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
>  create mode 100644 Documentation/media/v4l-drivers/imx7.rst
>  create mode 100644 drivers/staging/media/imx/imx-media-dev-common.c
>  create mode 100644 drivers/staging/media/imx/imx7-media-csi.c
>  create mode 100644 drivers/staging/media/imx/imx7-mipi-csis.c
> 

