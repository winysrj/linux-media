Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35429 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZBDPWU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2009 10:22:20 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: halli manjunatha <hallimanju@gmail.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Nagalla, Hari" <hnagalla@ti.com>
Date: Wed, 4 Feb 2009 09:22:13 -0600
Subject: RE: Missing first 4 frames
Message-ID: <A24693684029E5489D1D202277BE894420665A17@dlee02.ent.ti.com>
In-Reply-To: <ca6476860902040437h710ab4echd5e837502ce796d3@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: video4linux-list-bounces@redhat.com [mailto:video4linux-list-
> bounces@redhat.com] On Behalf Of halli manjunatha
> Sent: Wednesday, February 04, 2009 6:37 AM
> To: video4linux-list@redhat.com
> Subject: Missing first 4 frames
> 
> Hi ,
>        I am working on omap3 custom board and using the TI's camera
> patches
> on 2.6.28 kernel  and the problem is that first 4 frames are coming 1/4 of
> HVGA but i am capturing HVGA  images. after 4 frames everything is normal.

Hi,

(Looping linux-omap ML, and replacing v4l with linux-media ML)

I have some questions for you:

- The camera sensor you are using, is it:
	- Interfaced to OMAP through: Parallel, CCP2, or CSI2?
	- Raw (without internal ISP: Image Signal Processing) or smart (With ISP)
	- Which pixel format are you requesting?

- Which patchset did you use? The ones submitted on:
	- 12 Jan 2009 or
	- 12 Dec 2008

- The frames you're getting are stored with a wrong filesize? Or you're getting an incomplete frame?

- Can you describe me the steps you take for capturing (if its possible, your V4L2 test app source)

Regards,
Sergio

> 
>       I don't wether it is the right list to say this problem, please guid
> me where to look, following is my register dump
> 
> 
> ###CM_FCLKEN_CAM=0x3
> ###CM_ICLKEN_CAM=0x1
> ###CM_CLKSEL_CAM=0x4
> ###CM_AUTOIDLE_CAM=0x1
> ###CM_CLKEN_PLL[18:16] should be 0x7, = 0x90371037
> ###CM_CLKSEL2_PLL[18:8] should be 0x2D, [6:0] should be 1 = 0x1b00c
> ###CTRL_PADCONF_CAM_HS=0x1080108
> ###CTRL_PADCONF_CAM_XCLKA=0x1080108
> ###CTRL_PADCONF_CAM_D1=0x1000100
> ###CTRL_PADCONF_CAM_D3=0x1080100
> ###CTRL_PADCONF_CAM_D5=0x1080108
> ###CTRL_PADCONF_CAM_D7=0x1080108
> ###CTRL_PADCONF_CAM_D9=0x1080108
> ###CTRL_PADCONF_CAM_D11=0x108
> ###ISP_CTRL=0x3bf188
> ###ISP_TCTRL_CTRL=0x9
> ###ISP_SYSCONFIG=0x2000
> ###ISP_SYSSTATUS=0x1
> ###ISP_IRQ0ENABLE=0x90000300
> ###ISP_IRQ0STATUS=0x0
> ###CCDC PCR=0x1
> ISP_CTRL =0x3bf188
> ###ISP_CTRL in ccdc =0x3bf188
> ###ISP_IRQ0ENABLE in ccdc =0x90000300
> ###ISP_IRQ0STATUS in ccdc =0x0
> ###CCDC SYN_MODE=0x31700
> ###CCDC HORZ_INFO=0x13f
> ###CCDC VERT_START=0x0
> ###CCDC VERT_LINES=0x1df
> ###CCDC CULLING=0xffff00ff
> ###CCDC HSIZE_OFF=0x280
> ###CCDC SDOFST=0x0
> ###CCDC SDR_ADDR=0x4000000
> ###CCDC CLAMP=0x10
> ###CCDC COLPTN=0x0
> ###CCDC CFG=0x8000
> ###CCDC VP_OUT=0x0
> ###CCDC_SDR_ADDR= 0x4000000
> ###CCDC FMTCFG=0x4000
> ###CCDC FMT_HORZ=0x0
> ###CCDC FMT_VERT=0x0
> ###CCDC LSC_CONFIG=0x6600
> ###CCDC LSC_INIT=0x0
> ###CCDC LSC_TABLE BASE=0x0
> ###CCDC LSC TABLE OFFSET=0x0
> 
> Thanks in advance
> --
> Regards
> 
> Hall
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

