Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:34842 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZBQPxf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 10:53:35 -0500
Date: Tue, 17 Feb 2009 09:53:29 -0600
From: David Engel <david@istwok.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Borke <joshborke@gmail.com>, David Lonie <loniedavid@gmail.com>,
	CityK <cityk@rogers.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090217155329.GA6196@opus.istwok.net>
References: <20090210041512.6d684be3@pedra.chehab.org> <1767e6740902100407t6737d9f4j5d9edefef8801e27@mail.gmail.com> <20090210102732.5421a296@pedra.chehab.org> <20090211035016.GA3258@opus.istwok.net> <20090211054329.6c54d4ad@pedra.chehab.org> <20090211232149.GA28415@opus.istwok.net> <20090213030750.GA3721@opus.istwok.net> <20090213090446.2d77435a@pedra.chehab.org> <20090213092845.0ebfe97a@pedra.chehab.org> <20090213202811.GB3810@opus.istwok.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213202811.GB3810@opus.istwok.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 13, 2009 at 02:28:11PM -0600, David Engel wrote:
> On Fri, Feb 13, 2009 at 09:28:45AM -0200, Mauro Carvalho Chehab wrote:
> > Ok, I found the bug. It is inside tuner-simple code. It is caused due to a hack for TUV1236.
> > 
> > I've just committed a fix for it:
> > 	http://linuxtv.org/hg/v4l-dvb/rev/34ec729ed1a7
> > 
> > Please test.
> 
> In limited, remote testing -- it works!  It also works on my
> production MythTV backend with 2 ATSC 115s.  This is the first time
> analog has ever worked on both of those cards at the same time.  I'll
> do more testing over the weekend.  Thanks very much, Mauro, Hans and
> everyone else involved.

I didn't get to test as much as I'd hoped but I did do some.  The
fixed analog support on my ATSC 115s worked great.  Thanks again.

David
-- 
David Engel
david@istwok.net
