Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:51624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab0IUROP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 13:14:15 -0400
Date: Tue, 21 Sep 2010 14:14:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [RFC PATCHES] First version of the V4L2 core locking patches
Message-ID: <20100921141407.0893f03f@pedra>
In-Reply-To: <d2ceed8db848d1fbb35e751f5ccada51.squirrel@webmail.xs4all.nl>
References: <201009202337.01948.hverkuil@xs4all.nl>
	<4C98B5E3.9010008@redhat.com>
	<d2ceed8db848d1fbb35e751f5ccada51.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em Tue, 21 Sep 2010 15:50:13 +0200
"Hans Verkuil" <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> > Em 20-09-2010 18:37, Hans Verkuil escreveu:
...
> > 	/*
> > 	 * Need to sleep in order to wait for videobufs to complete.
> > 	 * It is not a good idea to sleep while waiting for an event with the dev
> > lock hold,
> > 	 * as it will block any other access to the device. Just unlock it while
> > waiting,
> > 	 * locking it again at the end.
> > 	 */
> >
> >  	is_vdev_locked = (q->vdev_lock && mutex_is_locked(q->vdev_lock)) ? true
> > : false;
> > 	if (is_vdev_locked)
> > 		mutex_unlock(q->vdev_lock);
> > 	if (intr)
> > 		return wait_event_interruptible(vb->done, is_state_active_or_queued(vb,
> > q));
> 
> This obviously needs to save the return value and continue to make sure
> the lock is taken again.

Yeah, it should be:
 rc = wait_event_interruptible(vb->done, is_state_active_or_queued(vb, q));

and return rc at the end.
 
> > 	else
> > 		wait_event(vb->done, is_state_active_or_queued(vb, q));
> > 	if (is_vdev_locked)
> > 		mutex_lock(q->vdev_lock);
> >
> > 	return 0;
> > }
> 
> Agreed. Thanks for reviewing this, it was the one patch that I knew I had
> to look into more closely. I'll incorporate your changes.

Ok, thanks.


-- 

Cheers,
Mauro
