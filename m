Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47056 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab1IUWFB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 18:05:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Patches at patchwork.linuxtv.org (127 patches)
Date: Wed, 21 Sep 2011 23:58:20 +0200
Cc: LMML <linux-media@vger.kernel.org>,
	Morimoto Kuninori <morimoto.kuninori@renesas.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Pawel Osiak <pawel@osciak.co>
References: <4E7A4BA7.5050505@redhat.com> <4E7A4CA4.8040205@redhat.com>
In-Reply-To: <4E7A4CA4.8040205@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109212358.22601.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 21 September 2011 22:44:20 Mauro Carvalho Chehab wrote:
> Em 21-09-2011 17:40, Mauro Carvalho Chehab escreveu:
> > As announced on Sept, 18, we moved our patch queue to
> > patchwork.linuxtv.org.

Thank you for working on that.

[snip]

> Aug,19 2011: v4l: Add V4L2_PIX_FMT_NV24 and V4L2_PIX_FMT_NV42 formats
> http://patchwork.linuxtv.org/patch/7630

This one has been superseeded. Speaking of this, the next version of the patch 
will be needed for an fbdev driver that should make it to v3.3. Should I push 
NV24 support through your tree for v3.2 to make sure compilation won't break 
during the v3.3 merge window ?

> Sep, 5 2011: BUG: unable to handle kernel paging request at 6b6b6bcb
> (v4l2_device_d
> http://patchwork.linuxtv.org/patch/7779

Superseeded as well.

> Sep,12 2011: [GIT,PULL,FOR,v3.1] v4l and uvcvideo fixes
> http://patchwork.linuxtv.org/patch/7835

Please pull that :-) It's for v3.1, there's not much time left.

> 		== Patches waiting for Laurent Pinchart review ==

[snip]
 
> Jul,12 2011: v4l: mem2mem: add wait_{prepare,finish} ops to m2m_testdev
> http://patchwork.linuxtv.org/patch/7431

I don't think that one is for me.

> Jul,10 2011: [3/3] Make use of 8-bit and 16-bit YCrCb media bus pixel
> codes in adv7
> http://patchwork.linuxtv.org/patch/7425

I don't think this one is for me either.

-- 
Regards,

Laurent Pinchart
