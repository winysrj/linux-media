Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61926 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab1D3KAg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 06:00:36 -0400
Received: by wwa36 with SMTP id 36so4955249wwa.1
        for <linux-media@vger.kernel.org>; Sat, 30 Apr 2011 03:00:35 -0700 (PDT)
Message-ID: <4DBBDDBF.4020704@googlemail.com>
Date: Sat, 30 Apr 2011 11:00:31 +0100
From: Robert Longbottom <rongblor@googlemail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: OK szap is looking better, and I feel so close...
References: <BANLkTimi5Tz2ER=6y93SH3JFXqb-w=7A0g@mail.gmail.com>
In-Reply-To: <BANLkTimi5Tz2ER=6y93SH3JFXqb-w=7A0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 30/04/2011 10:37, Morgan Read wrote:
> OK, think I might be getting somewhere...
>
<snip>

> [user@vortexbox ~]$ szap -r TV2
> reading channels from file '/home/user/.szap/channels.conf'
> zapping to 3 'TV2':
> sat 0, frequency = 12483 MHz H, symbolrate 22500000, vpid = 0x0204,
> apid = 0x028e
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 01 | signal fa00 | snr f772 | ber 00000000 | unc fffffffe |
> status 01 | signal 0f00 | snr a344 | ber 00000000 | unc fffffffe |
> status 01 | signal 0f00 | snr a423 | ber 00000000 | unc fffffffe |
> ... ... ...
> ^C

I'd expect to see (from memory) FE_HAS_LOCK on the end of those lines, 
so something more like this:

status 01 | signal fa00 | snr f772 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK

Looks like it hasn't locked on to the channel for some reason.  I think 
this is probably your problem, though I don't know what you should do to 
fix it...

> [user@vortexbox ~]$
>
> And, while szap -r TV2 is running, on another console I should be able
> to run mplayer?  So:
> [user@vortexbox ~]$ mplayer -vo x11 /dev/dvb/adapter0/dvr0
> MPlayer SVN-r33254-snapshot-4.5.1 (C) 2000-2011 MPlayer Team
> 162 audio&  360 video codecs
> Can't open joystick device /dev/input/js0: No such file or directory
> Can't init input joystick
> mplayer: could not connect to socket
> mplayer: No such file or directory
> Failed to open LIRC support. You will not be able to use your remote control.
>
> Playing /dev/dvb/adapter0/dvr0.
>
>
> MPlayer interrupted by signal 2 in module: demux_open
>
>
> MPlayer interrupted by signal 2 in module: demux_open
> [user@vortexbox ~]$
>
> But, nothing happens at Playing /dev/dvb/adapter0/dvr0. ...  Where
> should I see what's playing?

I usually do:

$ cat /dev/dvb/adapter0/dvr0 > recording.mpg

and then in another terminal

$ mplayer recording.mpg

Though it doesn't look like thats your problem, but at least you can see 
if any data is being retrieved if the file grows in size.

Robert.
