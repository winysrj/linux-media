Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33813 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752154AbaJVKDm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 06:03:42 -0400
Date: Wed, 22 Oct 2014 13:03:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	b.zolnierkie@samsung.com, kyungmin.park@samsung.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC v2 2/4] Add media device related data structures and
 API.
Message-ID: <20141022100301.GH15257@valkosipuli.retiisi.org.uk>
References: <1413557682-20535-1-git-send-email-j.anaszewski@samsung.com>
 <1413557682-20535-3-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413557682-20535-3-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Fri, Oct 17, 2014 at 04:54:40PM +0200, Jacek Anaszewski wrote:
...
> +/*
> + * struct media_entity - media device entity data
> + * @id:			media entity id within media controller
> + * @name:		media entity name
> + * @node_name:		media entity related device node name
> + * @pads:		array of media_entity pads
> + * @num_pads:		number of elements in the pads array
> + * @links:		array of media_entity links
> + * @num_links:		number of elements in the links array
> + * @subdev_fmt:		related sub-device format
> + * @fd:			related sub-device node file descriptor
> + * @src_pad_id:		source pad id when entity is linked
> + * @sink_pad_id:	sink pad id when entity is linked
> + * @next:		pointer to the next data structure in the list
> + */
> +struct media_entity {
> +	int id;
> +	char name[32];
> +	char node_name[32];
> +	struct media_pad_desc *pads;
> +	int num_pads;
> +	struct media_link_desc *links;
> +	int num_links;
> +	struct v4l2_subdev_format subdev_fmt;
> +	int fd;
> +	int src_pad_id;
> +	int sink_pad_id;
> +	struct media_entity *next;
> +};

Could you use libmediactl and libv4l2subdev instead here as well? They do
actually implement much of what you do here. Feel free to comment on the
API. The libraries have a little bit different background than this one.
Obviously there's functionality in this library what's not in the two; some
of this might belong to either of the two libraries.

I think we'll need V4L2 sub-device related information stored next to the
media entities as well, so that's something to be added.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
