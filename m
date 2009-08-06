Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:52997 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984AbZHFPOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 11:14:35 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "eduardo.valentin@nokia.com" <eduardo.valentin@nokia.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Thu, 6 Aug 2009 10:18:15 -0500
Subject: RE: Linux Plumbers Conference 2009: V4L2 API discussions
Message-ID: <A24693684029E5489D1D202277BE89444A4D863C@dlee02.ent.ti.com>
References: <200908040912.24718.hverkuil@xs4all.nl>
 <19F8576C6E063C45BE387C64729E73940432AF3A5D@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940432AF3A5D@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Hiremath, Vaibhav
> Sent: Tuesday, August 04, 2009 12:13 PM
> To: Hans Verkuil; linux-media@vger.kernel.org
> Cc: eduardo.valentin@nokia.com; davinci-linux-open-
> source@linux.davincidsp.com; linux-omap@vger.kernel.org; Magnus Damm;
> Dongsoo, Nathaniel Kim
> Subject: RE: Linux Plumbers Conference 2009: V4L2 API discussions
> 
> 
> 
> > -----Original Message-----
> > From: davinci-linux-open-source-bounces@linux.davincidsp.com
> > [mailto:davinci-linux-open-source-bounces@linux.davincidsp.com] On
> > Behalf Of Hans Verkuil
> > Sent: Tuesday, August 04, 2009 12:42 PM
> > To: linux-media@vger.kernel.org
> > Cc: eduardo.valentin@nokia.com; davinci-linux-open-
> > source@linux.davincidsp.com; linux-omap@vger.kernel.org; Magnus
> > Damm; Dongsoo, Nathaniel Kim
> > Subject: Linux Plumbers Conference 2009: V4L2 API discussions
> >
> > Hi all,
> >
> > During this years Plumbers Conference I will be organizing a session
> > (or
> > possibly more than one) on what sort of new V4L2 APIs are needed to
> > support the new SoC devices. These new APIs should also solve the
> > problem
> > of how to find all the related alsa/fb/ir/dvb devices that a typical
> > video
> > device might create.
> >
> > A proposal was made about a year ago (note that this is a bit
> > outdated
> > by now, but the basics are still valid):
> >
> > http://www.archivum.info/video4linux-list%40redhat.com/2008-
> > 07/msg00371.html
> >
> > In the past year the v4l2 core has evolved enough so that we can
> > finally
> > start thinking about this for real.
> >
> > I would like to know who will be attending this conference. I also
> > urge
> > anyone who is working in this area and who wants to have a say in
> > this to
> > attend the conference. The goal is to prepare a new RFC with a
> > detailed
> > proposal on the new APIs that are needed to fully support all the
> > new
> > SoCs. So the more input we get, the better the end-result will be.
> >
> [Hiremath, Vaibhav] Hi Hans,
> 
> I will be attending the conference and along with above mentioned RFC I
> would want to discuss some of the open issues, forthcoming TI devices,
> their complexity and required software interfaces (media processor (as you
> mentioned above)) and similar stuff.

Hans, Vaibhav,

I'll be attending this conference too. I just got approval from my boss ;).

I'm starting to take the v4l2_subdev migration task as a high priority now, since most of the stability related issues in some proprietary platform are gone now. :)

Actually, I'm also interested on the discussions about the Preview/Resizer Wrappers.

Meet you there.

Regards,
Sergio
> 
> 
> I will work with you offline before sharing the details here with the
> community.
> 
> Thanks,
> Vaibhav Hiremath
> 
> > Early-bird registration is still possible up to August 5th (that's
> > tomorrow :-) ).
> >
> > Regards,
> >
> > 	Hans
> >
> > --
> > Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> >
> > _______________________________________________
> > Davinci-linux-open-source mailing list
> > Davinci-linux-open-source@linux.davincidsp.com
> > http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-
> > source
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

