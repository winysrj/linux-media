Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:51234 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0JTNZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 09:25:34 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hal Moroff <halm90@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 20 Oct 2010 18:55:28 +0530
Subject: RE: soc_camera device
Message-ID: <19F8576C6E063C45BE387C64729E739404AA4E7B96@dbde02.ent.ti.com>
References: <AANLkTin4w=0sheXsfsPve7ivjrdUO-+9mHCCbwCkW=cP@mail.gmail.com>
 <AANLkTinw9xUPRv=gXM6KtnXEdtdMbz_TJKKV+ojm6+C0@mail.gmail.com>
In-Reply-To: <AANLkTinw9xUPRv=gXM6KtnXEdtdMbz_TJKKV+ojm6+C0@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Hal Moroff
> Sent: Wednesday, October 20, 2010 3:29 AM
> To: linux-media@vger.kernel.org
> Subject: soc_camera device
> 
> I'm pretty new to Linux video drivers (I do have experience with
> drivers in general) and am trying to get my head
> around the driver models.  Sorry if this is too basic a question for this
> forum.
> 
> I have an OMAP 3530 running Arago Linux (2.6.32 at the moment),
[Hiremath, Vaibhav] Are you using OMAP3EVM? Then we already have basic support for Aptima sensor MT9T111 available at 

http://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git?p=people/vaibhav/ti-psp-omap-video.git;a=shortlog;h=refs/heads/omap3cam-mc-devel

Thanks,
Vaibhav


> and
> I'm trying to capture images from an Aptina
> sensor for which there does not seem to be a driver.
> 
> There seem to be soc_camera, soc_camera-int, v4l2, omap34xxcam drivers
> at the very least.  I'm pretty confused
> over these and how they do or don't work with V4L2 and/or each other.
> 
> It seems that some of the driver models are deprecated (but still in
> use), and that soc_camera is current.  Or is it?
> 
> 2 things in particular at the moment are giving me a hard time:
>   1. I can't seem to load soc_camera.ko ... I keep getting the error:
>       soc_camera: exports duplicate symbol soc_camera_host_unregister
> (owned by kernel)
>       I can't seem to resolve this, nor can I find the issue described
> in any online forum (and so
>       I suspect it's my problem).
> 
>   2. There are drivers for the Aptina MT9V022 and the MT9M001 (among
> others).  Both of these
>       are sensors, and not SOC, and yet both of these rely on the
> soc_camera module.  I'm willing
>       to create the driver for my Aptina sensor, and the easiest way
> is generally to look at a known
>       driver as a template, however I can't figure out which to look at.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
