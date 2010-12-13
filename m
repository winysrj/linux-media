Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:56292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab0LMSbq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 13:31:46 -0500
Date: Mon, 13 Dec 2010 13:31:28 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
	Linux Input <linux-input@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jiri Kosina <jkosina@suse.cz>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Subject: Re: [RFC] Input: define separate EVIOCGKEYCODE_V2/EVIOCSKEYCODE_V2
Message-ID: <20101213183128.GE2531@redhat.com>
References: <20101209093948.GD8821@core.coreip.homeip.net>
 <4D012844.3020009@euromail.se>
 <20101209191647.GC23781@core.coreip.homeip.net>
 <20101213090559.GH21401@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213090559.GH21401@core.coreip.homeip.net>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Mon, Dec 13, 2010 at 01:06:00AM -0800, Dmitry Torokhov wrote:
> On Thu, Dec 09, 2010 at 11:16:47AM -0800, Dmitry Torokhov wrote:
> > On Thu, Dec 09, 2010 at 08:04:36PM +0100, Henrik Rydberg wrote:
> > > On 12/09/2010 10:39 AM, Dmitry Torokhov wrote:
> > > 
> > > > The desire to keep old names for the EVIOCGKEYCODE/EVIOCSKEYCODE while
> > > > extending them to support large scancodes was a mistake. While we tried
> > > > to keep ABI intact (and we succeeded in doing that, programs compiled
> > > > on older kernels will work on newer ones) there is still a problem with
> > > > recompiling existing software with newer kernel headers.
> > > > 
> > > > New kernel headers will supply updated ioctl numbers and kernel will
> > > > expect that userspace will use struct input_keymap_entry to set and
> > > > retrieve keymap data. But since the names of ioctls are still the same
> > > > userspace will happily compile even if not adjusted to make use of the
> > > > new structure and will start miraculously fail in the field.
> > > > 
> > > > To avoid this issue let's revert EVIOCGKEYCODE/EVIOCSKEYCODE definitions
> > > > and add EVIOCGKEYCODE_V2/EVIOCSKEYCODE_V2 so that userspace can explicitly
> > > > select the style of ioctls it wants to employ.
> > > > 
> > > > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> > > > ---
> > > 
> > > 
> > > Would the header change suffice in itself?
> > 
> > We still need to change evdev to return -EINVAL on wrong sizes but yes,
> > the amount of change there could be more limited. I just thought that
> > splitting it up explicitly shows the differences in handling better. If
> > people prefer the previos version we could leave it, I am 50/50 between
> > them.
> > 
> 
> *ping*
> 
> Mauro, Jarod, do you have an opinion on this? I think we need to settle
> on a solution before 2.6.37 is out.

Sorry, been meaning to reply, just been quite tied up with other work...
I'm of two minds on this as well, but probably leaning slightly in favor
of going ahead with an explicit _V2 so as to not break existing userspace
in new and unexpected ways. There presumably isn't much in the way of
userspace already adapted to the new interface, and its simple to do
another rev of those that have been. Okay, yeah, this is probably the best
way to go about it.

Acked-by: Jarod Wilson <jarod@redhat.com>


-- 
Jarod Wilson
jarod@redhat.com

