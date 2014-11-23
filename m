Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:64438 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaKWLpp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 06:45:45 -0500
Date: Sun, 23 Nov 2014 12:45:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>
cc: linux-media@vger.kernel.org, Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH v4 1/3] media: soc_camera: rcar_vin: Add scaling support
In-Reply-To: <1413868229-22205-2-git-send-email-ykaneko0929@gmail.com>
Message-ID: <Pine.LNX.4.64.1411231223340.23648@axis700.grange>
References: <1413868229-22205-1-git-send-email-ykaneko0929@gmail.com>
 <1413868229-22205-2-git-send-email-ykaneko0929@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
[g.liakhovetski@gmx.de: minor stylistic and formatting corrections]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Kaneko-san, Matsuoka-san, could you please have a look at this version of 
this your patch? Are my changes to it ok? Also, please test this my 
branch: 
http://git.linuxtv.org/cgit.cgi/gliakhovetski/v4l-dvb.git/log/?h=for-3.19-1 
before I push it to Mauro. Patches applied more or less cleanly, and there 
don't seem to be any functional dependencies, that I might have broken, 
the driver compiles with no warnings, still, would be good if you could 
test it! Otherwise waiting for updates for other your patches! Patch 
"rcar_vin: Add BT.709 24-bit RGB888 input support" is also marked "Ok" by 
me, but I couldn't push it yet, because it depends on other patches, that 
have to be updated.

Thanks
Guennadi

 drivers/media/platform/soc_camera/rcar_vin.c | 451 ++++++++++++++++++++++++++-
 1 file changed, 442 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index c60560a..c71ef2b 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -64,6 +64,30 @@
 #define VNDMR_REG	0x58	/* Video n Data Mode Register */
 #define VNDMR2_REG	0x5C	/* Video n Data Mode Register 2 */
 #define VNUVAOF_REG	0x60	/* Video n UV Address Offset Register */
+#define VNC1A_REG	0x80	/* Video n Coefficient Set C1A Register */
+#define VNC1B_REG	0x84	/* Video n Coefficient Set C1B Register */
+#define VNC1C_REG	0x88	/* Video n Coefficient Set C1C Register */
+#define VNC2A_REG	0x90	/* Video n Coefficient Set C2A Register */
+#define VNC2B_REG	0x94	/* Video n Coefficient Set C2B Register */
+#define VNC2C_REG	0x98	/* Video n Coefficient Set C2C Register */
+#define VNC3A_REG	0xA0	/* Video n Coefficient Set C3A Register */
+#define VNC3B_REG	0xA4	/* Video n Coefficient Set C3B Register */
+#define VNC3C_REG	0xA8	/* Video n Coefficient Set C3C Register */
+#define VNC4A_REG	0xB0	/* Video n Coefficient Set C4A Register */
+#define VNC4B_REG	0xB4	/* Video n Coefficient Set C4B Register */
+#define VNC4C_REG	0xB8	/* Video n Coefficient Set C4C Register */
+#define VNC5A_REG	0xC0	/* Video n Coefficient Set C5A Register */
+#define VNC5B_REG	0xC4	/* Video n Coefficient Set C5B Register */
+#define VNC5C_REG	0xC8	/* Video n Coefficient Set C5C Register */
+#define VNC6A_REG	0xD0	/* Video n Coefficient Set C6A Register */
+#define VNC6B_REG	0xD4	/* Video n Coefficient Set C6B Register */
+#define VNC6C_REG	0xD8	/* Video n Coefficient Set C6C Register */
+#define VNC7A_REG	0xE0	/* Video n Coefficient Set C7A Register */
+#define VNC7B_REG	0xE4	/* Video n Coefficient Set C7B Register */
+#define VNC7C_REG	0xE8	/* Video n Coefficient Set C7C Register */
+#define VNC8A_REG	0xF0	/* Video n Coefficient Set C8A Register */
+#define VNC8B_REG	0xF4	/* Video n Coefficient Set C8B Register */
+#define VNC8C_REG	0xF8	/* Video n Coefficient Set C8C Register */
 
 /* Register bit fields for R-Car VIN */
 /* Video n Main Control Register bits */
@@ -117,6 +141,324 @@ enum chip_id {
 	RCAR_E1,
 };
 
+struct vin_coeff {
+	unsigned short xs_value;
+	u32 coeff_set[24];
+};
+
+static const struct vin_coeff vin_coeff_set[] = {
+	{ 0x0000, {
+		0x00000000,		0x00000000,		0x00000000,
+		0x00000000,		0x00000000,		0x00000000,
+		0x00000000,		0x00000000,		0x00000000,
+		0x00000000,		0x00000000,		0x00000000,
+		0x00000000,		0x00000000,		0x00000000,
+		0x00000000,		0x00000000,		0x00000000,
+		0x00000000,		0x00000000,		0x00000000,
+		0x00000000,		0x00000000,		0x00000000 },
+	},
+	{ 0x1000, {
+		0x000fa400,		0x000fa400,		0x09625902,
+		0x000003f8,		0x00000403,		0x3de0d9f0,
+		0x001fffed,		0x00000804,		0x3cc1f9c3,
+		0x001003de,		0x00000c01,		0x3cb34d7f,
+		0x002003d2,		0x00000c00,		0x3d24a92d,
+		0x00200bca,		0x00000bff,		0x3df600d2,
+		0x002013cc,		0x000007ff,		0x3ed70c7e,
+		0x00100fde,		0x00000000,		0x3f87c036 },
+	},
+	{ 0x1200, {
+		0x002ffff1,		0x002ffff1,		0x02a0a9c8,
+		0x002003e7,		0x001ffffa,		0x000185bc,
+		0x002007dc,		0x000003ff,		0x3e52859c,
+		0x00200bd4,		0x00000002,		0x3d53996b,
+		0x00100fd0,		0x00000403,		0x3d04ad2d,
+		0x00000bd5,		0x00000403,		0x3d35ace7,
+		0x3ff003e4,		0x00000801,		0x3dc674a1,
+		0x3fffe800,		0x00000800,		0x3e76f461 },
+	},
+	{ 0x1400, {
+		0x00100be3,		0x00100be3,		0x04d1359a,
+		0x00000fdb,		0x002003ed,		0x0211fd93,
+		0x00000fd6,		0x002003f4,		0x0002d97b,
+		0x000007d6,		0x002ffffb,		0x3e93b956,
+		0x3ff003da,		0x001003ff,		0x3db49926,
+		0x3fffefe9,		0x00100001,		0x3d655cee,
+		0x3fffd400,		0x00000003,		0x3d65f4b6,
+		0x000fb421,		0x00000402,		0x3dc6547e },
+	},
+	{ 0x1600, {
+		0x00000bdd,		0x00000bdd,		0x06519578,
+		0x3ff007da,		0x00000be3,		0x03c24973,
+		0x3ff003d9,		0x00000be9,		0x01b30d5f,
+		0x3ffff7df,		0x001003f1,		0x0003c542,
+		0x000fdfec,		0x001003f7,		0x3ec4711d,
+		0x000fc400,		0x002ffffd,		0x3df504f1,
+		0x001fa81a,		0x002ffc00,		0x3d957cc2,
+		0x002f8c3c,		0x00100000,		0x3db5c891 },
+	},
+	{ 0x1800, {
+		0x3ff003dc,		0x3ff003dc,		0x0791e558,
+		0x000ff7dd,		0x3ff007de,		0x05328554,
+		0x000fe7e3,		0x3ff00be2,		0x03232546,
+		0x000fd7ee,		0x000007e9,		0x0143bd30,
+		0x001fb800,		0x000007ee,		0x00044511,
+		0x002fa015,		0x000007f4,		0x3ef4bcee,
+		0x002f8832,		0x001003f9,		0x3e4514c7,
+		0x001f7853,		0x001003fd,		0x3de54c9f },
+	},
+	{ 0x1a00, {
+		0x000fefe0,		0x000fefe0,		0x08721d3c,
+		0x001fdbe7,		0x000ffbde,		0x0652a139,
+		0x001fcbf0,		0x000003df,		0x0463292e,
+		0x002fb3ff,		0x3ff007e3,		0x0293a91d,
+		0x002f9c12,		0x3ff00be7,		0x01241905,
+		0x001f8c29,		0x000007ed,		0x3fe470eb,
+		0x000f7c46,		0x000007f2,		0x3f04b8ca,
+		0x3fef7865,		0x000007f6,		0x3e74e4a8 },
+	},
+	{ 0x1c00, {
+		0x001fd3e9,		0x001fd3e9,		0x08f23d26,
+		0x002fbff3,		0x001fe3e4,		0x0712ad23,
+		0x002fa800,		0x000ff3e0,		0x05631d1b,
+		0x001f9810,		0x000ffbe1,		0x03b3890d,
+		0x000f8c23,		0x000003e3,		0x0233e8fa,
+		0x3fef843b,		0x000003e7,		0x00f430e4,
+		0x3fbf8456,		0x3ff00bea,		0x00046cc8,
+		0x3f8f8c72,		0x3ff00bef,		0x3f3490ac },
+	},
+	{ 0x1e00, {
+		0x001fbbf4,		0x001fbbf4,		0x09425112,
+		0x001fa800,		0x002fc7ed,		0x0792b110,
+		0x000f980e,		0x001fdbe6,		0x0613110a,
+		0x3fff8c20,		0x001fe7e3,		0x04a368fd,
+		0x3fcf8c33,		0x000ff7e2,		0x0343b8ed,
+		0x3f9f8c4a,		0x000fffe3,		0x0203f8da,
+		0x3f5f9c61,		0x000003e6,		0x00e428c5,
+		0x3f1fb07b,		0x000003eb,		0x3fe440af },
+	},
+	{ 0x2000, {
+		0x000fa400,		0x000fa400,		0x09625902,
+		0x3fff980c,		0x001fb7f5,		0x0812b0ff,
+		0x3fdf901c,		0x001fc7ed,		0x06b2fcfa,
+		0x3faf902d,		0x001fd3e8,		0x055348f1,
+		0x3f7f983f,		0x001fe3e5,		0x04038ce3,
+		0x3f3fa454,		0x001fefe3,		0x02e3c8d1,
+		0x3f0fb86a,		0x001ff7e4,		0x01c3e8c0,
+		0x3ecfd880,		0x000fffe6,		0x00c404ac },
+	},
+	{ 0x2200, {
+		0x3fdf9c0b,		0x3fdf9c0b,		0x09725cf4,
+		0x3fbf9818,		0x3fffa400,		0x0842a8f1,
+		0x3f8f9827,		0x000fb3f7,		0x0702f0ec,
+		0x3f5fa037,		0x000fc3ef,		0x05d330e4,
+		0x3f2fac49,		0x001fcfea,		0x04a364d9,
+		0x3effc05c,		0x001fdbe7,		0x038394ca,
+		0x3ecfdc6f,		0x001fe7e6,		0x0273b0bb,
+		0x3ea00083,		0x001fefe6,		0x0183c0a9 },
+	},
+	{ 0x2400, {
+		0x3f9fa014,		0x3f9fa014,		0x098260e6,
+		0x3f7f9c23,		0x3fcf9c0a,		0x08629ce5,
+		0x3f4fa431,		0x3fefa400,		0x0742d8e1,
+		0x3f1fb440,		0x3fffb3f8,		0x062310d9,
+		0x3eefc850,		0x000fbbf2,		0x050340d0,
+		0x3ecfe062,		0x000fcbec,		0x041364c2,
+		0x3ea00073,		0x001fd3ea,		0x03037cb5,
+		0x3e902086,		0x001fdfe8,		0x022388a5 },
+	},
+	{ 0x2600, {
+		0x3f5fa81e,		0x3f5fa81e,		0x096258da,
+		0x3f3fac2b,		0x3f8fa412,		0x088290d8,
+		0x3f0fbc38,		0x3fafa408,		0x0772c8d5,
+		0x3eefcc47,		0x3fcfa800,		0x0672f4ce,
+		0x3ecfe456,		0x3fefaffa,		0x05531cc6,
+		0x3eb00066,		0x3fffbbf3,		0x047334bb,
+		0x3ea01c77,		0x000fc7ee,		0x039348ae,
+		0x3ea04486,		0x000fd3eb,		0x02b350a1 },
+	},
+	{ 0x2800, {
+		0x3f2fb426,		0x3f2fb426,		0x094250ce,
+		0x3f0fc032,		0x3f4fac1b,		0x086284cd,
+		0x3eefd040,		0x3f7fa811,		0x0782acc9,
+		0x3ecfe84c,		0x3f9fa807,		0x06a2d8c4,
+		0x3eb0005b,		0x3fbfac00,		0x05b2f4bc,
+		0x3eb0186a,		0x3fdfb3fa,		0x04c308b4,
+		0x3eb04077,		0x3fefbbf4,		0x03f31ca8,
+		0x3ec06884,		0x000fbff2,		0x03031c9e },
+	},
+	{ 0x2a00, {
+		0x3f0fc42d,		0x3f0fc42d,		0x090240c4,
+		0x3eefd439,		0x3f2fb822,		0x08526cc2,
+		0x3edfe845,		0x3f4fb018,		0x078294bf,
+		0x3ec00051,		0x3f6fac0f,		0x06b2b4bb,
+		0x3ec0185f,		0x3f8fac07,		0x05e2ccb4,
+		0x3ec0386b,		0x3fafac00,		0x0502e8ac,
+		0x3ed05c77,		0x3fcfb3fb,		0x0432f0a3,
+		0x3ef08482,		0x3fdfbbf6,		0x0372f898 },
+	},
+	{ 0x2c00, {
+		0x3eefdc31,		0x3eefdc31,		0x08e238b8,
+		0x3edfec3d,		0x3f0fc828,		0x082258b9,
+		0x3ed00049,		0x3f1fc01e,		0x077278b6,
+		0x3ed01455,		0x3f3fb815,		0x06c294b2,
+		0x3ed03460,		0x3f5fb40d,		0x0602acac,
+		0x3ef0506c,		0x3f7fb006,		0x0542c0a4,
+		0x3f107476,		0x3f9fb400,		0x0472c89d,
+		0x3f309c80,		0x3fbfb7fc,		0x03b2cc94 },
+	},
+	{ 0x2e00, {
+		0x3eefec37,		0x3eefec37,		0x088220b0,
+		0x3ee00041,		0x3effdc2d,		0x07f244ae,
+		0x3ee0144c,		0x3f0fd023,		0x07625cad,
+		0x3ef02c57,		0x3f1fc81a,		0x06c274a9,
+		0x3f004861,		0x3f3fbc13,		0x060288a6,
+		0x3f20686b,		0x3f5fb80c,		0x05529c9e,
+		0x3f408c74,		0x3f6fb805,		0x04b2ac96,
+		0x3f80ac7e,		0x3f8fb800,		0x0402ac8e },
+	},
+	{ 0x3000, {
+		0x3ef0003a,		0x3ef0003a,		0x084210a6,
+		0x3ef01045,		0x3effec32,		0x07b228a7,
+		0x3f00284e,		0x3f0fdc29,		0x073244a4,
+		0x3f104058,		0x3f0fd420,		0x06a258a2,
+		0x3f305c62,		0x3f2fc818,		0x0612689d,
+		0x3f508069,		0x3f3fc011,		0x05728496,
+		0x3f80a072,		0x3f4fc00a,		0x04d28c90,
+		0x3fc0c07b,		0x3f6fbc04,		0x04429088 },
+	},
+	{ 0x3200, {
+		0x3f00103e,		0x3f00103e,		0x07f1fc9e,
+		0x3f102447,		0x3f000035,		0x0782149d,
+		0x3f203c4f,		0x3f0ff02c,		0x07122c9c,
+		0x3f405458,		0x3f0fe424,		0x06924099,
+		0x3f607061,		0x3f1fd41d,		0x06024c97,
+		0x3f909068,		0x3f2fcc16,		0x05726490,
+		0x3fc0b070,		0x3f3fc80f,		0x04f26c8a,
+		0x0000d077,		0x3f4fc409,		0x04627484 },
+	},
+	{ 0x3400, {
+		0x3f202040,		0x3f202040,		0x07a1e898,
+		0x3f303449,		0x3f100c38,		0x0741fc98,
+		0x3f504c50,		0x3f10002f,		0x06e21495,
+		0x3f706459,		0x3f1ff028,		0x06722492,
+		0x3fa08060,		0x3f1fe421,		0x05f2348f,
+		0x3fd09c67,		0x3f1fdc19,		0x05824c89,
+		0x0000bc6e,		0x3f2fd014,		0x04f25086,
+		0x0040dc74,		0x3f3fcc0d,		0x04825c7f },
+	},
+	{ 0x3600, {
+		0x3f403042,		0x3f403042,		0x0761d890,
+		0x3f504848,		0x3f301c3b,		0x0701f090,
+		0x3f805c50,		0x3f200c33,		0x06a2008f,
+		0x3fa07458,		0x3f10002b,		0x06520c8d,
+		0x3fd0905e,		0x3f1ff424,		0x05e22089,
+		0x0000ac65,		0x3f1fe81d,		0x05823483,
+		0x0030cc6a,		0x3f2fdc18,		0x04f23c81,
+		0x0080e871,		0x3f2fd412,		0x0482407c },
+	},
+	{ 0x3800, {
+		0x3f604043,		0x3f604043,		0x0721c88a,
+		0x3f80544a,		0x3f502c3c,		0x06d1d88a,
+		0x3fb06851,		0x3f301c35,		0x0681e889,
+		0x3fd08456,		0x3f30082f,		0x0611fc88,
+		0x00009c5d,		0x3f200027,		0x05d20884,
+		0x0030b863,		0x3f2ff421,		0x05621880,
+		0x0070d468,		0x3f2fe81b,		0x0502247c,
+		0x00c0ec6f,		0x3f2fe015,		0x04a22877 },
+	},
+	{ 0x3a00, {
+		0x3f904c44,		0x3f904c44,		0x06e1b884,
+		0x3fb0604a,		0x3f70383e,		0x0691c885,
+		0x3fe07451,		0x3f502c36,		0x0661d483,
+		0x00009055,		0x3f401831,		0x0601ec81,
+		0x0030a85b,		0x3f300c2a,		0x05b1f480,
+		0x0070c061,		0x3f300024,		0x0562047a,
+		0x00b0d867,		0x3f3ff41e,		0x05020c77,
+		0x00f0f46b,		0x3f2fec19,		0x04a21474 },
+	},
+	{ 0x3c00, {
+		0x3fb05c43,		0x3fb05c43,		0x06c1b07e,
+		0x3fe06c4b,		0x3f902c3f,		0x0681c081,
+		0x0000844f,		0x3f703838,		0x0631cc7d,
+		0x00309855,		0x3f602433,		0x05d1d47e,
+		0x0060b459,		0x3f50142e,		0x0581e47b,
+		0x00a0c85f,		0x3f400828,		0x0531f078,
+		0x00e0e064,		0x3f300021,		0x0501fc73,
+		0x00b0fc6a,		0x3f3ff41d,		0x04a20873 },
+	},
+	{ 0x3e00, {
+		0x3fe06444,		0x3fe06444,		0x0681a07a,
+		0x00007849,		0x3fc0503f,		0x0641b07a,
+		0x0020904d,		0x3fa0403a,		0x05f1c07a,
+		0x0060a453,		0x3f803034,		0x05c1c878,
+		0x0090b858,		0x3f70202f,		0x0571d477,
+		0x00d0d05d,		0x3f501829,		0x0531e073,
+		0x0110e462,		0x3f500825,		0x04e1e471,
+		0x01510065,		0x3f40001f,		0x04a1f06d },
+	},
+	{ 0x4000, {
+		0x00007044,		0x00007044,		0x06519476,
+		0x00208448,		0x3fe05c3f,		0x0621a476,
+		0x0050984d,		0x3fc04c3a,		0x05e1b075,
+		0x0080ac52,		0x3fa03c35,		0x05a1b875,
+		0x00c0c056,		0x3f803030,		0x0561c473,
+		0x0100d45b,		0x3f70202b,		0x0521d46f,
+		0x0140e860,		0x3f601427,		0x04d1d46e,
+		0x01810064,		0x3f500822,		0x0491dc6b },
+	},
+	{ 0x5000, {
+		0x0110a442,		0x0110a442,		0x0551545e,
+		0x0140b045,		0x00e0983f,		0x0531585f,
+		0x0160c047,		0x00c08c3c,		0x0511645e,
+		0x0190cc4a,		0x00908039,		0x04f1685f,
+		0x01c0dc4c,		0x00707436,		0x04d1705e,
+		0x0200e850,		0x00506833,		0x04b1785b,
+		0x0230f453,		0x00305c30,		0x0491805a,
+		0x02710056,		0x0010542d,		0x04718059 },
+	},
+	{ 0x6000, {
+		0x01c0bc40,		0x01c0bc40,		0x04c13052,
+		0x01e0c841,		0x01a0b43d,		0x04c13851,
+		0x0210cc44,		0x0180a83c,		0x04a13453,
+		0x0230d845,		0x0160a03a,		0x04913c52,
+		0x0260e047,		0x01409838,		0x04714052,
+		0x0280ec49,		0x01208c37,		0x04514c50,
+		0x02b0f44b,		0x01008435,		0x04414c50,
+		0x02d1004c,		0x00e07c33,		0x0431544f },
+	},
+	{ 0x7000, {
+		0x0230c83e,		0x0230c83e,		0x04711c4c,
+		0x0250d03f,		0x0210c43c,		0x0471204b,
+		0x0270d840,		0x0200b83c,		0x0451244b,
+		0x0290dc42,		0x01e0b43a,		0x0441244c,
+		0x02b0e443,		0x01c0b038,		0x0441284b,
+		0x02d0ec44,		0x01b0a438,		0x0421304a,
+		0x02f0f445,		0x0190a036,		0x04213449,
+		0x0310f847,		0x01709c34,		0x04213848 },
+	},
+	{ 0x8000, {
+		0x0280d03d,		0x0280d03d,		0x04310c48,
+		0x02a0d43e,		0x0270c83c,		0x04311047,
+		0x02b0dc3e,		0x0250c83a,		0x04311447,
+		0x02d0e040,		0x0240c03a,		0x04211446,
+		0x02e0e840,		0x0220bc39,		0x04111847,
+		0x0300e842,		0x0210b438,		0x04012445,
+		0x0310f043,		0x0200b037,		0x04012045,
+		0x0330f444,		0x01e0ac36,		0x03f12445 },
+	},
+	{ 0xefff, {
+		0x0340dc3a,		0x0340dc3a,		0x03b0ec40,
+		0x0340e03a,		0x0330e039,		0x03c0f03e,
+		0x0350e03b,		0x0330dc39,		0x03c0ec3e,
+		0x0350e43a,		0x0320dc38,		0x03c0f43e,
+		0x0360e43b,		0x0320d839,		0x03b0f03e,
+		0x0360e83b,		0x0310d838,		0x03c0fc3b,
+		0x0370e83b,		0x0310d439,		0x03a0f83d,
+		0x0370e83c,		0x0300d438,		0x03b0fc3c },
+	}
+};
+
 enum rcar_vin_state {
 	STOPPED = 0,
 	RUNNING,
@@ -161,6 +503,9 @@ struct rcar_vin_cam {
 	/* Client output, as seen by the VIN */
 	unsigned int			width;
 	unsigned int			height;
+	/* User window from S_FMT */
+	unsigned int out_width;
+	unsigned int out_height;
 	/*
 	 * User window from S_CROP / G_CROP, produced by client cropping and
 	 * scaling, VIN scaling and VIN cropping, mapped back onto the client
@@ -667,6 +1012,60 @@ static void rcar_vin_clock_stop(struct soc_camera_host *ici)
 	/* VIN does not have "mclk" */
 }
 
+static void set_coeff(struct rcar_vin_priv *priv, unsigned short xs)
+{
+	int i;
+	const struct vin_coeff *p_prev_set = NULL;
+	const struct vin_coeff *p_set = NULL;
+
+	/* Look for suitable coefficient values */
+	for (i = 0; i < ARRAY_SIZE(vin_coeff_set); i++) {
+		p_prev_set = p_set;
+		p_set = &vin_coeff_set[i];
+
+		if (xs < p_set->xs_value)
+			break;
+	}
+
+	/* Use previous value if its XS value is closer */
+	if (p_prev_set && p_set &&
+	    xs - p_prev_set->xs_value < p_set->xs_value - xs)
+		p_set = p_prev_set;
+
+	/* Set coefficient registers */
+	iowrite32(p_set->coeff_set[0], priv->base + VNC1A_REG);
+	iowrite32(p_set->coeff_set[1], priv->base + VNC1B_REG);
+	iowrite32(p_set->coeff_set[2], priv->base + VNC1C_REG);
+
+	iowrite32(p_set->coeff_set[3], priv->base + VNC2A_REG);
+	iowrite32(p_set->coeff_set[4], priv->base + VNC2B_REG);
+	iowrite32(p_set->coeff_set[5], priv->base + VNC2C_REG);
+
+	iowrite32(p_set->coeff_set[6], priv->base + VNC3A_REG);
+	iowrite32(p_set->coeff_set[7], priv->base + VNC3B_REG);
+	iowrite32(p_set->coeff_set[8], priv->base + VNC3C_REG);
+
+	iowrite32(p_set->coeff_set[9], priv->base + VNC4A_REG);
+	iowrite32(p_set->coeff_set[10], priv->base + VNC4B_REG);
+	iowrite32(p_set->coeff_set[11], priv->base + VNC4C_REG);
+
+	iowrite32(p_set->coeff_set[12], priv->base + VNC5A_REG);
+	iowrite32(p_set->coeff_set[13], priv->base + VNC5B_REG);
+	iowrite32(p_set->coeff_set[14], priv->base + VNC5C_REG);
+
+	iowrite32(p_set->coeff_set[15], priv->base + VNC6A_REG);
+	iowrite32(p_set->coeff_set[16], priv->base + VNC6B_REG);
+	iowrite32(p_set->coeff_set[17], priv->base + VNC6C_REG);
+
+	iowrite32(p_set->coeff_set[18], priv->base + VNC7A_REG);
+	iowrite32(p_set->coeff_set[19], priv->base + VNC7B_REG);
+	iowrite32(p_set->coeff_set[20], priv->base + VNC7C_REG);
+
+	iowrite32(p_set->coeff_set[21], priv->base + VNC8A_REG);
+	iowrite32(p_set->coeff_set[22], priv->base + VNC8B_REG);
+	iowrite32(p_set->coeff_set[23], priv->base + VNC8C_REG);
+}
+
 /* rect is guaranteed to not exceed the scaled camera rectangle */
 static int rcar_vin_set_rect(struct soc_camera_device *icd)
 {
@@ -676,6 +1075,7 @@ static int rcar_vin_set_rect(struct soc_camera_device *icd)
 	unsigned int left_offset, top_offset;
 	unsigned char dsize = 0;
 	struct v4l2_rect *cam_subrect = &cam->subrect;
+	u32 value;
 
 	dev_dbg(icd->parent, "Crop %ux%u@%u:%u\n",
 		icd->user_width, icd->user_height, cam->vin_left, cam->vin_top);
@@ -695,40 +1095,64 @@ static int rcar_vin_set_rect(struct soc_camera_device *icd)
 
 	/* Set Start/End Pixel/Line Pre-Clip */
 	iowrite32(left_offset << dsize, priv->base + VNSPPRC_REG);
-	iowrite32((left_offset + cam->width - 1) << dsize,
+	iowrite32((left_offset + cam_subrect->width - 1) << dsize,
 		  priv->base + VNEPPRC_REG);
 	switch (priv->field) {
 	case V4L2_FIELD_INTERLACED:
 	case V4L2_FIELD_INTERLACED_TB:
 	case V4L2_FIELD_INTERLACED_BT:
 		iowrite32(top_offset / 2, priv->base + VNSLPRC_REG);
-		iowrite32((top_offset + cam->height) / 2 - 1,
+		iowrite32((top_offset + cam_subrect->height) / 2 - 1,
 			  priv->base + VNELPRC_REG);
 		break;
 	default:
 		iowrite32(top_offset, priv->base + VNSLPRC_REG);
-		iowrite32(top_offset + cam->height - 1,
+		iowrite32(top_offset + cam_subrect->height - 1,
 			  priv->base + VNELPRC_REG);
 		break;
 	}
 
+	/* Set scaling coefficient */
+	value = 0;
+	if (cam_subrect->height != cam->out_height)
+		value = (4096 * cam_subrect->height) / cam->out_height;
+	dev_dbg(icd->parent, "YS Value: %x\n", value);
+	iowrite32(value, priv->base + VNYS_REG);
+
+	value = 0;
+	if (cam_subrect->width != cam->out_width)
+		value = (4096 * cam_subrect->width) / cam->out_width;
+
+	/* Horizontal upscaling is up to double size */
+	if (0 < value && value < 2048)
+		value = 2048;
+
+	dev_dbg(icd->parent, "XS Value: %x\n", value);
+	iowrite32(value, priv->base + VNXS_REG);
+
+	/* Horizontal upscaling is carried out by scaling down from double size */
+	if (value < 4096)
+		value *= 2;
+
+	set_coeff(priv, value);
+
 	/* Set Start/End Pixel/Line Post-Clip */
 	iowrite32(0, priv->base + VNSPPOC_REG);
 	iowrite32(0, priv->base + VNSLPOC_REG);
-	iowrite32((cam_subrect->width - 1) << dsize, priv->base + VNEPPOC_REG);
+	iowrite32((cam->out_width - 1) << dsize, priv->base + VNEPPOC_REG);
 	switch (priv->field) {
 	case V4L2_FIELD_INTERLACED:
 	case V4L2_FIELD_INTERLACED_TB:
 	case V4L2_FIELD_INTERLACED_BT:
-		iowrite32(cam_subrect->height / 2 - 1,
+		iowrite32(cam->out_height / 2 - 1,
 			  priv->base + VNELPOC_REG);
 		break;
 	default:
-		iowrite32(cam_subrect->height - 1, priv->base + VNELPOC_REG);
+		iowrite32(cam->out_height - 1, priv->base + VNELPOC_REG);
 		break;
 	}
 
-	iowrite32(ALIGN(cam->width, 0x10), priv->base + VNIS_REG);
+	iowrite32(ALIGN(cam->out_width, 0x10), priv->base + VNIS_REG);
 
 	return 0;
 }
@@ -1007,6 +1431,8 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 		cam->subrect = rect;
 		cam->width = mf.width;
 		cam->height = mf.height;
+		cam->out_width	= mf.width;
+		cam->out_height	= mf.height;
 
 		icd->host_priv = cam;
 	} else {
@@ -1267,6 +1693,9 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
 	dev_dbg(dev, "W: %u : %u, H: %u : %u\n",
 		vin_sub_width, pix->width, vin_sub_height, pix->height);
 
+	cam->out_width = pix->width;
+	cam->out_height = pix->height;
+
 	icd->current_fmt = xlate;
 
 	priv->field = field;
@@ -1318,8 +1747,12 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
-	pix->width = mf.width;
-	pix->height = mf.height;
+	/* Adjust only if VIN cannot scale */
+	if (pix->width > mf.width * 2)
+		pix->width = mf.width * 2;
+	if (pix->height > mf.height * 3)
+		pix->height = mf.height * 3;
+
 	pix->field = mf.field;
 	pix->colorspace = mf.colorspace;
 
-- 
1.9.3

