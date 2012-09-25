Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2365 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2IYGvK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 02:51:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
Subject: Re: [RFC] Timestamps and V4L2
Date: Tue, 25 Sep 2012 08:50:35 +0200
Cc: linux-media@vger.kernel.org
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <20120923114342.GF12025@valkosipuli.retiisi.org.uk> <201209242311.51003@leon.remlab.net>
In-Reply-To: <201209242311.51003@leon.remlab.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209250850.35473.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon September 24 2012 22:11:50 Rémi Denis-Courmont wrote:
> Le dimanche 23 septembre 2012 14:43:42, Sakari Ailus a écrit :
> > > I think I like this idea best, it's relatively simple (even with adding
> > > support for reporting flags in VIDIOC_QUERYBUF) for the purpose.
> > > 
> > > If we ever need the clock selection API I would vote for an IOCTL.
> > > The controls API is a bad choice for something such fundamental as
> > > type of clock for buffer timestamping IMHO. Let's stop making the
> > > controls API a dumping ground for almost everything in V4L2! ;)
> > 
> > Why would the control API be worse than an IOCTL for choosing the type of
> > the timestamp? The control API after all has functionality for exactly for
> > this: this is an obvious menu control.
> > 
> > What comes to the nature of things that can be configured using controls
> > and what can be done using IOCTLs I see no difference. It's just a
> > mechanism. That's what traditional Unix APIs do in general: provide
> > mechanism, not a policy.
> 
> Seriously? Timestamp is _not_ a controllable hardware feature like brightness 
> or flash. Controls are meant to build user interface controls for interaction 
> with the user. Timestamp is _not_ something the user should control directly. 
> The application should figure out what it gets and what it needs.

Exactly. I agree completely.

Regards,

	Hans

> 
> Or why do you use STREAMON/STREAMOFF instead of a STREAM boolean control, eh?
> 
> 
