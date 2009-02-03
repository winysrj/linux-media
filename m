Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:34119 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZBCKsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2009 05:48:45 -0500
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KEH00K7LKP8R7@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Feb 2009 19:48:44 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KEH00IAWKP4U2@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Feb 2009 19:48:40 +0900 (KST)
Date: Tue, 03 Feb 2009 19:48:48 +0900
From: Dongsoo Kim <dongsoo45.kim@samsung.com>
Subject: Re: [V4L2] EV control API for digital camera
In-reply-to: <200902031120.01937.laurent.pinchart@skynet.be>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Dongsoo Kim <dongsoo.kim@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	=?euc-kr?Q?=C7=FC=C1=D8_=B1=E8?= <riverful.kim@samsung.com>,
	jongse.won@samsung.com, kyungmin.park@samsung.com
Reply-to: dongsoo45.kim@samsung.com
Message-id: <1233658128.6845.20.camel@chromatix>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
References: <5e9665e10901281824ibccbf00lcbecba5b01fdcbea@mail.gmail.com>
 <Pine.LNX.4.64.0901291934300.5474@axis700.grange>
 <B44B29E7-9C46-4F34-8CE4-AB17D6CCBCB7@gmail.com>
 <200902031120.01937.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




On 화, 2009-02-03 at 11:20 +0100, Laurent Pinchart wrote:
> Hi Nate,
> 
> On Thursday 29 January 2009, Dongsoo Kim wrote:
> > Thank you.
> >
> > So if V4L2_CID_EXPOSURE is for Exposure Value control, I think there
> > is no api for exposure metering. right?
> 
> V4L2_CID_EXPOSURE controls the exposure time. This is often implemented 
> through a mechanical or electronic shutter in the device.
> 
> What kind of exposure metering do you have in mind ? Can you give us some 
> details ?

I mean photometry which is all about light meter (or exposure meter).
Like spot metering, center weighted things..

> 
> > Actually many of APIs for camera are missing I guess.
> 
> You're probably right. The V4L1/V4L2 API have been developed for frame 
> grabbers and extended to webcams. Now that high-end digital cameras get USB 
> connectivity, the V4L2 API should be extended with new controls. Feel free to 
> submit proposals for discussion on the linux-media mailing list.
> 
Thank you for you encouraging words.
Actually I'm working on some ISP devices from NEC, Fujitsu. and ARM SOC
camera interface peripheral like PXA3, S3C64XX, OMAP3..
I wish I could make a device very close to a real digital camera.
It wouldn't take so long until I submit a RFC about V4L2 API for digital
camera :) (I hope so at least)
Cheers.

Regards,
Nate

