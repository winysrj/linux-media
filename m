Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828Ab2JIV1u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Oct 2012 17:27:50 -0400
Date: Tue, 9 Oct 2012 18:27:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
Subject: Re: Update on the CEC API
Message-ID: <20121009182725.4275d8cc@redhat.com>
In-Reply-To: <2023416.fd8kVxWoQJ@flexo>
References: <201209271633.30812.hverkuil@xs4all.nl>
	<2013064.dUp2SJ3pm9@flexo>
	<201210081749.00190.hverkuil@xs4all.nl>
	<2023416.fd8kVxWoQJ@flexo>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 08 Oct 2012 19:45:14 +0200
Florian Fainelli <f.fainelli@gmail.com> escreveu:

> On Monday 08 October 2012 17:49:00 Hans Verkuil wrote:
> > On Mon October 8 2012 17:06:20 Florian Fainelli wrote:
> > > Hi Hans,
> > > 
> > > On Thursday 27 September 2012 16:33:30 Hans Verkuil wrote:
> > > > Hi all,
> > > > 
> > > > During the Linux Plumbers Conference we (i.e. V4L2 and DRM developers) had a
> > > > discussion on how to handle the CEC protocol that's part of the HDMI 
> > > standard.
> > > > 
> > > > The decision was made to create a CEC bus with CEC clients, each represented
> > > > by a /dev/cecX device. So this is independent of the V4L or DRM APIs. 
> > > > 
> > > > In addition interested subsystems (alsa for the Audio Return Channel, and
> > > > possibly networking as well for ethernet over HDMI) can intercept/send CEC
> > > > messages as well if needed. Particularly for the CEC additions made in
> > > > HDMI 1.4a it is no longer possible to handle the CEC protocol completely in
> > > > userspace, but part of the intelligence has to be moved to kernelspace.

...

> > Also remote control messages might optionally be handled through an input driver.
> 
> Ok, then maybe just stick to the standard CEC_UI_* key codes, and let people
> having proprietary UI functions do the rest in user-space, or write their own
> input driver.

No. The RC core already provides standard ways for userspace to read/add/replace
the scancode -> Linux keycode using the standard Kernel mechanisms for that.

All it is needed is to use an userspace program for that (with already exists).
So, there's absolutely no need for per-vendor kernelspace/userspace drivers.

The RC core also allows sending remote controller keystrokes. The userspace API
currently works only with IR raw codes. There are, however, discussions and some
RFC patches proposing some changes there to also accept scancodes (and/or 
Linux keycodes) to be passed for the Remote Controller TX drivers.

So, from remote controller standpoint, just one driver will be enough to handle 
HDMI CEC.

Regards,
Mauro
