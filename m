Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33451 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbcEZMHo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2016 08:07:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [v4l-utils PATCH 1/2] libmediactl: Drop length argument from media_get_entity_by_name()
Date: Thu, 26 May 2016 15:07:41 +0300
Message-ID: <6424543.oB6h8DCtnj@avalon>
In-Reply-To: <20160524205044.GH26360@valkosipuli.retiisi.org.uk>
References: <1464094083-3637-1-git-send-email-sakari.ailus@linux.intel.com> <4674976.GzD7drDBGA@avalon> <20160524205044.GH26360@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 24 May 2016 23:50:44 Sakari Ailus wrote:
> On Tue, May 24, 2016 at 08:09:37PM +0300, Laurent Pinchart wrote:
> ...
> 
> > > +		if (strcmp(entity->info.name, name) == 0)
> > 
> > While the kernel API guarantees that entity->info.name will be NULL-
> > terminated, wouldn't it be safer to add a safety check here ?
> 
> The kernel implementation in media-device.c does use strlcpy() so this is
> even not about drivers doing this right. If you insist, I'll change it. :-)

I suppose we'll have other problems if the kernel doesn't behave.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

