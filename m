Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:34300 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755527AbeEaQKr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 12:10:47 -0400
Received: by mail-qt0-f196.google.com with SMTP id m5-v6so28525681qti.1
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 09:10:47 -0700 (PDT)
Message-ID: <4b9c4b84704ba4d1a89bd0408e76e68e5554d078.camel@ndufresne.ca>
Subject: Re: i.MX6 MIPI-CSI2 OV5640 Camera testing on Mainline Linux
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Jagan Teki <jagan@amarulasolutions.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Fabio Estevam <fabio.estevam@nxp.com>
Cc: Discussion of the development of and with GStreamer
        <gstreamer-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 31 May 2018 12:10:44 -0400
In-Reply-To: <CAMty3ZAMjCKv1BtLnobRZUzp=9Xu1gY5+R3Zi-JuobAJZQrXxg@mail.gmail.com>
References: <CAMty3ZAMjCKv1BtLnobRZUzp=9Xu1gY5+R3Zi-JuobAJZQrXxg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-Xi1Y/qtByxPXA39Kk8s5"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-Xi1Y/qtByxPXA39Kk8s5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 31 mai 2018 =C3=A0 20:39 +0530, Jagan Teki a =C3=A9crit :
> Hi All,
>=20
> I'm trying to verify MIPI-CSI2 OV5640 camera on i.MX6 platform with
> Mainline Linux.
>=20
> I've followed these[1] instructions to configure MC links and pads
> based on the probing details from dmesg and trying to capture
> ipu1_ic_prpenc capture (/dev/video1) but it's not working.
>=20
> Can anyone help me to verify whether I configured all the details
> properly if not please suggest.
>=20
> I'm pasting full log here, so-that anyone can comment in line and dt
> changes are at [2]

Be aware that because all of the provided GStreamer logs lines are
truncated, I won't be able to comment on the issue.

>=20
> Log:
> -----
>=20
> [    1.211866] etnaviv-gpu 2204000.gpu: Ignoring GPU with VG and
> FE2.0
> [    1.220211] [drm] Initialized etnaviv 1.2.0 20151214 for etnaviv
> on minor 0
> [    1.230344] imx-ipuv3 2400000.ipu: IPUv3H probed
> [    1.237170] [drm] Supports vblank timestamp caching Rev 2
> (21.10.2013).
> [    1.243920] [drm] No driver support for vblank timestamp query.
> [    1.250831] imx-drm display-subsystem: bound imx-ipuv3-crtc.2 (ops
> ipu_crtc_ops)
> [    1.258503] imx-drm display-subsystem: bound imx-ipuv3-crtc.3 (ops
> ipu_crtc_ops)
> [    1.266293] imx-drm display-subsystem: bound imx-ipuv3-crtc.6 (ops
> ipu_crtc_ops)
> [    1.274027] imx-drm display-subsystem: bound imx-ipuv3-crtc.7 (ops
> ipu_crtc_ops)
> [    1.282304] dwhdmi-imx 120000.hdmi: Detected HDMI TX controller
> v1.30a with HDCP (DWC HDMI 3D TX PHY)
> [    1.295722] imx-drm display-subsystem: bound 120000.hdmi (ops
> dw_hdmi_imx_ops)
> [    1.373615] Console: switching to colour frame buffer device
> 128x48
> [    1.396495] imx-drm display-subsystem: fb0:  frame buffer device
> [    1.404620] [drm] Initialized imx-drm 1.0.0 20120507 for
> display-subsystem on minor 1
> [    1.412763] imx-ipuv3 2800000.ipu: IPUv3H probed
> [    1.439673] brd: module loaded
> [    1.469099] loop: module loaded
> [    1.480324] nand: No NAND device found
> [    1.487768] libphy: Fixed MDIO Bus: probed
> [    1.493034] CAN device driver interface
> [    1.499057] fec 2188000.ethernet: 2188000.ethernet supply phy not
> found, using dummy regulator
> [    1.511633] pps pps0: new PPS source ptp0
> [    1.516928] fec 2188000.ethernet (unnamed net_device)
> (uninitialized): Invalid MAC address: 00:00:00:00:00:00
> [    1.527177] fec 2188000.ethernet (unnamed net_device)
> (uninitialized): Using random MAC address: f2:5a:6d:a6:90:74
> [    1.543567] libphy: fec_enet_mii_bus: probed
> [    1.549138] fec 2188000.ethernet eth0: registered PHC device 0
> [    1.556499] usbcore: registered new interface driver asix
> [    1.562066] usbcore: registered new interface driver ax88179_178a
> [    1.568259] usbcore: registered new interface driver cdc_ether
> [    1.574276] usbcore: registered new interface driver net1080
> [    1.580097] usbcore: registered new interface driver cdc_subset
> [    1.586144] usbcore: registered new interface driver zaurus
> [    1.591910] usbcore: registered new interface driver cdc_ncm
> [    1.597589] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI)
> Driver
> [    1.604209] ehci-pci: EHCI PCI platform driver
> [    1.608760] ehci-mxc: Freescale On-Chip EHCI Host driver
> [    1.614851] usbcore: registered new interface driver usb-storage
> [    1.629947] ci_hdrc ci_hdrc.0: EHCI Host Controller
> [    1.635066] ci_hdrc ci_hdrc.0: new USB bus registered, assigned
> bus number 1
> [    1.669473] ci_hdrc ci_hdrc.0: USB 2.0 started, EHCI 1.00
> [    1.677809] hub 1-0:1.0: USB hub found
> [    1.681902] hub 1-0:1.0: 1 port detected
> [    1.692839] ci_hdrc ci_hdrc.1: EHCI Host Controller
> [    1.697791] ci_hdrc ci_hdrc.1: new USB bus registered, assigned
> bus number 2
> [    1.729537] ci_hdrc ci_hdrc.1: USB 2.0 started, EHCI 1.00
> [    1.736740] hub 2-0:1.0: USB hub found
> [    1.740655] hub 2-0:1.0: 1 port detected
> [    1.753468] snvs_rtc 20cc000.snvs:snvs-rtc-lp: rtc core:
> registered
> 20cc000.snvs:snvs-rtc-lp as rtc0
> [    1.762976] i2c /dev entries driver
> [    1.811339] imx2-wdt 20bc000.wdog: timeout 60 sec (nowayout=3D0)
> [    1.817865] Bluetooth: HCI UART driver ver 2.3
> [    1.822460] Bluetooth: HCI UART protocol H4 registered
> [    1.828297] Bluetooth: HCI UART protocol LL registered
> [    1.834774] sdhci: Secure Digital Host Controller Interface driver
> [    1.841059] sdhci: Copyright(c) Pierre Ossman
> [    1.845437] sdhci-pltfm: SDHCI platform and OF driver helper
> [    1.852834] sdhci-esdhc-imx 2190000.usdhc: Got CD GPIO
> [    1.893497] mmc0: SDHCI controller on 2190000.usdhc
> [2190000.usdhc]
> using ADMA
> [    1.937500] mmc1: SDHCI controller on 2198000.usdhc
> [2198000.usdhc]
> using ADMA
> [    1.945049] mmc0: host does not support reading read-only switch,
> assuming write-enable
> [    1.959799] mmc0: new high speed SDHC card at address 1234
> [    1.968363] mmcblk0: mmc0:1234 SA04G 3.71 GiB
> [    1.977984] caam 2100000.caam: Entropy delay =3D 3200
> [    2.043796] caam 2100000.caam: Instantiated RNG4 SH0
> [    2.104558] caam 2100000.caam: Instantiated RNG4 SH1
> [    2.109596] caam 2100000.caam: device ID =3D 0x0a16010000000000 (Era
> 4)
> [    2.116060] caam 2100000.caam: job rings =3D 2, qi =3D 0, dpaa2 =3D no
> [    2.139266] caam algorithms registered in /proc/crypto
> [    2.139341]  mmcblk0: p1 p2
> [    2.150910] caam_jr 2101000.jr0: registering rng-caam
> [    2.157327] usbcore: registered new interface driver usbhid
> [    2.163103] usbhid: USB HID core driver
> [    2.171149] imx-media: subdev ov5640 2-003c bound
> [    2.176631] imx-media: subdev ipu1_vdic bound
> [    2.181640] imx-media: subdev ipu2_vdic bound
> [    2.183831] mmc1: new high speed MMC card at address 0001
> [    2.186357] imx-media: subdev ipu1_ic_prp bound
> [    2.193649] mmcblk1: mmc1:0001 M62704 3.53 GiB
> [    2.197342] ipu1_ic_prpenc: Registered ipu1_ic_prpenc capture as
> /dev/video0
> [    2.202620] mmcblk1boot0: mmc1:0001 M62704 partition 1 2.00 MiB
> [    2.208083] imx-media: subdev ipu1_ic_prpenc bound
> [    2.215764] mmcblk1boot1: mmc1:0001 M62704 partition 2 2.00 MiB
> [    2.219512] ipu1_ic_prpvf: Registered ipu1_ic_prpvf capture as
> /dev/video1
> [    2.231868] imx-media: subdev ipu1_ic_prpvf bound
> [    2.232186] mmcblk1rpmb: mmc1:0001 M62704 partition 3 512 KiB,
> chardev (244:0)
> [    2.236748] imx-media: subdev ipu2_ic_prp bound
> [    2.245958]  mmcblk1: p1 p2
> [    2.251569] ipu2_ic_prpenc: Registered ipu2_ic_prpenc capture as
> /dev/video2
> [    2.258696] imx-media: subdev ipu2_ic_prpenc bound
> [    2.264108] ipu2_ic_prpvf: Registered ipu2_ic_prpvf capture as
> /dev/video3
> [    2.271119] imx-media: subdev ipu2_ic_prpvf bound
> [    2.277042] ipu1_csi0: Registered ipu1_csi0 capture as /dev/video4
> [    2.283312] imx-media: subdev ipu1_csi0 bound
> [    2.288312] ipu1_csi1: Registered ipu1_csi1 capture as /dev/video5
> [    2.294583] imx-media: subdev ipu1_csi1 bound
> [    2.299694] ipu2_csi0: Registered ipu2_csi0 capture as /dev/video6
> [    2.305902] imx-media: subdev ipu2_csi0 bound
> [    2.310953] ipu2_csi1: Registered ipu2_csi1 capture as /dev/video7
> [    2.317162] imx-media: subdev ipu2_csi1 bound
> [    2.322293] imx-media: subdev imx6-mipi-csi2 bound
> [    2.336025] sgtl5000 2-000a: Error reading chip id -6
> [    2.346932] fsl-ssi-dai 2028000.ssi: No cache defaults, reading
> back from HW
> [    2.360345] NET: Registered protocol family 10
> [    2.367761] Segment Routing with IPv6
> [    2.371704] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
> [    2.379180] NET: Registered protocol family 17
> [    2.383872] can: controller area network core (rev 20170425 abi 9)
> [    2.390281] NET: Registered protocol family 29
> [    2.394756] can: raw protocol (rev 20170425)
> [    2.399126] can: broadcast manager protocol (rev 20170425 t)
> [    2.404869] can: netlink gateway (rev 20170425) max_hops=3D1
> [    2.410989] Key type dns_resolver registered
> [    2.420041] Registering SWP/SWPB emulation handler
> [    2.426337] Loading compiled-in X.509 certificates
> [    2.505422] imx-media: subdev ipu1_csi0_mux bound
> [    2.511142] imx-media: subdev ipu2_csi1_mux bound
> [    2.515930] imx-media: imx6-mipi-csi2:4 -> ipu2_csi1_mux:0
> [    2.518384] random: fast init done
> [    2.521600] imx-media: imx6-mipi-csi2:1 -> ipu1_csi0_mux:0
> [    2.530561] imx-media: ov5640 2-003c:0 -> imx6-mipi-csi2:0
> [    2.536094] imx-media: ipu2_csi1:1 -> ipu2_ic_prp:0
> [    2.541052] imx-media: ipu2_csi1:1 -> ipu2_vdic:0
> [    2.545801] imx-media: ipu2_csi1_mux:2 -> ipu2_csi1:0
> [    2.550932] imx-media: ipu2_csi0:1 -> ipu2_ic_prp:0
> [    2.555837] imx-media: ipu2_csi0:1 -> ipu2_vdic:0
> [    2.560629] imx-media: imx6-mipi-csi2:3 -> ipu2_csi0:0
> [    2.565800] imx-media: ipu1_csi1:1 -> ipu1_ic_prp:0
> [    2.570750] imx-media: ipu1_csi1:1 -> ipu1_vdic:0
> [    2.575497] imx-media: imx6-mipi-csi2:2 -> ipu1_csi1:0
> [    2.580716] imx-media: ipu1_csi0:1 -> ipu1_ic_prp:0
> [    2.585623] imx-media: ipu1_csi0:1 -> ipu1_vdic:0
> [    2.590411] imx-media: ipu1_csi0_mux:2 -> ipu1_csi0:0
> [    2.595499] imx-media: ipu2_ic_prp:1 -> ipu2_ic_prpenc:0
> [    2.600901] imx-media: ipu2_ic_prp:2 -> ipu2_ic_prpvf:0
> [    2.606159] imx-media: ipu1_ic_prp:1 -> ipu1_ic_prpenc:0
> [    2.611548] imx-media: ipu1_ic_prp:2 -> ipu1_ic_prpvf:0
> [    2.616803] imx-media: ipu2_vdic:2 -> ipu2_ic_prp:0
> [    2.621754] imx-media: ipu1_vdic:2 -> ipu1_ic_prp:0
> [    2.637015] imx_thermal tempmon: Industrial CPU temperature grade
> -
> max:105C critical:100C passive:95C
> [    2.650475] snvs_rtc 20cc000.snvs:snvs-rtc-lp: setting system
> clock
> to 1970-01-01 00:00:00 UTC (0)
> [    2.659880] cfg80211: Loading compiled-in X.509 certificates for
> regulatory database
> [    2.674031] cfg80211: Loaded X.509 cert 'sforshee:
> 00b28ddf47aef9cea7'
> [    2.682013] platform regulatory.0: Direct firmware load for
> regulatory.db failed with error -2
> [    2.690851] cfg80211: failed to load regulatory.db
> [    2.695737] ALSA device list:
> [    2.698762]   No soundcards found.
> [    3.592224] EXT4-fs (mmcblk0p2): recovery complete
> [    3.602020] EXT4-fs (mmcblk0p2): mounted filesystem with ordered
> data mode. Opts: (null)
> [    3.610371] VFS: Mounted root (ext4 filesystem) on device 179:2.
> [    3.618708] devtmpfs: mounted
> [    3.624665] Freeing unused kernel memory: 1024K
> [    3.743951] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null)
> Starting logging: OK
> Initializing random number generator... [    3.897748] random: dd:
> uninitialized urandom read (512 bytes read)
> done.
> Starting network: OK
>=20
> Welcome to Engicam i.CoreM6 Quad/Dual/DualLite/Solo
> buildroot login: root
> # media-ctl -l "'ov5640 2-003c':0 -> 'imx6-mipi-csi2':0[1]"
> # media-ctl -l "'imx6-mipi-csi2':2 -> 'ipu1_csi1':0[1]"
> # media-ctl -l "'ipu1_csi1':1 -> 'ipu1_ic_prp':0[1]"
> # media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
> # media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
> # media-ctl -V "'ov5640 2-003c':0 [fmt:UYVY2X8/640x480 field:none]"
> # media-ctl -V "'imx6-mipi-csi2':2 [fmt:UYVY2X8/640x480 field:none]"
> # media-ctl -V "'ipu1_csi1':1 [fmt:AYUV32/640x480 field:none]"
> # media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/640x480 field:none]"
> # media-ctl -V "'ipu1_ic_prpenc':1 [fmt:AYUV32/640x480 field:none]"
> # med# media-ctl -p
> Media controller API version 4.17.0
>=20
> Media device information
> ------------------------
> driver          imx-media
> model           imx-media
> serial
> bus info
> hw revision     0x0
> driver version  4.17.0
>=20
> Device topology
> - entity 1: ov5640 2-003c (1 pad, 1 link)
>             type V4L2 subdev subtype Sensor flags 0
>             device node name /dev/v4l-subdev0
> pad0: Source
> [fmt:UYVY8_2X8/640x480 field:none]
> -> "imx6-mipi-csi2":0 [ENABLED]
>=20
> - entity 3: ipu1_vdic (3 pads, 3 links)
>             type V4L2 subdev subtype Unknown flags 0
>             device node name /dev/v4l-subdev1
> pad0: Sink
> [fmt:AYUV8_1X32/640x480 field:none]
> <- "ipu1_csi0":1 []
> <- "ipu1_csi1":1 []
> pad1: Sink
> [fmt:UYVY8_2X8/640x480 field:none]
> pad2: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu1_ic_prp":0 []
>=20
> - entity 7: ipu2_vdic (3 pads, 3 links)
>             type V4L2 subdev subtype Unknown flags 0
>             device node name /dev/v4l-subdev2
> pad0: Sink
> [fmt:AYUV8_1X32/640x480 field:none]
> <- "ipu2_csi0":1 []
> <- "ipu2_csi1":1 []
> pad1: Sink
> [fmt:UYVY8_2X8/640x480 field:none]
> pad2: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu2_ic_prp":0 []
>=20
> - entity 11: ipu1_ic_prp (3 pads, 5 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev3
> pad0: Sink
> [fmt:AYUV8_1X32/640x480 field:none]
> <- "ipu1_vdic":2 []
> <- "ipu1_csi0":1 []
> <- "ipu1_csi1":1 [ENABLED]
> pad1: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu1_ic_prpenc":0 [ENABLED]
> pad2: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu1_ic_prpvf":0 []
>=20
> - entity 15: ipu1_ic_prpenc (2 pads, 2 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev4
> pad0: Sink
> [fmt:AYUV8_1X32/640x480 field:none]
> <- "ipu1_ic_prp":1 [ENABLED]
> pad1: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu1_ic_prpenc capture":0 [ENABLED]
>=20
> - entity 18: ipu1_ic_prpenc capture (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video0
> pad0: Sink
> <- "ipu1_ic_prpenc":1 [ENABLED]
>=20
> - entity 24: ipu1_ic_prpvf (2 pads, 2 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev5
> pad0: Sink
> [fmt:AYUV8_1X32/640x480 field:none]
> <- "ipu1_ic_prp":2 []
> pad1: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu1_ic_prpvf capture":0 []
>=20
> - entity 27: ipu1_ic_prpvf capture (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video1
> pad0: Sink
> <- "ipu1_ic_prpvf":1 []
>=20
> - entity 33: ipu2_ic_prp (3 pads, 5 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev6
> pad0: Sink
> [fmt:AYUV8_1X32/640x480 field:none]
> <- "ipu2_vdic":2 []
> <- "ipu2_csi0":1 []
> <- "ipu2_csi1":1 []
> pad1: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu2_ic_prpenc":0 []
> pad2: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu2_ic_prpvf":0 []
>=20
> - entity 37: ipu2_ic_prpenc (2 pads, 2 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev7
> pad0: Sink
> [fmt:AYUV8_1X32/640x480 field:none]
> <- "ipu2_ic_prp":1 []
> pad1: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu2_ic_prpenc capture":0 []
>=20
> - entity 40: ipu2_ic_prpenc capture (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video2
> pad0: Sink
> <- "ipu2_ic_prpenc":1 []
>=20
> - entity 46: ipu2_ic_prpvf (2 pads, 2 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev8
> pad0: Sink
> [fmt:AYUV8_1X32/640x480 field:none]
> <- "ipu2_ic_prp":2 []
> pad1: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu2_ic_prpvf capture":0 []
>=20
> - entity 49: ipu2_ic_prpvf capture (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video3
> pad0: Sink
> <- "ipu2_ic_prpvf":1 []
>=20
> - entity 55: ipu1_csi0 (3 pads, 4 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev9
> pad0: Sink
> [fmt:UYVY8_2X8/640x480 field:none
> crop.bounds:(0,0)/640x480
> crop:(0,0)/640x480
> compose.bounds:(0,0)/640x480
> compose:(0,0)/640x480]
> <- "ipu1_csi0_mux":2 []
> pad1: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu1_ic_prp":0 []
> -> "ipu1_vdic":0 []
> pad2: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu1_csi0 capture":0 []
>=20
> - entity 59: ipu1_csi0 capture (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video4
> pad0: Sink
> <- "ipu1_csi0":2 []
>=20
> - entity 65: ipu1_csi1 (3 pads, 4 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev10
> pad0: Sink
> [fmt:UYVY8_2X8/640x480 field:none
> crop.bounds:(0,0)/640x480
> crop:(0,0)/640x480
> compose.bounds:(0,0)/640x480
> compose:(0,0)/640x480]
> <- "imx6-mipi-csi2":2 [ENABLED]
> pad1: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu1_ic_prp":0 [ENABLED]
> -> "ipu1_vdic":0 []
> pad2: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu1_csi1 capture":0 []
>=20
> - entity 69: ipu1_csi1 capture (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video5
> pad0: Sink
> <- "ipu1_csi1":2 []
>=20
> - entity 75: ipu2_csi0 (3 pads, 4 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev11
> pad0: Sink
> [fmt:UYVY8_2X8/640x480 field:none
> crop.bounds:(0,0)/640x480
> crop:(0,0)/640x480
> compose.bounds:(0,0)/640x480
> compose:(0,0)/640x480]
> <- "imx6-mipi-csi2":3 []
> pad1: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu2_ic_prp":0 []
> -> "ipu2_vdic":0 []
> pad2: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu2_csi0 capture":0 []
>=20
> - entity 79: ipu2_csi0 capture (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video6
> pad0: Sink
> <- "ipu2_csi0":2 []
>=20
> - entity 85: ipu2_csi1 (3 pads, 4 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev12
> pad0: Sink
> [fmt:UYVY8_2X8/640x480 field:none
> crop.bounds:(0,0)/640x480
> crop:(0,0)/640x480
> compose.bounds:(0,0)/640x480
> compose:(0,0)/640x480]
> <- "ipu2_csi1_mux":2 []
> pad1: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu2_ic_prp":0 []
> -> "ipu2_vdic":0 []
> pad2: Source
> [fmt:AYUV8_1X32/640x480 field:none]
> -> "ipu2_csi1 capture":0 []
>=20
> - entity 89: ipu2_csi1 capture (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video7
> pad0: Sink
> <- "ipu2_csi1":2 []
>=20
> - entity 95: imx6-mipi-csi2 (5 pads, 5 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev13
> pad0: Sink
> [fmt:UYVY8_2X8/640x480 field:none]
> <- "ov5640 2-003c":0 [ENABLED]
> pad1: Source
> [fmt:UYVY8_2X8/640x480 field:none]
> -> "ipu1_csi0_mux":0 []
> pad2: Source
> [fmt:UYVY8_2X8/640x480 field:none]
> -> "ipu1_csi1":0 [ENABLED]
> pad3: Source
> [fmt:UYVY8_2X8/640x480 field:none]
> -> "ipu2_csi0":0 []
> pad4: Source
> [fmt:UYVY8_2X8/640x480 field:none]
> -> "ipu2_csi1_mux":0 []
>=20
> - entity 101: ipu1_csi0_mux (3 pads, 2 links)
>               type V4L2 subdev subtype Unknown flags 0
>               device node name /dev/v4l-subdev14
> pad0: Sink
> [fmt:unknown/0x0]
> <- "imx6-mipi-csi2":1 []
> pad1: Sink
> [fmt:unknown/0x0]
> pad2: Source
> [fmt:unknown/0x0]
> -> "ipu1_csi0":0 []
>=20
> - entity 105: ipu2_csi1_mux (3 pads, 2 links)
>               type V4L2 subdev subtype Unknown flags 0
>               device node name /dev/v4l-subdev15
> pad0: Sink
> [fmt:unknown/0x0]
> <- "imx6-mipi-csi2":4 []
> pad1: Sink
> [fmt:unknown/0x0]
> pad2: Source
> [fmt:unknown/0x0]
> -> "ipu2_csi1":0 []
>=20
> # GST_DEBUG=3D"v4l2*:5" gst-launch-1.0 -v v4l2src device=3D/dev/video1 !
> \
> > autovideosink
>=20
> 0:00:01.086281666   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l1
> 0:00:01.087369666   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l5
> 0:00:01.088496000   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l.
> 0:00:01.089540333   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4lR
> 0:00:01.090494666   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4lH
> 0:00:01.091657666   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l4
> 0:00:01.092745000   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l
> 0:00:01.093703333   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l
> 0:00:01.094854000   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l
> 0:00:01.095815000   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l
> 0:00:01.096818666   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4lB
> 0:00:01.097819000   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l8
> 0:00:01.098771000   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l
> 0:00:01.099798666   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l1
> 0:00:01.100776666   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4lV
> 0:00:01.101755333   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4lY
> 0:00:01.102771666   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4lP
> 0:00:01.103712000   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l4
> 0:00:01.104720000   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4lO
> 0:00:01.105697000   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4lP
> 0:00:01.106629666   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l4
> 0:00:01.107681666   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l4
> 0:00:01.108660666   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l2
> 0:00:01.442437333   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l0
> 0:00:01.444673333   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l2
> 0:00:01.446842000   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l2
> 0:00:01.449084000   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:1487:gst_v4l2_object_v4l4
> Setting pipeline to PAUSED ...
> 0:00:01.680823000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:524:gst_v4l2_open:<v4l2src01
> 0:00:01.681953333   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:69:gst_v4l2_get_capabilities
> 0:00:01.683098666   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:140:gst_v4l2_fill_lists:<v4s
> 0:00:01.684056666   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:143:gst_v4l2_fill_lists:<v4s
> 0:00:01.685201000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:215:gst_v4l2_fill_lists:<v4s
> 0:00:01.686159333   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:01.687207666   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4C
> 0:00:01.688183666   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:01.689155333   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4M
> 0:00:01.690142000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:01.691114000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4P
> 0:00:01.692080000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:01.693073000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4R
> 0:00:01.694043000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:01.695760000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4L
> 0:00:01.696736333   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:01.697708000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4G
> 0:00:01.698699000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:01.699667000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4H
> 0:00:01.700633000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:01.701623666   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4I
> 0:00:01.702591000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:01.703554333   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4K
> 0:00:01.704604000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:01.705576666   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4M
> 0:00:01.706567000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:02.040204667   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4B
> 0:00:02.042194667   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:02.044190000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4G
> 0:00:02.046338333   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:02.048327667   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4H
> 0:00:02.050296000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:02.052385000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4K
> 0:00:02.054376000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:02.056461333   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4L
> 0:00:02.058434000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:247:gst_v4l2_fill_lists:<v41
> 0:00:02.060423667   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:257:gst_v4l2_fill_lists:<v4c
> 0:00:02.062382667   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:263:gst_v4l2_fill_lists:<v4s
> 0:00:02.064291333   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:283:gst_v4l2_fill_lists:<v40
> 0:00:02.066224667   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:292:gst_v4l2_fill_lists:<v4.
> 0:00:02.067190333   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:283:gst_v4l2_fill_lists:<v40
> 0:00:02.068174333   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:300:gst_v4l2_fill_lists:<v40
> 0:00:02.069141000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:283:gst_v4l2_fill_lists:<v40
> 0:00:02.070113000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:305:gst_v4l2_fill_lists:<v4d
> 0:00:02.071088333   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:456:gst_v4l2_fill_lists:<v4e
> 0:00:02.072040000   185  0x1dce880 INFO                    v4l2
> v4l2_calls.c:592:gst_v4l2_open:<v4l2src0y
> 0:00:02.073017333   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:804:gst_v4l2_set_default)
> 0:00:02.074010667   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:740:gst_v4l2_get_norm:<v4l2m
> 0:00:02.075021000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:754:gst_v4l2_get_norm: Fail1
> 0:00:02.076012000   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:1027:gst_v4l2_get_input:<v4t
> Pipeline is live and does not need PREROLL ...
> 0:00:02.080105333   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:1109:gst_v4l2_object_fil.
> <v4l2src0> getting src format enumerations
> 0:00:02.412981333   185  0x1ec39b0 INFO              New clock:
> GstSystemClock
>       v4l2
> gstv4l2object.c:1146:gst_v4l2_object_fill_format_list:<v4l2src0>
> got 7 format(s):
> 0:00:02.415407667   185  0x1ec39b0 INFO                    v4l2
> gstv4l2object.c:1152:gst_v4l2_object_filV
> 0:00:02.417531667   185  0x1ec39b0 INFO                    v4l2
> gstv4l2object.c:1152:gst_v4l2_object_filY
> 0:00:02.419703667   185  0x1ec39b0 INFO                    v4l2
> gstv4l2object.c:1152:gst_v4l2_object_filP
> 0:00:02.421860000   185  0x1ec39b0 INFO                    v4l2
> gstv4l2object.c:1152:gst_v4l2_object_fil2
> 0:00:02.424022667   185  0x1ec39b0 INFO                    v4l2
> gstv4l2object.c:1152:gst_v4l2_object_fil2
> 0:00:02.426295000   185  0x1ec39b0 INFO                    v4l2
> gstv4l2object.c:1152:gst_v4l2_object_fil6
> 0:00:02.428481333   185  0x1ec39b0 INFO                    v4l2
> gstv4l2object.c:1152:gst_v4l2_object_fil2
> 0:00:02.430728333   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2564:gst_v4l2_object_proV
> 0:00:02.432985333   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2691:gst_v4l2_object_pro)
> 0:00:02.436117000   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2564:gst_v4l2_object_proY
> 0:00:02.437252333   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2691:gst_v4l2_object_pro)
> 0:00:02.438579000   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2564:gst_v4l2_object_proP
> 0:00:02.439656000   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2691:gst_v4l2_object_pro)
> 0:00:02.441016667   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2564:gst_v4l2_object_pro2
> 0:00:02.442092333   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2691:gst_v4l2_object_pro)
> 0:00:02.443443333   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2564:gst_v4l2_object_pro2
> 0:00:02.444626667   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2691:gst_v4l2_object_pro)
> 0:00:02.445990667   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2564:gst_v4l2_object_pro6
> 0:00:02.447063667   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2691:gst_v4l2_object_pro)
> 0:00:02.448410333   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2564:gst_v4l2_object_pro2
> 0:00:02.782148333   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2691:gst_v4l2_object_pro)
> 0:00:02.785264333   185  0x1ec39b0 INFO                    v4l2
> gstv4l2object.c:3967:gst_v4l2_object_get}
> 0:00:02.788800000   185  0x1ec39b0 DEBUG                v4l2src
> gstv4l2src.c:300:gst_v4l2src_negotiate:<}
> 0:00:02.792207000   185  0x1ec39b0 DEBUG                v4l2src
> gstv4l2src.c:308:gst_v4l2src_negotiate:<]
> 0:00:02.795419000   185  0x1ec39b0 DEBUG                v4l2src
> gstv4l2src.c:316:gst_v4l2src_negotiate:<}
> 0:00:03.132052667   185  0x1ec39b0 DEBUG                v4l2src
> gstv4l2src.c:256:gst_v4l2src_fixate:<v4l}
> 0:00:03.134399667   185  0x1ec39b0 DEBUG                v4l2src
> gstv4l2src.c:282:gst_v4l2src_fixate:<v4l}
> 0:00:03.136800667   185  0x1ec39b0 DEBUG                v4l2src
> gstv4l2src.c:367:gst_v4l2src_negotiate:<1
> 0:00:03.139067333   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:3887:gst_v4l2_object_stog
> 0:00:03.141452000   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:3176:gst_v4l2_object_seto
> 0:00:03.143608667   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:3310:gst_v4l2_object_set0
> 0:00:03.146025333   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:3361:gst_v4l2_object_set1
> 0:00:03.148229000   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:3370:gst_v4l2_object_set0
> 0:00:03.150373667   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:3404:gst_v4l2_object_set1
> 0:00:03.152589667   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:3414:gst_v4l2_object_set0
> 0:00:03.155250667   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:3455:gst_v4l2_object_set1
> 0:00:03.156584667   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:3472:gst_v4l2_object_set1
> 0:00:03.157659333   185  0x1ec39b0 INFO                    v4l2
> gstv4l2object.c:3504:gst_v4l2_object_set1
> 0:00:03.491432000   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2960:gst_v4l2_object_ext0
> 0:00:03.493645333   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:3071:gst_v4l2_object_sav0
> 0:00:03.496027333   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:2843:gst_v4l2_object_setm
> 0:00:03.498180000   185  0x1ec39b0 INFO                    v4l2
> gstv4l2object.c:2867:gst_v4l2_object_set2
> 0:00:03.502772000   185  0x1ec39b0 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:509:gst_v4l2_buffer_;
> 0:00:03.505283333   185  0x1ec39b0 INFO          v4l2bufferpool
> gstv4l2bufferpool.c:557:gst_v4l2_buffer_2
> 0:00:03.507120000   185  0x1ec39b0 INFO          v4l2bufferpool
> gstv4l2bufferpool.c:570:gst_v4l2_buffer_2
> /GstPipeline:pipeline0/GstV4l2Src:v4l2src0.GstPad:src: caps =3D
> video/x-raw, format=3D(string)YUY2, width=3D(i1
> /GstPipeline:pipeline0/GstAutoVideoSink:autovideosink0.GstGhostPad:si
> nk.GstProxyPad:proxypad0:
> caps =3D vi1
> /GstPipeline:pipeline0/GstAutoVideoSink:autovideosink0/GstKMSSink:aut
> ovideosink0-actual-sink-kms.GstPad:1
> 0:00:03/GstPipeline:pipeline0/GstAutoVideoSink:autovideosink0.GstGhos
> tPad:sink:
> caps =3D video/x-raw, form1
> .512440000   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:3985:gst_v4l2_object_decide_alln
> 0:00:03.513556667   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:4011:gst_v4l2_object_dec>
> 0:00:03.514745667   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:4069:gst_v4l2_object_dec>
> 0:00:03.515889000   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:4134:gst_v4l2_object_deca
> 0:00:03.516969667   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:4143:gst_v4l2_object_dec;
> 0:00:03.851350333   185  0x1ec39b0 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:509:gst_v4l2_buffer_2
> ams)NULL, options=3D(string)< GstBufferPoolOptionVideoMeta >;
> 0:00:03.853620333   185  0x1ec39b0 INFO          v4l2bufferpool
> gstv4l2bufferpool.c:570:gst_v4l2_buffer_2
> 0:00:03.855780667   185  0x1ec39b0 DEBUG                   v4l2
> gstv4l2object.c:4150:gst_v4l2_object_dec;
> 0:00:03.858430000   185  0x1ec39b0 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:509:gst_v4l2_buffer_;
> 0:00:03.861572333   185  0x1ec39b0 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:707:gst_v4l2_buffer_l
> 0:00:03.863468333   185  0x1ec39b0 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:737:gst_v4l2_buffer_s
> 0:00:03.918861000   185  0x1ec39b0 DEBUG          v4l2allocator
> gstv4l2allocator.c:706:gst_v4l2_allocatod
> 0:00:03.943783333   185  0x1ec39b0 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:1389:gst_v4l2_buffer8
> 0:00:03.946129333   185  0x1ec39b0 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:1389:gst_v4l2_buffer8
> 0:00:03.948065000   185  0x1ec39b0 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:1389:gst_v4l2_buffer8
> 0:00:03.950006000   185  0x1ec39b0 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:952:gst_v4l2_buffer_g
> 0:00:03.996241333   185  0x1ec39b0 ERROR         v4l2bufferpool
> gstv4l2bufferpool.c:641:gst_v4l2_buffer_)
> 0:00:03.998199667   185  0x1ec39b0 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:1311:gst_v4l2_buffere
> 0:00:04.000463000   185  0x1ec39b0 WARN          v4l2bufferpool
> gstv4l2bufferpool.c:1064:gst_v4l2_buffer)
> 0:00:04.004649333   185  0x1ec39b0 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:1283:gst_v4l2_bufferr
> 0:00:04.005853333   185  0x1ec39b0 WARN                 v4l2src
> gstv4l2src.c:866:gst_v4l2src_create:<v4lr
> ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Could
> not read from resource.
> Additional debug info:
> gstv4l2bufferpool.c(1064): gst_v4l2_buffer_pool_poll ():
> /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> poll error 1: Resource temporarily unavailable (11)
> Execution ended after 0:00:01.606871334
> Setting pipeline to PAUSED ...
> 0:00:04.022385000   185  0x1dce880 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:931:gst_v4l2_buffer_g
> Setting pipeline to READY ...
> 0:00:04.024850667   185  0x1dce880 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:879:gst_v4l2_buffer_l
> 0:00:04.026764000   185  0x1dce880 DEBUG          v4l2allocator
> gstv4l2allocator.c:757:gst_v4l2_allocator
> 0:00:04.028598333   185  0x1dce880 DEBUG          v4l2allocator
> gstv4l2allocator.c:765:gst_v4l2_allocatoe
> 0:00:04.362785667   185  0x1dce880 WARN          v4l2bufferpool
> gstv4l2bufferpool.c:918:gst_v4l2_buffer_g
> 0:00:04.364712333   185  0x1dce880 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:952:gst_v4l2_buffer_g
> 0:00:04.366504333   185  0x1dce880 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:629:gst_v4l2_buffer_g
> 0:00:04.368607000   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:3887:gst_v4l2_object_stog
> 0:00:04.370713333   185  0x1dce880 DEBUG                   v4l2
> gstv4l2object.c:3895:gst_v4l2_object_stol
> 0:00:04.372809333   185  0x1dce880 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:931:gst_v4l2_buffer_g
> 0:00:04.374732000   185  0x1dce880 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:879:gst_v4l2_buffer_l
> 0:00:04.376541000   185  0x1dce880 DEBUG         v4l2bufferpool
> gstv4l2bufferpool.c:663:gst_v4l2_buffer_g
> 0:00:04.378334000   185  0x1dce880 DEBUG          v4l2allocator
> gstv4l2allocator.c:757:gst_v4l2_allocator
> Setting pipeline to NULL ...
> 0:00:04.394764333   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:716:gst_v4l2_close:<v4l2src1
> 0:00:04.395897667   185  0x1dce880 DEBUG                   v4l2
> v4l2_calls.c:464:gst_v4l2_empty_lists:<vs
> Freeing pipeline ...
>=20
> [1] https://linuxtv.org/downloads/v4l-dvb-apis/v4l-drivers/imx.html#s
> abresd-with-mipi-csi-2-ov5640
> [2] https://paste.ubuntu.com/p/CTvFqdbyMW/
>=20
> Jagan.
>=20
--=-Xi1Y/qtByxPXA39Kk8s5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWxAehAAKCRBxUwItrAao
HDAyAJ46jucd2d38qiOX73tcTGxj4JA17gCfSfr+MDmM9ynIAdMRWGkatM4JRv4=
=aWdt
-----END PGP SIGNATURE-----

--=-Xi1Y/qtByxPXA39Kk8s5--
