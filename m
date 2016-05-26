Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37892 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753380AbcEZM3I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2016 08:29:08 -0400
Date: Thu, 26 May 2016 15:28:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [v4l-utils PATCH 1/2] libmediactl: Drop length argument from
 media_get_entity_by_name()
Message-ID: <20160526122832.GM26360@valkosipuli.retiisi.org.uk>
References: <1464094083-3637-1-git-send-email-sakari.ailus@linux.intel.com>
 <4674976.GzD7drDBGA@avalon>
 <20160524205044.GH26360@valkosipuli.retiisi.org.uk>
 <6424543.oB6h8DCtnj@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6424543.oB6h8DCtnj@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 26, 2016 at 03:07:41PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Tuesday 24 May 2016 23:50:44 Sakari Ailus wrote:
> > On Tue, May 24, 2016 at 08:09:37PM +0300, Laurent Pinchart wrote:
> > ...
> > 
> > > > +		if (strcmp(entity->info.name, name) == 0)
> > > 
> > > While the kernel API guarantees that entity->info.name will be NULL-
> > > terminated, wouldn't it be safer to add a safety check here ?
> > 
> > The kernel implementation in media-device.c does use strlcpy() so this is
> > even not about drivers doing this right. If you insist, I'll change it. :-)
> 
> I suppose we'll have other problems if the kernel doesn't behave.
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

I'll then proceed to push the two patches to v4l-utils.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
