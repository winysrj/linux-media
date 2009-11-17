Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48411 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbZKQEbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 23:31:42 -0500
Received: by bwz27 with SMTP id 27so6440685bwz.21
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2009 20:31:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091117032936.D7AF71CE833@ws1-6.us4.outblaze.com>
References: <20091117032936.D7AF71CE833@ws1-6.us4.outblaze.com>
Date: Mon, 16 Nov 2009 23:31:47 -0500
Message-ID: <829197380911162031s4697794cr4732ab5165d7380c@mail.gmail.com>
Subject: Re: [linux-dvb] Video lost after OS upgrade
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 16, 2009 at 10:29 PM,  <guzowskip@linuxmail.org> wrote:
> Hello all,
>
> I was happily watching TV with mplayer from my cable set-top box via a
> Pinnacle HDTV Pro USB Stick and Ubuntu 9.04.
>
> The command I was using and which worked was/is:
>
> mplayer -vo xv tv:// -tv
> driver=v4l2:alsa:immediatemode=0:adevice=hw.1,0:norm=ntsc:chanlist=us-cable:channel=3
>
> After ugrading to Ubuntu 9.10, when I launch mplayer with this command, I
> get an empty black window with no video or audio.  Any ideas and/or  help
> would be greatly appreciated.
>
> Paul in NW FL, USA

Hello Paul,

I assume you are talking about the "800e" version of the HD Pro Stick
(USB ID 2304:0227), right?

http://linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Pro_Stick_%28800e%29

That device should continue to work under 9.10.  I noticed that your
mplayer line did not specify which input to use.  Have you tried
connecting something to the s-video or composite to see if you start
getting a picture?  Typically you need to explicitly tell mplayer
which input to use (I don't have the exact syntax in front of me, but
it's in the mplayer man page).

Also, you have the xc3028 firmware installed, right?  Are you seeing
any errors in your dmesg output?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
