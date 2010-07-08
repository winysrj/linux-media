Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52060 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab0GHRwr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jul 2010 13:52:47 -0400
Received: by eya25 with SMTP id 25so144809eya.19
        for <linux-media@vger.kernel.org>; Thu, 08 Jul 2010 10:52:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C360E64.3020703@gmail.com>
References: <4C353039.4030202@gmail.com>
	<AANLkTikiCtPhE8uERNoYV_UF43MZU0YQgPWxyA4X0l5U@mail.gmail.com>
	<4C360E64.3020703@gmail.com>
Date: Thu, 8 Jul 2010 13:52:45 -0400
Message-ID: <AANLkTilNmBPU-YVXfo12MITtTJHwsMvZsxkkjCBz68H_@mail.gmail.com>
Subject: Re: em28xx: success report for KWORLD DVD Maker USB 2.0 (VS-USB2800)
	[eb1a:2860]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ivan <ivan.q.public@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 8, 2010 at 1:44 PM, Ivan <ivan.q.public@gmail.com> wrote:
> Now, regarding the difference in image quality between the Linux and Windows
> drivers, I took some snapshots. Linux is first, then Windows:
>
> http://www3.picturepush.com/photo/a/3762966/img/3762966.png
>
> http://www4.picturepush.com/photo/a/3762977/img/3762977.png
>
> I would have thought that the digitized video coming from the card would be
> essentially the same in both cases, but the vertical stripes and the
> difference in width don't seem to be merely a matter of postprocessing. Does
> the driver have a greater level of control than I suspected over the
> digitization process in the card? (The difference in sharpness, on the other
> hand, I would guess to be postprocessing.)
>
> So I'm mainly wondering whether the vertical stripes can be eliminated by
> controlling the card differently, or if we have no control over that and
> have to deal with it by postprocessing.

The vertical stripes were a problem with the anti-alias filter
configuration, which I fixed a few months ago (and probably just
hasn't made it into your distribution).  Just install the current
v4l-dvb code and it should go away:

http://linuxtv.org/repo

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
