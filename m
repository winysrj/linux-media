Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36524 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751198AbcBVKGZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 05:06:25 -0500
Date: Mon, 22 Feb 2016 12:06:19 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC 4/4] media: Drop media_get_uptr() macro
Message-ID: <20160222100619.GU32612@valkosipuli.retiisi.org.uk>
References: <1456090575-28354-1-git-send-email-sakari.ailus@linux.intel.com>
 <1456090575-28354-5-git-send-email-sakari.ailus@linux.intel.com>
 <20160222065251.4c9be90d@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160222065251.4c9be90d@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Feb 22, 2016 at 06:52:51AM -0300, Mauro Carvalho Chehab wrote:
> Em Sun, 21 Feb 2016 23:36:15 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
> > From: Sakari Ailus <sakari.ailus@iki.fi>
> > 
> > There's no real need for such a macro, especially not in the user space
> > header.
> 
> Ok, good point, but I would, instead, move the macro to
> drivers/media/media-device.c. That double-casting is something unusual,
> and we don't want to start receiving patch from newbie janitors wanting
> to strip the casts.

Ok, I'll move it to media-device.c then.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
