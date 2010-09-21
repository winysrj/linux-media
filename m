Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4628 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab0IUTFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 15:05:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC PATCHES] First version of the V4L2 core locking patches
Date: Tue, 21 Sep 2010 21:04:55 +0200
Cc: linux-media@vger.kernel.org, "Arnd Bergmann" <arnd@arndb.de>
References: <201009202337.01948.hverkuil@xs4all.nl> <d2ceed8db848d1fbb35e751f5ccada51.squirrel@webmail.xs4all.nl> <20100921141407.0893f03f@pedra>
In-Reply-To: <20100921141407.0893f03f@pedra>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009212104.55682.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, September 21, 2010 19:14:07 Mauro Carvalho Chehab wrote:
> Em Tue, 21 Sep 2010 15:50:13 +0200
> "Hans Verkuil" <hverkuil@xs4all.nl> escreveu:
> 
> > Hi Mauro,
> > 
> > > Em 20-09-2010 18:37, Hans Verkuil escreveu:
> ...
> > > 	/*
> > > 	 * Need to sleep in order to wait for videobufs to complete.
> > > 	 * It is not a good idea to sleep while waiting for an event with the dev
> > > lock hold,
> > > 	 * as it will block any other access to the device. Just unlock it while
> > > waiting,
> > > 	 * locking it again at the end.
> > > 	 */
> > >
> > >  	is_vdev_locked = (q->vdev_lock && mutex_is_locked(q->vdev_lock)) ? true
> > > : false;
> > > 	if (is_vdev_locked)
> > > 		mutex_unlock(q->vdev_lock);
> > > 	if (intr)
> > > 		return wait_event_interruptible(vb->done, is_state_active_or_queued(vb,
> > > q));
> > 
> > This obviously needs to save the return value and continue to make sure
> > the lock is taken again.
> 
> Yeah, it should be:
>  rc = wait_event_interruptible(vb->done, is_state_active_or_queued(vb, q));
> 
> and return rc at the end.
>  
> > > 	else
> > > 		wait_event(vb->done, is_state_active_or_queued(vb, q));
> > > 	if (is_vdev_locked)
> > > 		mutex_lock(q->vdev_lock);
> > >
> > > 	return 0;
> > > }
> > 
> > Agreed. Thanks for reviewing this, it was the one patch that I knew I had
> > to look into more closely. I'll incorporate your changes.
> 
> Ok, thanks.

I added a patch with basically this code to my test tree. I will try to convert
and test a few more drivers, but that will probably be Friday. If the conversion
goes well then I plan to post a pull request by Friday or Saturday with somewhat
cleaned up patches.

I strongly suspect that for the 2-3 weeks after that I will not be able to
continue with this, so I hope others will take over from me.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
