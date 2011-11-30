Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39801 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab1K3OiK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 09:38:10 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Gary Thomas <gary@mlbassoc.com>
CC: Javier Martinez Canillas <martinez.javier@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: Using MT9P031 digital sensor
Date: Wed, 30 Nov 2011 14:38:00 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A80461E3@DBDE01.ent.ti.com>
References: <4EB04001.9050803@mlbassoc.com>
 <201111281349.47411.laurent.pinchart@ideasonboard.com>
 <4ED639FE.7020503@mlbassoc.com>
 <201111301530.58977.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111301530.58977.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Wednesday, November 30, 2011 8:01 PM
> To: Gary Thomas
> Cc: Javier Martinez Canillas; Linux Media Mailing List
> Subject: Re: Using MT9P031 digital sensor
> 
> Hi Gary,
> 
> On Wednesday 30 November 2011 15:13:18 Gary Thomas wrote:
> > On 2011-11-28 05:49, Laurent Pinchart wrote:
> > > On Monday 28 November 2011 13:42:47 Gary Thomas wrote:
> > >> On 2011-11-28 04:07, Laurent Pinchart wrote:
> > >>> On Friday 25 November 2011 12:50:25 Gary Thomas wrote:
> > >>>> On 2011-11-24 04:28, Laurent Pinchart wrote:
> > >>>>> On Wednesday 16 November 2011 13:03:11 Gary Thomas wrote:
> > >>>>>> On 2011-11-15 18:26, Laurent Pinchart wrote:
> > >>>>>>> On Monday 14 November 2011 12:42:54 Gary Thomas wrote:
> > > [snip]
> > >
> > >>>>>>>> Here's my pipeline:
> > >>>>>>>>        media-ctl -r
> > >>>>>>>>        media-ctl -l '"mt9p031 3-005d":0->"OMAP3 ISP CCDC":0[1]'
> > >>>>>>>>        media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP
> preview":0[1]'
> > >>>>>>>>        media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP
> > >>>>>>>>        resizer":0[1]' media-ctl -l '"OMAP3 ISP resizer":1-
> >"OMAP3
> > >>>>>>>>        ISP resizer output":0[1]' media-ctl -f '"mt9p031
> > >>>>>>>>        3-005d":0[SGRBG12 2592x1944]' media-ctl -f  '"OMAP3 ISP
> > >>>>>>>>        CCDC":0 [SGRBG10 2592x1944]'
> > >>>>>>>>        media-ctl -f  '"OMAP3 ISP CCDC":1 [SGRBG10 2592x1944]'
> > >>>>>>>>        media-ctl -f  '"OMAP3 ISP preview":0 [SGRBG10
> 2592x1943]'
> > >>>>>>>>        media-ctl -f  '"OMAP3 ISP resizer":0 [YUYV 2574x1935]'
> > >>>>>>>>        media-ctl -f  '"OMAP3 ISP resizer":1 [YUYV 642x483]'
> > >>>>>>>>
> > >>>>>>>> The full media-ctl dump is at
> > >>>>>>>> http://www.mlbassoc.com/misc/pipeline.out
> > >>>>>>>>
> > >>>>>>>> When I try to grab from /dev/video6 (output node of resizer), I
> > >>>>>>>> see only previewer interrupts, no resizer interrrupts.  I added
> a
> > >>>>>>>> simple printk at each of the previewer/resizer *_isr functions,
> > >>>>>>>> and I only
> > >>>>>>>>
> > >>>>>>>> ever see this one:
> > >>>>>>>>        omap3isp_preview_isr_frame_sync.1373
> > >>>>>>>>
> > >>>>>>>> Can you give me an overview of what events/interrupts should
> occur
> > >>>>>>>> so I can try to trace through the ISP to see where it is
> failing?
> > >>>>>>>
> > >>>>>>> The CCDC generates VD0, VD1 and HS/VS interrupts regardless of
> > >>>>>>> whether it processes video or not, as long as it receives a
> video
> > >>>>>>> stream at its input. The preview engine and resizer will only
> > >>>>>>> generate an interrupt after writing an image to memory. With
> your
> > >>>>>>> above
> > >>>>>>> configuration VD0, VD1, HS/VS and resizer interrupts should be
> > >>>>>>> generated.
> > >>>>>>>
> > >>>>>>> Your pipeline configuration looks correct, except that the
> > >>>>>>> downscaling factor is slightly larger than 4. Could you try to
> > >>>>>>> setup the resizer to output a 2574x1935 image instead of
> 642x483 ?
> > >>>>>>> If that works, try to downscale to 660x496. If that works as
> well,
> > >>>>>>> the driver should be fixed to disallow resolutions that won't
> > >>>>>>> work.
> > >>>>>>
> > >>>>>> No change.  I also tried using only the previewer like this:
> > >>>>>>       media-ctl -r
> > >>>>>>       media-ctl -l '"mt9p031 3-005d":0->"OMAP3 ISP CCDC":0[1]'
> > >>>>>>       media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
> > >>>>>>       media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP preview
> > >>>>>>       output":0[1]' media-ctl -f '"mt9p031 3-005d":0[SGRBG12
> > >>>>>>       2592x1944]' media-ctl -f  '"OMAP3 ISP CCDC":0 [SGRBG12
> > >>>>>>       2592x1944]'
> > >>>>>>       media-ctl -f  '"OMAP3 ISP CCDC":1 [SGRBG10 2592x1944]'
> > >>>>>>       media-ctl -f  '"OMAP3 ISP preview":0 [SGRBG10 2592x1943]'
> > >>>>>>       media-ctl -f  '"OMAP3 ISP preview":1 [YUYV 2574x1935]'
> > >>>>>>
> > >>>>>>       yavta --capture=4 -f YUYV -s 2574x1935 -F /dev/video4
> > >>>>>>
> > >>>>>> I still only get the frame sync interrupts in the previewer, no
> > >>>>>> buffer interrupts, hence no data flowing to my application.  What
> > >>>>>> else can I look at?
> > >>>>>
> > >>>>> Do you get VD0 and VD1 interrupts ?
> > >>>>
> > >>>> Yes, the CCDC is working correctly, but nothing moves through the
> > >>>> previewer. Here's a trace of the interrupt sequence I get, repeated
> > >>>> over and over.  These are printed as __FUNCTION__.__LINE__
> > >>>> --- ccdc_vd0_isr.1615
> > >>>> --- ccdc_hs_vs_isr.1482
> > >>>> --- ccdc_vd1_isr.1664
> > >>>> --- omap3isp_preview_isr_frame_sync.1373
> > >>>>
> > >>>> What's the best tree to try this against?  3.2-rc2 doesn't have the
> > >>>> BT656 stuff in it yet, so I've been still using my older tree
> (3.0.0 +
> > >>>> drivers/media from your tree)
> > >>>
> > >>> I thought you were using an MT9P031 ? That doesn't require BT656
> > >>> support.
> > >>
> > >> True, but I have one board that supports either sensor and I want to
> > >> stay with one source tree.
> > >
> > > Sure, but let's start with a non-BT656 tree to rule out issues caused
> by
> > > BT656 patches. Could you please try mainline v3.1 ?
> >
> > This sort of works(*), but I'm still having issues (at least I can move
> > frames!) When I configure the pipeline like this:
> >    media-ctl -r
> >    media-ctl -l '"mt9p031 3-005d":0->"OMAP3 ISP CCDC":0[1]'
> >    media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
> >    media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1]'
> >    media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'
> >    media-ctl -f '"mt9p031 3-005d":0[SGRBG12 2592x1944]'
> >    media-ctl -f  '"OMAP3 ISP CCDC":0 [SGRBG12 2592x1944]'
> >    media-ctl -f  '"OMAP3 ISP CCDC":1 [SGRBG10 2592x1944]'
> >    media-ctl -f  '"OMAP3 ISP preview":0 [SGRBG10 2592x1943]'
> >    media-ctl -f  '"OMAP3 ISP resizer":0 [YUYV 2574x1935]'
> >    media-ctl -f  '"OMAP3 ISP resizer":1 [YUYV 660x496]'
> > the resulting frames are 666624 bytes each instead of 654720
> >
> > When I tried to grab from the previewer, the frames were 9969120 instead
> of
> > 9961380
> >
> > Any ideas what resolution is actually being moved through?
> 
> Because the OMAP3 ISP has alignment requirements. Both the preview engine
> and
> the resizer output line lenghts must be multiple of 32 bytes. The driver
> adds
> padding at end of lines when the output width isn't a multiple of 16
> pixels.
> 
> So this means that your original problem comes from the BT656 patches.
> 
> > (*) to build on v3.1, I had to manually add the mt9p031 driver and fix a
> > compile error in drivers/media/video/omap/omap_vout.c
> 
> I'm surprised that omap_vout doesn't compile on v3.1. What was the error ?
> 
Do you have below patch in your kernel baseline -

commit 5ebbf72dc51bd3b481aa91fea37a7157da5fc548
Author: archit taneja <archit@ti.com>
Date:   Fri Aug 5 04:19:21 2011 -0300

    [media] OMAP_VOUT: Fix build break caused by update_mode removal in DSS2

Thanks,
Vaibhav


> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
