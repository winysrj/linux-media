Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1931 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab2FRLtR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 07:49:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv1 PATCH 24/32] videobuf2-core: add helper functions.
Date: Mon, 18 Jun 2012 13:49:12 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <25b850acc7ddf6e625ef599a00a0079ec92178ed.1339321562.git.hans.verkuil@cisco.com> <14891583.OFcgNZlf7O@avalon>
In-Reply-To: <14891583.OFcgNZlf7O@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206181349.12330.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon June 18 2012 12:23:26 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Sunday 10 June 2012 12:25:46 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Add helper functions to make it easier to adapt drivers to vb2.
> 
> What about moving those functions to videobuf2-ioctl.c ? The helper functions 
> are based on top of an existing vb2 core that isn't aware of queue ownership. 
> It's not clear (to me at least) how the helpers will evolve and whether they 
> will be used by all drivers or not, or whether part of what they do will get 
> merged into the vb2 core. Splitting the helpers in a separate file would help 
> not mixing code too much without really thinking about it.

Sounds reasonable. One thing that I want to think about when preparing RFCv2 is
whether the new queue_lock in video_device shouldn't be moved to vb2_queue
instead, since it is a per-vb2_queue lock. I need to check whether that still
makes it possible to split it up like you suggest. It almost certainly will make
sense to do this.

> 
> > These helpers take care of core locking and check if the filehandle is the
> > owner of the queue.
> > 
> > This patch also adds support for count == 0 in create_bufs.
> 
> Could you please split that to its own patch ? The addition of 
> __verify_memory_type() should be split as well.

OK.

Regards,

	Hans

> 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> 
