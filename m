Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:44547 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbZF1BYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Jun 2009 21:24:53 -0400
Received: by yxe26 with SMTP id 26so41290yxe.33
        for <linux-media@vger.kernel.org>; Sat, 27 Jun 2009 18:24:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246148238.3148.11.camel@palomino.walls.org>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
	 <1246017001.4755.4.camel@palomino.walls.org>
	 <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
	 <COL103-W513258452EA45C7700193888320@phx.gbl>
	 <b24e53350906271457r594decccg397537db0d324754@mail.gmail.com>
	 <1246148238.3148.11.camel@palomino.walls.org>
Date: Sat, 27 Jun 2009 21:24:55 -0400
Message-ID: <829197380906271824h63ba92d2s4b1b45ca0228d744@mail.gmail.com>
Subject: Re: Bah! How do I change channels?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: Robert Krakora <rob.krakora@messagenetsystems.com>,
	George Adams <g_adams27@hotmail.com>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 27, 2009 at 8:17 PM, Andy Walls<awalls@radix.net> wrote:
> Oh, I'm not against power management.  But state is lost - somethings
> that's fixable with a lot of work apparently.  I was thinking maybe the
> V4L2 spec could change.
>
> I was also pondering maybe the final close() shouldn't be the trigger
> for powering devices down.  How about the final close() + 30 seconds?
> Or the final close() + some user set interval.  It seems like scheduling
> delayed work to do something like that should be easy enough.  That
> would require a spec change about state being only preserved until power
> management powered the thing down and probably an additional ioctl()
> added to set the powerdown delay.  The driver could probably default
> delay to some interval that would be good for most users.
>
> I don't know.  Just ideas...

On the DVB side, there actually is a modprobe parameter for
dvb_frontend that allows you to defer putting the device to sleep
(defaults to zero seconds).  It would be a little trickier to do this
in v4l because of the differences in the in-kernel threading (dvb has
a dedicated thread for controlling the device).  Also, it's globally
defined, which is good from a consistency standpoint but annoying in
cases where some devices really should defer sleep for some period.

For example, the HVR-950q's i2c implementation is *really* slow (8
seconds to load the xc5000 firmware).  If I had been able to control
the delay on a per-device basis in the board definition I could have
set it to sleep after 10 seconds by default, which would have helped
in cases like the Kaffeine channel scanner which continuously
closes/opens the frontend as it scans.

Anyway, it's good to discuss this issue, since I hadn't really
considered the implications of the power management until George's
email.  I'm just not sure what the best approach is at this point and
will have to give it some more thought.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
