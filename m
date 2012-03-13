Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:44485 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758268Ab2CMRsM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Mar 2012 13:48:12 -0400
Date: Tue, 13 Mar 2012 18:48:01 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] [media] dib0700: Fix memory leak during initialization
Message-ID: <20120313184801.41eb3d7e@endymion.delvare>
In-Reply-To: <4F5DCFB2.7090108@redhat.com>
References: <20120212111911.32f4c390@endymion.delvare>
 <4F589630.5020008@redhat.com>
 <20120312110450.6f052af0@endymion.delvare>
 <4F5DCFB2.7090108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 12 Mar 2012 07:28:02 -0300, Mauro Carvalho Chehab wrote:
> Em 12-03-2012 07:04, Jean Delvare escreveu:
> > "!d" can't actually happen, so it doesn't matter. d is passed by
> > dib0700_rc_setup() when calling usb_fill_bulk_urb(), and
> > dib0700_rc_setup() starts with dereferencing d, if it was NULL we'd
> > crash right away. Hence d is never NULL in dib0700_rc_urb_completion().
> > 
> > So this "if (d == NULL)" is just paranoia and might as well be removed.
> 
> Ok. Feel free to remove it on your patch.

I'll send a patch later today, yes.

> > (...)
> > Indeed, as I read the code, unless disable_rc_polling=1 or a fatal
> > error occurs, dib0700_rc_urb_completion will loop over and over
> > endlessly. I guess it's what "RC polling" is all about. No surprise why
> > my DVB-T card sucks so much power...
> 
> This code should not poll anymore, at least with a v1.2 firmware. 
> 
> The URB code will run only when the URB arrives. The URB will only arrive
> when some key is pressed. At key press, the URB handling code will re-trigger
> the URB handler to be prepared for a next key.

You're completely right. I enabled debugging, I have no remote control
on my card and the callback function is simply never called during run
time. It is called when I rmmod the driver though, with a negative
status value, which causes the urb to be freed. So there is no leak in
this case already, even without applying the fix that we discussed
earlier. I have no idea who calls dib0700_rc_urb_completion, but the
debug log clearly shows it is called.

I re-enabled kmemleak to understand exactly what was happening and I
get it now. My card behaves differently on cold boots and warm reboots.
In case of warm reboots I see the following error message in the log:
  rc submit urb failed
This is where the actual leak occurs, as the URB was never submitted,
dib0700_rc_urb_completion is never called, not even on module removal,
so the URB never has a chance to be freed.

Furthermore, the transfer_buffer of the urb is also never freed, not
even in the regular case. So a kfree must be added before any call to
usb_free_urb(). Patch follows.

(I guess this all means that the remote control wouldn't work on warm
reboots, but as I have no remote control I never noticed.)

> > (...)
> > Sure, we can do that, but what surprises me is that I don't remember
> > removing the  module when kmemleak reported the leak to me. Oh well,
> > kmemleak is pretty new, maybe that was a false positive after all.
> 
> It seems weird that kmemleak would warn about a leak before the
> memory removal. There are several places during driver init where data
> is alloced, and will only be freed at driver removal. The same happens
> with device probe/disconnect.

If there are no references left to allocated memory, it makes sense to
report immediately.

-- 
Jean Delvare
