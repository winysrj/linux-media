Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53553 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab2CLRKw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 13:10:52 -0400
Received: by eekc41 with SMTP id c41so1310743eek.19
        for <linux-media@vger.kernel.org>; Mon, 12 Mar 2012 10:10:51 -0700 (PDT)
Message-ID: <4F5E2E19.4010208@gmail.com>
Date: Mon, 12 Mar 2012 18:10:49 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] AF903X driver update, v1.02
References: <201202222321.43972.hfvogt@gmx.net> <201203111623.04475.hfvogt@gmx.net>
In-Reply-To: <201203111623.04475.hfvogt@gmx.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 11/03/2012 16:23, Hans-Frieder Vogt ha scritto:
> This is an update of the patch "Basic AF9035/AF9033 driver" that I send to the mailing list on 22 Feb.
> The driver provides support for DVB-T USB 2.0 sticks based on AF9035/AF9033. Currently supported devices:
> - Terratec T5 Ver.2 (also known as T6), Tuner FC0012
> - Avermedia Volar HD Nano (A867R), Tuner MxL5007t
> 
> Ver 1.02 of the driver includes the following changes compared to the initial version:
> 
> - significantly reduced number of mutex calls (only remaining protection in low-level af903x_send_cmd)
>   this change made some multiply defined function unnecessary (_internal functions and non _internal functions)
>   maybe this reduction was a bit too agressive, but I didn't get any problems in several days testing 
> - reduced number of iterations in loop for lock detection (should improve response)
> - correct errors in initial contribution and add proper entries in dvb-usb-ids.h (thanks to Gianluca Gennari)
> - removed unnecessary (loading of rc key table) and commented out code
> - minor cleanup (e.g. af903x_fe_is_locked)
> 

Hi Hans,
I just tested the new version of the driver on my a867 stick (single
mxl5007 tuner), on Ubuntu 11.10 with a vanilla 3.2.9 kernel and the
latest media_build tree installed.

I can confirm the two main issues I found on the previous version are
completely solved.
In fact, Kaffeine is much more responsive now, and I can also open the
window with the signal strength/quality bars without any sluggishness.
I also unplugged the device from the USB port under several different
conditions (watching a channel, doing a channel scan and so on) without
any kernel crash.

I tested several channels (UHF, VHF, QAM64, QAM16, QPSK, 8MHz, 7MHz,...)
with no problem: the reception was stable in all configurations. Zapping
is also much faster with this version. I will run longer tests in the
coming days.

The only minor issues that I could find are related to channel scanning.
A full scan with Kaffeine takes much longer than with other sticks (most
of the time is spent on empty frequencies).
Despite the long wait, some frequency is not locked (for example, the
very first VHF frequency, channel 5, is missed 100% of the times).
This problem seem to disappear disabling the PID filter (but I need
further testing to draw any conclusion).
Also, during a full scan, Kaffeine becomes sluggish again.

In the end, the driver seem to work fine now, with only a few minor issues.

Thank you for your effort.

Regards,
Gianluca
