Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522Ab0BXM63 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 07:58:29 -0500
Message-ID: <4B85224C.7080206@redhat.com>
Date: Wed, 24 Feb 2010 09:57:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: LMML <linux-media@vger.kernel.org>, helmut@helmutauer.de,
	moinejf@free.fr, m-karicheri2@ti.com, pboettcher@dibcom.fr,
	tobias.lorenz@gmx.net, awalls@radix.net, khali@linux-fr.org,
	hdegoede@redhat.com, abraham.manu@gmail.com, davidtlwong@gmail.com,
	stoth@kernellabs.com
Subject: Re: Status of the patches under review (29 patches)
References: <4B84BBB0.1020408@redhat.com> <Pine.LNX.4.64.1002240807100.4741@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1002240807100.4741@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> Hi Mauro
> 
> On Wed, 24 Feb 2010, Mauro Carvalho Chehab wrote:
> 
>> Hi,
>>
>> I suspect that Linus should be releasing the 2.6.33 kernel any time soon,
>> so the next merge window is about to open. I've handled already everything
>> on my pending queues. However, I missed some emails due to a crash on my 
>> exim filter. Also, patchwork.kernel.org missed some emails due to some
>> trouble there. So, maybe there are still some unnoticed pending stuff.
> 
> Looks like you missed about two of my pull requests.
> 
>> If you still have any pending work for 2.6.34 that aren't merged nor
>> are under review, please submit it ASAP, as patches received after the 
>> release of 2.6.33 will likely be postponed to 2.6.35.
> 
> Namely:
> 
>> 		== soc_camera patches - Waiting Guennadi <g.liakhovetski@gmx.de> submission/review == 
>>
>> Feb, 9 2010: mt9t031: use runtime pm support to restore ADDRESS_MODE registers      http://patchwork.kernel.org/patch/77997
> 
> This one depends on my runtime-pm patch (which is not listed here btw), 
> which we didn't come to a consensus about, so, I think, I'll just push 
> both of them and let you decide whether or not to pull.

Yes, please do it. I'll keep it as "under review" for now.

> 
>> Feb,19 2010: v4l: soc_camera: fix bound checking of mbus_fmt[] index                http://patchwork.kernel.org/patch/80757
> 
> This one 
> (http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/16068/match=pull+soc+camera) 

This one I missed. Applying it.

> and
> 
>> Feb, 2 2010: [1/3] soc-camera: mt9t112: modify exiting conditions from standby mode http://patchwork.kernel.org/patch/76212

This patch were applied only to the fixes.git tree:

commit 2b59125b1b5f8c9bb0524b8a0bdad4b780a239ac
Author: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Date:   Tue Feb 2 13:17:54 2010 +0900

    soc-camera: mt9t112: modify exiting conditions from standby mode
    
    This polling is needed if camera is in standby mode, but current exiting
    condition is inverted.
    
    Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
    Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

I'll merge it back to v4l-dvb.git when merging 2.6.33, after its release.

Removed it from my queue, since it should be upstream already.

> this one are in fixes branch of 
> http://git.linuxtv.org/gliakhovetski/soc-camera.git?a=shortlog;h=refs/heads/fixes 
> which I asked you to pull in 
> http://www.spinics.net/lists/linux-media/msg16281.html
> 
>> Feb, 2 2010: [2/3] soc-camera: mt9t112: modify delay time after initialize          http://patchwork.kernel.org/patch/76213
>> Feb, 2 2010: [3/3] soc-camera: mt9t112: The flag which control camera-init is       http://patchwork.kernel.org/patch/76214
> 
> These two have been put on hold by Morimoto-san.

Ok, I think I'll keep them at the "Under Review" status.

-- 

Cheers,
Mauro
