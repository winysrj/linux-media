Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f177.google.com ([209.85.222.177]:36949 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbZEYDFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 23:05:42 -0400
Received: by pzk7 with SMTP id 7so2289084pzk.33
        for <linux-media@vger.kernel.org>; Sun, 24 May 2009 20:05:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A186764.4080007@klepeis.net>
References: <4A186764.4080007@klepeis.net>
Date: Sun, 24 May 2009 23:05:43 -0400
Message-ID: <829197380905242005p2cd41103rc1e0ecfb6c0e156f@mail.gmail.com>
Subject: Re: Temporary success with Pinnacle PCTV 801e (xc5000 chip)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: list1@klepeis.net
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 23, 2009 at 5:15 PM, N Klepeis <list1@klepeis.net> wrote:
> Hi,
>
> I installed the latest v4l-dvb from CVS with the latest firmware
> (dvb-fe-xc5000-1.6.114.fw) for the 801e (XC5000 chip).   I can  scan for
> channels no problem.   But after a first use with either mplayer or mythtv,
> it then immediately stops working and won't start again until I unplug and
> then reinsert the device from the USB port.       On the first time use
> everything seems fine and I can watch TV through mplayer for as long as I
> want.    On the 2nd use (restart mplayer), there's an error (FE_GET_INFO
> error: 19, FD: 3).    On the 2nd use with mythtv, mythtv cannot connect to
> the card at all in mythtvsetup, but on the first time use I can assign
> channel.conf.      I know there have been recent updates to the xc5000
> driver.    I only started trying this chip this week so I never confirmed
> that any prior driver version worked.
>
> Any thoughts on how to proceed?     Below are the full console outputs when
> using with mplayer and when running dmesg.   (This is fedora 10).
>
> --Neil
>

Neil,

Already tracked down and a PULL has been requested for the patch:

http://kernellabs.com/hg/~dheitmueller/dvb-frontend-exit-fix

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
