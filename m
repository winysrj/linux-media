Return-path: <dheitmueller@kernellabs.com>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48415 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab0HHX6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Aug 2010 19:58:19 -0400
Received: by pwj7 with SMTP id 7so1106878pwj.19
        for <linux-media@vger.kernel.org>; Sun, 08 Aug 2010 16:58:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1281311584.2803.6.camel@ray-desktop-linux>
References: <1281311584.2803.6.camel@ray-desktop-linux>
Date: Sun, 8 Aug 2010 19:58:19 -0400
Message-ID: <AANLkTimyGMSFQyLyKYBhmmdop3ApEuekFOwue==4xVMF@mail.gmail.com>
Subject: Re: pinnacle 801e help please!
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ray Bullins <bbullins@triad.rr.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 8, 2010 at 7:53 PM, Ray Bullins <bbullins@triad.rr.com> wrote:
> I am new to Linux (somewhat) and I am running Linux mint 9. So far so
> good, I have replaced dreamweaver with NVU, office with open office.
> Outlook with evolution and so on. Everything is now perfect no looking
> back to windows except I just spent about 1.5 hours going through
> configuring mythtv only to find it doesn't think my pinnacle usb hd
> stick is a dvb device. So i did more research and stumbled upon all of
> your hard work and tried downloading the tar for my device but it
> wouldn't download. 2 questions 1) will this device work now 2) how do I
> implement all of you fixes in mint Linux 9 gnome running mythtv?
>
> thanks for any help
> Ray

The 801e driver only has support currently for ATSC/ClearQAM (which is
why it appears as a DVB device).  The driver does not have any support
for analog (e.g. the analog tuner or the composite/s-video inputs).

Run "ls /dev/dvb/adapter0/frontend0" and if you see an entry then the
driver loaded successfully.  Also, you may need to load firmware (it's
bundled by default with a number of distributions but I don't know
about Mint).  If you don't have it, you can get it here:

http://kernellabs.com/firmware/dib0700/

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
