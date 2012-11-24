Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53582 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2KXRpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Nov 2012 12:45:34 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so6871697qcr.19
        for <linux-media@vger.kernel.org>; Sat, 24 Nov 2012 09:45:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50B1047B.4040901@gmail.com>
References: <50B1047B.4040901@gmail.com>
Date: Sat, 24 Nov 2012 12:45:33 -0500
Message-ID: <CAGoCfiwpj5ua79wOp8_CZfD_O9EOG7PAA4wE3L4n3-d-+FEhVg@mail.gmail.com>
Subject: Re: Poor HVR 1600 Video Quality
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bob Lightfoot <boblfoot@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 24, 2012 at 12:31 PM, Bob Lightfoot <boblfoot@gmail.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Dear Linux Media Community:
>     I am struggling with what has changed in recent {past 6-9 months} of
> kernel releases as related to the HVR-1600 Tuner Card and Analog Signal
> processing.  I spent the bulk of today going through my video chain
> feeding into the HVR-1600 and tried multiple sources all of which
> provide good video and sound when fed into a Sanyo TV bought in the
> 1990s.  They all produce recordings similar to the attached file.
> It almost looks like noise on the system and I am beginning to suspect
> my card may be hosed on the analog side.  Just looking for any thing I
> may have missed while RTFM and Google.  I'd share a 1 minute sample
> capture but 30.5 mb is too large to attach to a google email and I'm not
> sure where to drop a sample file for others to download and check out.
> It should be noted analog video was fine, but sound was intermittent
> with the kernels and drivers in use back in May.  Now the sound it rock
> solid, but the video has gone noisy.

A few questions,

Which version of the HVR-1600 do you have?  Could you provide the
exact PCI ID, vendor ID, and subsystem ID?

Can you post the 1-minute video to a website where it can be downloaded?

Are you using the coax input?  Composite?  S-video?  If you're using
the coax input, it would be good just as a test for you to try the
s-video input, as that would help rule out various problems that could
be introduced by the tuner and demodulation phases.

Are you capturing MPEG compressed video or raw?  The HVR-1600 supports both.

Are you familiar enough with compiling kernels that you could bisect
this down to a specific commit which introduces the problem?

What application(s) are you testing with?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
