Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1850 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2JPGOa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Oct 2012 02:14:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Timestamps and V4L2
Date: Tue, 16 Oct 2012 08:13:13 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	remi@remlab.net, daniel-gl@gmx.net, sylwester.nawrocki@gmail.com
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <20121015160549.GE21261@valkosipuli.retiisi.org.uk> <2316067.OFTCziv4Z5@avalon>
In-Reply-To: <2316067.OFTCziv4Z5@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210160813.13167.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon October 15 2012 20:45:45 Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Monday 15 October 2012 19:05:49 Sakari Ailus wrote:
> > Hi all,
> > 
> > As a summar from the discussion, I think we have reached the following
> > conclusion. Please say if you agree or disagree with what's below. :-)
> > 
> > - The drivers will be moved to use monotonic timestamps for video buffers.
> > - The user space will learn about the type of the timestamp through buffer
> > flags.
> > - The timestamp source may be made selectable in the future, but buffer
> > flags won't be the means for this, primarily since they're not available on
> > subdevs. Possible way to do this include a new V4L2 control or a new IOCTL.
> 
> That's my understanding as well. For the concept,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Also for the concept:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
