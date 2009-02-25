Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:39047 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756433AbZBYVvp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 16:51:45 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [Bugme-new] [Bug 12768] New: usb_alloc_urb() leaks memory together with uvcvideo driver
Date: Wed, 25 Feb 2009 22:55:43 +0100
Cc: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>,
	Markus Rechberger <mrechberger@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
References: <bug-12768-10286@http.bugzilla.kernel.org/> <49A4F6C0.5060503@freemail.hu> <20090225094929.09783b83@caramujo.chehab.org>
In-Reply-To: <20090225094929.09783b83@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902252255.43803.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 25 February 2009 13:49:29 Mauro Carvalho Chehab wrote:
> On Wed, 25 Feb 2009 08:44:00 +0100
>
> Németh Márton <nm127@freemail.hu> wrote:
> > What I did with the other out-of-tree em28xx-new driver was that
> > I printed out the urb->kref.refcount before and after each urb operation.
> >
> > The result was that when the urb->complete function is called, the
> > reference count was still 2, instead of 1.
> >
> > I could imagine three possible errors:
> > 1. there is a bug in uvcvideo driver
> > 2. there is a bug in v4l framework
> > 3. there is a bug in usb subsystem

I'd vote for 3 (with an option on 1, just in case).

> > It would be good if someone who have a deeper knowledge than me on these
> > fields could give some hints or debug patches which would lead us closer
> > to the solution.
>
> Márton,
>
> I did a test yesterday night with 2.6.29-rc6. The em28xx in-kernel still
> has same problem we focused a while ago (except that, before, memory were
> going exausted on a much higher rate, and we had memory leaks for every
> close() call).
>
> What happens is that, sometimes, memory are not being freed by
> usb_kill_urb()/usb_unlink_urb(). I'm trying to debug it right now, to
> understand what's happening.

Could this

http://article.gmane.org/gmane.linux.usb.general/15315/match=urb+leak

be related ?

Cheers,

Laurent Pinchart

