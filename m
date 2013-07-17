Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33065 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab3GQMuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 08:50:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jakub Piotr =?utf-8?B?Q8WCYXBh?= <jpc-ml@zenburn.net>
Cc: linux-media <linux-media@vger.kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [omap3isp] xclk deadlock
Date: Wed, 17 Jul 2013 14:50:57 +0200
Message-ID: <3227918.6DpNM0vnE9@avalon>
In-Reply-To: <51E0165C.5000401@zenburn.net>
References: <51D37796.2000601@zenburn.net> <1604535.2Z0SUEyxcF@avalon> <51E0165C.5000401@zenburn.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jakub,

(CC'ing Tomi Valkeinen)

On Friday 12 July 2013 16:44:44 Jakub Piotr Cłapa wrote:
> Hi Laurent,
> 
> On 05.07.13 12:48, Laurent Pinchart wrote:
> >> Thanks for the explanation. It would be great if you could update your
> >> board/beagle/mt9p031 branch and include the discussed changes.
> > 
> > Done. Could you please test it ?
> 
> Thanks for you help. There are no errors about the clocks or regulators
> now but the rest does not work so well (everything mentioned below works
> fine on my old 3.2.24 kernel):
> 
> 1. The images streamed to omapdss using omap3-isp-live look like they
> lost "synchronization" with a black bar horizontal bar jumping on the
> screen and other such artifacts (it looks as if both width and height
> were invalid). The framerate is about a half of what it should be.
> Adjusting the camera iris changes the lightness of the image so the
> whole pipeline is working to some extent (so these artifacts are not
> just some random memory patterns).
> 
> The Register dumps are a little different between 3.2.24 and 3.10 [4].
>
> 2. When exiting from live the kernel hangs more often then not
> (sometimes it is accompanied by "Unhandled fault: external abort on
> non-linefetch" in "dispc_write_irqenable" in omapdss).

I'll pass this one to Tomi :-)

> 3. After setting up a simple pipeline using media-ctl[2] I get "CCDC
> won't become idle errors". If I do this after running "live" I also get
> (unless it hangs) the CCDC Register dump [1]. Otherwise I only get the
> stream of kernel log messages without anything else from omap3isp.
> 
> 4. I recreated the "live" pipeline (judging by the lack of differences
> in media-ctl -p output [3]) and used yavta. I get the same hangs but
> when I don't I can check the UYVY frames one by one. They look bad at
> any stride (I dropped the UV components and tried to get some meaningful
> output in the GIMP raw image data import dialog by adjustung the "width").

Would you be able to bisect the problems ? Please also see below for more 
comments.

As a side note, you can use raw2rgbpnm (https://gitorious.org/raw2rgbpnm) to 
convert raw binary images to a more usable format.

> [1]:
> [  153.774017] omap3isp omap3isp: -------------CCDC Register
> dump-------------
> [  153.781494] omap3isp omap3isp: ###CCDC PCR=0x00000000
> [  153.786773] omap3isp omap3isp: ###CCDC SYN_MODE=0x00030400
> [  153.792572] omap3isp omap3isp: ###CCDC HD_VD_WID=0x00000000
> [  153.798431] omap3isp omap3isp: ###CCDC PIX_LINES=0x00000000
> [  153.804290] omap3isp omap3isp: ###CCDC HORZ_INFO=0x0000031f
> [  153.810180] omap3isp omap3isp: ###CCDC VERT_START=0x00000000
> [  153.816101] omap3isp omap3isp: ###CCDC VERT_LINES=0x00000257
> [  153.822052] omap3isp omap3isp: ###CCDC CULLING=0xffff00ff
> [  153.827728] omap3isp omap3isp: ###CCDC HSIZE_OFF=0x00000640
> [  153.833648] omap3isp omap3isp: ###CCDC SDOFST=0x00000000
> [  153.839263] omap3isp omap3isp: ###CCDC SDR_ADDR=0x00001000
> [  153.845001] omap3isp omap3isp: ###CCDC CLAMP=0x00000010
> [  153.850524] omap3isp omap3isp: ###CCDC DCSUB=0x00000000
> [  153.855987] omap3isp omap3isp: ###CCDC COLPTN=0xbb11bb11
> [  153.861602] omap3isp omap3isp: ###CCDC BLKCMP=0x00000000
> [  153.867156] omap3isp omap3isp: ###CCDC FPC=0x00000000
> [  153.872497] omap3isp omap3isp: ###CCDC FPC_ADDR=0x00000000
> [  153.878265] omap3isp omap3isp: ###CCDC VDINT=0x02560190
> [  153.883789] omap3isp omap3isp: ###CCDC ALAW=0x00000004
> [  153.889221] omap3isp omap3isp: ###CCDC REC656IF=0x00000000
> [  153.894958] omap3isp omap3isp: ###CCDC CFG=0x00008000
> [  153.900299] omap3isp omap3isp: ###CCDC FMTCFG=0x0000c000
> [  153.905853] omap3isp omap3isp: ###CCDC FMT_HORZ=0x00000320
> [  153.911651] omap3isp omap3isp: ###CCDC FMT_VERT=0x00000258
> [  153.917388] omap3isp omap3isp: ###CCDC PRGEVEN0=0x00000000
> [  153.923187] omap3isp omap3isp: ###CCDC PRGEVEN1=0x00000000
> [  153.928955] omap3isp omap3isp: ###CCDC PRGODD0=0x00000000
> [  153.934661] omap3isp omap3isp: ###CCDC PRGODD1=0x00000000
> [  153.940338] omap3isp omap3isp: ###CCDC VP_OUT=0x04ae3200
> [  153.945922] omap3isp omap3isp: ###CCDC LSC_CONFIG=0x00006600
> [  153.951873] omap3isp omap3isp: ###CCDC LSC_INITIAL=0x00000000
> [  153.957916] omap3isp omap3isp: ###CCDC LSC_TABLE_BASE=0x00000000
> [  153.964233] omap3isp omap3isp: ###CCDC LSC_TABLE_OFFSET=0x00000000
> [  153.970733] omap3isp omap3isp:
> --------------------------------------------
> [  154.174468] omap3isp omap3isp: CCDC won't become idle!
> [  154.315917] omap3isp omap3isp: CCDC won't become idle!
> [  154.340118] omap3isp omap3isp: CCDC won't become idle!
> [  154.364349] omap3isp omap3isp: CCDC won't become idle!
> [  154.388549] omap3isp omap3isp: CCDC won't become idle!
> [  154.412750] omap3isp omap3isp: CCDC won't become idle!
> [  154.436950] omap3isp omap3isp: CCDC won't become idle!
> [  154.461151] omap3isp omap3isp: CCDC won't become idle!
> [  154.485382] omap3isp omap3isp: CCDC won't become idle!
> 
> 
> 
> 
> [2]:
> media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
> CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> media-ctl -v -f '"mt9p031 2-0048":0 [SGRBG12 800x600 (96,72)/2400x1800],
> "OMAP3 ISP CCDC":1 [SGRBG8 800x600]'

You're trying to configure the sensor output to 800x600, but the closest 
resolution the sensor can deliver is 864x648. The sensor driver will thus 
return that resolution, and media-ctl will automatically configure the 
connected pad (CCDC sink pad 0) with the same resolution. Similarly, you try 
to configure the CCDC output to 800x600, but the CCDC driver will 
automatically set its output resolution (on source pad 1) to 864x648. media-
ctl won't complain, and your pipeline will be correctly configured, but not in 
the resolution you expect.

> yavta -f SGRBG12 -s 800x600 -n 8 --skip 4 --capture=5 -F'frame-#.bin'
> $(media-ctl -e "OMAP3 ISP CCDC output")

Can you run this without error ? You're trying to capture in 800x600 at the 
CCDC output but the pipeline has been configured with a different resolution. 
The OMAP3 ISP driver should return an error when you start the video stream. 
If it doesn't, that's a driver bug.

> [3]:
> Opening media device /dev/media0
> Enumerating entities
> Found 16 entities
> Enumerating pads and links
> Media controller API version 0.0.0
> 
> Media device information
> ------------------------
> driver          omap3isp
> model           TI OMAP3 ISP
> serial
> bus info
> hw revision     0xf0
> driver version  0.0.0
> 
> Device topology
> - entity 1: OMAP3 ISP CCP2 (2 pads, 2 links)
>              type V4L2 subdev subtype Unknown
>              device node name /dev/v4l-subdev0
> 	pad0: Sink [SGRBG10 4096x4096]
> 		<- "OMAP3 ISP CCP2 input":0 []
> 	pad1: Source [SGRBG10 4096x4096]
> 		-> "OMAP3 ISP CCDC":0 []
> 
> - entity 2: OMAP3 ISP CCP2 input (1 pad, 1 link)
>              type Node subtype V4L
>              device node name /dev/video0
> 	pad0: Source
> 		-> "OMAP3 ISP CCP2":0 []
> 
> - entity 3: OMAP3 ISP CSI2a (2 pads, 2 links)
>              type V4L2 subdev subtype Unknown
>              device node name /dev/v4l-subdev1
> 	pad0: Sink [SGRBG10 4096x4096]
> 	pad1: Source [SGRBG10 4096x4096]
> 		-> "OMAP3 ISP CSI2a output":0 []
> 		-> "OMAP3 ISP CCDC":0 []
> 
> - entity 4: OMAP3 ISP CSI2a output (1 pad, 1 link)
>              type Node subtype V4L
>              device node name /dev/video1
> 	pad0: Sink
> 		<- "OMAP3 ISP CSI2a":1 []
> 
> - entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
>              type V4L2 subdev subtype Unknown
>              device node name /dev/v4l-subdev2
> 	pad0: Sink [SGRBG12 864x648]
> 		<- "OMAP3 ISP CCP2":1 []
> 		<- "OMAP3 ISP CSI2a":1 []
> 		<- "mt9p031 2-0048":0 [ENABLED]
> 	pad1: Source [SGRBG12 864x648 (0,0)/864x648]
> 		-> "OMAP3 ISP CCDC output":0 []
> 		-> "OMAP3 ISP resizer":0 []
> 	pad2: Source [SGRBG10 864x647]
> 		-> "OMAP3 ISP preview":0 [ENABLED]
> 		-> "OMAP3 ISP AEWB":0 [ENABLED,IMMUTABLE]
> 		-> "OMAP3 ISP AF":0 [ENABLED,IMMUTABLE]
> 		-> "OMAP3 ISP histogram":0 [ENABLED,IMMUTABLE]
> 
> - entity 6: OMAP3 ISP CCDC output (1 pad, 1 link)
>              type Node subtype V4L
>              device node name /dev/video2
> 	pad0: Sink
> 		<- "OMAP3 ISP CCDC":1 []
> 
> - entity 7: OMAP3 ISP preview (2 pads, 4 links)
>              type V4L2 subdev subtype Unknown
>              device node name /dev/v4l-subdev3
> 	pad0: Sink [SGRBG10 864x647 (10,4)/846x639]
> 		<- "OMAP3 ISP CCDC":2 [ENABLED]
> 		<- "OMAP3 ISP preview input":0 []
> 	pad1: Source [YUYV 846x639]
> 		-> "OMAP3 ISP preview output":0 []
> 		-> "OMAP3 ISP resizer":0 [ENABLED]
> 
> - entity 8: OMAP3 ISP preview input (1 pad, 1 link)
>              type Node subtype V4L
>              device node name /dev/video3
> 	pad0: Source
> 		-> "OMAP3 ISP preview":0 []
> 
> - entity 9: OMAP3 ISP preview output (1 pad, 1 link)
>              type Node subtype V4L
>              device node name /dev/video4
> 	pad0: Sink
> 		<- "OMAP3 ISP preview":1 []
> 
> - entity 10: OMAP3 ISP resizer (2 pads, 4 links)
>               type V4L2 subdev subtype Unknown
>               device node name /dev/v4l-subdev4
> 	pad0: Sink [YUYV 846x639 (0,0)/846x638]
> 		<- "OMAP3 ISP CCDC":1 []
> 		<- "OMAP3 ISP preview":1 [ENABLED]
> 		<- "OMAP3 ISP resizer input":0 []
> 	pad1: Source [YUYV 800x600]
> 		-> "OMAP3 ISP resizer output":0 [ENABLED]
> 
> - entity 11: OMAP3 ISP resizer input (1 pad, 1 link)
>               type Node subtype V4L
>               device node name /dev/video5
> 	pad0: Source
> 		-> "OMAP3 ISP resizer":0 []
> 
> - entity 12: OMAP3 ISP resizer output (1 pad, 1 link)
>               type Node subtype V4L
>               device node name /dev/video6
> 	pad0: Sink
> 		<- "OMAP3 ISP resizer":1 [ENABLED]
> 
> - entity 13: OMAP3 ISP AEWB (1 pad, 1 link)
>               type V4L2 subdev subtype Unknown
>               device node name /dev/v4l-subdev5
> 	pad0: Sink
> 		<- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]
> 
> - entity 14: OMAP3 ISP AF (1 pad, 1 link)
>               type V4L2 subdev subtype Unknown
>               device node name /dev/v4l-subdev6
> 	pad0: Sink
> 		<- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]
> 
> - entity 15: OMAP3 ISP histogram (1 pad, 1 link)
>               type V4L2 subdev subtype Unknown
>               device node name /dev/v4l-subdev7
> 	pad0: Sink
> 		<- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]
> 
> - entity 16: mt9p031 2-0048 (1 pad, 1 link)
>               type V4L2 subdev subtype Unknown
>               device node name /dev/v4l-subdev8
> 	pad0: Source [SGRBG12 864x648 (0,0)/2592x1944]
> 		-> "OMAP3 ISP CCDC":0 [ENABLED]
> 
> 
> 
> 
> [4]:
> 
> @@ -21,9 +21,9 @@
>   omap3isp omap3isp: ###RSZ YENH=0x00000000
>   omap3isp omap3isp: --------------------------------------------
>   omap3isp omap3isp: -------------Preview Register dump----------
> -omap3isp omap3isp: ###PRV PCR=0x180e0609
> -omap3isp omap3isp: ###PRV HORZ_INFO=0x0006035b
> -omap3isp omap3isp: ###PRV VERT_INFO=0x00000286
> +omap3isp omap3isp: ###PRV PCR=0x180e0600

Bits 0 and 3 are the ENABLE and ONESHOT bits respectively. The registers dump 
might have been displayed at a different time in v3.2.24 (although I haven't 
checked);

> +omap3isp omap3isp: ###PRV HORZ_INFO=0x00080359
> +omap3isp omap3isp: ###PRV VERT_INFO=0x00020284

Those two registers contain the input crop rectangle coordinates (left/top in 
bits 31-16, right/bottom in bits 15-0). Note that this is the internal crop 
rectangle, which takesrows and columns required for internal processing into 
account. It will thus not match the user-visible crop rectangle at the sink 
pad.

The crop rectangle has changed from (6,0)/860x647 to (8,2)/850x643. The 
preview engine internally crops 4 rows and 4 columns (2 on each side) when 
converting from Bayer to YUV, so the (8,2)/850x643 crop rectangle becomes 
(10,4)/846x639 after manual and internal cropping, which matches the value 
reported by media-ctl -p.

>   omap3isp omap3isp: ###PRV RSDR_ADDR=0x00000000
>   omap3isp omap3isp: ###PRV RADR_OFFSET=0x00000000
>   omap3isp omap3isp: ###PRV DSDR_ADDR=0x00000000
> @@ -52,7 +52,7 @@
>   omap3isp omap3isp: ###PRV CNT_BRT=0x00001000
>   omap3isp omap3isp: ###PRV CSUP=0x00000000
>   omap3isp omap3isp: ###PRV SETUP_YC=0xff00ff00
> -omap3isp omap3isp: ###PRV SET_TBL_ADDR=0x00000800
> +omap3isp omap3isp: ###PRV SET_TBL_ADDR=0x00001700
>   omap3isp omap3isp: ###PRV CDC_THR0=0x0000000e
>   omap3isp omap3isp: ###PRV CDC_THR1=0x0000000e
>   omap3isp omap3isp: ###PRV CDC_THR2=0x0000000e
-- 
Regards,

Laurent Pinchart

