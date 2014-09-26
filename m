Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47144 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbaIZOUx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 10:20:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: Set entity->links NULL in cleanup
Date: Fri, 26 Sep 2014 17:20:53 +0300
Message-ID: <2859813.J4bS3FA36H@avalon>
In-Reply-To: <54228C39.7080207@linux.intel.com>
References: <1401197269-18773-1-git-send-email-sakari.ailus@linux.intel.com> <4899501.NLaQ1XGmm5@avalon> <54228C39.7080207@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 24 September 2014 12:17:45 Sakari Ailus wrote:
> Hi Laurent,
> 
> Oops. this got buried in my inbox...
> 
> Laurent Pinchart wrote:
> > On Thursday 17 July 2014 14:53:49 Sakari Ailus wrote:
> >> On Thu, Jul 17, 2014 at 01:43:09PM +0200, Laurent Pinchart wrote:
> >>> On Tuesday 27 May 2014 16:27:49 Sakari Ailus wrote:
> >>>> Calling media_entity_cleanup() on a cleaned-up entity would result into
> >>>> double free of the entity->links pointer and likely memory corruption
> >>>> as well.
> >>> 
> >>> My first question is, why would anyone do that ? :-)
> >> 
> >> Because it makes error handling easier. Many cleanup functions work this
> >> way, but not media_entity_cleanup().
> > 
> > Do the cleanup functions support being called multiple times, or do they
> > just support being called on memory that has been zeroed and not further
> > initialized ? The media_entity_cleanup() function supports the latter.
>
> I'd hope they wouldn't be called multiple times, or on memory that's not
> been zeroed, but in that case it's better to behave rather than corrupt
> system memory. That could be an indication of other problems, too, so
> one could consider adding WARN_ON() to this as well. What do you think?

I agree that calling the cleanup function on uninitialized memory simplifies 
error paths, that's a good feature. Regarding double calls, I have no strong 
opinion. I don't think they should happen in the first place though.

-- 
Regards,

Laurent Pinchart

