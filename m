Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45211 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2GTKOp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 06:14:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFCv3 PATCH 00/33] Core and vb2 enhancements
Date: Fri, 20 Jul 2012 12:14:50 +0200
Message-ID: <2999684.W2D4Cvl3k2@avalon>
In-Reply-To: <Pine.LNX.4.64.1207201149010.27906@axis700.grange>
References: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl> <Pine.LNX.4.64.1207201149010.27906@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Friday 20 July 2012 11:55:31 Guennadi Liakhovetski wrote:
> On Thu, 28 Jun 2012, Hans Verkuil wrote:
> > Hi all,
> > 
> > This is the third version of this patch series.
> > 
> > The first version is here:
> > 
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg47558.html
> 
> Nice to see an owner concept added to the vb2. In soc-camera we're also
> using a concept of a "streamer" user. This is the user, that first calls
> one of data-flow related ioctl()s, like s_fmt(), streamon(), streamoff()
> and all buffer queue-related operations. I realise that this your
> patch-set only deals with the buffer queue, but in principle, do you think
> it would make sense to use such a concept globally? We probably don't want
> to let other processes mess with any of the above calls as long as one
> process is actively managing the streaming.

I think that's a good idea (the uvcvideo driver implements something similar), 
but I'm not sure whether the spec currently describes the expected behaviour 
and relationships between ioctls correctly. That could be a topic for the V4L2 
ambiguities discussions during KS. 

Such a a mechanism should not be imposed on drivers though, as it probably 
wouldn't cover all use cases (think about mem-to-mem drivers where the format 
is per file-handle for instance).

-- 
Regards,

Laurent Pinchart

