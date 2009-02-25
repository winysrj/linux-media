Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47589 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbZBYDRb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 22:17:31 -0500
Date: Wed, 25 Feb 2009 00:16:35 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: kilgota@banach.math.auburn.edu
Cc: Adam Baker <linux@baker-net.org.uk>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	Olivier Lorin <o.lorin@laposte.net>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
Message-ID: <20090225001635.0543a2dc@pedra.chehab.org>
In-Reply-To: <alpine.LNX.2.00.0902241914530.15651@banach.math.auburn.edu>
References: <200902180030.52729.linux@baker-net.org.uk>
	<200902211253.58061.hverkuil@xs4all.nl>
	<20090223080715.0c97774e@pedra.chehab.org>
	<200902232237.32362.linux@baker-net.org.uk>
	<alpine.LNX.2.00.0902231730410.13397@banach.math.auburn.edu>
	<alpine.LRH.2.00.0902241723090.6831@pedra.chehab.org>
	<alpine.LNX.2.00.0902241449020.15189@banach.math.auburn.edu>
	<alpine.LRH.2.00.0902242153490.6831@pedra.chehab.org>
	<alpine.LNX.2.00.0902241914530.15651@banach.math.auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 24 Feb 2009 20:12:00 -0600 (CST)
kilgota@banach.math.auburn.edu wrote:

> > For sure we need to have a way for retrieving this information for devices 
> > like the sq905 cameras, where the information can't be currently be 
> > determined by userspace.  
> 
> Yes, indeed. Except for just one word, "currently." It does not fit here. 

Yes, it fits, since, after implementing the API, the userspace will have this
information by using the agreed API.

> > If so, IMO, the 
> > better approach is to use a flag at the v4l2_input, as already discussed in 
> > this thread.  
> 
> OK.

As it seems to be a consensus that the better is to use a flag inside
v4l2_input, could you please provide us an RFC patch to implement it and update
the V4L2 spec?

Cheers,
Mauro
