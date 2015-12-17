Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:59388 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbbLQNz6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 08:55:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH] [media] uapi/media.h: Use u32 for the number of graph objects
Date: Thu, 17 Dec 2015 14:55:11 +0100
Message-ID: <2035986.3qXU4Qokl3@wuerfel>
In-Reply-To: <20151217104556.70d4f0f8@recife.lan>
References: <40e950dbb6a3b7f73da52e147fa51441b762131a.1450350558.git.mchehab@osg.samsung.com> <5672A69F.7020505@xs4all.nl> <20151217104556.70d4f0f8@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 17 December 2015 10:45:56 Mauro Carvalho Chehab wrote:
> If I understood well, he's proposing to do is:
> 
> struct media_v2_topology {
>         __u64 topology_version;
> 
>         __u32 num_entities;
>         __u32 num_interfaces;
>         __u32 num_pads;
>         __u32 num_links;
> 
>         __u64 ptr_entities;
>         __u64 ptr_interfaces;
>         __u64 ptr_pads;
>         __u64 ptr_links;
> };
> 
> The problem is that, if we latter need to extend it to add a new type
> the extension will not be too nice. For example, I did some experimental
> patches adding graph groups:
> 

Can you clarify how the 'topology_version' is used here? Is that
the version of the structure layout that decides how we interpret the
rest, or is it a number that is runtime dependent?

If this is an API version, I think the answer can simply be to drop
the topology_version field entirely, and use a new ioctl command code
whenever the API changes. This is the preferred method anyway.

	Arnd
