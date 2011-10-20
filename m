Return-path: <linux-media-owner@vger.kernel.org>
Received: from v38276.1blu.de ([88.84.155.223]:46093 "EHLO barth.jannau.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab1JTQaP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 12:30:15 -0400
Date: Thu, 20 Oct 2011 18:23:40 +0200
From: Janne Grunau <janne@jannau.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Taylor Ralph <taylor.ralph@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] hdpvr: update picture controls to support
 firmware versions > 0.15
Message-ID: <20111020162340.GC7530@jannau.net>
References: <CAOTqeXouWiYaRkKKO-1iQ5SJEb7RUXJpHdfe9-YeSzwXxdUVfg@mail.gmail.com>
 <CAGoCfiyCPD-W3xeqD4+AE3xCo-bj05VAy4aHXMNXP7P124ospQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGoCfiyCPD-W3xeqD4+AE3xCo-bj05VAy4aHXMNXP7P124ospQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 20, 2011 at 11:30:11AM -0400, Devin Heitmueller wrote:
> On Thu, Oct 20, 2011 at 11:24 AM, Taylor Ralph <taylor.ralph@gmail.com> wrote:
> > I've attached a patch that correctly sets the max/min/default values
> > for the hdpvr picture controls. The reason the current values didn't
> > cause a problem until now is because any firmware <= 0.15 didn't
> > support them. The latest firmware releases properly support picture
> > controls and the values in the patch are derived from the windows
> > driver using SniffUSB2.0.
> >
> > Thanks to Devin Heitmueller for helping me.
> 
> What worries me here is the assertion that the controls didn't work at
> all in previous firmware and driver versions.  Did you downgrade the
> firmware and see that the controls had no effect when using v4l2-ctl?
> 
> Janne, any comment on whether the controls *ever* worked?

I've looked at them only at very beginning and if I recall correctly
they had no visible effects. The values in the linux driver were taken
from sniffing the windows driver. I remember that I've verified the
default brightness value since 0x86 looked odd. I'm not sure that I
verified all controls. I might have assumed all controls shared the
same value range.

There were previous reports of the picture controls not working at all.

Janne
