Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60835 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759395AbZCMQzP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 12:55:15 -0400
Date: Fri, 13 Mar 2009 13:54:43 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org
Subject: Re: [REVIEW] Draft of V4L2 API and spec changes for
 V4L2_MPEG_STREAM_VBI_FMT_IVTV
Message-ID: <20090313135443.5f94a6fe@pedra.chehab.org>
In-Reply-To: <200903131750.38580.hverkuil@xs4all.nl>
References: <1236799528.3111.15.camel@palomino.walls.org>
	<200903131750.38580.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Mar 2009 17:50:38 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Wednesday 11 March 2009 20:25:28 Andy Walls wrote:
> > All,
> >
> > The inline diff below has my completed draft of V4L2 API and
> > Specifcation changes to add proper definitions and documentation for the
> > MPEG stream embedded, sliced VBI data format triggered by the
> > V4L2_MPEG_STREAM_VBI_FMT_IVTV control setting.  These changes only add
> > to the V4L2 API and do modify or remove exiting elements.
> >
> > Please review.  The only question remaining in my mind is whether the
> > type "__le32" can be used in the userspace API structures.  I think it
> > can, but I don't know what kernel version introduced "__le32".
> >
> >
> > Mauro,
> >
> > When I make a pull request for this, do you want 1 request, or separate
> > requests for videodev2.h changes and v4l2-spec changes?
> 
> He'll probably wants two since the videodev2.h change will also go to the 
> linux git tree, while the doc changes stay behind in v4l-dvb.

Just one is fine. My merge script will drop anything that it is not at /linux dir.

Cheers,
Mauro
