Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:54985 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbZFZNkH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 09:40:07 -0400
Received: by gxk26 with SMTP id 26so797071gxk.13
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 06:40:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A448634.7000209@powercraft.nl>
References: <4A448634.7000209@powercraft.nl>
Date: Fri, 26 Jun 2009 09:40:08 -0400
Message-ID: <829197380906260640r45a31a83gd4bf23c06fdcf88f@mail.gmail.com>
Subject: Re: Pinnacle Systems PCTV 330e and Hauppauge WinTV HVR 900 (R2) not
	working under Debian 2.6.30-1
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jelle de Jong <jelledejong@powercraft.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 26, 2009 at 4:26 AM, Jelle de Jong<jelledejong@powercraft.nl> wrote:
> Hi all,
>
> This is sort of an updated report, I tested my em28xx based hybrid
> devices again and the dvb-t still does not work under the 2.6.30 kernel.
> I am not interested in the analog parts. So how is the process going on
> getting support for dvb-t in the kernel. I am also not interested in any
> non free non mainstream maintained code bases.
>
> I believe I sent some em28xx devices to Devin, so how is the process
> going, any luck?
>
> Question for Antti if he had any luck with the devices (rtl2831-r2) I send?
>
> Best regards,
>
> Jelle de Jong

Hello Jelle,

Unfortunately, I could have told you without your having done any
testing that the 330e and HVR-900 R2 are not any closer to working -
nobody is working on them.  They both use the Micronas drx-d, for
which we have a reverse engineered driver that is not currently used
in any devices and it is unknown whether it actually works.  Devices
attempting to use the driver require a config structure which has
something like 27 inputs, so while I do have the HVR-900 R2 hardware I
didn't feel comfortable attempting to get it to work without a signal
generator.

Regarding the Terratec Cinergy T XS USB you sent me...  there are two
variants of the same device with the same USB ID.  One has the zl10353
and the other has the mt352.  I found one bug that was common to both,
one bug in the zl10353 version, and one bug in the mt352.  I issued a
PULL request for the zl10353 version last Tuesday.

So, I've fixed three bugs and gotten the zl10353 version working.  The
mt352 version (which is the one you sent me) has the fixes above, but
according to the one user who has been willing to test the changes,
the device still does not work.  I do not know whether this is really
a bug in the driver or a problem in the user's environment (since he
doesn't own any other tuners to verify his signal and antenna with).
Contrary to my expectations, I haven't been been able to get access to
the signal generator, so I haven't been able to fully test/debug the
device myself.

If there are any other users out there with the mt352 version of the
Terratec Cinergy T XS who can do testing, I would definitely be
willing to work with them.

I am continuing to try to get access to a generator, and looking for
other testers who can try the changes.  I'm at a point now where I was
debating just sending it back to you and having you see if it works
(given the fixes I've already made), and attempting to debug any
issues remotely.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
