Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44208 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3LDBRT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 20:17:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	pawel@osciak.com, awalls@md.metrocast.net,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 7/9] vb2: add thread support
Date: Wed, 04 Dec 2013 02:17:24 +0100
Message-ID: <1604380.oHcqFNncgD@avalon>
In-Reply-To: <529DAAB7.100@xs4all.nl>
References: <1385719124-11338-1-git-send-email-hverkuil@xs4all.nl> <2319725.0dGUTBP8Q9@avalon> <529DAAB7.100@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 03 December 2013 10:56:07 Hans Verkuil wrote:
> On 11/29/13 19:21, Laurent Pinchart wrote:
> > On Friday 29 November 2013 10:58:42 Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >> 
> >> In order to implement vb2 DVB or ALSA support you need to be able to
> >> start a kernel thread that queues and dequeues buffers, calling a
> >> callback function for every captured/displayed buffer. This patch adds
> >> support for that.
> >> 
> >> It's based on drivers/media/v4l2-core/videobuf-dvb.c, but with all the
> >> DVB specific stuff stripped out, thus making it much more generic.
> > 
> > Do you see any use for this outside of videobuf2-dvb ? If not I wonder
> > whether the code shouldn't be moved there. The sync objects framework
> > being developed for KMS will in my opinion cover the other use cases, and
> > I'd like to discourage non-DVB drivers to use vb2 threads in the
> > meantime.
> 
> I'm using it for ALSA drivers which, at least in my case, require almost
> identical functionality as that needed by DVB.

You're using videobuf2 for audio ?

> But regardless of that, I really don't like the way it was done in the old
> videobuf framework, mixing low-level videobuf calls/data structure accesses
> with DVB code. That should be separate.
> 
> The vb2 core framework should provide the low-level functionality that is
> needed by the videobuf2-dvb to build on.

Right, but I want to make sure that drivers will not start using this 
directly. It should be an internal videobuf2 API.

-- 
Regards,

Laurent Pinchart

