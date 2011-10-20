Return-path: <linux-media-owner@vger.kernel.org>
Received: from v38276.1blu.de ([88.84.155.223]:43123 "EHLO barth.jannau.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab1JTRIM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 13:08:12 -0400
Date: Thu, 20 Oct 2011 19:08:11 +0200
From: Janne Grunau <j@jannau.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Taylor Ralph <taylor.ralph@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] hdpvr: update picture controls to support
 firmware versions > 0.15
Message-ID: <20111020170811.GD7530@jannau.net>
References: <CAOTqeXouWiYaRkKKO-1iQ5SJEb7RUXJpHdfe9-YeSzwXxdUVfg@mail.gmail.com>
 <CAGoCfiyCPD-W3xeqD4+AE3xCo-bj05VAy4aHXMNXP7P124ospQ@mail.gmail.com>
 <20111020162340.GC7530@jannau.net>
 <CAGoCfiwXjQsAEVfFiNA5CNw1PVuO0npO63pGb91rpbPuKGvwZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGoCfiwXjQsAEVfFiNA5CNw1PVuO0npO63pGb91rpbPuKGvwZQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 20, 2011 at 12:35:40PM -0400, Devin Heitmueller wrote:
> On Thu, Oct 20, 2011 at 12:23 PM, Janne Grunau <janne@jannau.net> wrote:
> >
> > I've looked at them only at very beginning and if I recall correctly
> > they had no visible effects. The values in the linux driver were taken
> > from sniffing the windows driver. I remember that I've verified the
> > default brightness value since 0x86 looked odd. I'm not sure that I
> > verified all controls. I might have assumed all controls shared the
> > same value range.
> >
> > There were previous reports of the picture controls not working at all.
> 
> Thanks for taking the time to chime in.

no problem, sorry for ignoring the other mails, I had no time to look
at the problem immediately and then forgot about it.

> If the controls really were broken all along under Linux, then that's
> good to know.  That said, I'm not confident the changes Taylor
> proposed should really be run against older firmwares.  There probably
> needs to be a check to have the values in question only applied if
> firmware >= 16.  If the controls were broken entirely, then we should
> probably not advertise them in ENUM_CTRL and S_CTRL should return
> -EINVAL if running the old firmware (perhaps put a warning in the
> dmesg output saying the controls are unavailable because the user is
> not running firmware >= 16).
> 
> My immediate concern is about ensuring we don't cause breakage in
> older firmware.  For example, we don't know if there are some older
> firmware revisions that *did* work with the driver.  The controls
> might have worked up to firmware revision 10, then been broken from
> 11-15, then work again in 16 (with the new hue value needed).  The
> safe approach is to only use these new settings if they're running
> firmware >= 16.

I think such scenario is unlikely but I don't know it for sure and
I don't want to force anyone to test every firmware version.
Ignoring them for firmware version < 16 should be safe since we assume
they had no effect. Returning -EINVAL might break API-ignoring
applications written with the HD PVR in mind but I think it's a better
approach than silently ignoring those controls.

Janne
