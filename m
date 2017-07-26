Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55363 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751744AbdGZMbb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 08:31:31 -0400
Date: Wed, 26 Jul 2017 14:29:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4] uvcvideo: add a metadata device node
In-Reply-To: <Pine.LNX.4.64.1707240958280.4948@axis700.grange>
Message-ID: <Pine.LNX.4.64.1707261316010.6259@axis700.grange>
References: <Pine.LNX.4.64.1707071536440.9200@axis700.grange>
 <3406101.2MuKeu43r1@avalon> <Pine.LNX.4.64.1707240958280.4948@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 25 Jul 2017, Guennadi Liakhovetski wrote:

[snip]

> > > +struct uvc_meta_buf {
> > > +	struct timespec ts;
> > 
> > timespec has a different size on 32-bit and 64-bit architectures, so there
> > could be issues on 32-bit userspace running on a 64-bit kernel.
> > 
> > Additionally, on 32-bit platforms, timespec is not year 2038-safe. I thought
> > that timespec64 was exposed to userspace nowadays, but it doesn't seem to be
> > the case. I'm not sure how to handle this.
> 
> Oh, that isn't good :-/ I'll have to think more about this. If you get any 
> more ideas, I'd be glad to hear them too.

Shall we just use nanoseconds here too then, as returned by 
timespec_to_ns(), just like in frame timestamps?

Thanks
Guennadi
