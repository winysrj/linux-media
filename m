Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.122.233]:44432 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759754Ab0HLKeg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 06:34:36 -0400
Subject: Re: A problem with http://git.linuxtv.org/media_tree.git
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: ext Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <3d84baeb117bdf02fa44a883e3ae05cf.squirrel@webmail.xs4all.nl>
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <201008091838.13247.hverkuil@xs4all.nl>
	 <1281425501.14489.7.camel@masi.mnp.nokia.com>
	 <b141c1c6bfc03ce320b94add5bb5f9fc.squirrel@webmail.xs4all.nl>
	 <1281441830.14489.27.camel@masi.mnp.nokia.com>
	 <4C614294.7080101@redhat.com>
	 <1281518486.14489.43.camel@masi.mnp.nokia.com>
	 <757d559ab06463d8b5e662b9aeeec701.squirrel@webmail.xs4all.nl>
	 <1281526453.14489.50.camel@masi.mnp.nokia.com>
	 <1281527073.14489.59.camel@masi.mnp.nokia.com>
	 <4C62A2AF.9070805@redhat.com>
	 <1281606326.14489.66.camel@masi.mnp.nokia.com>
	 <3d84baeb117bdf02fa44a883e3ae05cf.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 13:34:08 +0300
Message-ID: <1281609248.14489.71.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thu, 2010-08-12 at 12:29 +0200, ext Hans Verkuil wrote:
> > On Wed, 2010-08-11 at 15:16 +0200, ext Mauro Carvalho Chehab wrote:
> >> Em 11-08-2010 08:44, Matti J. Aaltonen escreveu:
> >> > Hi again.
> >> >
> >> > On Wed, 2010-08-11 at 14:34 +0300, Matti J. Aaltonen wrote:
> >> >> Hello.
> >> >>
> >> >> On Wed, 2010-08-11 at 12:56 +0200, ext Hans Verkuil wrote:
> >> >>>> Hi.
> >> >>>>
> >> >>>> I cloned your tree at 	http://linuxtv.org/git/media_tree.git and
> >> checked
> >> >>>> out the origin/staging/v2.6.37 branch and the
> >> >>>> Documentation/video4linux/v4l2-controls.txt  just isn't there. I
> >> asked
> >> >>>> one of my colleagues to do the same and the result was also the
> >> same.
> >> >>>
> >> >>> The file is in the v2.6.36 branch. It hasn't been merged yet in the
> >> >>> v2.6.37 branch.
> >> >>
> >> >> 37 above was a typo, sorry. My point was that we couldn't find it in
> >> the
> >> >> origin/staging/v2.6.36 branch... and that the branch lags behind of
> >> what
> >> >> can be seen via the git web interface...
> >> >>
> >> >> B.R.
> >> >> Matti
> >> >
> >> > I'd suggest - if that's not too much trouble - that you'd clone the
> >> tree
> >> > using http (from http://linuxtv.org/git/media_tree.git) and then
> >> checked
> >> > out the 36 branch and see that it works for you and then post the
> >> > command you used and then I'll admit what I did wrong - if
> >> necessary:-)
> >>
> >> You should try to avoid using http method for clone/fetch. It depends on
> >> some
> >> files that are created by running "git update-server-info". There's a
> >> script to
> >> run it automatically after each push. Yet, the better is to use git.
> >
> > I guess I didn't emphasize my point enough... I would avoid using http
> > if it wasn't the only protocol I can use to access your site... And if
> > you have serious problems with it I think it would be fair to mention
> > that on your git web page...
> 
> FYI: the control framework has been merged into the mainline, so you can
> get it from there as well.

OK, good, the mainline tree can be cloned over http...

Thanks,
Matti

> 
> Regards,
> 
>         Hans
> 


