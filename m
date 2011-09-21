Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab1IUWUe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 18:20:34 -0400
Message-ID: <4E7A6319.9010805@redhat.com>
Date: Wed, 21 Sep 2011 19:20:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: LMML <linux-media@vger.kernel.org>,
	Morimoto Kuninori <morimoto.kuninori@renesas.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Pawel Osiak <pawel@osciak.co>
Subject: Re: Patches at patchwork.linuxtv.org (127 patches)
References: <4E7A4BA7.5050505@redhat.com> <4E7A4CA4.8040205@redhat.com> <201109212358.22601.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201109212358.22601.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-09-2011 18:58, Laurent Pinchart escreveu:
>> Aug,19 2011: v4l: Add V4L2_PIX_FMT_NV24 and V4L2_PIX_FMT_NV42 formats
>> http://patchwork.linuxtv.org/patch/7630
> 
> This one has been superseeded. Speaking of this, the next version of the patch 
> will be needed for an fbdev driver that should make it to v3.3. Should I push 
> NV24 support through your tree for v3.2 to make sure compilation won't break 
> during the v3.3 merge window ?

The better is to submit both patches to the same tree, getting the maintainer's
ack from the other side. I'm ok with either direction. If you opt to sent the
patches via fbdev tree, send me the latest version of it for me to review and
ack.

> 
>> Sep, 5 2011: BUG: unable to handle kernel paging request at 6b6b6bcb
>> (v4l2_device_d
>> http://patchwork.linuxtv.org/patch/7779
> 
> Superseeded as well.
> 
>> Sep,12 2011: [GIT,PULL,FOR,v3.1] v4l and uvcvideo fixes
>> http://patchwork.linuxtv.org/patch/7835
> 
> Please pull that :-) It's for v3.1, there's not much time left.

I will. 

>> 		== Patches waiting for Laurent Pinchart review ==
> 
> [snip]
>  
>> Jul,12 2011: v4l: mem2mem: add wait_{prepare,finish} ops to m2m_testdev
>> http://patchwork.linuxtv.org/patch/7431
> 
> I don't think that one is for me.
> 
>> Jul,10 2011: [3/3] Make use of 8-bit and 16-bit YCrCb media bus pixel
>> codes in adv7
>> http://patchwork.linuxtv.org/patch/7425
> 
> I don't think this one is for me either.


Hmm.. not sure why I put those two for you. Will fix that on my control
files.

Thank you!
Mauro
