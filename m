Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60780 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbZGTNyb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 09:54:31 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] em28xx: kworld 340u
Date: Mon, 20 Jul 2009 09:53:20 -0400
Cc: acano@fastmail.fm, linux-media@vger.kernel.org
References: <20090718213428.GA8854@localhost.localdomain> <829197380907181513mbd8dc5ag7facc128a2b2a951@mail.gmail.com>
In-Reply-To: <829197380907181513mbd8dc5ag7facc128a2b2a951@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907200953.21506.jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 18 July 2009 18:13:30 Devin Heitmueller wrote:
> On Sat, Jul 18, 2009 at 5:34 PM, <acano@fastmail.fm> wrote:
> > support for kworld 340u.  8vsb and qam256 work, qam64 untested.
> 
> Hello Acano,
> 
> You should talk to Jarod Wilson about this.  He did a bunch of work to
> get the 340u working over the last couple of months, and you two could
> probably collaborate on a unified solution.

Hrm. I really probably should have sent something to the list that
mentioned I'd done this, to prevent duplication... Oops.

> There were also some
> problems related to the fact that the device can have either the
> tda18271c1 or the c2 (both have the same USB id), which would have to
> be accommodated in the final solution.

But with luck, some combination of dvb_gpio changes will get them
both behaving... But yeah, this is the main thing currently holding
back what I've got being merged.

> The patch itself also needs alot of cleanup and doesn't meet the
> coding standards.  It would need considerable cleanup before it could
> be taken upstream.

Just took a quick look. I don't think there's anything in there I
haven't already got covered, and covered in a way that should already
be up to kernel coding standards. The other major difference with my
approach, is that rather than use the lgdt3304 driver to handle the
demod, I'm using a modified lgdt3305 driver with 3304 support added,
as its a FAR more complete driver, and the two are incredibly similar.

WIP patches from a few weeks back:

http://jwilson.fedorapeople.org/misc/lgdt3305-add-lgdt3304-support-20090623.patch
http://jwilson.fedorapeople.org/misc/em28xx-add-kworld-340u-using-lgdt3305-20090623.patch

But yeah, we still need to work out properly supporting both the C1 and
C2 variant of the stick -- my C1 works perfectly, Mike Krufky's C2 does
not... But it could be as simple as fixing up the dvb_gpio settings,
just need to get around to figuring out what the bare minimum are that
need to be reset on the C1, then see if that works better for the C2...

-- 
Jarod Wilson
jarod@redhat.com
