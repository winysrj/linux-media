Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:38595 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbZEBAD4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2009 20:03:56 -0400
Date: Fri, 1 May 2009 19:03:55 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Alexey Klimov <klimov.linux@gmail.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@isely.net>
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS,  2.6.16-2.6.21:
 ERRORS
In-Reply-To: <208cbae30904301320u4e8e594aw6eb8ce2ed7c507cf@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0905011901500.15541@cnc.isely.net>
References: <200904191818.n3JIISWN021959@smtp-vbr12.xs4all.nl>
 <208cbae30904191542l4e3996cejf1df9cadfb187dfe@mail.gmail.com>
 <Pine.LNX.4.64.0904191849280.19718@cnc.isely.net>
 <208cbae30904301320u4e8e594aw6eb8ce2ed7c507cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811561-1650566038-1241222635=:15541"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811561-1650566038-1241222635=:15541
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 1 May 2009, Alexey Klimov wrote:

> Hello,
> 
> On Mon, Apr 20, 2009 at 3:59 AM, Mike Isely <isely@isely.net> wrote:

   [...]

> >
> > So the kernel already has this; it just needs to be pulled back into
> > v4l-dvb.  It's an obvious trivial thing for now and I've acked it there.
> > Obviously we're getting had here because you're compiling against a
> > kernel snapshot that's been changed but v4l-dvb doesn't have the
> > corresponding change in its local copy of the pvrusb2 driver.  Part of
> > the fun of synchronizing changes from different trees :-(
> 
> Well, good to know that this thing is already fixed.
> I'm very sorry for the mess.

No apology needed.  Really - this "mess" wasn't caused by you.  If 
anything I should have just immediately pulled that patch into hg and 
not waited for it to trickle back to Mauro.  That would have avoided the 
error.  So, all I can say is that I'm sorry you had to hit this!

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
---1463811561-1650566038-1241222635=:15541--
