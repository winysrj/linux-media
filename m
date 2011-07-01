Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1135 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab1GAMKW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 08:10:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: RFC: poll behavior
Date: Fri, 1 Jul 2011 14:10:15 +0200
Cc: Hans Verkuil <hansverk@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
References: <201106291326.47527.hansverk@cisco.com> <201107011145.51118.hverkuil@xs4all.nl> <4E0DB692.7040605@redhat.com>
In-Reply-To: <4E0DB692.7040605@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107011410.15401.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, July 01, 2011 13:59:14 Mauro Carvalho Chehab wrote:
> Em 01-07-2011 06:45, Hans Verkuil escreveu:
> > On Thursday, June 30, 2011 22:35:15 Mauro Carvalho Chehab wrote:
> 
> >>> This also leads to another ambiguity with poll(): what should poll do if 
> >>> another filehandle started streaming? So fh1 called STREAMON (and so becomes 
> >>> the 'owner' of the stream), and you poll on fh2. If a frame becomes available, 
> >>> should fh2 wake up? Is fh2 allowed to call DQBUF?
> >>
> >> IMO, both fh's should get the same results. This is what happens if you're
> >> writing into a file and two or more processes are selecting at the EOF.
> > 
> > Yes, but multiple filehandles are allowed to write/read from a file at the
> > same time. That's not true for V4L2. Only one filehandle can do I/O at a time.
> 
> Actually, this is not quite true currently, as you could, for example use one fd
> for QBUF, and another for DQBUF, with the current behavior, but, with luck,
> no applications are doing weird things like that. Yet, tests are needed to avoid
> breaking something, if we're willing to change it.

Many drivers prevent such things. But it is very much up to the driver. My
gut-feeling is that it is a 50-50 split between drivers that allow it (whether
it actually works is another matter) and drivers that prevent this and return
-EBUSY.

> > I'm going to look into changing fs/select.c so that the poll driver function
> > can actually see the event mask provided by the application.
> 
> Why? A POLLERR should be notified, whatever mask is there, as the application
> may need to abort (for example, in cases like hardware removal).

If an application isn't interested in POLLIN or POLLOUT, but just POLLPRI, then
poll() doesn't need to start streaming.

It obviously makes no sense to start streaming if the application isn't polling
for input.

Regards,

	Hans
