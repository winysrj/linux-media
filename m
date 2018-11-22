Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f48.google.com ([209.85.221.48]:36757 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729936AbeKWB6j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 20:58:39 -0500
Received: by mail-wr1-f48.google.com with SMTP id t3so9624504wrr.3
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 07:18:49 -0800 (PST)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v9 00/13] media: staging/imx7: add i.MX7 media driver
Date: Thu, 22 Nov 2018 15:18:21 +0000
Message-Id: <20181122151834.6194-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
This series introduces the Media driver to work with the i.MX7 SoC. it uses the
already existing imx media core drivers but since the i.MX7, contrary to
i.MX5/6, do not have an IPU and because of that some changes in the imx media
core are made along this series to make it support that case.

This patches adds CSI and MIPI-CSI2 drivers for i.MX7, along with several
configurations changes for this to work as a capture subsystem. Some bugs are
also fixed along the line. And necessary documentation.

For a more detailed view of the capture paths, pads links in the i.MX7 please
take a look at the documentation in PATCH 10.

The system used to test and develop this was the Warp7 board with an OV2680
sensor, which output format is 10-bit bayer. So, only MIPI interface was
tested, a scenario with an parallel input would nice to have.


Bellow goes an example of the output of the pads and links and the output of
v4l2-compliance testing.

The v4l-utils version used is:
v4l2-compliance SHA   : 044d5ab7b0d02683070d01a369c73d462d7a0cee from Nov 19th

The Media Driver fail some tests but this failures are coming from code out of
scope of this series (imx-capture), and some from the sensor OV2680
but that I think not related with the sensor driver but with the testing and
core.

The csi and mipi-csi entities pass all compliance tests.

Cheers,
    Rui

v8->v9:
Hans Verkuil:
 - Fix issues detected by checkpatch strict, still some left:
     - bigger kconfig option description
     - some alignement parenthesis that were left as they are, to be more
     readable 
     - added new patch (PATCH13) for Maintainers update
     - SPDX in documentation rst file
Sakari Ailus:
 - remove pad check in csi, this is done by core already
 - destroy mutex in probe error path (add label)
 - swap order in driver release
 - initialize endpoint in stack
 - use clk_bulk
kbuild test robot:
 - add the missing imx-media-dev-common.c in patch 1/13
 - remove OWNER of module csis
Myself:
 - add MAINTAINERS entries - new patch

v7->v8:
Myself:
 - rebase to latest linux-next (s/V4L2_MBUS_CSI2/V4L2_MBUS_CSI2_DPHY/)
 - Rebuild and test with latest v4l2-compliance
 - add Sakari reviewed-by tag to dt-bindings

v6->v7:
Myself:
 - Clock patches removed from this version since they were already merged
 - Rebuild and test with the latest v4l2-compliance
 - Add patch to video-mux regarding bayer formats
 - remove reference to dependent patch serie (was already merged)

Sakari Ailus:
 - add port and endpoint explanantions
 - fix some wording should -> shall

v5->v6:
Rob Herring:
 - rename power-domain node name from: pgc-power-domain to power-domain
 - change mux-control-cells to 0
 - remove bus-width from mipi bindings and dts
 - remove err... regarding clock names line
 - remove clk-settle from example
 - split mipi-csi2 and csi bindings per file
 - add OF graph description to CSI

Philipp Zabel:
 - rework group IDs and rename them with an _IPU_ prefix, this allowed to remove
   the ipu_present flag need.

v4->v5:
Sakari Ailus:
 - fix remove of the capture entries in dts bindings in the right patch

Stephen Boyd:
 - Send all series to clk list

v3->v4:
Philipp Zabel:
 - refactor initialization code from media device probe to be possible to used
   from other modules
 - Remove index of csi from all accurrencs (dts, code, documentation)
 - Remove need for capture node for imx7
 - fix pinctrl for ov2680
 - add reviewed tag to add multiplexer controls patch

Fabio Estevam:
 - remove always on from new regulator

Randy Dunlap:
 - several text editing fixes in documentation

Myself:
 - rebase on top of v4 of Steve series
 - change CSI probe to initialize imx media device
 - remove csi mux parallel endpoint from mux to avoid warning message

v2->v3:
Philipp Zabel:
 - use of_match_device in imx-media-dev instead of of_device_match
 - fix number of data lanes from 4 to 2
 - change the clock definitions and use of mipi
 - move hs-settle from endpoint

Rob Herring:
 - fix phy-supply description
 - add vendor properties
 - fix examples indentations

Stephen Boyd: patch 3/14
 - fix double sign-off
 - add fixes tag

Dong Aisheng: patch 3/14
 - fix double sign-off
 - add Acked-by tag

Shawn Guo:
patch 4/14
 - remove line breakage in parent redifiniton
 - added Acked-by tag

 - dropped CMA area increase and add more verbose information in case of
   dma allocation failure
patch 9/14
 - remove extra line between cells and reg masks

Myself:
 - rework on frame end in csi
 - add rxcount in csi driver
 - add power supplies to ov2680 node and fix gpio polarity

v1->v2:
Dan Carpenter:
 - fix return paths and codes;
 - fix clk_frequency validation and return code;
 - handle the csi remove (release resources that was missing)
 - revert the logic arround the ipu_present flag

Philipp Zabel:
 - drop patch that changed the rgb formats and address the pixel/bus format in
   mipi_csis code.

MySelf:
 - add patch that add ov2680 node to the warp7 dts, so the all data path is
   complete.
 - add linux-clk mailing list to the clock patches cc:

v4l2-compliance SHA: 044d5ab7b0d02683070d01a369c73d462d7a0cee, 32 bits

Compliance test for device /dev/media0:

Media Driver Info:
        Driver name      : imx7-csi
        Model            : imx-media
        Serial           : 
        Bus info         : 
        Media version    : 4.20.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.20.0

Required ioctls:
        test MEDIA_IOC_DEVICE_INFO: OK

Allow for multiple opens:
        test second /dev/media0 open: OK
        test MEDIA_IOC_DEVICE_INFO: OK
        test for unlimited opens: OK

Media Controller ioctls:
        test MEDIA_IOC_G_TOPOLOGY: OK
        Entities: 5 Interfaces: 5 Pads: 9 Links: 9
        test MEDIA_IOC_ENUM_ENTITIES/LINKS: OK
        test MEDIA_IOC_SETUP_LINK: OK

--------------------------------------------------------------------------------
Compliance test for device /dev/video0:

Driver Info:
        Driver name      : imx-media-captu
        Card type        : imx-media-capture
        Bus info         : platform:csi
        Driver version   : 4.20.0
        Capabilities     : 0x84200001
                Video Capture
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps      : 0x04200001
                Video Capture
                Streaming
                Extended Pix Format
Media Driver Info:
        Driver name      : imx7-csi
        Model            : imx-media
        Serial           : 
        Bus info         : 
        Media version    : 4.20.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.20.0
Interface Info:
        ID               : 0x03000005
        Type             : V4L Video
Entity Info:
        ID               : 0x00000004 (4)
        Name             : csi capture
        Function         : V4L2 I/O
        Pad 0x01000007   : 0: Sink
          Link 0x02000008: from remote pad 0x1000003 of entity 'csi': Data, Enabled

Required ioctls:
        test MC information (see 'Media Driver Info' above): OK
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
                fail: ../../../../../../../../../../v4l-utils/utils/v4l2-compliance/v4l2-test-input-output.cpp(420): G_INPUT not supported for a capture dev
ice
        test VIDIOC_G/S/ENUMINPUT: FAIL
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 0 Audio Inputs: 0 Tuners: 0

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

Control ioctls:
        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
        test VIDIOC_QUERYCTRL: OK
        test VIDIOC_G/S_CTRL: OK
        test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                fail: ../../../../../../../../../../v4l-utils/utils/v4l2-compliance/v4l2-test-controls.cpp(816): subscribe event for control 'User Controls'
 failed
        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
        Standard Controls: 10 Private Controls: 0

Format ioctls:
        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
        test VIDIOC_G/S_PARM: OK (Not Supported)
        test VIDIOC_G_FBUF: OK (Not Supported)
        test VIDIOC_G_FMT: OK
        test VIDIOC_TRY_FMT: OK
        test VIDIOC_S_FMT: OK
        test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
        test Cropping: OK (Not Supported)
        test Composing: OK (Not Supported)
        test Scaling: OK (Not Supported)

Codec ioctls:
        test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
        test VIDIOC_G_ENC_INDEX: OK (Not Supported)
        test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
        test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------
Compliance test for device /dev/v4l-subdev0:

Media Driver Info:
        Driver name      : imx7-csi
        Model            : imx-media
        Serial           : 
        Bus info         : 
        Media version    : 4.20.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.20.0
Interface Info:
        ID               : 0x03000019
        Type             : V4L Sub-Device
Entity Info:
        ID               : 0x00000001 (1)
        Name             : csi
        Function         : Video Interface Bridge
        Pad 0x01000002   : 0: Sink
          Link 0x02000015: from remote pad 0x100000d of entity 'csi_mux': Data, Enabled
        Pad 0x01000003   : 1: Source
          Link 0x02000008: to remote pad 0x1000007 of entity 'csi capture': Data, Enabled

Required ioctls:
        test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
        test second /dev/v4l-subdev0 open: OK
        test for unlimited opens: OK

Debug ioctls:
        test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
        test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 0 Audio Inputs: 0 Tuners: 0

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

Sub-Device ioctls (Sink Pad 0):
        test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
        test Try VIDIOC_SUBDEV_G/S_FMT: OK
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
        test Active VIDIOC_SUBDEV_G/S_FMT: OK
        test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 1):
        test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
        test Try VIDIOC_SUBDEV_G/S_FMT: OK
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
        test Active VIDIOC_SUBDEV_G/S_FMT: OK
        test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Control ioctls:
        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
        test VIDIOC_QUERYCTRL: OK
        test VIDIOC_G/S_CTRL: OK
        test VIDIOC_G/S/TRY_EXT_CTRLS: OK
        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
        Standard Controls: 0 Private Controls: 0

Format ioctls:
        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
        test VIDIOC_G/S_PARM: OK (Not Supported)
        test VIDIOC_G_FBUF: OK (Not Supported)
        test VIDIOC_G_FMT: OK (Not Supported)
        test VIDIOC_TRY_FMT: OK (Not Supported)
        test VIDIOC_S_FMT: OK (Not Supported)
        test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
        test Cropping: OK (Not Supported)
        test Composing: OK (Not Supported)
        test Scaling: OK (Not Supported)

Codec ioctls:
        test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
        test VIDIOC_G_ENC_INDEX: OK (Not Supported)
        test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
        test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------
Compliance test for device /dev/v4l-subdev1:

Media Driver Info:
        Driver name      : imx7-csi
        Model            : imx-media
        Serial           : 
        Bus info         : 
        Media version    : 4.20.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.20.0
Interface Info:
        ID               : 0x0300001b
        Type             : V4L Sub-Device
Entity Info:
        ID               : 0x0000000a (10)
        Name             : csi_mux
        Function         : Video Muxer
        Pad 0x0100000b   : 0: Sink
        Pad 0x0100000c   : 1: Sink
          Link 0x02000013: from remote pad 0x1000010 of entity 'imx7-mipi-csis.0': Data, Enabled
        Pad 0x0100000d   : 2: Source
          Link 0x02000015: to remote pad 0x1000002 of entity 'csi': Data, Enabled

Required ioctls:
        test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
        test second /dev/v4l-subdev1 open: OK
        test for unlimited opens: OK

Debug ioctls:
        test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
        test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 0 Audio Inputs: 0 Tuners: 0

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

Sub-Device ioctls (Sink Pad 0):
        test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
        test Try VIDIOC_SUBDEV_G/S_FMT: OK
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
        test Active VIDIOC_SUBDEV_G/S_FMT: OK
        test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Sink Pad 1):
        test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
        test Try VIDIOC_SUBDEV_G/S_FMT: OK
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
        test Active VIDIOC_SUBDEV_G/S_FMT: OK
        test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 2):
        test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
                fail: ../../../../../../../../../../v4l-utils/utils/v4l2-compliance/v4l2-test-subdevs.cpp(370): s_fmt.format.width != fmt.format.width
        test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
        test Active VIDIOC_SUBDEV_G/S_FMT: OK
        test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Control ioctls:
        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
        test VIDIOC_QUERYCTRL: OK (Not Supported)
        test VIDIOC_G/S_CTRL: OK (Not Supported)
        test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
        Standard Controls: 0 Private Controls: 0

Format ioctls:
        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
        test VIDIOC_G/S_PARM: OK (Not Supported)
        test VIDIOC_G_FBUF: OK (Not Supported)
        test VIDIOC_G_FMT: OK (Not Supported)
        test VIDIOC_TRY_FMT: OK (Not Supported)
        test VIDIOC_S_FMT: OK (Not Supported)
        test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
        test Cropping: OK (Not Supported)
        test Composing: OK (Not Supported)
        test Scaling: OK (Not Supported)

Codec ioctls:
        test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
        test VIDIOC_G_ENC_INDEX: OK (Not Supported)
        test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
        test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------
Compliance test for device /dev/v4l-subdev2:

Media Driver Info:
        Driver name      : imx7-csi
        Model            : imx-media
        Serial           : 
        Bus info         : 
        Media version    : 4.20.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.20.0
Interface Info:
        ID               : 0x0300001d
        Type             : V4L Sub-Device
Entity Info:
        ID               : 0x0000000e (14)
        Name             : imx7-mipi-csis.0
        Function         : Video Interface Bridge
        Pad 0x0100000f   : 0: Sink
          Link 0x02000017: from remote pad 0x1000012 of entity 'ov2680 1-0036': Data, Enabled
        Pad 0x01000010   : 1: Source
          Link 0x02000013: to remote pad 0x100000c of entity 'csi_mux': Data, Enabled

Required ioctls:
        test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
        test second /dev/v4l-subdev2 open: OK
        test for unlimited opens: OK

Debug ioctls:
        test VIDIOC_LOG_STATUS: OK

Input ioctls:
        test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 0 Audio Inputs: 0 Tuners: 0

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

Sub-Device ioctls (Sink Pad 0):
        test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
        test Try VIDIOC_SUBDEV_G/S_FMT: OK
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
        test Active VIDIOC_SUBDEV_G/S_FMT: OK
        test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 1):
        test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
        test Try VIDIOC_SUBDEV_G/S_FMT: OK
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
        test Active VIDIOC_SUBDEV_G/S_FMT: OK
        test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Control ioctls:
        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
        test VIDIOC_QUERYCTRL: OK (Not Supported)
        test VIDIOC_G/S_CTRL: OK (Not Supported)
        test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
        Standard Controls: 0 Private Controls: 0

Format ioctls:
        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
        test VIDIOC_G/S_PARM: OK (Not Supported)
        test VIDIOC_G_FBUF: OK (Not Supported)
        test VIDIOC_G_FMT: OK (Not Supported)
        test VIDIOC_TRY_FMT: OK (Not Supported)
        test VIDIOC_S_FMT: OK (Not Supported)
        test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
        test Cropping: OK (Not Supported)
        test Composing: OK (Not Supported)
        test Scaling: OK (Not Supported)

Codec ioctls:
        test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
        test VIDIOC_G_ENC_INDEX: OK (Not Supported)
        test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
        test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------
Compliance test for device /dev/v4l-subdev3:

Media Driver Info:
        Driver name      : imx7-csi
        Model            : imx-media
        Serial           : 
        Bus info         : 
        Media version    : 4.20.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.20.0
Interface Info:
        ID               : 0x0300001f
        Type             : V4L Sub-Device
Entity Info:
        ID               : 0x00000011 (17)
        Name             : ov2680 1-0036
        Function         : Camera Sensor
        Pad 0x01000012   : 0: Source
          Link 0x02000017: to remote pad 0x100000f of entity 'imx7-mipi-csis.0': Data, Enabled

Required ioctls:
        test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
        test second /dev/v4l-subdev3 open: OK
        test for unlimited opens: OK

Debug ioctls:
        test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
        test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 0 Audio Inputs: 0 Tuners: 0

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

Sub-Device ioctls (Source Pad 0):
                fail: ../../../../../../../../../../v4l-utils/utils/v4l2-compliance/v4l2-test-subdevs.cpp(57): node->enum_frame_interval_pad >= 0
                fail: ../../../../../../../../../../v4l-utils/utils/v4l2-compliance/v4l2-test-subdevs.cpp(183): ret && ret != ENOTTY
                fail: ../../../../../../../../../../v4l-utils/utils/v4l2-compliance/v4l2-test-subdevs.cpp(248): ret && ret != ENOTTY
        test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
                fail: ../../../../../../../../../../v4l-utils/utils/v4l2-compliance/v4l2-test-subdevs.cpp(311): fmt.width == 0 || fmt.width > 65536
                fail: ../../../../../../../../../../v4l-utils/utils/v4l2-compliance/v4l2-test-subdevs.cpp(356): checkMBusFrameFmt(node, fmt.format)
        test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
        test Active VIDIOC_SUBDEV_G/S_FMT: OK
        test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK

Control ioctls:
        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
        test VIDIOC_QUERYCTRL: OK
        test VIDIOC_G/S_CTRL: OK
        test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                fail: ../../../../../../../../../../v4l-utils/utils/v4l2-compliance/v4l2-test-controls.cpp(816): subscribe event for control 'User Controls'
 failed
        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
        Standard Controls: 10 Private Controls: 0

Format ioctls:
        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
        test VIDIOC_G/S_PARM: OK (Not Supported)
        test VIDIOC_G_FBUF: OK (Not Supported)
        test VIDIOC_G_FMT: OK (Not Supported)
        test VIDIOC_TRY_FMT: OK (Not Supported)
        test VIDIOC_S_FMT: OK (Not Supported)
        test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
        test Cropping: OK (Not Supported)
        test Composing: OK (Not Supported)
        test Scaling: OK (Not Supported)

Codec ioctls:
        test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
        test VIDIOC_G_ENC_INDEX: OK (Not Supported)
        test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
        test VIDIOC_EXPBUF: OK (Not Supported)

Total: 267, Succeeded: 261, Failed: 6, Warnings: 0

Rui Miguel Silva (13):
  media: staging/imx: refactor imx media device probe
  media: staging/imx: rearrange group id to take in account IPU
  media: staging/imx7: add imx7 CSI subdev driver
  media: staging/imx7: add MIPI CSI-2 receiver subdev for i.MX7
  media: dt-bindings: add bindings for i.MX7 media driver
  ARM: dts: imx7s: add mipi phy power domain
  ARM: dts: imx7s: add multiplexer controls
  ARM: dts: imx7: Add video mux, csi and mipi_csi and connections
  ARM: dts: imx7s-warp: add ov2680 sensor node
  media: imx7.rst: add documentation for i.MX7 media driver
  media: staging/imx: add i.MX7 entries to TODO file
  media: video-mux: add bayer formats
  media: MAINTAINERS: add entry for Freescale i.MX7 media driver

 .../devicetree/bindings/media/imx7-csi.txt    |   45 +
 .../bindings/media/imx7-mipi-csi2.txt         |   90 ++
 Documentation/media/v4l-drivers/imx7.rst      |  157 ++
 Documentation/media/v4l-drivers/index.rst     |    1 +
 MAINTAINERS                                   |   11 +
 arch/arm/boot/dts/imx7s-warp.dts              |   95 ++
 arch/arm/boot/dts/imx7s.dtsi                  |   44 +-
 drivers/media/platform/video-mux.c            |   20 +
 drivers/staging/media/imx/Kconfig             |    9 +-
 drivers/staging/media/imx/Makefile            |    4 +
 drivers/staging/media/imx/TODO                |    9 +
 drivers/staging/media/imx/imx-ic-common.c     |    6 +-
 drivers/staging/media/imx/imx-ic-prp.c        |   16 +-
 drivers/staging/media/imx/imx-media-csi.c     |    6 +-
 .../staging/media/imx/imx-media-dev-common.c  |  102 ++
 drivers/staging/media/imx/imx-media-dev.c     |  110 +-
 .../staging/media/imx/imx-media-internal-sd.c |   20 +-
 drivers/staging/media/imx/imx-media-of.c      |    6 +-
 drivers/staging/media/imx/imx-media-utils.c   |   12 +-
 drivers/staging/media/imx/imx-media.h         |   38 +-
 drivers/staging/media/imx/imx7-media-csi.c    | 1354 +++++++++++++++++
 drivers/staging/media/imx/imx7-mipi-csis.c    | 1135 ++++++++++++++
 22 files changed, 3166 insertions(+), 124 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/imx7-csi.txt
 create mode 100644 Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
 create mode 100644 Documentation/media/v4l-drivers/imx7.rst
 create mode 100644 drivers/staging/media/imx/imx-media-dev-common.c
 create mode 100644 drivers/staging/media/imx/imx7-media-csi.c
 create mode 100644 drivers/staging/media/imx/imx7-mipi-csis.c

-- 
2.19.1
