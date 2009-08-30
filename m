Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39503 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbZH3XHr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 19:07:47 -0400
Date: Sun, 30 Aug 2009 20:07:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	linux-media@vger.kernel.org, sailus@maxwell.research.nokia.com,
	"Zutshi Vimarsh (Nokia-D/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Lasse.Laukkanen@digia.com
Subject: Re: [PATCH] V4L: videobuf-core.c VIDIOC_QBUF should return video
 buffer flags
Message-ID: <20090830200742.62ae4a87@pedra.chehab.org>
In-Reply-To: <200908111229.36230.laurent.pinchart@ideasonboard.com>
References: <200908102037.40140.tuukka.o.toivonen@nokia.com>
	<200908111229.36230.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Aug 2009 12:29:36 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> On Monday 10 August 2009 19:37:40 Tuukka.O Toivonen wrote:
> > When user space queues a buffer using VIDIOC_QBUF, the kernel
> > should set flags to V4L2_BUF_FLAG_QUEUED in struct v4l2_buffer.
> > videobuf_qbuf() was missing a call to videobuf_status() which does
> > that. This patch adds the proper function call.
> >
> > Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
> 
> I was a bit surprised, as I didn't think VIDIOC_QBUF was supposed to update 
> the buffer structure, but according to the v4l2 spec it is.
> 
> However, I don't think calling videobuf_status() is the right thing to do. It 
> will update fields that don't make sense at this point, such as 
> v4l2_buffer::timestamp.
> 
> Thanks Tuukka for finding this, I'll update the UVC video driver 
> accordingly :-)

Tuukka,

Could you please update your patch to take Laurent's comments into
consideration



Cheers,
Mauro
