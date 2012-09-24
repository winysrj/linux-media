Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:56051 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523Ab2IXULy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 16:11:54 -0400
Received: from leon.localnet (226.Red-80-33-141.staticIP.rima-tde.net [80.33.141.226])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: remi)
	by oyp.chewa.net (Postfix) with ESMTPSA id 28D3C201D3
	for <linux-media@vger.kernel.org>; Mon, 24 Sep 2012 22:11:53 +0200 (CEST)
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: [RFC] Timestamps and V4L2
Date: Mon, 24 Sep 2012 23:11:50 +0300
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <505DF194.9030007@gmail.com> <20120923114342.GF12025@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120923114342.GF12025@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209242311.51003@leon.remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le dimanche 23 septembre 2012 14:43:42, Sakari Ailus a écrit :
> > I think I like this idea best, it's relatively simple (even with adding
> > support for reporting flags in VIDIOC_QUERYBUF) for the purpose.
> > 
> > If we ever need the clock selection API I would vote for an IOCTL.
> > The controls API is a bad choice for something such fundamental as
> > type of clock for buffer timestamping IMHO. Let's stop making the
> > controls API a dumping ground for almost everything in V4L2! ;)
> 
> Why would the control API be worse than an IOCTL for choosing the type of
> the timestamp? The control API after all has functionality for exactly for
> this: this is an obvious menu control.
> 
> What comes to the nature of things that can be configured using controls
> and what can be done using IOCTLs I see no difference. It's just a
> mechanism. That's what traditional Unix APIs do in general: provide
> mechanism, not a policy.

Seriously? Timestamp is _not_ a controllable hardware feature like brightness 
or flash. Controls are meant to build user interface controls for interaction 
with the user. Timestamp is _not_ something the user should control directly. 
The application should figure out what it gets and what it needs.

Or why do you use STREAMON/STREAMOFF instead of a STREAM boolean control, eh?

-- 
Rémi Denis-Courmont
http://www.remlab.net/
