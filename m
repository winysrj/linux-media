Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49403 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751958Ab2LQLev (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 06:34:51 -0500
Date: Mon, 17 Dec 2012 13:34:47 +0200
From: 'Sakari Ailus' <sakari.ailus@iki.fi>
To: Kamil Debski <k.debski@samsung.com>
Cc: 'Hans Verkuil' <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 4/4] v4l: Tell user space we're using monotonic
 timestamps
Message-ID: <20121217113447.GE4738@valkosipuli.retiisi.org.uk>
References: <20121115220627.GB29863@valkosipuli.retiisi.org.uk>
 <1353017207-370-4-git-send-email-sakari.ailus@iki.fi>
 <201211161455.20781.hverkuil@xs4all.nl>
 <000101cddc48$6fe977e0$4fbc67a0$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000101cddc48$6fe977e0$4fbc67a0$%debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Mon, Dec 17, 2012 at 12:19:51PM +0100, Kamil Debski wrote:
...
> > > @@ -367,7 +368,8 @@ static void __fill_v4l2_buffer(struct vb2_buffer
> > *vb, struct v4l2_buffer *b)
> > >  	/*
> > >  	 * Clear any buffer state related flags.
> > >  	 */
> > > -	b->flags &= ~V4L2_BUFFER_STATE_FLAGS;
> > > +	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
> > > +	b->flags |= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 
> As far as I know, after __fill_v4l2_buffer is run driver has no means
> to change flags. Right?

Correct. Querybuf, for example, is implemented in vb2 and no driver
involvement is required. And we sure don't want to add it. ;)

> So how should a driver, which is not using the MONOTONIC timestamps inform
> the user space about it?

We currently support only monotonic timestamps. Support for different kind
of timestamps should be added to videobuf2 when they are needed. The drivers
would then be using a videobuf2 equivalent of v4l2_get_timestamp().

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
