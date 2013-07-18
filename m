Return-path: <linux-media-owner@vger.kernel.org>
Received: from belief.htu.tuwien.ac.at ([128.131.95.14]:35881 "EHLO
	belief.htu.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572Ab3GRWTx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 18:19:53 -0400
Date: Fri, 19 Jul 2013 00:19:49 +0200
From: Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Possible problem with stk1160 driver
Message-ID: <20130718221949.GA17610@deadlock.dhs.org>
References: <20130716220418.GC10973@deadlock.dhs.org> <20130717084428.GA2334@localhost> <20130717213139.GA14370@deadlock.dhs.org> <20130718001752.GA2318@localhost> <51E78BB1.4020108@xs4all.nl> <20130718125557.GB2307@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718125557.GB2307@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

On Thu, Jul 18, 2013 at 09:55:59AM -0300, Ezequiel Garcia wrote:
> > You generally can't switch standards while streaming. That said, it is OK
> > to accept the same standard, i.e. return 0 if the standard is unchanged and
> > EBUSY otherwise.
> > 
> 
> Ok, I'll add a check for unchanged standards to overcome this situation.
> 
> > In the end it is an application bug, though. It shouldn't try to change the
> > standard while streaming has started.
> > 
> 
> Ok, so that confirms we should not allow it.
> 
> Sergey: Hopefully, with these two patches you won't need any further
> patching on your side.

thanks a lot! Seems to work fine.

Kind regards,
Sergey

