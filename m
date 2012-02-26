Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36948 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab2BZXQ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 18:16:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Chris Whittenburg <whittenburg@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: OMAP CCDC with sensors that are always on...
Date: Mon, 27 Feb 2012 00:16:34 +0100
Message-ID: <4984891.IGZ3Td2Zlk@avalon>
In-Reply-To: <20120224234801.GB12602@valkosipuli.localdomain>
References: <CABcw_OmQEV2K0Hgvnh7xtCNQUmf5pa4ftZJwRFdkM68Hftp=Rg@mail.gmail.com> <CABcw_Om4VNCn_a73tZBBgb_1OzVTQRkQWDZcoasT6CA-JasH+w@mail.gmail.com> <20120224234801.GB12602@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On Saturday 25 February 2012 01:48:02 Sakari Ailus wrote:
> On Fri, Feb 17, 2012 at 05:32:31PM -0600, Chris Whittenburg wrote:
> > I fixed my sensor to respect a "run" signal from the omap, so that now
> > it only sends data when the ccdc is expecting it.
> > 
> > This fixed my problem, and now I can capture the 640x1440 frames.
> > 
> > At least the first one...
> > 
> > Subsequent frames are always full of 0x55, like the ISP didn't write
> > anything into them.
> > 
> > I still get the VD0 interrupts, and I checked that WEN in the
> > CCDC_SYN_MODE register is set, and that the EXWEN bit is clear.
> > 
> > I'm using the command:
> > yavta -c2 -p -F --skip 0 -f Y8 -s 640x1440 /dev/video2
> > 
> > Here are my register settings:
> > 
> > [ 6534.029907] omap3isp omap3isp: -------------CCDC Register
> > dump------------- [ 6534.029907] omap3isp omap3isp: ###CCDC
> > PCR=0x00000000
> > [ 6534.029937] omap3isp omap3isp: ###CCDC SYN_MODE=0x00030f00
> > [ 6534.029937] omap3isp omap3isp: ###CCDC HD_VD_WID=0x00000000
> > [ 6534.029937] omap3isp omap3isp: ###CCDC PIX_LINES=0x00000000
> > [ 6534.029968] omap3isp omap3isp: ###CCDC HORZ_INFO=0x0000027f
> > [ 6534.029968] omap3isp omap3isp: ###CCDC VERT_START=0x00000000
> > [ 6534.029968] omap3isp omap3isp: ###CCDC VERT_LINES=0x0000059f
> > [ 6534.029998] omap3isp omap3isp: ###CCDC CULLING=0xffff00ff
> > [ 6534.029998] omap3isp omap3isp: ###CCDC HSIZE_OFF=0x00000280
> > [ 6534.029998] omap3isp omap3isp: ###CCDC SDOFST=0x00000000
> > [ 6534.030029] omap3isp omap3isp: ###CCDC SDR_ADDR=0x00001000
> > [ 6534.030029] omap3isp omap3isp: ###CCDC CLAMP=0x00000010
> > [ 6534.030029] omap3isp omap3isp: ###CCDC DCSUB=0x00000000
> > [ 6534.030059] omap3isp omap3isp: ###CCDC COLPTN=0xbb11bb11
> > [ 6534.030059] omap3isp omap3isp: ###CCDC BLKCMP=0x00000000
> > [ 6534.030059] omap3isp omap3isp: ###CCDC FPC=0x00000000
> > [ 6534.030090] omap3isp omap3isp: ###CCDC FPC_ADDR=0x00000000
> > [ 6534.030090] omap3isp omap3isp: ###CCDC VDINT=0x059e03c0
> > [ 6534.030090] omap3isp omap3isp: ###CCDC ALAW=0x00000000
> > [ 6534.030120] omap3isp omap3isp: ###CCDC REC656IF=0x00000000
> > [ 6534.030120] omap3isp omap3isp: ###CCDC CFG=0x00008000
> > [ 6534.030120] omap3isp omap3isp: ###CCDC FMTCFG=0x0000e000
> > [ 6534.030151] omap3isp omap3isp: ###CCDC FMT_HORZ=0x00000280
> > [ 6534.030151] omap3isp omap3isp: ###CCDC FMT_VERT=0x000005a0
> > [ 6534.030151] omap3isp omap3isp: ###CCDC PRGEVEN0=0x00000000
> > [ 6534.030181] omap3isp omap3isp: ###CCDC PRGEVEN1=0x00000000
> > [ 6534.030181] omap3isp omap3isp: ###CCDC PRGODD0=0x00000000
> > [ 6534.030181] omap3isp omap3isp: ###CCDC PRGODD1=0x00000000
> > [ 6534.030212] omap3isp omap3isp: ###CCDC VP_OUT=0x0b3e2800
> > [ 6534.030212] omap3isp omap3isp: ###CCDC LSC_CONFIG=0x00006600
> > [ 6534.030212] omap3isp omap3isp: ###CCDC LSC_INITIAL=0x00000000
> > [ 6534.030242] omap3isp omap3isp: ###CCDC LSC_TABLE_BASE=0x00000000
> > [ 6534.030242] omap3isp omap3isp: ###CCDC LSC_TABLE_OFFSET=0x00000000
> > [ 6534.030242] omap3isp omap3isp:
> > --------------------------------------------
> > 
> > Output frame 0 is always good, while output frame 1 is 0x5555.
> > 
> > I believe my sensor is respecting the clocks required before and after
> > the frame.
> > 
> > Could the ISP driver be writing my data to some unexpected location
> > rather than to the v4l2 buffer?
> > 
> > Is there a way to determine if the CCDC is writing to memory or not?
> 
> How long vertical blanking do you have? It shouldn't have an effect, though.

It definitely can :-) If vertical blanking isn't long enough, the CCDC will 
start processing the next frame before the driver gets time to update the 
hardware with the pointer to the next buffer. The first frame will then be 
overwritten.

> Is the polarity of the hs/vs signals correct in platform data?
> 
> > On Wed, Feb 15, 2012 at 11:29 AM, Chris Whittenburg
> > 
> > <whittenburg@gmail.com> wrote:
> > > Maybe this is more of a OMAP specific question, but I'm using a
> > > beagleboard-xm with a custom image sensor on a 3.0.17 kernel.
> > > 
> > > Everything configures ok with:
> > > 
> > > media-ctl -r
> > > media-ctl -l '"xrtcam 2-0048":0->"OMAP3 ISP CCDC":0[1]'
> > > media-ctl -l '"OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> > > media-ctl -f '"xrtcam 2-0048":0 [Y8 640x1440]'
> > > media-ctl -f '"OMAP3 ISP CCDC":1 [Y8 640x1440]'
> > > media-ctl -e 'OMAP3 ISP CCDC output'
> > > 
> > > root@beagleboard:~# ./setup.sh
> > > Resetting all links to inactive
> > > Setting up link 16:0 -> 5:0 [1]
> > > Setting up link 5:1 -> 6:0 [1]
> > > Setting up format Y8 640x1440 on pad irtcam 2-0048/0
> > > Format set: Y8 640x1440
> > > Setting up format Y8 640x1440 on pad OMAP3 ISP CCDC/0
> > > Format set: Y8 640x1440
> > > Setting up format Y8 640x1440 on pad OMAP3 ISP CCDC/1
> > > Format set: Y8 640x1440
> > > /dev/video2
> > > 
> > > But when I go to capture, with:
> > > yavta -c2 -p -F --skip 0 -f Y8 -s 640x1440 /dev/video2
> > > 
> > > I don't seem to get any interrupts.  Actually I get some HS_VS_IRQ
> > > after I launch yavta, but before I press return at the "Press enter to
> > > start capture" prompt.  After that, I don't believe I am getting any
> > > interrupts.
> > > 
> > > The one problem I see is that my sensor is always spewing data into
> > > the CCDC on HS,VS, PCLK, and D0 to D7.
> > > 
> > > I know I have been told with other sensors that I need to only turn
> > > XCLK on to the sensor when I am capturing.
> > > 
> > > Could this be my problem here?  What exactly happens if you are always
> > > sending data?  Does the ISP get hung up?
> > > 
> > > Thanks for any pointers,
> > > Chris

-- 
Regards,

Laurent Pinchart
