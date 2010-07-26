Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:56405 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab0GZQbQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 12:31:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC/PATCH v2 06/10] media: Entities, pads and links enumeration
Date: Mon, 26 Jul 2010 18:31:48 +0200
Cc: linux-media@vger.kernel.org
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <201007221733.37439.laurent.pinchart@ideasonboard.com> <4C48802D.6090406@maxwell.research.nokia.com>
In-Reply-To: <4C48802D.6090406@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007261831.49749.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 22 July 2010 19:30:21 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> >>> +
> >>> +struct media_user_pad {
> >>> +	__u32 entity;		/* entity ID */
> >>> +	__u8 index;		/* pad index */
> >>> +	__u32 direction;	/* pad direction */
> >>> +};
> >> 
> >> Another small comment, I think you mentioned it yourself some time back
> >> 
> >> :-): how about some reserved fields to these structures?
> > 
> > Very good point. Reserved fields are needed in media_user_entity and
> > media_user_links at least. For media_user_pad and media_user_link, we
> > could do without reserved fields if we add fields to media_user_links to
> > store the size of those structures.
> 
> The structure size is part of the ioctl number defined by the _IOC macro

Not in this case, the ioctl uses a structure that stores pointers to the links 
and pads arrays.

> so I'd go with reserved fields even for these structures. Otherwise
> special handling would be required for these ioctls in a few places.

A few reserved links would still be good, yes.

-- 
Regards,

Laurent Pinchart
