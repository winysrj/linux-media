Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53642 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937344AbZLHRh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 12:37:28 -0500
Received: by fxm5 with SMTP id 5so6475921fxm.28
        for <linux-media@vger.kernel.org>; Tue, 08 Dec 2009 09:37:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B1E8E4D.9010101@esdelle.co.uk>
References: <4B1E8E4D.9010101@esdelle.co.uk>
Date: Tue, 8 Dec 2009 12:37:33 -0500
Message-ID: <829197380912080937r2f9ca358h548e5ba4ee21b51e@mail.gmail.com>
Subject: Re: [linux-dvb] WinTV HVR-900 USB (B3C0)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 8, 2009 at 12:35 PM, Rob Beard <rob@esdelle.co.uk> wrote:
> Hi folks,
>
> I've borrowed a WinTV HVR-900 USB stick from a friend of mine to see if I
> can get any reception in my area before forking out for one however I've run
> in to a couple of problems and wondered if anyone had used one of these
> sticks?
>
> The device appears to support both analogue and DVB-T (Freeview) TV however
> when I plug the device in it only appears to enable the analogue side of
> things (it comes up as /dev/video1 as I have a webcam on my laptop).
>
> I've downloaded and installed the firmware in /lib/firmware as per the
> instructions on the LinuxDVB web site
> and it appears to pick it up and I've even tried compiling the v4l-dvb
> drivers too which didn't appear to make any difference.
>
> Just to check it wasn't me going mad, I tried the dvb-utils scan utility and
> also Kaffene, both of which doesn't work (and I can't find a /dev/dvb
> directory either).
>
> If it helps, the output from /var/log/messages is here:
> http://pastebin.com/m34f1048f
>
> I just wondered if anyone else had one of these sticks actually working
> under Ubuntu 9.10?  (I'm running kernel 2.6.31-16-generic-pae).

The DVB-T portion of that particular board is unsupported (I have some
code in the works but there are issues with the firmware
redistribution rights).

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
