Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:50234 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220Ab0BXCiR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 21:38:17 -0500
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
From: hermann pitton <hermann-pitton@arcor.de>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Brandon Philips <brandon@ifup.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
In-Reply-To: <1a297b361002230145t325ec009h877defe104dfccb3@mail.gmail.com>
References: <4B55445A.10300@infradead.org> <4B5B30E4.7030909@redhat.com>
	 <20100222225426.GC4013@jenkins.home.ifup.org>
	 <201002230026.59712.hverkuil@xs4all.nl>
	 <20100222233808.GD4013@jenkins.home.ifup.org>
	 <4B83242E.40703@infradead.org>
	 <1a297b361002230145t325ec009h877defe104dfccb3@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 24 Feb 2010 03:32:23 +0100
Message-Id: <1266978743.3178.4.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Dienstag, den 23.02.2010, 13:45 +0400 schrieb Manu Abraham:
> On Tue, Feb 23, 2010 at 4:41 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > Brandon Philips wrote:
> >> On 00:26 Tue 23 Feb 2010, Hans Verkuil wrote:
> >>> On Monday 22 February 2010 23:54:26 Brandon Philips wrote:
> >>>> On 18:24 Sat 23 Jan 2010, Hans de Goede wrote:
> >>>>>> lib/
> >>>>>>   libv4l1/
> >>>>>>   libv4l2/
> >>>>>>   libv4lconvert/
> >>>>>> utils/
> >>>>>>   v4l2-dbg
> >>>>>>   v4l2-ctl
> >>>>>>   cx18-ctl
> >>>>>>   ivtv-ctl
> >>>>>> contrib/
> >>>>>>   test/
> >>>>>>   everything else
> >>>>>>
> >>>>   git clone git://ifup.org/philips/create-v4l-utils.git
> >>>>   cd create-v4l-utils/
> >>>>   ./convert.sh
> >>>>
> >>>> You should now have v4l-utils.git which should have this directory
> >>>> struture. If we need to move other things around let me know and I can
> >>>> tweak name-filter.sh
> >>>>
> >>>> Thoughts? Let me know how we should proceed with dropping v4l2-apps
> >>>> from v4l-dvb.
> >>>>
> >>>> Re: code style cleanup. I think we should do that once we drop
> >>>> v4l2-apps/ from v4l-dvb and make the new v4l-utils.git upstream.
> >>> Question: shouldn't we merge dvb-apps and v4l-utils? The alevtv tool was
> >>> merged into dvb-apps, but while that tool supports dvb, it also supports
> >>> v4l2. Just like we merged dvb and v4l in a single repository, so I think we
> >>> should also merge the tools to a media-utils repository.
> >>>
> >>> It remains a fact of life that dvb and v4l are connected and trying to
> >>> artificially keep them apart does not make much sense to me.
> >>
> >> Easy to do but who should be the maintainer of the dvb things?
> >>
> >> According to the wiki[1] these tools are without a maintainer. So, if
> >> no one cares about them enough to make releases why merge them and
> >> clutter up the git tree with dead code?
> >>
> >> Cheers,
> >>
> >>       Brandon
> >>
> >> [1] http://www.linuxtv.org/wiki/index.php/LinuxTV_dvb-apps
> >
> > That's weird. I've recently added support for ISDB-T on it:
> >        http://linuxtv.org/hg/~mchehab/dvb-apps-isdbt2/
> 
> 
> That's probably Michael Krufky (user: Jon2856) from what i guess, he
> has been the one who has been making ground for propaganda's on the
> wiki.

Manu, you are actively calling the trolls back again with such
accusations!

It is the other way round, you own him at least one clear excuse.

Cheers,
Hermann

> > and we've got some comments at the mailing list. Btw, the patches
> > I added there also adds DVB-S2 support to szap/scan, but tests
> > are needed, since I don't have any satellite dish nowadays.
> 
> 
> Btw, I did spend time to review your code before it is pulled in. You
> did not even provide a reply on my last mail on the subject, or did I
> miss that reply of yours ?
> 
> 
> Regards,
> Manu



