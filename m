Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55046 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZLAOKg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 09:10:36 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, jonsmirl@gmail.com,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, mchehab@redhat.com,
	superm1@ubuntu.com
In-Reply-To: <1259667480.3100.10.camel@palomino.walls.org>
References: <BE3edeNXqgB@lirc> <1259667480.3100.10.camel@palomino.walls.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 16:10:35 +0200
Message-ID: <1259676635.18599.5.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-12-01 at 06:38 -0500, Andy Walls wrote: 
> On Tue, 2009-12-01 at 08:45 +0100, Christoph Bartelmus wrote:
> > Hi Jon,
> > 
> > on 30 Nov 09 at 16:35, Jon Smirl wrote:
> 
> 
> > Currently I would tend to an approach like this:
> > - raw interface to userspace using LIRC
> > - fixed set of in-kernel decoders that can handle bundled remotes
> > 
> > That would allow zero configuration for simple use cases and full  
> > flexibility for more advanced use cases.
> > 
> > Christoph
> 
> I'd also prefer that approach.

I also agree with this approach.
This way, there will be no need for configfs hacks, but just static
table for bundled remotes, and in fact this is very clean approach.
Also, since bundled remotes use standard protocols, there will be no
problem to add decoders for them.

For the rest, the remotes that were never meant to be used with the
computer, lircd will do just fine.

So, it a deal?

Best regards,
Maxim Levitsky



