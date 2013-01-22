Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39965 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751625Ab3AVTnO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 14:43:14 -0500
Date: Tue, 22 Jan 2013 21:43:10 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] media: implement 32-on-64 bit compat IOCTL handling
Message-ID: <20130122194309.GC18639@valkosipuli.retiisi.org.uk>
References: <20130122162343.GO13641@valkosipuli.retiisi.org.uk>
 <1358872076-5477-1-git-send-email-sakari.ailus@iki.fi>
 <1358872076-5477-2-git-send-email-sakari.ailus@iki.fi>
 <201301222003.01772.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301222003.01772.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the comments!

On Tue, Jan 22, 2013 at 08:03:01PM +0100, Hans Verkuil wrote:
> On Tue January 22 2013 17:27:56 Sakari Ailus wrote:
> > Use the same handlers where the structs are the same. Implement a new
> > handler for link enumeration since struct media_links_enum is different on
> > 32-bit and 64-bit systems.
> 
> I think I would prefer to have the compat handling split off into a
> seperate source. I know it is just a small amount of code at the moment,
> but that's the way it is done as well for the V4L2 ioctls and I rather
> like that approach.
> 
> What do others think about that?

I pondered the possibility but thought that as it's not much code so it'd be
fine in the same file. I agree that hiding the compat code out of sight in
V4L2 works really well --- it's mostly uninteresting and only needs to be
touched when the API changes. But there's also much, much more code and
handling to do in V4L2. I doubt the MC will ever be nearly as large unless
the functionality and the problem area of the API changes significantly.

I have nothing against putting this into a separate file, though. :-)

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
