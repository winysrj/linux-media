Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50196 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933695AbeGCKEo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2018 06:04:44 -0400
Date: Tue, 3 Jul 2018 07:04:37 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv15 01/35] uapi/linux/media.h: add request API
Message-ID: <20180703070437.6343905b@coco.lan>
In-Reply-To: <6009b87f-4eae-0ea3-9e72-e5bd4bb85d59@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
        <20180604114648.26159-2-hverkuil@xs4all.nl>
        <20180703062131.46cb4179@coco.lan>
        <6009b87f-4eae-0ea3-9e72-e5bd4bb85d59@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 3 Jul 2018 11:33:13 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 03/07/18 11:21, Mauro Carvalho Chehab wrote:
> > Em Mon,  4 Jun 2018 13:46:14 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Define the public request API.
> >>
> >> This adds the new MEDIA_IOC_REQUEST_ALLOC ioctl to allocate a request
> >> and two ioctls that operate on a request in order to queue the
> >> contents of the request to the driver and to re-initialize the
> >> request.  
> > 
> > It would be better if you had added the documentation stuff here...
> > I can't review this patch without first reviewing the documentation
> > for the new ioctls...  
> 
> I moved patch 29 to the front for the next version.

Thanks! Be sure to move other documentation patches to be together
with the respective code changes. Reviewing a /35 patch series
is hard enough even without needing to review stuff on some
random order.

Thanks,
Mauro
