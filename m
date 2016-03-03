Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34288 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbcCCSuo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 13:50:44 -0500
Date: Thu, 3 Mar 2016 15:50:37 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jani Nikula <jani.nikula@intel.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Keith Packard <keithp@keithp.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160303155037.705f33dd@recife.lan>
In-Reply-To: <20160303071305.247e30b1@lwn.net>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 03 Mar 2016 07:13:05 -0700
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Thu, 03 Mar 2016 16:03:14 +0200
> Jani Nikula <jani.nikula@intel.com> wrote:
> 
> > This stalled a bit, but the waters are still muddy...  
> 
> I've been dealing with real-world obnoxiousness, something which won't
> come to an immediate end, unfortunately.  But I have been taking some time
> to mess with things, and hope to have some more POC patches to send out
> soon.
> 
> > Is the Sphinx/reStructuredText table support adequate for media/v4l
> > documentation?  
> 
> That's perhaps the biggest question.  My sense is "yes", but this needs a
> bit more assurance than that.

On my tests, Sphinix seemed too limited to format tables. Asciidoc
produced an output that worked better.

Please notice that we tried to convert only one type of table. The result
with RST was not beautiful, but worked.

However, we use tables also to show how bits appear at the video formats,
like the tables at:
	https://linuxtv.org/downloads/v4l-dvb-apis/subdev.html#v4l2-mbus-format

For those tables to look nice, we should be able to remove borders and grids
from the table. I was unable to find a way to control the tables format
with RST to do things like grid/border removal.

> > Are the Sphinx output formats adequate in general? Specifically, is the
> > lack of DocBook support, and the flexibility it provides, a blocker?  
> 
> DocBook is a means to an end; nobody really wants DocBook itself as far
> as I can tell. I've been messing with rst2pdf a bit; it's not hard to get
> reasonable output, and, with some effort, we could probably get really
> nice output. HTML and EPUB are easily covered, still haven't really played
> around with man pages yet.  And there's LaTeX if we really need it.  I
> kind of think we're covered there, unless I've missed something?
> 
> > Otherwise, I think Sphinx is promising.
> > 
> > Jon, I think we need a roll of dice, err, a well-thought-out decision
> > from the maintainer to go with one or the other, so we can make some
> > real progress.  
> 
> My inclination at the moment is very much in the Sphinx direction.  I had
> some vague thoughts of pushing a throwaway experimental directory with a
> couple of docs for 4.6 that would just let people play with it easily;
> then we'd see how many screams we get.  We'll see if the world lets me get
> there.

I'm not against having a staging/Documentation for us to play with,
provided, of course, that whatever tool chosen would allow converting
what we have today.

Regards,
Mauro
