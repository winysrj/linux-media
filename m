Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:3474 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbZKTLve (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 06:51:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: Help in adding documentation
Date: Fri, 20 Nov 2009 12:51:29 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A69FA2915331DC488A831521EAE36FE401559C59A2@dlee06.ent.ti.com> <A69FA2915331DC488A831521EAE36FE40155A51446@dlee06.ent.ti.com> <A69FA2915331DC488A831521EAE36FE40155A5149B@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155A5149B@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911201251.29694.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 19 November 2009 18:01:28 Karicheri, Muralidharan wrote:
> Hans,
>
> It is hard for me to get the v4l2-apps compile on my build environment.
> Unless someone can help me to resolve the build issue, I wouldn't be able
> to update the v4l2-apps or Alternately someone volunteer to add this
> support based on the API.

OK, the correct procedure to build the apps is this:

go to the top-level of your v4l-dvb repository and then run:

make distclean (just to be sure we start from scratch)
make apps

Now, I do get a compile error for decode_tm6000.c (patch pending in one of 
my pull requests), but by then v4l2-ctl.cpp has already been built.

I've also just discovered that the libv4l Makefiles are wrong: they contain 
a -I../../../include that should be a -I../../include. I think these 
sources have been moved up one level and the Makefiles were never updated. 
So if you don't have a recent videodev2.h in your /usr/include/linux 
directory, then you can get all sorts of compile errors.

I've added a patch for this to my pending 
http://www.linuxtv.org/hg/~hverkuil/v4l-dvb tree. As a workaround while 
this patch is not merged yet you can copy 
v4l2-apps/include/linux/videodev2.h to /usr/include/linux/videodev2.h.

If you still have problems compiling the v4l2-ctl.cpp tool, then you can 
also do it manually:

g++ -O2 -I../include -D_GNU_SOURCE -lm  v4l2-ctl.cpp   -o v4l2-ctl

Regards,

	Hans

>
> Thanks and regards,
>
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> phone: 301-407-9583
> email: m-karicheri2@ti.com
>
> >-----Original Message-----
> >From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> >owner@vger.kernel.org] On Behalf Of Karicheri, Muralidharan
> >Sent: Thursday, November 19, 2009 11:26 AM
> >To: Hans Verkuil; Mauro Carvalho Chehab
> >Cc: linux-media@vger.kernel.org
> >Subject: RE: Help in adding documentation
> >
> >BTW,
> >
> >I don't know what is qt4/qt3 that you are referring to.
> >I see qv4l2 in the directory v4l2-apps/qv4l2.
> >
> >Murali Karicheri
> >Software Design Engineer
> >Texas Instruments Inc.
> >Germantown, MD 20874
> >phone: 301-407-9583
> >email: m-karicheri2@ti.com
> >
> >>-----Original Message-----
> >>From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> >>Sent: Wednesday, November 18, 2009 2:33 AM
> >>To: Mauro Carvalho Chehab
> >>Cc: Karicheri, Muralidharan; linux-media@vger.kernel.org
> >>Subject: Re: Help in adding documentation
> >>
> >>On Wednesday 18 November 2009 08:24:13 Mauro Carvalho Chehab wrote:
> >>> Hans Verkuil wrote:
> >>> > On Wednesday 18 November 2009 08:04:10 Mauro Carvalho Chehab wrote:
> >>> >> Karicheri, Muralidharan escreveu:
> >>> >>> Mauro,
> >>> >>>
> >>> >>> Thanks to your help, I could finish my documentation today.
> >>> >>>
> >>> >>> But I have another issue with the v4l2-apps.
> >>> >>>
> >>> >>> When I do make apps, it doesn't seem to build. I get the
> >>> >>> following
> >>
> >>error
> >>
> >>> >>> logs... Is this broken?
> >>> >>
> >>> >> Well... no, it is not really broken, but the build system for
> >>> >> v4l2-
> >>
> >>apps
> >>
> >>> >> needs serious improvements. There are some know issues on it:
> >>> >> 	- It doesn't check/warn if you don't have all the dependencies
> >>> >> 	  (qv4l2 and v4l2-sysfs-path require some development libraries
> >>> >> 	   that aren't available per default when gcc is installed - I
> >>> >> 	   think the other files there are ok);
> >>> >> 	- make only works fine when calling on certain directories (it
> >
> >used
> >
> >>to work
> >>
> >>> >> 	  fine if you call it from /v4l2-apps/*) - but, since some
> >
> >patch, it
> >
> >>now requires
> >>
> >>> >> 	  that you call make from /v4l2-apps, in order to create v4l2-
> >>
> >>apps/include.
> >>
> >>> >> 	  After having it created, make can be called from a /v4l2-apps
> >>
> >>subdir;
> >>
> >>> >> 	- for some places (libv4l - maybe there are other places?), you
> >
> >need
> >
> >>to
> >>
> >>> >> 	  have the latest headers installed, as it doesn't use the one
> >
> >at the
> >
> >>tree.
> >>
> >>> >> 	- qv4l2 only compiles with qt3.
> >>> >
> >>> > I have a qt4 version available in my v4l-dvb-qv4l2 tree. Just no
> >>> > time
> >>
> >>to work
> >>
> >>> > on a series of patches to merge it in the main repo. And it is
> >>> > missing
> >>
> >>string
> >>
> >>> > control support.
> >>> >
> >>> > If anyone is interested, then feel free to do that work. This new
> >>> > qt4
> >>
> >>version
> >>
> >>> > is much better than the qt3 version.
> >>>
> >>> IMO, the better is to have both versions on separate dirs, and let
> >>> the
> >>
> >>building
> >>
> >>> system to check if qt4 is available. If so, build the qt4 version
> >
> >instead
> >
> >>of
> >>
> >>> qt3 (a configure script, for example). Otherwise, warn users that it
> >>> is
> >>
> >>compiling
> >>
> >>> a legacy application, due to the lack of the proper dependencies.
> >>
> >>I'm not going to maintain the qt3 version. Personally I think it is
> >>pointless
> >>having two tools for this and it only creates confusion and unnecessary
> >>maintenance cost. Of course, all this is moot as long as the new
> >> version
> >
> >is
> >
> >>still unmerged.
> >>
> >>BTW: everything inside v4l2-apps should use the generated headers
> >> inside v4l2-apps/include. These are generated from the headers in the
> >> tree and
> >
> >yes,
> >
> >>it would be nice if v4l2-apps/Makefile would have a proper dependency
> >> to generate them. Now only the top-level Makefile knows about it.
> >> After that include directory is generated you can do a make in
> >> v4l2-apps.
> >>
> >>But libv4l should use those headers and not the installed headers.
> >>Something
> >>may have been broken since when I last wrote that code.
> >>
> >>Regards,
> >>
> >>	Hans
> >>
> >>--
> >>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media"
> > in the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
