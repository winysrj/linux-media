Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50355 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab3GCTdf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jul 2013 15:33:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Support for events with a large payload
Date: Wed, 03 Jul 2013 21:34:04 +0200
Message-ID: <3981855.thaXQaXO7C@avalon>
In-Reply-To: <20130702230159.GO2064@valkosipuli.retiisi.org.uk>
References: <201305131414.43685.hverkuil@xs4all.nl> <201306241540.14469.hverkuil@xs4all.nl> <20130702230159.GO2064@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 03 July 2013 02:01:59 Sakari Ailus wrote:
> On Mon, Jun 24, 2013 at 03:40:14PM +0200, Hans Verkuil wrote:
> ...
> 
> > Since the payloads are larger I am less concerned about speed. There is
> > one problem, though: if you dequeue the event and the buffer that should
> > receive the payload is too small, then you have lost that payload. You
> > can't allocate a new, larger, buffer and retry. So this approach can only
> > work if you really know the maximum payload size.
> > 
> > The advantage is also that you won't lose payloads.
> 
> Forgot to answer this one --- I think it's fair to assume the user knows the
> maximum size of the payload. What we also could do in such a case is to
> return the error (e.g. ENOSPC) and put the required size to the large event
> size field. But first someone must come up with a variable size event
> without well defined maximum size for this to make much sense.

And while we're discussing use cases, Hans, what are you current use cases for 
>64 bytes event payloads ?

-- 
Regards,

Laurent Pinchart

