Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36460 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbaGQMNf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 08:13:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: Set entity->links NULL in cleanup
Date: Thu, 17 Jul 2014 14:13:40 +0200
Message-ID: <4899501.NLaQ1XGmm5@avalon>
In-Reply-To: <20140717115349.GN16460@valkosipuli.retiisi.org.uk>
References: <1401197269-18773-1-git-send-email-sakari.ailus@linux.intel.com> <3533594.Ac4LJj8QGP@avalon> <20140717115349.GN16460@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 17 July 2014 14:53:49 Sakari Ailus wrote:
> On Thu, Jul 17, 2014 at 01:43:09PM +0200, Laurent Pinchart wrote:
> > On Tuesday 27 May 2014 16:27:49 Sakari Ailus wrote:
> > > Calling media_entity_cleanup() on a cleaned-up entity would result into
> > > double free of the entity->links pointer and likely memory corruption as
> > > well.
> > 
> > My first question is, why would anyone do that ? :-)
> 
> Because it makes error handling easier. Many cleanup functions work this
> way, but not media_entity_cleanup().

Do the cleanup functions support being called multiple times, or do they just 
support being called on memory that has been zeroed and not further 
initialized ? The media_entity_cleanup() function supports the latter.

-- 
Regards,

Laurent Pinchart

