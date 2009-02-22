Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:52913 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbZBVWvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 17:51:43 -0500
Date: Sun, 22 Feb 2009 14:51:42 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans de Goede <hdegoede@redhat.com>
cc: kilgota@banach.math.auburn.edu, Hans Verkuil <hverkuil@xs4all.nl>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
In-Reply-To: <49A1CA5B.5000407@redhat.com>
Message-ID: <Pine.LNX.4.58.0902221419550.24268@shell2.speakeasy.net>
References: <200902180030.52729.linux@baker-net.org.uk>
 <200902211253.58061.hverkuil@xs4all.nl> <49A13466.5080605@redhat.com>
 <alpine.LNX.2.00.0902221225310.10870@banach.math.auburn.edu>
 <49A1A03A.8080303@redhat.com> <alpine.LNX.2.00.0902221334310.10870@banach.math.auburn.edu>
 <49A1CA5B.5000407@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 22 Feb 2009, Hans de Goede wrote:
> Yes that is what we are talking about, the camera having a gravity switch
> (usually nothing as advanced as a gyroscope). Also the bits we are talking
> about are in a struct which communicates information one way, from the camera
> to userspace, so there is no way to clear the bits to make the camera do something.

First, I'd like to say I agree with most that the installed orientation of
the camera sensor really is a different concept than the current value of a
gravity sensor.  It's not necessary, and maybe not even desirable, to
handle them in the same way.

I do not see the advantage of using reserved bits instead of controls.

The are a limited number of reserved bits.  In some structures there are
only a few left.  They will run out.  Then what?  Packing non-standard
sensor attributes and camera sensor meta-data into a few reserved bits is
not a sustainable policy.

Controls on the other card are not limited and won't run out.

Currently reserved bits and previously reserved but now in use bits
look exactly the same.  How does an app know if the bits are valid
or not?  More reserved bits?

The control API is already designed to allow for enumeration of controls.

Reserved bits have no meta-data to document them.  An app sees that some
bits in the input struct which were reserved when it was written are now
set.  What does this tell the app?  Nothing.  What can the app tell the
user?  Nothing.

The control API provides for control meta-data.  We have a means of
enumeration, name, min, max, step size, and various flags to tell us about
a control that wasn't already handled.  Does this new gravity sensor have
45 degree resolution?  The control's step size can show this even if only
90 degree rotations had been considered when gravity sensor support was
first added to some other driver.  At the very least, the app (and various
existing utilities) can provide information about the controls to the user.
