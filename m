Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:3575 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbZIMQHE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 12:07:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: wk <handygewinnspiel@gmx.de>
Subject: Re: Media controller: sysfs vs ioctl
Date: Sun, 13 Sep 2009 18:07:04 +0200
Cc: linux-media@vger.kernel.org
References: <200909120021.48353.hverkuil@xs4all.nl> <4AAD15A3.5080001@gmx.de>
In-Reply-To: <4AAD15A3.5080001@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909131807.04159.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 13 September 2009 17:54:11 wk wrote:
> Hans Verkuil schrieb:
> > Hi all,
> >
> > I've started this as a new thread to prevent polluting the discussions of the
> > media controller as a concept.
> >
> > First of all, I have no doubt that everything that you can do with an ioctl,
> > you can also do with sysfs and vice versa. That's not the problem here.
> >
> > The problem is deciding which approach is the best.
> >
> >   
> 
> Is it really a good idea to create a dependency to some virtual file 
> system which may go away in future?
>  From time to time some of those seem to go away, for example devfs.
> 
> Is it really unavoidable to have something in sysfs, something which is 
> really not possible with ioctls?
> And do you really want to depend on sysfs developers?

One other interesting question is: currently the V4L2 API is also used by BSD
variants for their video drivers. Our V4L2 header is explicitly dual-licensed
to allow this. I don't think that BSD has sysfs. So making the media controller
sysfs-based only would make it very hard for them if they ever want to port
drivers that rely on that to BSD.

Yes, I know that strictly speaking we don't have to care about that, but it
is yet another argument against the use of sysfs as far as I am concerned.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
