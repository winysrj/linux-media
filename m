Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39040 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754079AbcEXUvV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 16:51:21 -0400
Date: Tue, 24 May 2016 23:50:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [v4l-utils PATCH 1/2] libmediactl: Drop length argument from
 media_get_entity_by_name()
Message-ID: <20160524205044.GH26360@valkosipuli.retiisi.org.uk>
References: <1464094083-3637-1-git-send-email-sakari.ailus@linux.intel.com>
 <1464094083-3637-2-git-send-email-sakari.ailus@linux.intel.com>
 <4674976.GzD7drDBGA@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4674976.GzD7drDBGA@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review!

On Tue, May 24, 2016 at 08:09:37PM +0300, Laurent Pinchart wrote:
...
> > +		if (strcmp(entity->info.name, name) == 0)
> 
> While the kernel API guarantees that entity->info.name will be NULL-
> terminated, wouldn't it be safer to add a safety check here ?

The kernel implementation in media-device.c does use strlcpy() so this is
even not about drivers doing this right. If you insist, I'll change it. :-)

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
