Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45684 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820AbZLGQEL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2009 11:04:11 -0500
Received: by ewy19 with SMTP id 19so617171ewy.1
        for <linux-media@vger.kernel.org>; Mon, 07 Dec 2009 08:04:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200912070400.03469.liplianin@me.by>
References: <200912070400.03469.liplianin@me.by>
Date: Mon, 7 Dec 2009 11:04:14 -0500
Message-ID: <83bcf6340912070804i64eeb132hdf97546f68fa31cb@mail.gmail.com>
Subject: Re: Success for Compro E650F analog television and alsa sound.
From: Steven Toth <stoth@kernellabs.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 6, 2009 at 9:00 PM, Igor M. Liplianin <liplianin@me.by> wrote:
> Hi Steve
>
> I'm able to watch now analog television with Compro E650F.
> I rich this by merging your cx23885-alsa tree and adding some modifications
> for Compro card definition.
> Actually, I take it from Mygica definition, only tuner type and DVB port is different.
> Tested with Tvtime.
>
> tvtime | arecord -D hw:2,0 -r 32000 -c 2 -f S16_LE | aplay -
>
> My tv card is third for alsa, so parameter -D for arecord is hw:2,0.
> SECAM works well also.
> I didn't test component input, though it present in my card.

Thanks Igor, I'll merge this into the cx23885-alsa tree in the next
couple of days.

Regards,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
