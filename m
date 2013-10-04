Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-m07.mx.aol.com ([64.12.143.81]:43268 "EHLO
	omr-m07.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3JDTH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 15:07:27 -0400
Message-ID: <524F0F57.5020605@netscape.net>
Date: Fri, 04 Oct 2013 15:56:23 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWlyb3NsYXYgU2x1Z2XFiA==?= <thunder.mmm@gmail.com>,
	linux-media@vger.kernel.org,
	=?UTF-8?B?TWlyb3NsYXYgU2x1Z2XFiA==?= <thunder.m@email.cz>
Subject: Re: cx23885: Add basic analog radio support
References: <CAEN_-SBR5qGJfUk6h+n04Q4zP-zofiLO+Jr6pOBJU2nqYBuDWQ@mail.gmail.com>
In-Reply-To: <CAEN_-SBR5qGJfUk6h+n04Q4zP-zofiLO+Jr6pOBJU2nqYBuDWQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060506000907060905090002"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060506000907060905090002
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi all


El 14/01/12 15:25, Miroslav Slugeň escribió:
> New version of patch, fixed video modes for DVR3200 tuners and working
> audio mux.

I tested this patch (https://linuxtv.org/patch/9498/) with the latest 
versions of git (September 28, 2013) with my TV card (Mygica X8507) and 
it works.
I found some issue, although it may be through a bad implementation of mine.

Details of them:

1) Some warning when compiling

...
   CC [M] 
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.o
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1910:8: 
: initialization from incompatible pointer type [enabled by default]
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1910:8: 
warning: (near initialization for 'radio_ioctl_ops.vidioc_s_tuner') 
[enabled by default]
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1911:8: 
warning: initialization from incompatible pointer type [enabled by default]
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1911:8: 
warning: (near initialization for 'radio_ioctl_ops.vidioc_s_audio') 
[enabled by default]
   CC [M] /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-vbi.o
...

--------------------------------------------------------
static const struct v4l2_ioctl_ops radio_ioctl_ops = {

        .vidioc_s_tuner       = radio_s_tuner, /* line 1910 */
        .vidioc_s_audio       = radio_s_audio, /* line 1911 */

--------------------------------------------------------

2)
No reports signal strength or stereo signal with KRadio. XC5000 neither 
reported (modprobe xc5000 debug=1). Maybe a feature XC5000.
To listen in stereo, sometimes, you have to turn on the Digital TV then 
Analog TV and then radio.

3)
To listen Analog TV I need changed to NTSC standard and then PAL-Nc (the 
norm in my country is PAL-Nc). If I leave the tune in NTSC no problem 
with sound.
The patch (https://linuxtv.org/patch/9505/) corrects the latter, if used 
tvtime with xawtv not always.
If I see-Digital TV (ISDB-T), then so as to listen the radio I have 
first put the TV-Analog, because I hear very low and a strong white noise.
The latter is likely to be corrected by resetting the tuner, I have to 
study it more.

I put below attached the patch applied to the plate: X8507.

Have you done any update of this patch?

Thanks

--------------060506000907060905090002
Content-Type: text/x-patch;
 name="X8507-radio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="X8507-radio.patch"

 .../media/pci/cx23885/{ => }/media/pci/cx23885/cx23885-cards.c   |    6 ++++++
 drivers/media/pci/cx23885/{ => }/media/pci/cx23885/cx23885-dvb.c |    1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 6a71a96..324809a 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -526,16 +526,18 @@ struct cx23885_board cx23885_boards[] = {
 			.amux   = CX25840_AUDIO7,
 			.gpio0  = 0,
 		} },
 	},
 	[CX23885_BOARD_MYGICA_X8507] = {
 		.name		= "Mygica X8502/X8507 ISDB-T",
 		.tuner_type = TUNER_XC5000,
 		.tuner_addr = 0x61,
+		.radio_type	= TUNER_XC5000,
+		.radio_addr	= 0x61,
 		.tuner_bus	= 1,
 		.porta		= CX23885_ANALOG_VIDEO,
 		.portb		= CX23885_MPEG_DVB,
 		.input		= {
 			{
 				.type   = CX23885_VMUX_TELEVISION,
 				.vmux   = CX25840_COMPOSITE2,
 				.amux   = CX25840_AUDIO8,
@@ -555,16 +557,20 @@ struct cx23885_board cx23885_boards[] = {
 				.type   = CX23885_VMUX_COMPONENT,
 				.vmux   = CX25840_COMPONENT_ON |
 					CX25840_VIN1_CH1 |
 					CX25840_VIN6_CH2 |
 					CX25840_VIN7_CH3,
 				.amux   = CX25840_AUDIO7,
 			},
 		},
+		.radio = {
+				.type= CX23885_RADIO,
+				.amux= CX25840_AUDIO8,
+			},
 	},
 	[CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL] = {
 		.name		= "TerraTec Cinergy T PCIe Dual",
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
 	},
 	[CX23885_BOARD_TEVII_S471] = {
 		.name		= "TeVii S471",
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 971e4ff..4e946b2 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -495,16 +495,17 @@ static struct xc5000_config mygica_x8506_xc5000_config = {
 
 static struct mb86a20s_config mygica_x8507_mb86a20s_config = {
 	.demod_address = 0x10,
 };
 
 static struct xc5000_config mygica_x8507_xc5000_config = {
 	.i2c_address = 0x61,
 	.if_khz = 4000,
+	.radio_input = XC5000_RADIO_FM1,
 };
 
 static struct stv090x_config prof_8000_stv090x_config = {
 	.device                 = STV0903,
 	.demod_mode             = STV090x_SINGLE,
 	.clk_mode               = STV090x_CLK_EXT,
 	.xtal                   = 27000000,
 	.address                = 0x6A,

--------------060506000907060905090002--
