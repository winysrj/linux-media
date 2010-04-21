Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:50528 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554Ab0DUTiw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 15:38:52 -0400
Date: Wed, 21 Apr 2010 13:38:50 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: matti.j.aaltonen@nokia.com
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Subject: Re: [PATCH 1/3] MFD: WL1273 FM Radio: MFD driver for the FM radio.
Message-ID: <20100421133850.275f168b@bike.lwn.net>
In-Reply-To: <1271842140.4927.20.camel@masi.mnp.nokia.com>
References: <1271776807-2710-1-git-send-email-matti.j.aaltonen@nokia.com>
	<1271776807-2710-2-git-send-email-matti.j.aaltonen@nokia.com>
	<20100420133334.75184ea5@bike.lwn.net>
	<1271842140.4927.20.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 21 Apr 2010 12:29:00 +0300
m7aalton <matti.j.aaltonen@nokia.com> wrote:

> > So I was taking a quick look at this; it mostly looks OK (though I wonder
> > about all those symbol exports - does all that stuff need to be in the
> 
> Some functions get called from both child drivers/modules, but some
> stuff could probably be moved from the core to either of the children.
> Should I actually do that?

Depends.  If it's truly only useful to a single child device, the code
probably belongs there, without an export.  If it's truly a core
function, in that (1) it's applicable to multiple devices, or (2) it
can't be implemented without exposing stuff you want to keep private to
the core, then it should stay in the core.  

> > What I would suggest you do is remove the completion in favor of a wait
> > queue which the interrupt handler can use to signal that something has
> > completed.  You can then use wait_event() to wait for a wakeup and test
> > that the specific condition you are waiting for has come to pass.
> 
> Do you agree with my explanation? Or should I switch to using wait
> queue?

My belief is that the code would be cleaner with a wait queue; that's
the normal pattern for implementing this kind of logic.  I'll stop
here, though; if others want to take it upstream with the completion,
I'll not scream about it.

Thanks,

jon
