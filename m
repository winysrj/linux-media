Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:63322 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZJMAYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 20:24:47 -0400
Received: by fxm27 with SMTP id 27so9730914fxm.17
        for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 17:23:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091013012255.260afea3@ieee.org>
References: <loom.20091011T180513-771@post.gmane.org>
	 <829197380910111218q5739eb5ex9a87f19899a13e98@mail.gmail.com>
	 <loom.20091012T223603-551@post.gmane.org>
	 <829197380910121437m4f1fb7cld8d7dc351f468671@mail.gmail.com>
	 <20091013012255.260afea3@ieee.org>
Date: Mon, 12 Oct 2009 20:23:34 -0400
Message-ID: <829197380910121723i59d2498en10d166f523889fbd@mail.gmail.com>
Subject: Re: Dazzle TV Hybrid USB and em28xx
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Giuseppe Borzi <gborzi@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 12, 2009 at 7:22 PM, Giuseppe Borzi <gborzi@gmail.com> wrote:
>>
>> Yeah, that happens with Ubuntu Karmic.  The v4l-dvb firedtv driver
>> depends on headers that are private to ieee1394 and not in their
>> kernel headers package.
>>
>> To workaround the issue, open v4l/.config and set the firedtv driver
>> from "=m" to "=n"
>>
>> Devin
>>
>
> Thanks Devin,
> following your instruction for firedtv I've compiled
> v4l-dvb-5578cc977a13 but the results aren't so good. After doing an
> "make rminstall" , compiling and "make install" I plugged the USB
> stick, the various devices were created (including /dev/dvb) and here
> is the dmesg output (now it's identified as card=1)
>
> then I started checking if it works. The command "vlc channels.conf"
> works, i.e. it plays the first channel in the list, but is unable to
> switch channel. me-tv doesn't start, but I think this is related to the
> recent gnome upgrade. w_scan doesn't find any channel.

Open v4l/em28xx-cards.c and comment out line 181 so it looks like:

//        {EM2880_R04_GPO,        0x04,   0xff,          100},/*
zl10353 reset */

This is an issue I have been actively debugging for two other users.

> Analog TV only shows video, no audio. Tried this both with sox and vlc.
> When you say that I have to choose the right TV standard (PAL for my
> region) do you mean I have to select this in the TV app I'm using
> (tvtime, vlc, xawtv) or as a module option? I've not seen any em28xx
> option for TV standard, so I suppose it's in the app.

Correct - the em28xx module does not have module parameters for the
standard - you have to select it in the application.

> Finally, I've noticed that the device is much less hot than it happened
> with out of kernel modules and the card=11 workaround.
> Is your latest post "em28xx mode switching" related to my device?

Yes, it is one device effected by that discussion.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
