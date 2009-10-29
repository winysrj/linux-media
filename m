Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:32894 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbZJ2DkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2009 23:40:25 -0400
Received: by bwz27 with SMTP id 27so1817445bwz.21
        for <linux-media@vger.kernel.org>; Wed, 28 Oct 2009 20:40:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AE8F99E.5010701@acm.org>
References: <4AE8F99E.5010701@acm.org>
Date: Wed, 28 Oct 2009 23:40:28 -0400
Message-ID: <829197380910282040t6fce747aoca318911e76aa23f@mail.gmail.com>
Subject: Re: HVR-950Q problem under MythTV
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bob Cunningham <rcunning@acm.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 28, 2009 at 10:10 PM, Bob Cunningham <rcunning@acm.org> wrote:
> I just completed a fresh install of MythTV 0.22 RC1 on my fully-updated
> Fedora 11 system.  My tuner is an HVR-950Q, connected to cable.  The tuner
> works fine under tvtime (SD) and xine (HD).
>
> All MythTV functions work, except LiveTV.  The problem is that mythfrontend
> times out waiting for the HVR-950Q to tune to the first station.  This
> appears to be due to the very long HVR-950Q firmware load time, since no
> errors are reported by the backend.
>
> Unfortunately, mythfrontend has a hard-wired 7 second timeout for most
> requests sent to the backend.  It seems this timeout works fine under normal
> circumstances for every other tuner MythTV works with.
>
> The following is repeated in dmesg after every attempt:
>
>  xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
>  usb 1-2: firmware: requesting dvb-fe-xc5000-1.6.114.fw
>  xc5000: firmware read 12401 bytes.
>  xc5000: firmware uploading...
>  xc5000: firmware upload complete...
>
> It looks like the HVR-950Q driver reloads the firmware at every possible
> opportunity, independent of the hardware state, each time either the SD or
> HD device is opened, such as when changing from an SD channel on /dev/video0
> to an HD channel on /dev/dvb/adapter0.  Is this necessary?
>
> Is it possible to tell the driver to ease up on the firmware reloads?  I
> don't mind if the first attempt fails, but the second attempt should succeed
> (without a reload).
>
> Alternatively, are faster firmware loads possible?
>
> Should I open a bug on this?

Hello Bob,

In order to avoid the firmware reloading condition, you need to add a
modprobe option called "no_poweroff=1" for the xc5000 driver to your
modprobe.conf file and then reboot your computer.  I agree that this
is a very annoying workaround, but have not had a chance to try to
find another solution (the i2c master in the au0828 hardware is poorly
designed and this same problem occurs in Windows but the problem is
not as noticeable because the Windows application doesn't as
aggressively power down the tuner).

Also, in order for the video to be rendered properly, you need to make
sure your capture resolution for LiveTV mode and the various capture
modes is set to 720x480 (the default in MythTV is 480x480).  Without
this change, the picture will appear to be vertically stretched.  This
is actually a bug in MythTV not properly handling analog capture
products that do not have an onboard hardware scaler (I did work in
0.22 to get the analog support working but have not had an opportunity
to fix this bug yet).

If you still have trouble, feel free to reply to this message.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
