Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6THGKkf030097
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 13:16:20 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6THG8SE011331
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 13:16:08 -0400
Date: Tue, 29 Jul 2008 19:16:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87tze997uu.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0807291902200.17188@axis700.grange>
References: <1217113647-20638-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0807270155020.29126@axis700.grange>
	<878wvnkd8n.fsf@free.fr>
	<Pine.LNX.4.64.0807271337270.1604@axis700.grange>
	<87tze997uu.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] Fix suspend/resume of pxa_camera driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Mon, 28 Jul 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > On Sun, 27 Jul 2008, Robert Jarzmik wrote:
> >
> > Yes, this is the difference. The sensor is attached to the camera host 
> > only on open. In fact, I am not sure, how video applications should behave 
> > during a suspend / resume cycle. If you suspend, while, say, recording 
> > from your camera, should you directly continue recording after a wake up? 
> > How do currect drivers implement this? Or, in general, for example with 
> > audio - if you suspend while listening to a stream over the net, or to a 
> > CD, or to a mp3-file on your local disk, should the sound resume after a 
> > wake up? I added linux-pm for some authoritative answers:-)
> AFAIK, on resume, sound streams continues. So the normal behaviour would be to
> continue video stream too (as done in ALSA). This supposes the whole video chip
> state is saved on suspend and restored on resume, of course.

Ok, that's what I also thought.

> > If you know how a v4l2 device should handle suspend/resume, or when we get 
> > some answers, let's try to do it completely-
> Of course. In a week or two, my mt9m111 driver will be ready for submission, and
> in the review process I'll post a submission for complete suspend/resume.
> 
> >> For the camera part, by now, I'm using standard suspend/resume functions of the
> >> platform driver (mt9m111.c). It does work, but it's not clean ATM. The chaining
> >> between the driver resume function and the availability of the I2C bus are not
> >> properly chained. I'm still working on it.
> >
> > Yes, we have to clarify this too.
> Yes.
> 
> So, to sum up :
>  - I finish the mt9m111 driver
>  - I submit it
>  - I cook up a clean suspend/resume (unless you did it first of course :)

Good plan! You don't have to worry - I will not do this before you:-)

And, I am still waiting for the patch to move .power and .reset to 
camera-link (see my another post on the V4L ML today). With that patch in 
place your power-management would also become easier and more logical.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
