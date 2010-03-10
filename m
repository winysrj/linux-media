Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2A7oRYe006417
	for <video4linux-list@redhat.com>; Wed, 10 Mar 2010 02:50:27 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o2A7oEcP029556
	for <video4linux-list@redhat.com>; Wed, 10 Mar 2010 02:50:14 -0500
Date: Wed, 10 Mar 2010 08:50:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Arno Euteneuer <arno.euteneuer@toptica.com>
Subject: Re: soc-camera driver for i.MX25
In-Reply-To: <4B974A71.5030506@toptica.com>
Message-ID: <Pine.LNX.4.64.1003100849200.4618@axis700.grange>
References: <4B960AE2.3090803@toptica.com> <4B974A71.5030506@toptica.com>
MIME-Version: 1.0
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, 10 Mar 2010, Arno Euteneuer wrote:

> Thanks for your interest!
> 
> > Nice, thanks for the patch! Now, you'd have to formalise the submission -
> > add your Signed-off-by line, provide a suitable patch description.
> Ok. That sounds like the easy part ;)
> 
> > More
> > importantly, it certainly has to be updated for 2.6.32 and 2.6.33 - the
> > biggest change since 2.6.31 has been the conversion to the v4l2-subdev
> > API, and a smaller one - the addition of the mediabus API.
> I already suspected that I have to update it :D Currently I'm using a 2.6.31
> kernel that has been patched with a BSP from the board supplier. So, I have to
> first update these patches in order to be able to run my system with a current
> kernel,I guess. I will try that ...

Good, looking forward to an updated patch;)

> > For a single
> > driver these are not very big changes, I could help you with them, but you
> > certainly would have to re-test your setup with the current kernel. Would
> > you be able to do that? And then, of course, we'd also have to pass your
> > driver through the usual review rounds.
> > 
> Thanks for your encouraging answer. I never before submitted a driver and any
> help is highly appreciated.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
