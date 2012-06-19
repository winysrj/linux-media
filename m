Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35908 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab2FSPzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jun 2012 11:55:16 -0400
Received: by yenl2 with SMTP id l2so4331523yen.19
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2012 08:55:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340080702.24618.15.camel@obelisk.thedillows.org>
References: <1339994998.32360.61.camel@obelisk.thedillows.org>
	<201206180929.48107.hverkuil@xs4all.nl>
	<1340028940.32360.70.camel@obelisk.thedillows.org>
	<CAGoCfize92S-8cR9f-RjQDcZARKiT84UtX-oH0EcPomCYFAyxQ@mail.gmail.com>
	<1340029964.23706.4.camel@obelisk.thedillows.org>
	<CAGoCfix48wNUBRuUbehjSHpqV33D68AA7mBy_4zu22JWTkbcmQ@mail.gmail.com>
	<1340080702.24618.15.camel@obelisk.thedillows.org>
Date: Tue, 19 Jun 2012 11:55:15 -0400
Message-ID: <CAGoCfiziiMQwZiAbSVkAeyZXL-XipOqQwFeBbW1crQ2f4BRDBw@mail.gmail.com>
Subject: Re: [RFC] [media] cx231xx: restore tuner settings on first open
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: David Dillow <dave@thedillows.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,
> It sounds like we want a solution that
>      * lives in core code
>      * doesn't require tuner drivers to save state
>      * manages hybrid tuners appropriately
>      * allows for gradual API change-over (no flag day for tuners or
>        for capture devices)
>      * has a reasonable grace period before putting tuner to standby

These seem like pretty reasonable working requirements to start with.

> Aside from the entering standby issue, fixing the loss of mode/frequency
> looks like it may be fixable by just having the capture cards explicitly
> request the tuner become active -- the tuner core will already restore
> those for us. It's just that few cards do that today.

The challenge is *when* do those cards request the tuner become
active?  In response to what ioctl() calls?

> Is it safe to say that the tuner core will know about all hybrid tuners,
> even if it doesn't know if the digital side is still in use?

The tuner-core is used for pretty much every hybrid tuner I know of
except for saa7164, which from what I understand controls the tuners
directly.

> Can a single tuner be used for both digital and analog tuning at the
> same time?

No.  However one mode is often used *immediately* after the other.
I've seen quite a few race conditions over the years that had to do
with closing the v4l2 device and then immediately opening the DVB
device (or vice versa).

> I'm wondering if just having a simple counter would work, with the
> digital side calling for power just as the capture side should already
> be doing. If the count is non-zero on a standby call, don't do anything.
> If it goes to zero, then schedule the HW standby. The challenge would
> seem to be getting the DVB system to call into the tuner-core (or other
> proper place).

There is a ts_ctrl() callback in the dvb frontend which could be used
by the digital side to "claim" that it's using the tuner.

You may also wish to consider this in the context of allowing either
side to "lock" the tuner to prevent callers from attempting to use it
in both analog and digital mode simultaneously.  This is a huge
outstanding problem for hybrid tuners, where applications like MythTV
will attempt to use the device in both modes at the same time
(thinking they are separate tuners), and the failure to return
something like EBUSY to the second caller results in all sorts of
undefined behavior.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
