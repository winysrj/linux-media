Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36263 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752825AbeERJ2U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 05:28:20 -0400
Received: by mail-wr0-f193.google.com with SMTP id p4-v6so8478211wrh.3
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 02:28:19 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        linux-clk@vger.kernel.org, Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v5 00/12] media: staging/imx7: add i.MX7 media driver
Date: Fri, 18 May 2018 10:27:54 +0100
Message-Id: <20180518092806.3829-1-rui.silva@linaro.org>
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
take a look at the documentation in PATCH 14.

The system used to test and develop this was the Warp7 board with an OV2680
sensor, which output format is 10-bit bayer. So, only MIPI interface was
tested, a scenario with an parallel input would nice to have.

*Important note*, this code depends on Steve Longerbeam series [0]:
[PATCH v4 00/13] media: imx: Switch to subdev notifiers
which the merging status is not clear to me, but the changes in there make
senses to this series

Bellow goes an example of the output of the pads and links and the output of
v4l2-compliance testing.

The v4l-utils version used is:
v4l2-compliance SHA   : 47d43b130dc6e9e0edc900759fb37649208371e4 from Apr 4th.

The Media Driver fail some tests but this failures are coming from code out of
scope of this series (video-mux, imx-capture), and some from the sensor OV2680
but that I think not related with the sensor driver but with the testing and
core.

The csi and mipi-csi entities pass all compliance tests.

Cheers,
    Rui

[0]: https://www.mail-archive.com/linux-media@vger.kernel.org/msg131186.html

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

 media-ctl -p
Media controller API version 4.17.0

Media device information
------------------------
driver          imx-media
model           imx-media
serial
bus info
hw revision     0x0
driver version  4.17.0

Device topology
- entity 1: csi (2 pads, 2 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev0
        pad0: Sink
                [fmt:SBGGR10_1X10/800x600 field:none]
                <- "csi_mux":2 [ENABLED]
        pad1: Source
                [fmt:SBGGR10_1X10/800x600 field:none]
                -> "csi capture":0 [ENABLED]

- entity 4: csi capture (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
        pad0: Sink
                <- "csi":1 [ENABLED]

- entity 10: csi_mux (3 pads, 2 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev1
        pad0: Sink
                [fmt:unknown/0x0]
        pad1: Sink
                [fmt:SBGGR10_1X10/800x600 field:none]
                <- "imx7-mipi-csis.0":1 [ENABLED]
        pad2: Source
                [fmt:SBGGR10_1X10/800x600 field:none]
                -> "csi":0 [ENABLED]

- entity 14: imx7-mipi-csis.0 (2 pads, 2 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev2
        pad0: Sink
                [fmt:SBGGR10_1X10/800x600 field:none]
                <- "ov2680 1-0036":0 [ENABLED]
        pad1: Source
                [fmt:SBGGR10_1X10/800x600 field:none]
                -> "csi_mux":1 [ENABLED]

- entity 17: ov2680 1-0036 (1 pad, 1 link)
             type V4L2 subdev subtype Sensor flags 0
             device node name /dev/v4l-subdev3
        pad0: Source
                [fmt:SBGGR10_1X10/800x600 field:none]
                -> "imx7-mipi-csis.0":0 [ENABLED]

compliance tests:
v4l2-compliance SHA   : 47d43b130dc6e9e0edc900759fb37649208371e4

Compliance test for device /dev/media0:

Media Driver Info:
        Driver name      : imx-media
        Model            : imx-media
        Serial           :
        Bus info         :
        Media version    : 4.17.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.17.0

Required ioctls:
        test MEDIA_IOC_DEVICE_INFO: OK

Allow for multiple opens:
        test second /dev/media0 open: OK
        test MEDIA_IOC_DEVICE_INFO: OK
        test for unlimited opens: OK

Media Controller ioctls:
                Entity: 0x00000001 (Name: 'csi', Function: 0x00005002)
                Entity: 0x00000004 (Name: 'csi capture', Function: 0x00010001)
                Entity: 0x0000000a (Name: 'csi_mux', Function: 0x00005001)
                Entity: 0x0000000e (Name: 'imx7-mipi-csis.0', Function: 0x00005002)
                Entity: 0x00000011 (Name: 'ov2680 1-0036', Function: 0x00020001)
                Interface: 0x03000005 (Type: 0x00000200)
                Interface: 0x03000019 (Type: 0x00000203)
                Interface: 0x0300001b (Type: 0x00000203)
                Interface: 0x0300001d (Type: 0x00000203)
                Interface: 0x0300001f (Type: 0x00000203)
                Pad: 0x01000002
                Pad: 0x01000003
                Pad: 0x01000007
                Pad: 0x0100000b
                Pad: 0x0100000c
                Pad: 0x0100000d
                Pad: 0x0100000f
                Pad: 0x01000010
                Pad: 0x01000012
                Link: 0x02000006
                Link: 0x02000008
                Link: 0x02000013
                Link: 0x02000015
                Link: 0x02000017
                Link: 0x0200001a
                Link: 0x0200001c
                Link: 0x0200001e
                Link: 0x02000020
        test MEDIA_IOC_G_TOPOLOGY: OK
        Entities: 5 Interfaces: 5 Pads: 9 Links: 9
                Entity: 0x00000001 (Name: 'csi', Type: 0x00020000
                Entity: 0x00000004 (Name: 'csi capture', Type: 0x00010001
                Entity: 0x0000000a (Name: 'csi_mux', Type: 0x00020000
                Entity: 0x0000000e (Name: 'imx7-mipi-csis.0', Type: 0x00020000
                Entity: 0x00000011 (Name: 'ov2680 1-0036', Type: 0x00020001
                Entity Links: 0x00000001 (Name: 'csi')
                Entity Links: 0x00000004 (Name: 'csi capture')
                Entity Links: 0x0000000a (Name: 'csi_mux')
                Entity Links: 0x0000000e (Name: 'imx7-mipi-csis.0')
                Entity Links: 0x00000011 (Name: 'ov2680 1-0036')
        test MEDIA_IOC_ENUM_ENTITIES/LINKS: OK
        test MEDIA_IOC_SETUP_LINK: OK

--------------------------------------------------------------------------------

Compliance test for device /dev/video0:

Driver Info:
        Driver name      : imx-media-captu
        Card type        : imx-media-capture
        Bus info         : platform:csi
        Driver version   : 4.17.0
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
        Driver name      : imx-media
        Model            : imx-media
        Serial           :
        Bus info         :
        Media version    : 4.17.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.17.0
Interface Info:
        ID               : 0x03000005
        Type             : V4L Video
Entity Info:
        ID               : 0x00000004 (4)
        Name             : csi capture
        Function         : V4L2 I/O
        Pad 0x01000007   : Sink
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
                fail: v4l2-test-input-output.cpp(420): G_INPUT not supported for a capture device
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
                info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
                info: checking v4l2_queryctrl of control 'Exposure' (0x00980911)
                info: checking v4l2_queryctrl of control 'Gain, Automatic' (0x00980912)
                info: checking v4l2_queryctrl of control 'Gain' (0x00980913)
                info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
                info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
                info: checking v4l2_queryctrl of control 'Camera Controls' (0x009a0001)
                info: checking v4l2_queryctrl of control 'Auto Exposure' (0x009a0901)
                info: checking v4l2_queryctrl of control 'Image Processing Controls' (0x009f0001)
                info: checking v4l2_queryctrl of control 'Test Pattern' (0x009f0903)
                info: checking v4l2_queryctrl of control 'Exposure' (0x00980911)
                info: checking v4l2_queryctrl of control 'Gain, Automatic' (0x00980912)
                info: checking v4l2_queryctrl of control 'Gain' (0x00980913)
                info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
                info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
        test VIDIOC_QUERYCTRL: OK
                info: checking control 'User Controls' (0x00980001)
                info: checking control 'Exposure' (0x00980911)
                info: checking control 'Gain, Automatic' (0x00980912)
                info: checking control 'Gain' (0x00980913)
                info: checking control 'Horizontal Flip' (0x00980914)
                info: checking control 'Vertical Flip' (0x00980915)
                info: checking control 'Camera Controls' (0x009a0001)
                info: checking control 'Auto Exposure' (0x009a0901)
                info: checking control 'Image Processing Controls' (0x009f0001)
                info: checking control 'Test Pattern' (0x009f0903)
        test VIDIOC_G/S_CTRL: OK
                info: checking extended control 'User Controls' (0x00980001)
                info: checking extended control 'Exposure' (0x00980911)
                info: checking extended control 'Gain, Automatic' (0x00980912)
                info: checking extended control 'Gain' (0x00980913)
                info: checking extended control 'Horizontal Flip' (0x00980914)
                info: checking extended control 'Vertical Flip' (0x00980915)
                info: checking extended control 'Camera Controls' (0x009a0001)
                info: checking extended control 'Auto Exposure' (0x009a0901)
                info: checking extended control 'Image Processing Controls' (0x009f0001)
                info: checking extended control 'Test Pattern' (0x009f0903)
        test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                info: checking control event 'User Controls' (0x00980001)
                fail: v4l2-test-controls.cpp(796): subscribe event for control 'User Controls' failed
        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
        Standard Controls: 10 Private Controls: 0

Format ioctls:
                info: found 1 formats for buftype 1
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
                info: test buftype Video Capture
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
        test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev0:

Media Driver Info:
        Driver name      : imx-media
        Model            : imx-media
        Serial           :
        Bus info         :
        Media version    : 4.17.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.17.0
Interface Info:
        ID               : 0x03000019
        Type             : V4L Sub-Device
Entity Info:
        ID               : 0x00000001 (1)
        Name             : csi
        Function         : Video Interface Bridge
        Pad 0x01000002   : Sink
          Link 0x02000015: from remote pad 0x100000d of entity 'csi_mux': Data, Enabled
        Pad 0x01000003   : Source
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
        Driver name      : imx-media
        Model            : imx-media
        Serial           :
        Bus info         :
        Media version    : 4.17.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.17.0
Interface Info:
        ID               : 0x0300001b
        Type             : V4L Sub-Device
Entity Info:
        ID               : 0x0000000a (10)
        Name             : csi_mux
        Function         : Video Muxer
        Pad 0x0100000b   : Sink
        Pad 0x0100000c   : Sink
          Link 0x02000013: from remote pad 0x1000010 of entity 'imx7-mipi-csis.0': Data, Enabled
        Pad 0x0100000d   : Source
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
                fail: v4l2-test-subdevs.cpp(311): fmt.width == 0 || fmt.width == ~0U
                fail: v4l2-test-subdevs.cpp(356): checkMBusFrameFmt(node, fmt.format)
        test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
                fail: v4l2-test-subdevs.cpp(311): fmt.width == 0 || fmt.width == ~0U
                fail: v4l2-test-subdevs.cpp(356): checkMBusFrameFmt(node, fmt.format)
        test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
        test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Sink Pad 1):
        test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
                fail: v4l2-test-subdevs.cpp(311): fmt.width == 0 || fmt.width == ~0U
                fail: v4l2-test-subdevs.cpp(356): checkMBusFrameFmt(node, fmt.format)
        test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
                fail: v4l2-test-subdevs.cpp(381): s_fmt.format.code == ~0U
        test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
        test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 2):
        test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
                fail: v4l2-test-subdevs.cpp(311): fmt.width == 0 || fmt.width == ~0U
                fail: v4l2-test-subdevs.cpp(356): checkMBusFrameFmt(node, fmt.format)
        test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
                fail: v4l2-test-subdevs.cpp(313): fmt.code == 0 || fmt.code == ~0U
                fail: v4l2-test-subdevs.cpp(369): checkMBusFrameFmt(node, s_fmt.format)
        test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
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
        Driver name      : imx-media
        Model            : imx-media
        Serial           :
        Bus info         :
        Media version    : 4.17.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.17.0
Interface Info:
        ID               : 0x0300001d
        Type             : V4L Sub-Device
Entity Info:
        ID               : 0x0000000e (14)
        Name             : imx7-mipi-csis.0
        Function         : Video Interface Bridge
        Pad 0x0100000f   : Sink
          Link 0x02000017: from remote pad 0x1000012 of entity 'ov2680 1-0036': Data, Enabled
        Pad 0x01000010   : Source
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
        Driver name      : imx-media
        Model            : imx-media
        Serial           :
        Bus info         :
        Media version    : 4.17.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.17.0
Interface Info:
        ID               : 0x0300001f
        Type             : V4L Sub-Device
Entity Info:
        ID               : 0x00000011 (17)
        Name             : ov2680 1-0036
        Function         : Camera Sensor
        Pad 0x01000012   : Source
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
                fail: v4l2-test-subdevs.cpp(57): node->enum_frame_interval_pad >= 0
                fail: v4l2-test-subdevs.cpp(183): ret && ret != ENOTTY
                fail: v4l2-test-subdevs.cpp(248): ret && ret != ENOTTY
        test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
        test Try VIDIOC_SUBDEV_G/S_FMT: OK
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
        test Active VIDIOC_SUBDEV_G/S_FMT: OK
        test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK

Control ioctls:
                info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
                info: checking v4l2_queryctrl of control 'Exposure' (0x00980911)
                info: checking v4l2_queryctrl of control 'Gain, Automatic' (0x00980912)
                info: checking v4l2_queryctrl of control 'Gain' (0x00980913)
                info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
                info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
                info: checking v4l2_queryctrl of control 'Camera Controls' (0x009a0001)
                info: checking v4l2_queryctrl of control 'Auto Exposure' (0x009a0901)
                info: checking v4l2_queryctrl of control 'Image Processing Controls' (0x009f0001)
                info: checking v4l2_queryctrl of control 'Test Pattern' (0x009f0903)
                info: checking v4l2_queryctrl of control 'Exposure' (0x00980911)
                info: checking v4l2_queryctrl of control 'Gain, Automatic' (0x00980912)
                info: checking v4l2_queryctrl of control 'Gain' (0x00980913)
                info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
                info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
        test VIDIOC_QUERYCTRL: OK
                info: checking control 'User Controls' (0x00980001)
                info: checking control 'Exposure' (0x00980911)
                info: checking control 'Gain, Automatic' (0x00980912)
                info: checking control 'Gain' (0x00980913)
                info: checking control 'Horizontal Flip' (0x00980914)
                info: checking control 'Vertical Flip' (0x00980915)
                info: checking control 'Camera Controls' (0x009a0001)
                info: checking control 'Auto Exposure' (0x009a0901)
                info: checking control 'Image Processing Controls' (0x009f0001)
                info: checking control 'Test Pattern' (0x009f0903)
        test VIDIOC_G/S_CTRL: OK
                info: checking extended control 'User Controls' (0x00980001)
                info: checking extended control 'Exposure' (0x00980911)
                info: checking extended control 'Gain, Automatic' (0x00980912)
                info: checking extended control 'Gain' (0x00980913)
                info: checking extended control 'Horizontal Flip' (0x00980914)
                info: checking extended control 'Vertical Flip' (0x00980915)
                info: checking extended control 'Camera Controls' (0x009a0001)
                info: checking extended control 'Auto Exposure' (0x009a0901)
                info: checking extended control 'Image Processing Controls' (0x009f0001)
                info: checking extended control 'Test Pattern' (0x009f0903)
        test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                info: checking control event 'User Controls' (0x00980001)
                fail: v4l2-test-controls.cpp(796): subscribe event for control 'User Controls' failed
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

Total: 267, Succeeded: 257, Failed: 10, Warnings: 0



Rui Miguel Silva (12):
  media: staging/imx: refactor imx media device probe
  media: staging/imx7: add imx7 CSI subdev driver
  clk: imx7d: fix mipi dphy div parent
  clk: imx7d: reset parent for mipi csi root
  media: staging/imx7: add MIPI CSI-2 receiver subdev for i.MX7
  media: dt-bindings: add bindings for i.MX7 media driver
  ARM: dts: imx7s: add mipi phy power domain
  ARM: dts: imx7s: add multiplexer controls
  ARM: dts: imx7: Add video mux, csi and mipi_csi and connections
  ARM: dts: imx7s-warp: add ov2680 sensor node
  media: imx7.rst: add documentation for i.MX7 media driver
  media: staging/imx: add i.MX7 entries to TODO file

 .../devicetree/bindings/media/imx7.txt        |  125 ++
 Documentation/media/v4l-drivers/imx7.rst      |  157 ++
 Documentation/media/v4l-drivers/index.rst     |    1 +
 arch/arm/boot/dts/imx7s-warp.dts              |   95 ++
 arch/arm/boot/dts/imx7s.dtsi                  |   42 +-
 drivers/clk/imx/clk-imx7d.c                   |    4 +-
 drivers/staging/media/imx/Kconfig             |    9 +-
 drivers/staging/media/imx/Makefile            |    4 +
 drivers/staging/media/imx/TODO                |    9 +
 .../staging/media/imx/imx-media-dev-common.c  |  102 ++
 drivers/staging/media/imx/imx-media-dev.c     |   89 +-
 .../staging/media/imx/imx-media-internal-sd.c |    3 +
 drivers/staging/media/imx/imx-media-of.c      |    6 +-
 drivers/staging/media/imx/imx-media.h         |   18 +
 drivers/staging/media/imx/imx7-media-csi.c    | 1352 +++++++++++++++++
 drivers/staging/media/imx/imx7-mipi-csis.c    | 1154 ++++++++++++++
 16 files changed, 3098 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/imx7.txt
 create mode 100644 Documentation/media/v4l-drivers/imx7.rst
 create mode 100644 drivers/staging/media/imx/imx-media-dev-common.c
 create mode 100644 drivers/staging/media/imx/imx7-media-csi.c
 create mode 100644 drivers/staging/media/imx/imx7-mipi-csis.c

-- 
2.17.0
