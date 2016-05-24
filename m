Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39096 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751997AbcEXUyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 16:54:52 -0400
Date: Tue, 24 May 2016 23:54:48 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [v4l-utils PATCH 2/2] mediactl: Separate entity and pad parsing
Message-ID: <20160524205448.GI26360@valkosipuli.retiisi.org.uk>
References: <1464094083-3637-1-git-send-email-sakari.ailus@linux.intel.com>
 <1464094083-3637-3-git-send-email-sakari.ailus@linux.intel.com>
 <3496464.NH5W0U7aUq@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3496464.NH5W0U7aUq@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, May 24, 2016 at 08:14:22PM +0300, Laurent Pinchart wrote:
...
> > +struct media_pad *media_parse_pad(struct media_device *media,
> > +				  const char *p, char **endp)
> > +{
> > +	unsigned int pad;
> > +	struct media_entity *entity;
> > +	char *end;
> > +
> > +	if (endp == NULL)
> > +		endp = &end;
> > +
> > +	entity = media_parse_entity(media, p, &end);
> > +	if (!entity)
> > +		return NULL;
> > +	*endp = end;
> 
> Did you mean
> 
> 	if (!entity) {
> 		*endp = end;
> 		return NULL;
> 	}
> 
> ? There's no need to assign endp after the check as all return paths below 
> assign it correctly, but it should be set when returning an error here.

Good catch! Yeah, it's a bug, I'll fix that.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
