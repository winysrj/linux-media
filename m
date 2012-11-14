Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53565 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940Ab2KNK5s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 05:57:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 1/1] media: Entities with sink pads must have at least one enabled link
Date: Wed, 14 Nov 2012 11:58:42 +0100
Message-ID: <2181130.3OlxHxCofA@avalon>
In-Reply-To: <50A36307.50502@samsung.com>
References: <1351280777-4936-1-git-send-email-sakari.ailus@iki.fi> <20121113142409.GR25623@valkosipuli.retiisi.org.uk> <50A36307.50502@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wednesday 14 November 2012 10:23:19 Sylwester Nawrocki wrote:
> On 11/13/2012 03:24 PM, Sakari Ailus wrote:
> > Hi all,
> > 
> > Comments would be appreciated, either positive or negative. The omap3isp
> > driver does the same check itself currently, but I think this is more
> > generic than that.
> > 
> > Thanks.
> > 
> > On Fri, Oct 26, 2012 at 10:46:17PM +0300, Sakari Ailus wrote:
> >> If an entity has sink pads, at least one of them must be connected to
> >> another pad with an enabled link. If a driver with multiple sink pads has
> >> more strict requirements the check should be done in the driver itself.
> >> 
> >> Just requiring one sink pad is connected with an enabled link is enough
> >> API-wise: entities with sink pads with only disabled links should not be
> >> allowed to stream in the first place, but also in a different operation
> >> mode a device might require only one of its pads connected with an
> >> active link.
> >> 
> >> If an entity has an ability to function as a source entity another
> >> logical entity connected to the aforementioned one should be used for the
> >> purpose.
> 
> Why not leave it to individual drivers ? I'm not sure if it is a good idea
> not to allow an entity with sink pads to be used as a source only. It might
> be appropriate for most of the cases but likely not all. I'm inclined not to
> add this requirement in the API. Just my opinion though.

I have mixed feelings about this patch too, which is why I've asked Sakari to 
cross-post it. It's pretty easy to add this check to the core now, but pushing 
it back to drivers late if we realize it's too restrictive would be difficult. 
I think my preference would go for a helper function that drivers can use, 
possibly first waiting until a second driver requires this kind of checks 
before implementing it.

-- 
Regards,

Laurent Pinchart

