Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57683 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1DEMw7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 08:52:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer management
Date: Tue, 5 Apr 2011 14:53:32 +0200
Cc: "Hans Verkuil" <hverkuil@xs4all.nl>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <201104051402.17836.laurent.pinchart@ideasonboard.com> <201104051440.16449.hansverk@cisco.com>
In-Reply-To: <201104051440.16449.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104051453.33013.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 05 April 2011 14:40:16 Hans Verkuil wrote:
> On Tuesday, April 05, 2011 14:02:17 Laurent Pinchart wrote:
> > On Monday 04 April 2011 10:06:47 Hans Verkuil wrote:
> > > > On Mon, 4 Apr 2011, Hans Verkuil wrote:
> > > >> On Friday, April 01, 2011 10:13:02 Guennadi Liakhovetski wrote:
> > [snip]
> > 
> > > BTW, REQBUFS and CREATE/DESTROY_BUFS should definitely co-exist.
> > > REQBUFS is compulsory, while CREATE/DESTROY are optional.
> > 
> > Drivers must support REQBUFS and should support CREATE/DESTROY, but I
> > think applications should not be allowed to mix calls.
> 
> Why not? The videobuf2-core.c implementation shouldn't care about that, so
> I don't see why userspace should care.

Because it makes the API semantics much more complex to define. We would have 
to precisely define interactions between REQBUFS and CREATE/DESTROY. That will 
be error-prone, for very little benefits (if any at all). If an application is 
aware of the CREATE/DESTROY ioctls and wants to use them, why would it need to 
use REQBUFS ?

-- 
Regards,

Laurent Pinchart
