Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:60656 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbZJAWOX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Oct 2009 18:14:23 -0400
Date: Thu, 1 Oct 2009 17:14:26 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Wellington Terumi Uemura <wellingtonuemura@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: How to make my device work with linux?
In-Reply-To: <829197380910011507k59f3b18fv3cc5d21b77299ef7@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0910011708260.22836@cnc.isely.net>
References: <c85228170910011138w6d3fa3adibbb25d275baa824f@mail.gmail.com>  <37219a840910011227r155d4bc1kc98935e3a52a4a17@mail.gmail.com>  <c85228170910011414n29837812y28010ef0d97b7bf1@mail.gmail.com>  <alpine.DEB.1.10.0910011628420.21852@cnc.isely.net>
 <c85228170910011503t68b100a1v3dccda2602ae08da@mail.gmail.com> <829197380910011507k59f3b18fv3cc5d21b77299ef7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 1 Oct 2009, Devin Heitmueller wrote:

> On Thu, Oct 1, 2009 at 6:03 PM, Wellington Terumi Uemura
> <wellingtonuemura@gmail.com> wrote:
> > It's not the answer that I was looking for but looks like the thing is
> > much more complex than just compile and run drivers, this gives me
> > another perspective, like a dead end.
> >
> > Thank you Mike.
> 
> Well, it's certainly possible to get it to work if you're willing to
> make the investment.  It's just one of those situations where you
> realize quickly that you're going to have to be prepared to do *way*
> more work than just adding a new board profile.  Just because there
> are drivers for the chips on your device doesn't mean that it is
> trivial to get working.
> 
> Cheers,
> 
> Devin
> 

And actually I wasn't intending on totally discouraging you either.  
But you do need to see the perspective of what you're trying to do 
otherwise you may just get frustrated.

Things aren't hopeless.  The cxusb module in DVB might be something you 
should look at.  I guess it depends on how deep you wish to dive here.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
