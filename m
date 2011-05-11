Return-path: <mchehab@gaivota>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41576 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab1EKUxk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 16:53:40 -0400
Date: Wed, 11 May 2011 13:53:32 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Peter Hutterer <peter.hutterer@who-t.net>,
	linux-media@vger.kernel.org,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	xorg-devel@lists.freedesktop.org
Subject: Re: IR remote control autorepeat / evdev
Message-ID: <20110511205332.GA11123@core.coreip.homeip.net>
References: <4DC61E28.4090301@iki.fi>
 <20110510041107.GA32552@barra.redhat.com>
 <4DC8C9B6.5000501@iki.fi>
 <20110510053038.GA5808@barra.redhat.com>
 <4DC940E5.2070902@iki.fi>
 <4DCA1496.20304@redhat.com>
 <4DCABA42.30505@iki.fi>
 <4DCABEAE.4080607@redhat.com>
 <4DCACE74.6050601@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCACE74.6050601@iki.fi>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wed, May 11, 2011 at 08:59:16PM +0300, Anssi Hannula wrote:
> 
> I meant replacing the softrepeat with native repeat for such devices
> that have native repeats but no native release events:
> 
> - keypress from device => keydown + keyup
> - repeat from device => keydown + keyup
> - repeat from device => keydown + keyup
> 
> This is what e.g. ati_remote driver now does.
> 
> Or alternatively
> 
> - keypress from device => keydown
> - repeat from device => repeat
> - repeat from device => repeat
> - nothing for 250ms => keyup
> (doing it this way requires some extra handling in X server to stop its
> softrepeat from triggering, though, as previously noted)
> 
> With either of these, if one holds down volumeup, the repeat works, and
> stops volumeup'ing immediately when user releases the button (as it is
> supposed to).
> 

Unfortunately this does not work for devices that do not have hardware
autorepeat and also stops users from adjusting autorepeat parameters to
their liking.

It appears that the delay to check whether the key has been released is
too long (almost order of magnitude longer than our typical autorepeat
period). I think we should increase the period for remotes (both in
kernel and in X, and also see if the release check delay can be made
shorter, like 50-100 ms.

Thanks.

-- 
Dmitry
