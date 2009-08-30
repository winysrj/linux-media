Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64832 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZH3Qoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 12:44:38 -0400
Received: by bwz19 with SMTP id 19so2396506bwz.37
        for <linux-media@vger.kernel.org>; Sun, 30 Aug 2009 09:44:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908301726.52296.jens.reimann@s2003.tu-chemnitz.de>
References: <200908301726.52296.jens.reimann@s2003.tu-chemnitz.de>
Date: Sun, 30 Aug 2009 12:44:39 -0400
Message-ID: <829197380908300944i4872d26r3429844a0741efc@mail.gmail.com>
Subject: Re: Hauppauge WinTV-HVR 900 R2 (DRX 3973D)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jens Reimann <jens.reimann@s2003.tu-chemnitz.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 30, 2009 at 11:26 AM, Jens
Reimann<jens.reimann@s2003.tu-chemnitz.de> wrote:
> Hi,
> it's again about the second revision of  WinTV-HVR 900. I'm know about the
> problems and conflicts with this device and the developers of the driver. I'm
> still using the driver from Markus Rechberger (www.mcentral.de) but he stopped
> development and there is only support up to Linux kernel 2.6.28.
> I would like to see support for DVB-T for this device in the linuxtv tree. As
> much as I understood, the problem is initializing the drx3973d chip with
> proper data, but there are no specs available. I own one of these devices and
> willing to help debugging. I even have the programming skills to do
> investigations. But, are there any hints where to start? For example there are
> parameters for this device in the tree of Markus. May be these parameters can
> be used (even if not understood) to get the device working.
>
> Thanks
> Jens
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hello Jens,

As is the case with the PCTV 330e, I've got the device working here
and I have a tree setup (fully tested and debugged).  All I need to do
is get the firmware extraction script finished.  Mauro took a crack at
it last week but it still needs some work.

I'm hoping to get back to it in the next couple of weeks, so keep an
eye on the KernelLabs blog for an announcement
(http://kernellabs.com/blog).

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
