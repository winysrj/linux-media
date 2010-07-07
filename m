Return-path: <linux-media-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:60200 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670Ab0GGRaU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Jul 2010 13:30:20 -0400
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Jarod Wilson <jarod@redhat.com>
Subject: Re: Some issues with imon input driver
Date: Wed, 7 Jul 2010 20:21:44 +0300
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
References: <201007070536.45900.anssi.hannula@iki.fi> <20100707135259.GA29996@redhat.com>
In-Reply-To: <20100707135259.GA29996@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007072021.44619.anssi.hannula@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson kirjoitti keskiviikko, 7. heinäkuuta 2010 16:52:59:
> On Wed, Jul 07, 2010 at 05:36:45AM +0300, Anssi Hannula wrote:
> > Hi!
> > 
> > I tried to set up my imon remote, but run into the issue of buttons
> > getting easily stuck. And while looking at the code, I noticed some more
> > issues :)
> 
> I'm not entirely surprised, I knew there were a few quirks left I'd not
> yet fully sorted out. Generally, it works quite well, but I didn't abuse
> the receiver quite as thoroughly as you. ;)
> 
> Can I talk you into filing a bug to track this? I can probably work up
> fixes for a number of these sooner or later, if you don't beat me to them,
> but it'd be easy for one or more of the specific problems to slip through
> the cracks if not logged somewhere. My From: address here matches my
> b.k.o. account, if you want to assign said bug to me.

Done, though I didn't have the permissions to assign it to you:
https://bugzilla.kernel.org/show_bug.cgi?id=16351

> Ah, and because we're actually handing remote controls via
> drivers/media/IR/, you should cc linux-media as well (if not instead of
> linux-input) on anything regarding this driver.

OK.

BTW, I wonder if we should also disable kernel autorepeat and use the remote 
control's own repeat signals instead?
Then extra repeat codes would not not emitted if the release signal is missed.

-- 
Anssi Hannula
