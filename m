Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53120 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755693Ab0CIWMs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Mar 2010 17:12:48 -0500
Date: Tue, 9 Mar 2010 23:12:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: LMML <linux-media@vger.kernel.org>, moinejf@free.fr,
	m-karicheri2@ti.com, pboettcher@dibcom.fr, tobias.lorenz@gmx.net,
	awalls@radix.net, khali@linux-fr.org, hdegoede@redhat.com,
	abraham.manu@gmail.com, Hans Verkuil <hverkuil@xs4all.nl>,
	crope@iki.fi, davidtlwong@gmail.com, henrik@kurelid.se,
	stoth@kernellabs.com
Subject: Re: Status of the patches under review (45 patches)
In-Reply-To: <4B969C08.2030807@redhat.com>
Message-ID: <Pine.LNX.4.64.1003092310490.4891@axis700.grange>
References: <4B969C08.2030807@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

On Tue, 9 Mar 2010, Mauro Carvalho Chehab wrote:

> 		== soc_camera patches - Waiting Guennadi <g.liakhovetski@gmx.de> submission/review == 
> 
> Feb, 9 2010: mt9t031: use runtime pm support to restore ADDRESS_MODE registers      http://patchwork.kernel.org/patch/77997

This one is already in your tree, if I see it right:

http://git.linuxtv.org/v4l-dvb.git?a=commit;h=36e9541f11bfe175781b1ea8e4cb3032e4b23508

> Feb, 2 2010: [2/3] soc-camera: mt9t112: modify delay time after initialize          http://patchwork.kernel.org/patch/76213
> Feb, 2 2010: [3/3] soc-camera: mt9t112: The flag which control camera-init is       http://patchwork.kernel.org/patch/76214

These two we agreed to put on hold, can be that they'll be dropped.

> Mar, 5 2010: [v2] V4L/DVB: mx1-camera: compile fix                                  http://patchwork.kernel.org/patch/83742

Yes, I still have to process this one.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
