Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:41915 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759736AbZKLBEG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 20:04:06 -0500
Subject: Re: cx18: Reprise of YUV frame alignment improvements
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
Cc: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
In-Reply-To: <de8cad4d0911111638m3de0d417x60d71d8d331e03f0@mail.gmail.com>
References: <1257913905.28958.32.camel@palomino.walls.org>
	 <de8cad4d0911111638m3de0d417x60d71d8d331e03f0@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 11 Nov 2009 20:06:46 -0500
Message-Id: <1257988006.4065.4.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-11-11 at 19:38 -0500, Brandon Jenkins wrote:
> On Tue, Nov 10, 2009 at 11:31 PM, Andy Walls <awalls@radix.net> wrote:
> >
> > Could folks give this cx18 code a test to make sure their primary use
> > cases didn't break?
> >
> >
> > Regards,
> > Andy
> >
> Andy,
> 
> I have loaded the drivers (also pulling in Devin's change request too)
> and am running with 3 cards and SageTV. I'll let you know if something
> pops up, but nothing thus far.
> 
> Brandon


Thanks a bunch.  It's nice to have someone with a system capable of
being highly loaded to try to break things. :)

For myself, after 1 day I haven't noticed anything.  Though my normal
use case is simple live Digital TV viewing with MythTV - not terribly
stressing.

I assume you mean the mxl5005s and s5h1409 changes for clear QAM when
you say Devin's change.

Regards,
Andy

