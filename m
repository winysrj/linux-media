Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:39876 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab0GVPdW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jul 2010 11:33:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC/PATCH v2 06/10] media: Entities, pads and links enumeration
Date: Thu, 22 Jul 2010 17:33:36 +0200
Cc: linux-media@vger.kernel.org
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279722935-28493-7-git-send-email-laurent.pinchart@ideasonboard.com> <4C48633F.9020001@maxwell.research.nokia.com>
In-Reply-To: <4C48633F.9020001@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007221733.37439.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 22 July 2010 17:26:55 Sakari Ailus wrote:
> Hi,
> 
> Laurent Pinchart wrote:
> ...
> 
> > diff --git a/include/linux/media.h b/include/linux/media.h
> > new file mode 100644
> > index 0000000..746bdda
> > --- /dev/null
> > +++ b/include/linux/media.h
> > @@ -0,0 +1,73 @@

[snip]

> > +
> > +struct media_user_pad {
> > +	__u32 entity;		/* entity ID */
> > +	__u8 index;		/* pad index */
> > +	__u32 direction;	/* pad direction */
> > +};
> 
> Another small comment, I think you mentioned it yourself some time back
> 
> :-): how about some reserved fields to these structures?

Very good point. Reserved fields are needed in media_user_entity and 
media_user_links at least. For media_user_pad and media_user_link, we could do 
without reserved fields if we add fields to media_user_links to store the size 
of those structures.

> > +struct media_user_entity {
> > +	__u32 id;
> > +	char name[32];
> > +	__u32 type;
> > +	__u32 subtype;
> > +	__u8 pads;
> > +	__u32 links;
> > +
> > +	union {
> > +		/* Node specifications */
> > +		struct {
> > +			__u32 major;
> > +			__u32 minor;
> > +		} v4l;
> > +		struct {
> > +			__u32 major;
> > +			__u32 minor;
> > +		} fb;
> > +		int alsa;
> > +		int dvb;
> > +
> > +		/* Sub-device specifications */
> > +		/* Nothing needed yet */
> > +	};
> > +};
> > +
> > +struct media_user_link {
> > +	struct media_user_pad source;
> > +	struct media_user_pad sink;
> > +	__u32 flags;
> > +};
> > +
> > +struct media_user_links {
> > +	__u32 entity;
> > +	/* Should have enough room for pads elements */
> > +	struct media_user_pad __user *pads;
> > +	/* Should have enough room for links elements */
> > +	struct media_user_link __user *links;
> > +};

-- 
Regards,

Laurent Pinchart
