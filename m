Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59186 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbbHUVJj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 17:09:39 -0400
Date: Fri, 21 Aug 2015 18:09:31 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v6 7/8] [media] media: add a debug message to warn about
 gobj creation/removal
Message-ID: <20150821180931.4c492767@recife.lan>
In-Reply-To: <2758453.qxSJXS9IU1@avalon>
References: <cover.1439981515.git.mchehab@osg.samsung.com>
	<1485912.HaZnsqcIqp@avalon>
	<20150821071921.1f76b70d@recife.lan>
	<2758453.qxSJXS9IU1@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Aug 2015 20:54:29 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Friday 21 August 2015 07:19:21 Mauro Carvalho Chehab wrote:
> > Em Fri, 21 Aug 2015 04:32:51 +0300 Laurent Pinchart escreveu:
> > > On Wednesday 19 August 2015 08:01:54 Mauro Carvalho Chehab wrote:
> > > > It helps to check if the media controller is doing the
> > > > right thing with the object creation and removal.
> > > > 
> > > > No extra code/data will be produced if DEBUG or
> > > > CONFIG_DYNAMIC_DEBUG is not enabled.
> > > 
> > > CONFIG_DYNAMIC_DEBUG is often enabled.
> > 
> > True, but once a driver/core is properly debugged, images without DEBUG
> > could be used in production, if the amount of memory constraints are
> > too tight.
> > 
> > > You're more or less adding function call tracing in this patch, isn't that
> > > something that ftrace is supposed to do ?
> > 
> > Ftrace is a great infrastructure and helps a lot when we need to
> > identify bottlenecks and other performance related stuff, but it
> > doesn't replace debug functions.
> > 
> > There are some fundamental differences on what you could do with ftrace
> > and what you can't.
> > 
> > At least on this stage, what I need is something that will provide
> > output via serial console when the driver gets loaded, and that provides
> > a synchronous output with the other Kernel messages.
> > 
> > This is the only way to debug certain OOPSes that are happening during
> > the development of the patches.
> > 
> > This is something you cannot do with ftrace, but dynamic DEBUG works
> > like a charm.
> 
> I understand the need for debug messages during development of a patch series, 
> but I don't think this level of debugging belongs to mainline. Debug messages 
> for function call tracing, even more in patch 6/8 and 7/8, is frowned upon in 
> the kernel.
> 
> Or maybe I got it wrong and patches 6/8 and 7/8 are only for development and 
> you don't plan to get them in mainline ?

As we've agreed, the first phase won't have dynamic support. Both patches
6/8 and 7/8 are important until then.

So, they should reach mainline together with the first MC new gen series.

Patch 6/8 can be reverted after we finish implementing dynamic support.

I think patch 7/8 will still be a good debug feature, but we can discuss
about that after implementing dynamic support.

Regards,
Mauro

