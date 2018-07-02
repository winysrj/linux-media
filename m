Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39918 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752596AbeGBJl2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 05:41:28 -0400
Date: Mon, 2 Jul 2018 06:41:21 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: [RFC] Make entity to interface links immutable
Message-ID: <20180702064116.401a244e@coco.lan>
In-Reply-To: <354b01c0-6825-4302-a1f4-d120cf8c34e3@xs4all.nl>
References: <354b01c0-6825-4302-a1f4-d120cf8c34e3@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 2 Jul 2018 10:18:37 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> While working on v4l2-compliance I noticed that entity to interface links
> have just the MEDIA_LNK_FL_ENABLED flag set.
> 
> Shouldn't we also set the MEDIA_LNK_FL_IMMUTABLE? After all, you cannot change
> an entity-interface link. It feels inconsistent not to have this flag.

It could make sense for non-hybrid devices, but this may not be true
for hybrid ones. See below.

> I also propose that media_create_intf_link() drops the last flags argument:
> it can set the link flags directly since they are always the same anyway.

When we came with this design, the idea is that an interface can be 
disabled/enabled at runtime, if the entity it links can't be used,
because the hardware is busy doing something else. 

That could happen with hybrid devices, where the analog part could
be consuming resources that would be needed for the digital part.

Disabling the link at runtime has an advantage that it makes easier
to check - as open() syscalls could just use it to return -EBUSY,
instead of doing a complete graph analysis. Also, applications can
test it directly, in order to have a hint if a device is ready for
usage.

That was one of the approaches we considered at the design, but I
don't remember if Shuah's patch series actually used it or not,
as I don't look at her pending patches for a long time. I suspect
she took a different approach.

Anyway, before touching it, I'd like to see her patches merged,
and do some tests with real case scenarios before changing it.


Thanks,
Mauro
