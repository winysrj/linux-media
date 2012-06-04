Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3284 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab2FDOSB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2012 10:18:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Media controller entity information ioctl [was "Re: [patch] suggestion for media framework"]
Date: Mon, 4 Jun 2012 16:17:32 +0200
Cc: Oleksij Rempel <bug-track@fisher-privat.net>,
	linux-uvc-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
	sakari.ailus@iki.fi,
	Youness Alaoui <youness.alaoui@collabora.co.uk>
References: <4FCB9C12.1@fisher-privat.net> <9993866.a3VUSWRbyi@avalon>
In-Reply-To: <9993866.a3VUSWRbyi@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206041617.32315.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon June 4 2012 16:02:12 Laurent Pinchart wrote:
> Hi Oleksiy,
> 
> Thank you for the patch.
> 
> [CC'ing linux-media]
> 
> On Sunday 03 June 2012 19:17:06 Oleksij Rempel wrote:
> > Hi Laurent,
> > 
> > in attachment is a suggestion patch for media framework and a test
> > program which use this patch.
> > 
> > Suddenly we still didn't solved the problem with finding of XU. You
> > know, the proper way to find them is guid (i do not need to explain this
> > :)). Since uvc devices starting to have more and complicated XUs, media
> > api is probably proper way to go - how you suggested.
> > 
> > On the wiki of TexasInstruments i found some code examples, how they use
> > this api. And it looks like there is some desing differences between
> > OMPA drivers and UVC. It is easy to find proper entity name for omap
> > devices just by: "(!strcmp(entity[index].name, "OMAP3 ISP CCDC"))".
> > We can't do the same for UVC, current names are just "Extension %u". We
> > can put guid instead, but it will looks ugly and not really informative.
> > This is why i added new struct uvc_ext.
> > 
> > If you do not agree with this patch, it will be good if you proved other
> > solution. This problem need to be solved.
> 
> The patch goes in the right direction, in that I think the media controller 
> API is the proper way to solve this problem. However, extending the 
> media_entity_desc structure with information about all possible kinds of 
> entities will not scale, especially given that an entity may need to expose 
> information related to multiple types (for instance an XU need to expose its 
> GUID, but also subdev-related information if it has a device node).
> 
> I've been thinking about adding a new ioctl to the media controller API for 
> some time now, to report advanced static information about entities.
> 
> The idea is that each entity would be allowed to report an arbitrary number of 
> static items. Items would have a type (for which we would likely need some 
> kind of central registry, possible with driver-specific types), a length and 
> data. The items would be static (registered an initialization time) and 
> aggregated in a single buffer that would be read in one go through a new 
> ioctl.

And since it is static the media_entity_desc struct can tell the caller how many
of these items there are, and use that information to retrieve them.

> One important benefit of such an API would be to be able to report more than 
> one entity type per subdev using entity type items. Many entities serve 
> several purpose, for instance a sensor can integrate a flash controller. This 
> can't be reported with the current API, as subdevs have a single type. By 
> having several entity type items we could fix this issue.
> 
> Details remain to be drafted, but I'd like a feedback on the general approach.

Sound good. We discussed this before, and I agree that these seems to be the
right approach.

Regards,

	Hans
