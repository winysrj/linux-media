Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:38511 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbZKDSmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 13:42:51 -0500
Received: by gxk26 with SMTP id 26so5029382gxk.1
        for <linux-media@vger.kernel.org>; Wed, 04 Nov 2009 10:42:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911042033.48257.opensource@andmarios.com>
References: <200909281850.25492.opensource@andmarios.com>
	 <200909281909.15028.opensource@andmarios.com>
	 <829197380910150853l6797a053qd2d9e05ec3b7552e@mail.gmail.com>
	 <200911042033.48257.opensource@andmarios.com>
Date: Wed, 4 Nov 2009 13:42:55 -0500
Message-ID: <829197380911041042l1413e767vf96a0babbc4c78b0@mail.gmail.com>
Subject: Re: [linux-dvb] KWORLD 323U, kernel panic when trying to access ALSA
	interface
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/11/4 Marios Andreopoulos <opensource@andmarios.com>:
> Just a small update.
>
> After this message of yours: http://www.linuxtv.org/pipermail/linux-dvb/2009-October/032442.html
> I tried again the v4l-dvb tree and now my card works without problems!
>
> I don’t know what the problem was with your tree. I think another tree I had used previously copied it’s modules to a non standard location in /lib/modules/current-kernel/ and thus its modules took precedence over the kernels’, yours’ or v4l-dvb’s modules.
>
> It just happened that I upgraded my kernel recently and found out that v4l-dvb works now.
>
> Thanks!

Well the fix I mentioned for the audio panic was merged on October
29th (and that's the only change that's been made to the driver in
five months).  This makes me think that perhaps you made some mistake
when you tried out the testing tree I sent you.

Regardless, it's a relief to hear that it's working for you now, since
I didn't have any idea what the problem could be if it wasn't the
crash that I fixed.

I'll see about getting this backported to stable, since 2.6.31 users
are likely to hit this issue as they upgrade to newer distros (such as
the recently released Ubuntu 9.10).

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
