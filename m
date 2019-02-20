Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B1B3C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 08:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBB4F20700
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 08:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbfBTIM0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 03:12:26 -0500
Received: from mout.gmx.net ([212.227.15.18]:53761 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbfBTIMZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 03:12:25 -0500
Received: from axis700.grange ([87.78.226.14]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LxgM7-1h7tBw4Aax-017HGj; Wed, 20
 Feb 2019 09:12:20 +0100
Received: by axis700.grange (Postfix, from userid 1000)
        id CDF2F61CCF; Wed, 20 Feb 2019 09:12:17 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by axis700.grange (Postfix) with ESMTP id B1C8561C80;
        Wed, 20 Feb 2019 09:12:17 +0100 (CET)
Date:   Wed, 20 Feb 2019 09:12:17 +0100 (CET)
From:   Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To:     =?ISO-8859-15?Q?Moritz_D=F6tterl?= 
        <moritz.doetterl@pentlandfirth.com>
cc:     "linux-uvc-devel@lists.berlios.de" <linux-uvc-devel@lists.berlios.de>,
        "kieran.bingham@ideasonboard.com" <kieran.bingham@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [linux-uvc-devel] metadata device file
In-Reply-To: <AM0PR10MB2788437E98A6CFB2780A7026F07D0@AM0PR10MB2788.EURPRD10.PROD.OUTLOOK.COM>
Message-ID: <alpine.DEB.2.20.1902200908540.16595@axis700.grange>
References: <d6a7d5e54acd4cb6b71eacf0724a92e4AM0PR10MB2788C3DEE0DF6144DAFA6FA1F0600@AM0PR10MB2788.EURPRD10.PROD.OUTLOOK.COM>,<d7b02766-b920-8cf7-9db8-275dfc22851c@ideasonboard.com>
 <AM0PR10MB2788437E98A6CFB2780A7026F07D0@AM0PR10MB2788.EURPRD10.PROD.OUTLOOK.COM>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:ILDQT2vmOYFG/Y3SwgnzlrAX4v1KYoiPGMvX0F3pyUBZoe5Pa1K
 jPPu4jC6+lJ0t6tHlApbnwcpXA0QBRXr0yWiDTcE2Sfw3G5rXa7XNop+dGikZe/lymQVQjc
 19XjXwuWNvIJJru4pzgQ4145W55TzX/oBEMXA5xEcpjP6Ld3Y0dRmWaj309f2a23h2S3lFJ
 TVELZ/K3nGOjrqcVmLCUg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:BwElpfsER48=:X3Url8ykdIjAm5MY1mkq93
 ESFcX7v1xR3wCNvKXGqOKIgykBSWG0lO7b1cgBMEBw05ViL+YDe1MOpmbr5qx/5PX0K2y2/uJ
 0eiYq+vb80coK7b8VhxnIE7BQdECnKFIhLWOceEUFzYEGMUvQ1/jBCgcpTT9WF+CCmBojRtFI
 L+dvOHwGLk35vPUJfmolMkd5eXApn0oJzYqEkS2cN5sfN1+vvBIlbI8HaVeYD1KMBPENbNMnQ
 1CKtFqFWNvMCVW+79jPga61FQ/5rH+HzdjTQcPXRS8rSmehClPilj4s0K3+FUCzNm6YCrz30L
 idd4tiNAxhcGzjPfe9zWv0ndRI7fjMaRNvaJNa5z7DGqxiGzN7YK+9ctKbDx+3ljkN4UsPZBl
 xJjYSk69Qry4icnutbp4SPkbxhcCTWCeGdUhLBvOv90HPHMxMtEYKfhm5yj2yNmZizwyyQza/
 MsFgSZLLQ+odmARbqs54md7477GTsipWitONbxzMt/FNDTP8vGsRVKDytp5/yqmyR6jhuNuZ1
 0Gh/d+A3brQGxcZPwdOE5/x6bTNNurnXTl7GVA54YnEamQTQ43mIZXpaXaDZzS7ipGV6DQsgi
 etJf3QHr/h+kGqsWuC7E8AlYC76se7wlXH84PqTioAXdB/+ZUqEeuX/jPnfhPd78URHGl5zHI
 K1Ggz9XF/EHeAiCmfMuNwyxQK2NXRRASwdyWDpcxFEVSEWdmvzmJAMxzXM0vY9RwAC2HGh8Ji
 88DJ/klEJ47r7qY67I4hA06acUFJdPQHe02qIn58u8cGQHYSdhisUtxSg7uiAR6ca1q0xtcbE
 C77eL2X6NY3YejzVccIQrEX3e8ehT9DJIBugooyz0lJ79n6lPoU81xVk4O8c0SiHPQFaX9V6L
 iJRLK5GVguzUShcoQxIskwtZE/AbFTBRCcb1OUtxN2uJZevV2pcRdug/Iyps5j6//4+qzvGkC
 vzKokytFerw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Moritz,

On Wed, 20 Feb 2019, Moritz Dötterl wrote:

> Hi Kieran
> 
> 
> Thank you very much for your explanation.
> 
> At least in the setup we are using every /dev/video device is a capture device.
> 
> Wouldn't it be good to have that configurable with a module parameter?

I don't think it would. It can be argued whether the decision to add video 
metadata device nodes as /dev/video* was the best choice possible, but 
once the choice has been made, I think our best option now is to convert 
all users to be prepared to handle them.

Thanks
Guennadi

> Best regards / Mit freundlichen Grüßen
> Moritz Dötterl
> 
> Pentland Firth Software GmbH
> 
> Hofmannstr. 61
> 81379 München, Germany
> 
> Mobile: +49 17655389056
> 
> moritz.doetterl@pentlandfirth.com<mailto:aron.borbath@pentlandfirth.com>
> 
> ----------------------------------------------------------------------------------------------------------------------------------
> Pentland Firth is Microsoft Gold Partner
> 
> Brands we own:  www.whiz-cart.com<http://www.whiz-cart.com/>
> ----------------------------------------------------------------------------------------------------------------------------------
> Sitz der Gesellschaft: München, Handelsregister München, HRB 155 786, Geschäftsführer: Frank Heinrich
> 
> 
> ________________________________
> From: Kieran Bingham <kieran.bingham@ideasonboard.com>
> Sent: Friday, February 15, 2019 9:51:08 PM
> To: Moritz Dötterl; linux-uvc-devel@lists.berlios.de
> Cc: Linux Media Mailing List; Laurent Pinchart; Guennadi Liakhovetski
> Subject: Re: [linux-uvc-devel] metadata device file
> 
> Hi Moritz,
> 
> On 15/02/2019 08:45, Moritz Dötterl wrote:
> > Hello
> >
> > Recently we updated the Kernel on our Ubuntu machines from 4.15 to 4.18
> > because the OS was randomly freezing. However with the new Kernel we ran
> > into a problem regarding our two webcams. We had two /dev/video device
> > files per camera of which only one seemed to work.
> 
> Yes, a new device node has been added to represent the meta-data from
> the device.
> 
> You should be able to enumerate the devices, and you should
> verify/validate the capabilities of the device after you open it.
> 
> A UVC capture device will expose the V4L2_CAP_VIDEO_OUTPUT capability flag.
> 
> > The problem was that
> > our application would just randomly open one of those two device files
> 
> Is this an application you have control over the source code for?
> or some external application?
> 
> > and then crashed if it opened the wrong one. After some search i figured
> > out that the second device file is for meta data (which might not be
> > provided by our camera i guess...). However i also found the line in the
> > uvc_driver.c which generates the device file
> > (https://elixir.bootlin.com/linux/v4.18/source/drivers/media/usb/uvc/uvc_driver.c#L2005)
> > that line including the whole uvc_metadata.c was added when comparing
> > 4.15 and 4.18 Kernel. I took that line out, recompiled the Kernel and
> > ended up with having only one /dev/video device file per camera. I also
> > found it is using the exact same function to register the device node
> > that the uvc_driver.c is using and also using the same vfl_devnode_type
> >  (VFL_TYPE_GRABBER) and therefore ending up as a /dev/video device. Was
> > that move on purpose?
> 
> Yes, this addition was on purpose. It was added by the following patch:
> 
> https://www.spinics.net/lists/linux-media/msg125681.html
> 
> I've added the linux-media mailing list on Cc where you will be able to
> find better support if this topic causes further problems.
> 
> 
> > Why was it split up in two device files, or is
> > that just added functionality?
> 
> I believe it is just added functionality - not split.
> 
> > I would rather like this device file to
> > have a different name because in this setup it is not easily decidable
> 
> Perhaps some different naming might have continued to hide this issue
> for you but it would only have hidden a potential bug.
> 
> Even with a different name, you can not expect that all /dev/video*
> nodes are capture devices. They can be output devices or M2M devices for
> example. Your application should always check the device capabilities
> using the V4L2 API's as applicable.
> 
> 
> > if a /dev/video device is the "real" webcam or just the meta data... So
> > i would prefer that to end up as something like /dev/metavideo or so (
> > or maybe easier: change the type to VFL_TYPE_SUBDEV so it will end up as
> > a v4l-subdev device, that sounds more suitable for me...)
> 
> I think in this instance it has to be a full video node and not a subdev
> so that data can be captured from the device node.
> 
> 
> > What are the plans for this in future kernel versions? Should it stay
> > like it is now or are there plans to change/evolve the meta data
> > handling again?
> 
> This is in mainline now - so I would expect it to continue to be supported.
> 
> >
> >
> > Thanks very much.
> >
> >
> > Best regards / Mit freundlichen Grüßen
> > *Moritz Dötterl*
> >
> > Pentland Firth Software GmbH
> >
> > Hofmannstr. 61
> > 81379 München, Germany
> >
> > Mobile: +49 17655389056
> >
> > moritz.doetterl@pentlandfirth.com <mailto:aron.borbath@pentlandfirth.com>
> >
> > ----------------------------------------------------------------------------------------------------------------------------------
> > Pentland Firth is *Microsoft Gold Partner*
> >
> > Brands we own:  www.whiz-cart.com<http://www.whiz-cart.com> <http://www.whiz-cart.com/>
> > ----------------------------------------------------------------------------------------------------------------------------------
> > Sitz der Gesellschaft: München, Handelsregister München, HRB 155 786,
> > Geschäftsführer: Frank Heinrich
> >
> >
> >
> >
> > _______________________________________________
> > Linux-uvc-devel mailing list
> > Linux-uvc-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-uvc-devel
> >
> 
> --
> Regards
> --
> Kieran
> 
