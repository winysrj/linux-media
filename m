Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAGFUO2U009899
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 10:30:24 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAGFUBgd022833
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 10:30:12 -0500
Date: Sun, 16 Nov 2008 16:30:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87abbz698w.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811161612430.16868@axis700.grange>
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0811160142140.21494@axis700.grange>
	<8763mo6irz.fsf@free.fr>
	<Pine.LNX.4.64.0811161409350.4368@axis700.grange>
	<87abbz698w.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: soc-camera: pixelfmt translation serie
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

On Sun, 16 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > On Sun, 16 Nov 2008, Robert Jarzmik wrote:
> >
> >> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> > Yes, I saw this, and although it does look useful, I tend not to add the 
> > whole host format - sensor format infrastructure alone for this debug 
> > feature. I would restrict this generated format list to user (host) 
> > formats only - without exposing which sensor format the host has decided 
> > to use for it. We can either add this debug functionality either on a 
> > per-host basis, or implement a debug hook in host drivers? In any case I 
> > would prefer not to make this a part of the infrastructure for debugging 
> > alone.
> 
> Ah, but I think it is neceesary. The true purpose of soc_camera is to provide a
> generic infrastructure to match sensors to hosts, isn't it ?

Exactly - within v4l2 infrastructure.

> So there should be
> a way to dynamically display all available formats, and where they come from
> (ie. which sensor provides it, and with which of its own formats => thinking
> debugfs here).
> 
> Ideally, you will have a debugfs part telling what are the available formats, to
> which (host format, sensor format) they refer, and which couple is the current
> one.

Well, the thing is, the end user is only interested in "what can I get," 
not really "how this is going to be done" - at least not normally. And 
this is what the v4l2 API provides an answer to (what can I get) with the 
VIDIOC_ENUM_FMT ioctl. If you now impose this model: sensor provides 
format A, it is converted to format B by the host driver, and we present A 
and B for debugging, it might very well come to a point, where a host will 
have multi-stage image processing chain from A to B to C... What do you do 
then? And even now in many cases A == B, so in this case this information 
is superfluous. So, I think, this model sensor:A -> host:B is not generic 
enough to be exported to the user. Besides, we can always add it, so, for 
the beginning I would just try to get this conversions right with as 
little code and API modifications as possible.

> >> Would you also duplicate current_fmt, so that the current host format and sensor
> >> current format are available at sight ?
> >
> > Why? Give me a real reason (apart from debugging) why we need to know in 
> > soc_camera.c which formats the host requests from the sensor for a 
> > specific output format or which format is currently configured on the 
> > sensor?
> Exactly what you said, debug and tracability.
> 
> > Well, would it be enough if I put the current state somewhere up as a 
> > quilt patch series, for instance? I don't want to repost all patches on 
> > each iteration.
> Very well, so just in the cover which of the previous patches should be applied
> before your new serie. Or a git repository if you have one ...
> 
> Ah, and before I forget. The original idea behind the translation API was to
> have the less code in each host for format list creation. I hope you keep in
> mind that purpose. The less code in pxa_camera and sh_mobile_ceu_camera.c, the
> better.

...but also avoid putting code, that is too specific and restrictive in 
the core. So, I would rather put stuff in hardware drivers, then see - it 
is generic, let's make it once for all, than first put it centrally, and 
then see - it is not generic enough, we have to shift it down to hardware 
drivers.

> Anyway, I'll see it in your post, and compare to the translation
> framework, it's always easier to compare code than specifications :)

Yep, let's do that:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
