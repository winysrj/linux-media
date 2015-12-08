Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:64377 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbbLHTtF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2015 14:49:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v8 44/55] [media] uapi/media.h: Add MEDIA_IOC_G_TOPOLOGY ioctl
Date: Tue, 08 Dec 2015 20:48:47 +0100
Message-ID: <2308038.NjPhfBgjQD@wuerfel>
In-Reply-To: <20151208172340.43a76779@recife.lan>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <1647957.hsKJGfKUVG@avalon> <20151208172340.43a76779@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 08 December 2015 17:23:40 Mauro Carvalho Chehab wrote:
> > > +
> > > +struct media_v2_topology {
> > > +   __u32 topology_version;
> > > +
> > > +   __u32 num_entities;
> > > +   struct media_v2_entity *entities;
> > 
> > The kernel seems to be moving to using __u64 instead of pointers in userspace-
> > facing structures to avoid compat32 code.
> 
> We had such discussion at the MC summit. I don't object to change to
> __u64, but we need to reach a consensus 
> 

Just saw the email fly by. Using a __u64 to pass a pointer is generally
the preferred method for most subsystems these days.

However, that means you probably want to extract the pointer from
that using something like

static inline void __user *get_upointer(u64 arg)
{
	return (void __user *)(uintptr_t)arg;
}

This is the only way that I know that works on both 32-bit and 64-bit
architectures as well as the oddball s390 compat mode (which you don't
care about because there are no media devices on s390).

	Arnd
