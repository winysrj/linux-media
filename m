Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:49106 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab2CTHUM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 03:20:12 -0400
Date: Tue, 20 Mar 2012 08:20:02 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] [media] dib0700: Drop useless check when remote key
  is pressed
Message-ID: <20120320082002.6551466a@endymion.delvare>
In-Reply-To: <4F67B283.4050308@redhat.com>
References: <20120313185037.4059a869@endymion.delvare>
	<CAGoCfixvanxKT4h1k+FkaYkQ-zHjR-rYBWxHHiDygOScPCeZPA@mail.gmail.com>
	<4F67B283.4050308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, 19 Mar 2012 19:26:11 -0300, Mauro Carvalho Chehab wrote:
>  On Tue, Mar 13, 2012 at 1:50 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > --- linux-3.3-rc7.orig/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-03-13 11:09:13.000000000 +0100
> > +++ linux-3.3-rc7/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-03-13 18:37:05.785953845 +0100
> > @@ -677,9 +677,6 @@ static void dib0700_rc_urb_completion(st
> >  	u8 toggle;
> >  
> >  	deb_info("%s()\n", __func__);
> > -	if (d == NULL)
> > -		return;
> > -
> 
> Well, usb_free_urb() is not called when d == NULL, so, if this condition
> ever happens, it will keep URB's allocated.
> 
> Anyway, if struct dvb_usb_device *d is NULL, the driver has something very
> wrong happening on it, and nothing will work on it.
> 
> I agree with Jean: it is better to just remove this code there.
> 
> Yet, I'd be more happy if Jean's patch could check first if the status is
> below 0, in order to prevent a possible race condition at device disconnect.

I'm not sure I see the race condition you're seeing. Do you believe
purb->context would be NULL (or point to already-freed memory) when
dib0700_rc_urb_completion is called as part of device disconnect? Or is
it something else? I'll be happy to resubmit my patch series with a fix
if you explain where you think there is a race condition.

-- 
Jean Delvare
