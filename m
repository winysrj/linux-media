Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:60136 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757549Ab0JSDUU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 23:20:20 -0400
Date: Mon, 18 Oct 2010 21:20:17 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH] viafb camera controller driver
Message-ID: <20101018212017.7c53789e@bike.lwn.net>
In-Reply-To: <4CB9AC58.5020301@infradead.org>
References: <20101010162313.5caa137f@bike.lwn.net>
	<4CB9AC58.5020301@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 16 Oct 2010 10:44:56 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> drivers/media/video/via-camera.c: In function ‘viacam_open’:
> drivers/media/video/via-camera.c:651: error: too few arguments to function ‘videobuf_queue_sg_init’

> The fix for this one is trivial:
> drivers/media/video/via-camera.c:651: error: too few arguments to function ‘videobuf_queue_sg_init’
> 
> Just add an extra NULL parameter to the function.

So I'm looking into this stuff.  The extra NULL parameter is a struct
mutex, which seems to be used in one place in videobuf_waiton():

	is_ext_locked = q->ext_lock && mutex_is_locked(q->ext_lock);

	/* Release vdev lock to prevent this wait from blocking outside access to
	   the device. */
	if (is_ext_locked)
		mutex_unlock(q->ext_lock);

I'd be most curious to know what the reasoning behind this code is; to my
uneducated eye, it looks like a real hack.  How does this function know who
locked ext_lock?  Can it really just unlock it safely?  It seems to me that
this is a sign of locking issues which should really be dealt with
elsewhere, but, as I said, I'm uneducated, and the changelogs don't help me
much.  Can somebody educate me?

Thanks,

jon
