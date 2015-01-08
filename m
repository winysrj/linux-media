Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:49714 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847AbbAHQxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jan 2015 11:53:38 -0500
Received: by mail-ob0-f172.google.com with SMTP id va8so9053500obc.3
        for <linux-media@vger.kernel.org>; Thu, 08 Jan 2015 08:53:37 -0800 (PST)
MIME-Version: 1.0
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Thu, 8 Jan 2015 17:53:22 +0100
Message-ID: <CAL8zT=hPSYBcUGZbpaqidcWvHk9TB5u30XeXjVsp_b_puB0KYg@mail.gmail.com>
Subject: HDMI input on i.MX6 using IPU
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Jean-Michel Hautbois <jhautbois@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have modified both Steve's and Philipp's code, in order to get
something able to get frames from an ADV7611.
Right now, I am back to Philipp's base of code, rebased on top of
media-tree, and everything works fine, except the very last link
between SFMC and IDMAC (using media controller).
Here is a status.

The code is here :
https://github.com/Vodalys/linux-2.6-imx/tree/media-tree-zabel

I am using a DT with this simple connection between adv7611 and IPU :
&ipu1_csi0 {
    csi0_from_hdmi: endpoint {
        remote-endpoint = <&hdmi0_out>;
    };
};

hdmiin1: adv7611@4c {
    compatible = "adi,adv7611";
    pinctrl-names = "default";
    pinctrl-0 = <&pinctrl_csi0>;
    reset-gpios = <&gpio1 20 GPIO_ACTIVE_LOW>;
    reg = <0x4c 0x68 0x66 0x64 0x62
        0x60 0x5e 0x5c 0x5a 0x58 0x56
        0x54 0x52>;
    reg-names = "main", "avlink", "cec", "infoframe", "esdp",
        "dpp", "afe", "rep", "edid", "hdmi", "test",
        "cp", "vdp";
    ports {
        #address-cells = <1>;
        #size-cells = <0>;
        port@0 {
            reg = <0>;
        };
        port@1 {
            reg = <1>;
            hdmi0_out: endpoint@1 {
                remote-endpoint = <&csi0_from_hdmi>;
                bus-width = <16>;
            };
        };
    };
};

It seems to be pretty good, I can configure mbus format, etc.
$> media-ctl -v --set-v4l2 '"adv7611 1-004c":1 [fmt: YUYV/1280x720]
Opening media device /dev/media0
Enumerating entities
Found 33 entities
Enumerating pads and links
Setting up format YUYV 1280x720 on pad adv7611 1-004c/1
Format set: YUYV 1280x720
Setting up format YUYV 1280x720 on pad /soc/ipu@02400000/port@0/0
Format set: YUYV 1280x720

Here is the complete topology right now.
Device topology
- entity 1: /soc/ipu@02400000/port@0 (5 pads, 10 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev0
    pad0: Sink
        [fmt:YUYV/1280x720]
        <- "adv7611 1-004c":1 [ENABLED,IMMUTABLE]
    pad1: Source
        [fmt:unknown/0x0]
        -> "IPU0 SMFC0":0 [ENABLED]
        -> "IPU0 SMFC1":0 []
        -> "IPU0 SMFC2":0 []
        -> "IPU0 SMFC3":0 []
        -> "IPU0 IC PRP":0 []
        -> "IPU0 VDIC":0 []
    pad2: Source
        [fmt:unknown/0x0]
        -> "IPU0 SMFC0":0 []
    pad3: Source
        [fmt:unknown/0x0]
        -> "IPU0 SMFC0":0 []
    pad4: Source
        [fmt:unknown/0x0]
        -> "IPU0 SMFC0":0 []

- entity 2: imx-ipuv3-camera.2 (1 pad, 9 links)
            type Node subtype V4L flags 0
            device node name /dev/video0
    pad0: Sink
        <- "IPU0 SMFC0":1 []
        <- "IPU0 SMFC1":1 []
        <- "IPU0 SMFC2":1 []
        <- "IPU0 SMFC3":1 []
        <- "IPU0 IC PRP":1 []
        <- "IPU0 IC PRP ENC":1 []
        <- "IPU0 IC PRP VF":1 []
        <- "IPU0 IRT ENC":1 []
        <- "IPU0 IRT VF":1 []

- entity 3: /soc/ipu@02400000/port@1 (5 pads, 9 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev1
    pad0: Sink
        [fmt:unknown/0x0]
    pad1: Source
        [fmt:unknown/0x0]
        -> "IPU0 SMFC0":0 []
        -> "IPU0 SMFC1":0 []
        -> "IPU0 SMFC2":0 [ENABLED]
        -> "IPU0 SMFC3":0 []
        -> "IPU0 IC PRP":0 []
        -> "IPU0 VDIC":0 []
    pad2: Source
        [fmt:unknown/0x0]
        -> "IPU0 SMFC0":0 []
    pad3: Source
        [fmt:unknown/0x0]
        -> "IPU0 SMFC0":0 []
    pad4: Source
        [fmt:unknown/0x0]
        -> "IPU0 SMFC0":0 []

- entity 4: imx-ipuv3-camera.3 (1 pad, 9 links)
            type Node subtype V4L flags 0
            device node name /dev/video1
    pad0: Sink
        <- "IPU0 SMFC0":1 []
        <- "IPU0 SMFC1":1 []
        <- "IPU0 SMFC2":1 []
        <- "IPU0 SMFC3":1 []
        <- "IPU0 IC PRP":1 []
        <- "IPU0 IC PRP ENC":1 []
        <- "IPU0 IC PRP VF":1 []
        <- "IPU0 IRT ENC":1 []
        <- "IPU0 IRT VF":1 []

- entity 5: IPU0 SMFC0 (2 pads, 15 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev2
    pad0: Sink
        <- "/soc/ipu@02400000/port@0":1 [ENABLED]
        <- "/soc/ipu@02400000/port@0":2 []
        <- "/soc/ipu@02400000/port@0":3 []
        <- "/soc/ipu@02400000/port@0":4 []
        <- "/soc/ipu@02400000/port@1":1 []
        <- "/soc/ipu@02400000/port@1":2 []
        <- "/soc/ipu@02400000/port@1":3 []
        <- "/soc/ipu@02400000/port@1":4 []
    pad1: Source
        -> "IPU0 IC PRP":0 []
        -> "IPU0 IC PP":0 []
        -> "IPU0 IRT ENC":0 []
        -> "IPU0 IRT VF":0 []
        -> "IPU0 IRT PP":0 []
        -> "imx-ipuv3-camera.3":0 []
        -> "imx-ipuv3-camera.2":0 []

- entity 6: IPU0 SMFC1 (2 pads, 6 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev3
    pad0: Sink
        <- "/soc/ipu@02400000/port@0":1 []
        <- "/soc/ipu@02400000/port@1":1 []
    pad1: Source
        -> "IPU0 IRT ENC":0 []
        -> "IPU0 IRT VF":0 []
        -> "imx-ipuv3-camera.3":0 []
        -> "imx-ipuv3-camera.2":0 []

- entity 7: IPU0 SMFC2 (2 pads, 9 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev4
    pad0: Sink
        <- "/soc/ipu@02400000/port@0":1 []
        <- "/soc/ipu@02400000/port@1":1 [ENABLED]
    pad1: Source
        -> "IPU0 IC PRP":0 []
        -> "IPU0 IC PP":0 []
        -> "IPU0 IRT ENC":0 []
        -> "IPU0 IRT VF":0 []
        -> "IPU0 IRT PP":0 []
        -> "imx-ipuv3-camera.3":0 []
        -> "imx-ipuv3-camera.2":0 []

- entity 8: IPU0 SMFC3 (2 pads, 6 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev5
    pad0: Sink
        <- "/soc/ipu@02400000/port@0":1 []
        <- "/soc/ipu@02400000/port@1":1 []
    pad1: Source
        -> "IPU0 IRT ENC":0 []
        -> "IPU0 IRT VF":0 []
        -> "imx-ipuv3-camera.3":0 []
        -> "imx-ipuv3-camera.2":0 []

- entity 9: IPU0 IC PRP (2 pads, 14 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev6
    pad0: Sink
        <- "/soc/ipu@02400000/port@0":1 []
        <- "/soc/ipu@02400000/port@1":1 []
        <- "IPU0 SMFC0":1 []
        <- "IPU0 SMFC2":1 []
        -> "IPU0 IRT ENC":0 []
        -> "IPU0 IRT ENC":0 []
        -> "IPU0 IRT VF":0 []
        -> "IPU0 IRT VF":0 []
        <- "IPU0 IRT ENC":1 []
        <- "IPU0 IRT VF":1 []
    pad1: Source
        -> "IPU0 IC PRP ENC":0 []
        -> "IPU0 IC PRP VF":0 []
        -> "imx-ipuv3-camera.3":0 []
        -> "imx-ipuv3-camera.2":0 []

- entity 10: IPU0 IC PRP ENC (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev7
    pad0: Sink
        <- "IPU0 IC PRP":1 []
    pad1: Source
        -> "IPU0 IRT ENC":0 []
        -> "imx-ipuv3-camera.3":0 []
        -> "imx-ipuv3-camera.2":0 []

- entity 11: IPU0 IC PRP VF (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev8
    pad0: Sink
        <- "IPU0 IC PRP":1 []
    pad1: Source
        -> "IPU0 IRT VF":0 []
        -> "imx-ipuv3-camera.3":0 []
        -> "imx-ipuv3-camera.2":0 []

- entity 12: IPU0 IC PP (2 pads, 6 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev9
    pad0: Sink
        <- "IPU0 SMFC0":1 []
        <- "IPU0 SMFC2":1 []
        <- "IPU0 IRT PP":1 []
    pad1: Source
        -> "IPU0 IRT PP":0 []
        -> "IPU0 VDIC":1 []
        -> "IPU0 VDIC":2 []

- entity 13: IPU0 IRT ENC (2 pads, 10 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev10
    pad0: Sink
        <- "IPU0 SMFC0":1 []
        <- "IPU0 SMFC1":1 []
        <- "IPU0 SMFC2":1 []
        <- "IPU0 SMFC3":1 []
        <- "IPU0 IC PRP":0 []
        <- "IPU0 IC PRP":0 []
        <- "IPU0 IC PRP ENC":1 []
    pad1: Source
        -> "IPU0 IC PRP":0 []
        -> "imx-ipuv3-camera.3":0 []
        -> "imx-ipuv3-camera.2":0 []

- entity 14: IPU0 IRT VF (2 pads, 12 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev11
    pad0: Sink
        <- "IPU0 SMFC0":1 []
        <- "IPU0 SMFC1":1 []
        <- "IPU0 SMFC2":1 []
        <- "IPU0 SMFC3":1 []
        <- "IPU0 IC PRP":0 []
        <- "IPU0 IC PRP":0 []
        <- "IPU0 IC PRP VF":1 []
    pad1: Source
        -> "IPU0 IC PRP":0 []
        -> "IPU0 VDIC":1 []
        -> "IPU0 VDIC":2 []
        -> "imx-ipuv3-camera.3":0 []
        -> "imx-ipuv3-camera.2":0 []

- entity 15: IPU0 IRT PP (2 pads, 6 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev12
    pad0: Sink
        <- "IPU0 SMFC0":1 []
        <- "IPU0 SMFC2":1 []
        <- "IPU0 IC PP":1 []
    pad1: Source
        -> "IPU0 IC PP":0 []
        -> "IPU0 VDIC":1 []
        -> "IPU0 VDIC":2 []

- entity 16: IPU0 VDIC (4 pads, 8 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev13
    pad0: Sink
        <- "/soc/ipu@02400000/port@0":1 []
        <- "/soc/ipu@02400000/port@1":1 []
    pad1: Sink
        <- "IPU0 IC PP":1 []
        <- "IPU0 IRT VF":1 []
        <- "IPU0 IRT PP":1 []
    pad2: Sink
        <- "IPU0 IC PP":1 []
        <- "IPU0 IRT VF":1 []
        <- "IPU0 IRT PP":1 []
    pad3: Source

- entity 17: /soc/ipu@02800000/port@0 (5 pads, 9 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev14
    pad0: Sink
        [fmt:unknown/0x0]
    pad1: Source
        [fmt:unknown/0x0]
        -> "IPU1 SMFC0":0 [ENABLED]
        -> "IPU1 SMFC1":0 []
        -> "IPU1 SMFC2":0 []
        -> "IPU1 SMFC3":0 []
        -> "IPU1 IC PRP":0 []
        -> "IPU1 VDIC":0 []
    pad2: Source
        [fmt:unknown/0x0]
        -> "IPU1 SMFC0":0 []
    pad3: Source
        [fmt:unknown/0x0]
        -> "IPU1 SMFC0":0 []
    pad4: Source
        [fmt:unknown/0x0]
        -> "IPU1 SMFC0":0 []

- entity 18: imx-ipuv3-camera.6 (1 pad, 9 links)
             type Node subtype V4L flags 0
             device node name /dev/video2
    pad0: Sink
        <- "IPU1 SMFC0":1 []
        <- "IPU1 SMFC1":1 []
        <- "IPU1 SMFC2":1 []
        <- "IPU1 SMFC3":1 []
        <- "IPU1 IC PRP":1 []
        <- "IPU1 IC PRP ENC":1 []
        <- "IPU1 IC PRP VF":1 []
        <- "IPU1 IRT ENC":1 []
        <- "IPU1 IRT VF":1 []

- entity 19: /soc/ipu@02800000/port@1 (5 pads, 9 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev15
    pad0: Sink
        [fmt:unknown/0x0]
    pad1: Source
        [fmt:unknown/0x0]
        -> "IPU1 SMFC0":0 []
        -> "IPU1 SMFC1":0 []
        -> "IPU1 SMFC2":0 [ENABLED]
        -> "IPU1 SMFC3":0 []
        -> "IPU1 IC PRP":0 []
        -> "IPU1 VDIC":0 []
    pad2: Source
        [fmt:unknown/0x0]
        -> "IPU1 SMFC0":0 []
    pad3: Source
        [fmt:unknown/0x0]
        -> "IPU1 SMFC0":0 []
    pad4: Source
        [fmt:unknown/0x0]
        -> "IPU1 SMFC0":0 []

- entity 20: imx-ipuv3-camera.7 (1 pad, 9 links)
             type Node subtype V4L flags 0
             device node name /dev/video3
    pad0: Sink
        <- "IPU1 SMFC0":1 []
        <- "IPU1 SMFC1":1 []
        <- "IPU1 SMFC2":1 []
        <- "IPU1 SMFC3":1 []
        <- "IPU1 IC PRP":1 []
        <- "IPU1 IC PRP ENC":1 []
        <- "IPU1 IC PRP VF":1 []
        <- "IPU1 IRT ENC":1 []
        <- "IPU1 IRT VF":1 []

- entity 21: IPU1 SMFC0 (2 pads, 15 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev16
    pad0: Sink
        <- "/soc/ipu@02800000/port@0":1 [ENABLED]
        <- "/soc/ipu@02800000/port@0":2 []
        <- "/soc/ipu@02800000/port@0":3 []
        <- "/soc/ipu@02800000/port@0":4 []
        <- "/soc/ipu@02800000/port@1":1 []
        <- "/soc/ipu@02800000/port@1":2 []
        <- "/soc/ipu@02800000/port@1":3 []
        <- "/soc/ipu@02800000/port@1":4 []
    pad1: Source
        -> "IPU1 IC PRP":0 []
        -> "IPU1 IC PP":0 []
        -> "IPU1 IRT ENC":0 []
        -> "IPU1 IRT VF":0 []
        -> "IPU1 IRT PP":0 []
        -> "imx-ipuv3-camera.6":0 []
        -> "imx-ipuv3-camera.7":0 []

- entity 22: IPU1 SMFC1 (2 pads, 6 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev17
    pad0: Sink
        <- "/soc/ipu@02800000/port@0":1 []
        <- "/soc/ipu@02800000/port@1":1 []
    pad1: Source
        -> "IPU1 IRT ENC":0 []
        -> "IPU1 IRT VF":0 []
        -> "imx-ipuv3-camera.6":0 []
        -> "imx-ipuv3-camera.7":0 []

- entity 23: IPU1 SMFC2 (2 pads, 9 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev18
    pad0: Sink
        <- "/soc/ipu@02800000/port@0":1 []
        <- "/soc/ipu@02800000/port@1":1 [ENABLED]
    pad1: Source
        -> "IPU1 IC PRP":0 []
        -> "IPU1 IC PP":0 []
        -> "IPU1 IRT ENC":0 []
        -> "IPU1 IRT VF":0 []
        -> "IPU1 IRT PP":0 []
        -> "imx-ipuv3-camera.6":0 []
        -> "imx-ipuv3-camera.7":0 []

- entity 24: IPU1 SMFC3 (2 pads, 6 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev19
    pad0: Sink
        <- "/soc/ipu@02800000/port@0":1 []
        <- "/soc/ipu@02800000/port@1":1 []
    pad1: Source
        -> "IPU1 IRT ENC":0 []
        -> "IPU1 IRT VF":0 []
        -> "imx-ipuv3-camera.6":0 []
        -> "imx-ipuv3-camera.7":0 []

- entity 25: IPU1 IC PRP (2 pads, 14 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev20
    pad0: Sink
        <- "/soc/ipu@02800000/port@0":1 []
        <- "/soc/ipu@02800000/port@1":1 []
        <- "IPU1 SMFC0":1 []
        <- "IPU1 SMFC2":1 []
        -> "IPU1 IRT ENC":0 []
        -> "IPU1 IRT ENC":0 []
        -> "IPU1 IRT VF":0 []
        -> "IPU1 IRT VF":0 []
        <- "IPU1 IRT ENC":1 []
        <- "IPU1 IRT VF":1 []
    pad1: Source
        -> "IPU1 IC PRP ENC":0 []
        -> "IPU1 IC PRP VF":0 []
        -> "imx-ipuv3-camera.6":0 []
        -> "imx-ipuv3-camera.7":0 []

- entity 26: IPU1 IC PRP ENC (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev21
    pad0: Sink
        <- "IPU1 IC PRP":1 []
    pad1: Source
        -> "IPU1 IRT ENC":0 []
        -> "imx-ipuv3-camera.6":0 []
        -> "imx-ipuv3-camera.7":0 []

- entity 27: IPU1 IC PRP VF (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev22
    pad0: Sink
        <- "IPU1 IC PRP":1 []
    pad1: Source
        -> "IPU1 IRT VF":0 []
        -> "imx-ipuv3-camera.6":0 []
        -> "imx-ipuv3-camera.7":0 []

- entity 28: IPU1 IC PP (2 pads, 6 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev23
    pad0: Sink
        <- "IPU1 SMFC0":1 []
        <- "IPU1 SMFC2":1 []
        <- "IPU1 IRT PP":1 []
    pad1: Source
        -> "IPU1 IRT PP":0 []
        -> "IPU1 VDIC":1 []
        -> "IPU1 VDIC":2 []

- entity 29: IPU1 IRT ENC (2 pads, 10 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev24
    pad0: Sink
        <- "IPU1 SMFC0":1 []
        <- "IPU1 SMFC1":1 []
        <- "IPU1 SMFC2":1 []
        <- "IPU1 SMFC3":1 []
        <- "IPU1 IC PRP":0 []
        <- "IPU1 IC PRP":0 []
        <- "IPU1 IC PRP ENC":1 []
    pad1: Source
        -> "IPU1 IC PRP":0 []
        -> "imx-ipuv3-camera.6":0 []
        -> "imx-ipuv3-camera.7":0 []

- entity 30: IPU1 IRT VF (2 pads, 12 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev25
    pad0: Sink
        <- "IPU1 SMFC0":1 []
        <- "IPU1 SMFC1":1 []
        <- "IPU1 SMFC2":1 []
        <- "IPU1 SMFC3":1 []
        <- "IPU1 IC PRP":0 []
        <- "IPU1 IC PRP":0 []
        <- "IPU1 IC PRP VF":1 []
    pad1: Source
        -> "IPU1 IC PRP":0 []
        -> "IPU1 VDIC":1 []
        -> "IPU1 VDIC":2 []
        -> "imx-ipuv3-camera.6":0 []
        -> "imx-ipuv3-camera.7":0 []

- entity 31: IPU1 IRT PP (2 pads, 6 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev26
    pad0: Sink
        <- "IPU1 SMFC0":1 []
        <- "IPU1 SMFC2":1 []
        <- "IPU1 IC PP":1 []
    pad1: Source
        -> "IPU1 IC PP":0 []
        -> "IPU1 VDIC":1 []
        -> "IPU1 VDIC":2 []

- entity 32: IPU1 VDIC (4 pads, 8 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev27
    pad0: Sink
        <- "/soc/ipu@02800000/port@0":1 []
        <- "/soc/ipu@02800000/port@1":1 []
    pad1: Sink
        <- "IPU1 IC PP":1 []
        <- "IPU1 IRT VF":1 []
        <- "IPU1 IRT PP":1 []
    pad2: Sink
        <- "IPU1 IC PP":1 []
        <- "IPU1 IRT VF":1 []
        <- "IPU1 IRT PP":1 []
    pad3: Source

- entity 33: adv7611 1-004c (2 pads, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev28
    pad0: Sink
        [dv.caps:BT.656/1120 min:0x0@25000000 max:1920x1200@225000000
stds:CEA-861,DMT,CVT,GTF caps:progressive,reduced-blanking,custom]
    pad1: Source
        [fmt:YUYV/1280x720]
        [dv.caps:BT.656/1120 min:0x0@25000000 max:1920x1200@225000000
stds:CEA-861,DMT,CVT,GTF caps:progressive,reduced-blanking,custom]
        [dv.detect:BT.656/1120 1280x720p50 (1980x750) stds:CEA-861 flags:]
        [dv.current:BT.656/1120 1280x720p50 (1980x750) stds:CEA-861 flags:]
        -> "/soc/ipu@02400000/port@0":0 [ENABLED,IMMUTABLE]

Now, I want to get the stream from /dev/video0 so, entity is imx-ipuv3-camera.2.
If I do this (according to topology it seems ok) :
$> media-ctl -v -l '"IPU0 SMFC0":1->"imx-ipuv3-camera.2":0[1]'
Opening media device /dev/media0
Enumerating entities
Found 33 entities
Enumerating pads and links
Setting up link 5:1 -> 2:0 [1]
Opening media device /dev/media0
media_setup_link: Unable to setup link (Invalid argument)

 "IPU0 SMFC0":1->"imx-ipuv3-camera.2":0[1]
                                         ^
Unable to parse link: Invalid argument (22)

I added a lot of printk() and I can get to :
[  208.010610] [ipu_find_link] find link IPU0 SMFC0(2):1 ->
imx-ipuv3-camera.2(234):0 in ipu_links
[  208.019372] [ipu_smfc_link_setup] link not found

This means that in ipu_find_link, imx-ipuv3-camera.2 is not found. The
234 is 256-22 as ipu_find_link returns -22 in a u8.
The code which breaks is here :
https://github.com/Vodalys/linux-2.6-imx/blob/media-tree-zabel/drivers/gpu/ipu-v3/ipu-media.c#L347

I can understand why the entity is not found, it does not existe as
such in the ipu_links array.
I think the issue is at the create of the imx-ipuv3-csi device but not
sure at all, and I would really appreciate some help in debugging
this.
I can see a FIXME in the code, but don't know if this is related, nor
how to solve it :
https://github.com/Vodalys/linux-2.6-imx/blob/media-tree-zabel/drivers/media/platform/imx/imx-ipuv3-csi.c#L1196

I think that when this final link will be ok, I will be able start
streaming some frames from adv7611, and this driver will be pretty
nice to be reviewed.

Thanks in advance,
JM
