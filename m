Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2533 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab0DAVGT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 17:06:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: V4L-DVB drivers and BKL
Date: Thu, 1 Apr 2010 23:06:31 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <201004011001.10500.hverkuil@xs4all.nl> <4BB4D9AB.6070907@redhat.com> <g2q829197381004011129lc706e6c3jcac6dcc756012173@mail.gmail.com>
In-Reply-To: <g2q829197381004011129lc706e6c3jcac6dcc756012173@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004012306.31471.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 01 April 2010 20:29:52 Devin Heitmueller wrote:
> On Thu, Apr 1, 2010 at 1:36 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > If you take a look at em28xx-dvb, it is not lock-protected. If the bug is due
> > to the async load, we'll need to add the same locking at *alsa and *dvb
> > parts of em28xx.
> 
> Yes, that is correct.  The problem effects both dvb and alsa, although
> empirically it is more visible with the dvb case.
> 
> > Yet, in this specific case, as the errors are due to the reception of
> > wrong data from tvp5150, maybe the problem is due to the lack of a
> > proper lock at the i2c access.
> 
> The problem is because hald sees the new device and is making v4l2
> calls against the tvp5150 even though the gpio has been toggled over
> to digital mode.  Hence an i2c lock won't help.  We would need to
> implement proper locking of analog versus digital mode, which
> unfortunately would either result in hald getting back -EBUSY on open
> of the V4L device or the DVB module loading being deferred while the
> v4l side of the board is in use (neither of which is a very good
> solution).
> 
> This is what got me thinking a few weeks ago that perhaps the
> submodules should not be loaded asynchronously.  In that case, at
> least the main em28xx module could continue to hold the lock while the
> submodules are still being loaded.

What was the reason behind the asynchronous loading? In general it simplifies
things a lot if you load modules up front.

Regards,

	Hans

> 
> Devin
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
