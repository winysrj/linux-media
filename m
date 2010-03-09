Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab0CIXV5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Mar 2010 18:21:57 -0500
Message-ID: <4B96D7E0.8090402@redhat.com>
Date: Tue, 09 Mar 2010 20:21:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: LMML <linux-media@vger.kernel.org>, moinejf@free.fr,
	m-karicheri2@ti.com, pboettcher@dibcom.fr, tobias.lorenz@gmx.net,
	awalls@radix.net, khali@linux-fr.org, hdegoede@redhat.com,
	abraham.manu@gmail.com, Hans Verkuil <hverkuil@xs4all.nl>,
	crope@iki.fi, davidtlwong@gmail.com, henrik@kurelid.se,
	stoth@kernellabs.com
Subject: Re: Status of the patches under review (45 patches)
References: <4B969C08.2030807@redhat.com> <Pine.LNX.4.64.1003092310490.4891@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1003092310490.4891@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> Hi Mauro
> 
> On Tue, 9 Mar 2010, Mauro Carvalho Chehab wrote:
> 
>> 		== soc_camera patches - Waiting Guennadi <g.liakhovetski@gmx.de> submission/review == 
>>
>> Feb, 9 2010: mt9t031: use runtime pm support to restore ADDRESS_MODE registers      http://patchwork.kernel.org/patch/77997
> 
> This one is already in your tree, if I see it right:
> 
> http://git.linuxtv.org/v4l-dvb.git?a=commit;h=36e9541f11bfe175781b1ea8e4cb3032e4b23508

Ok, updated.

>> Feb, 2 2010: [2/3] soc-camera: mt9t112: modify delay time after initialize          http://patchwork.kernel.org/patch/76213
>> Feb, 2 2010: [3/3] soc-camera: mt9t112: The flag which control camera-init is       http://patchwork.kernel.org/patch/76214
> 
> These two we agreed to put on hold, can be that they'll be dropped.

I'll keep it as Under Review, until you point me otherwise. So, you may expect them to appear on
the next week's email, if not acked/rejected until the next report.

>> Mar, 5 2010: [v2] V4L/DVB: mx1-camera: compile fix                                  http://patchwork.kernel.org/patch/83742
> 
> Yes, I still have to process this one.

Ok.

Cheers,
Mauro
