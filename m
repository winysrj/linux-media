Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57253 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754225AbaKORpk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Nov 2014 12:45:40 -0500
Date: Sat, 15 Nov 2014 19:44:59 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 06/11] videodev2.h: add new v4l2_ext_control flags
 field
Message-ID: <20141115174459.GH8907@valkosipuli.retiisi.org.uk>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
 <1411310909-32825-7-git-send-email-hverkuil@xs4all.nl>
 <20141115141858.GG8907@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115141858.GG8907@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sat, Nov 15, 2014 at 04:18:59PM +0200, Sakari Ailus wrote:
...
> >  	union {
> >  		__s32 value;
> >  		__s64 value64;
> > @@ -1294,6 +1294,10 @@ struct v4l2_ext_control {
> >  	};
> >  } __attribute__ ((packed));
> >  
> > +/* v4l2_ext_control flags */
> > +#define V4L2_EXT_CTRL_FL_IGN_STORE_AFTER_USE	0x00000001
> > +#define V4L2_EXT_CTRL_FL_IGN_STORE		0x00000002
> 
> Do we need both? Aren't these mutually exclusive, and you must have either
> to be meaningful in the context of a store?

Ah. Now I think I understand what do these mean. Please ignore my previous
comment.

I might call them differently. What would you think of
V4L2_EXT_CTRL_FL_STORE_IGNORE and V4L2_EXT_CTRL_FL_STORE_ONCE?
V4L2_EXT_CTRL_FL_IGN_STORE_AFTER_USE is quite long IMO. Up to you.

I wonder if we need EXT in V4L2_EXT_CTRL_FL. It's logical but also
redundant since the old control interface won't have flags either.

I'd assume that for cameras the vast majority of users will always want to
just apply the values once. How are the use cases in video decoding?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
