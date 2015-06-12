Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45466 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbbFLLdr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 07:33:47 -0400
Date: Fri, 12 Jun 2015 08:33:23 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Kconfig: disable Media Controller for DVB
Message-ID: <20150612083323.79562d10@recife.lan>
In-Reply-To: <557ABC28.2020101@xs4all.nl>
References: <f146ea68c1a5db7a17bdbc0a4f32ebb220c5913e.1434106648.git.mchehab@osg.samsung.com>
	<557ABC28.2020101@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 12 Jun 2015 13:02:00 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 06/12/2015 12:57 PM, Mauro Carvalho Chehab wrote:
> > Since when we start discussions about the usage Media Controller
> > for complex hardware, one thing become clear: the way it is, MC
> > fails to map anything more complex than a webcam.
> > 
> > The point is that MC has entities named as devnodes, but the only
> > devnode used (before the DVB patches) is MEDIA_ENT_T_DEVNODE_V4L.
> > Due to the way MC got implemented, however, this entity actually
> > doesn't represent the devnode, but the hardware I/O engine that
> > receives data via DMA.
> > 
> > By coincidence, such DMA is associated with the V4L device node
> > on webcam hardware, but this is not true even for other V4L2
> > devices. For example, on USB hardware, the DMA is done via the
> > USB controller. The data passes though a in-kernel filter that
> > strips off the URB headers. Other V4L2 devices like radio may not
> > even have DMA. When it have, the DMA is done via ALSA, and not
> > via the V4L devnode.
> > 
> > In other words, MC is broken as a hole, but tagging it as BROKEN
> 
> hole -> whole
> 
> One of these days you'll have retrained your brain for this :-)

Heh ;)

> 
> > right now would do more harm than good.
> > 
> > So, instead, let's mark, for now, the DVB part as broken and
> > block all new changes to it while we don't fix this mess, with
> 
> "while we fix this mess, which"

Changed to:
   "block all new changes to MC while we fix this mess, which"


Sending version 2.

Regards,
Mauro
