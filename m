Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57064 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2FVO2R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 10:28:17 -0400
Received: by obbuo13 with SMTP id uo13so2014326obb.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 07:28:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE3A3A6.5050500@gmail.com>
References: <4FE24132.4090705@gmail.com>
	<CAGoCfixL-tEFq4SpjxChH7uc0aDZGtdoO6EqrEH3tzPzoTqK8w@mail.gmail.com>
	<4FE3A3A6.5050500@gmail.com>
Date: Fri, 22 Jun 2012 10:28:16 -0400
Message-ID: <CAGoCfiympaYxeypnq0uuX_azsHhk3OFuLu-=r0yEvOz51Eznqw@mail.gmail.com>
Subject: Re: Chipset change for CX88_BOARD_PINNACLE_PCTV_HD_800i
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mack Stanley <mcs1937@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 21, 2012 at 6:43 PM, Mack Stanley <mcs1937@gmail.com> wrote:
> mplayer [various options] dvb://6
>
> tunes to different channels different times, sometimes to video from one
> channel and sound from another, sometimes to video but no sound.

I would try tuning to the same channel multiple times and see if it
behaves *consistently*.  In other words, does it always tune to the
same "wrong" channel or consistently show the same wrong audio/video
stream.  My guess is this has nothing to do with the card but rather
is a problem with the scanner putting the right values into the
channels.conf (wrong video/audio PIDs in the file).

> I'll be interested in what your contacts at pctv suggest.

I'm going back and forth with my PCTV contact.  He says the chip was
swapped out and there weren't any other changes to the PCB.  However
as you discovered, driver changes are required.  Should be pretty easy
to get working.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
