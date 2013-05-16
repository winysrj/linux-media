Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47937 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755243Ab3EPXr3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 19:47:29 -0400
Date: Fri, 17 May 2013 02:47:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Phillip Norisez <phillip.norisez@creationtech.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Media controller versus int device in V4L2
Message-ID: <20130516234724.GE2077@valkosipuli.retiisi.org.uk>
References: <72B01BB430E48246B160E44B43976D910CFCF18C@CTFIREBIRD.creationtech.com>
 <201305101355.05814.hverkuil@xs4all.nl>
 <72B01BB430E48246B160E44B43976D910CFD2938@CTFIREBIRD.creationtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72B01BB430E48246B160E44B43976D910CFD2938@CTFIREBIRD.creationtech.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Phillip,

On Mon, May 13, 2013 at 06:03:38PM +0000, Phillip Norisez wrote:
> Hans,
> 
> I fear that in my ignorance of V4L2, I have backed my client into a
> corner, so to speak. I am developing embedded Linux firmware for boards
> intended to driver video sensors within a medical device. As such, tried
> and true versions of everything on board are preferred, even if they are
> not cutting edge. Applying this philosophy has gotten me into the
> situation where I am committed, for first human use, to a 2.6.37 kernel
> which does not have media controller v4l2, only int device. Hence my
> question about back-porting drivers, and the programming differences. I
> hope that clears up my situation for you. If a patch exists to make the
> v4l2 on a 2.6.37 kernel into a media controller version, I am unaware of
> it, though I have not conducted a search for it (I will as soon as I
> finish this e-mail).

To amend what Hans already told you, V4L2 int device has nothing to do with
Media controller. What comes closest is V4L2 subdev interface which is part
of your kernel.

If you wish to use V4L2 subdev in the user space (and Media controller),
you'll need to backport patches from at least v2.6.39 which is the one where
the two were merged.

I'd really try to start with something closer to mainline if reliability is
important: there may be issues in backporting patches, too. Just that the
code hasn't been changed for a long time does not make it magically better.
Often it's quite the contrary.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
