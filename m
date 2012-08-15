Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab2HOVns (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 17:43:48 -0400
Message-ID: <502C17F5.5070301@redhat.com>
Date: Wed, 15 Aug 2012 18:43:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Silvester Nawrocki <sylvester.nawrocki@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: Patches submitted via linux-media ML that are at patchwork.linuxtv.org
References: <502A4CD1.1020108@redhat.com> <1648356.GPjgaBcQZf@avalon>
In-Reply-To: <1648356.GPjgaBcQZf@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-08-2012 12:16, Laurent Pinchart escreveu:
>> May,15 2012: [GIT,PULL,FOR,3.5] DMABUF importer feature in V4L2 API         
>>        http://patchwork.linuxtv.org/patch/11268
>>        Sylwester Nawrocki <s.nawrocki@samsung.com>
> 
> What is needed here, can I help with testing ?

Testing, as Sylwester answered. Yeah, any help with those are welcome.

I had some discussions with Sylwester today. Let's see if he can help
setting a test environment for it.
> 
> [snip]
> 
>> 		== Guennadi Liakhovetski <g.liakhovetski@gmx.de> ==
>>
>> Aug, 2 2012: [v3] mt9v022: Add support for mt9v024                          
>>        http://patchwork.linuxtv.org/patch/13582
>>        Alex Gershgorin <alexg@meprolight.com>
>> Aug, 6 2012: [1/1] media: mx3_camera: Improve data bus width check code for
>> probe
>> 		http://patchwork.linuxtv.org/patch/13618
>> 		Liu Ying <Ying.liu@freescale.com>
>> Aug, 9 2012: [1/1, v2] media/video: vpif: fixing function name start to
>> vpif_config
>> 		http://patchwork.linuxtv.org/patch/13689
>> 		Dror Cohen <dror@liveu.tv>
> 
> I think this one has been misclassified. v1 was correctly attributed to 
> Prabhakar Lad <prabhakar.lad@ti.com>

Ok, changed on my internal control.

> 
> [snip]
> 
>> 		== Laurent Pinchart <laurent.pinchart@ideasonboard.com> ==
>>
>> Sep,27 2011: [v2,1/5] omap3evm: Enable regulators for camera interface
>>        http://patchwork.linuxtv.org/patch/7969
>>        Vaibhav Hiremath <hvaibhav@ti.com>
> 
> I'm fine with that one, shouldn't it go through the arm tree ?

Ah, yes. Dropped from my queue.

>> Jul,26 2012: [1/2,media] omap3isp: implement ENUM_FMT
>> 		http://patchwork.linuxtv.org/patch/13492
>> 		Michael Jones <michael.jones@matrix-vision.de>
>> Jul,26 2012: [2/2,media] omap3isp: support G_FMT
>> 		http://patchwork.linuxtv.org/patch/13493
>> 		Michael Jones <michael.jones@matrix-vision.de>
> 
> A proper solution for this will first require CREATE_BUFS/PREPARE_BUF support 
> in the OMAP3 ISP driver (and a move to videobuf2).

Marked as "changes requested".

Michael Jones c/c, to let him know.

Regards,
Mauro
