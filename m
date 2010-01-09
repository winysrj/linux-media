Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppp-93-104-149-215.dynamic.mnet-online.de ([93.104.149.215]:58215
	"EHLO gauss.x.fun" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752768Ab0AILzz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jan 2010 06:55:55 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: Re: Fwd: Compro S300 - ZL10313
Date: Sat, 9 Jan 2010 12:47:39 +0100
Cc: Theunis Potgieter <theunis.potgieter@gmail.com>,
	JD Louw <jd.louw@mweb.co.za>
References: <23582ca0912291306v11d0631fia6ad442918961b48@mail.gmail.com> <1262428404.1944.22.camel@Core2Duo> <23582ca1001061217v6a67d6a3k8ac61fee5bd861da@mail.gmail.com>
In-Reply-To: <23582ca1001061217v6a67d6a3k8ac61fee5bd861da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001091247.40027.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, 6. January 2010, Theunis Potgieter wrote:
> 2010/1/2 JD Louw <jd.louw@mweb.co.za>:
> > On Sat, 2010-01-02 at 09:39 +0200, Theunis Potgieter wrote:
> >
> > Hi,
> >
> > Just to clarify, can you now watch channels?
> >
> > At the moment the signal strength measurement is a bit whacked, so don't
> > worry too much about it. I also get the 75%/17% figures you mentioned
> > when tuning to strong signals. The figure is simply reported wrongly:
> > even weaker signals should tune fine. If you want you can have a look in
> > ~/v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c at
> > mt312_read_signal_strength().
> >
> > Also, if you have a multimeter handy, can you confirm that the
> > 0x0000c000 GPIO fix enables LNB voltage? I'd like to issue a patch for
> > this. I've already tested this on my older card with no ill effect.
> 
Does this gpio value changes voltage?
If yes it is possible to hook into set_voltage and use this to disable LNB 
voltage for power saving.

> This is what happened when I started vdr.
> 
> Vertical gave a Volt reading between 13.9 and 14.1, Horizontal Gave
> 19.4 ~ 19.5. When I stopped vdr, the Voltage went back to 14V. I
> thought that it would read 0V. What is suppose to happen?
> 
Sounds good so far.

The voltage after stopping vdr is no surprise with zl10313, look into the
code at mt312.c line 425, The value it writes for no voltage is the same as 
for vertical voltage.

Matthias
