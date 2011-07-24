Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:41918 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab1GXNDA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 09:03:00 -0400
Received: by eye22 with SMTP id 22so3067501eye.2
        for <linux-media@vger.kernel.org>; Sun, 24 Jul 2011 06:02:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E2C16B5.5010703@redhat.com>
References: <CAGoCfiyp4TB6RvF75WFrFLkTxha0-XKrXnR8L13BwJu938PaHg@mail.gmail.com>
	<4E2C16B5.5010703@redhat.com>
Date: Sun, 24 Jul 2011 09:02:59 -0400
Message-ID: <CAGoCfiyM1O1o2Ops=fzwPEL2pR-e4TbSqm0qDXtQqAfifa0KjQ@mail.gmail.com>
Subject: Re: [PATCH] Fix regression introduced which broke the Hauppauge
 USBLive 2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 24, 2011 at 8:57 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> I proposed the same fix sometime ago, when Gerd reported this issue
> for me. His feedback was that this partially fixed the issue, but
> he reported that he also needed to increase the set_power_mode delay
> from 5 to 50 ms in order to fully initialize the cx231xx hardware,
> as on the enclosed patch. It seems he tested with vanilla Fedora kernel.
>
> So, I suspect that HZ may be affecting this driver as well. As you know,
> if HZ is configured with 100, the minimum msleep() delay will be 10.
> so, instead of waiting for 5ms, it will wait for 10ms for the device
> to powerup.
>
> It would be great to configure HZ with 1000 and see the differences with
> and without Gerd's patch.
>
> Cheers,
> Mauro.

I don't dispute the possibility that there is some *other* bug that
effects users who have some other value for HZ, but neither I nor the
other use saw it.  Without this patch though, the device is broken for
*everybody*.

I would suggest checking in this patch, and separately the HZ issue
can be investigated.

I'll see if I can find some cycles today to reconfigure my kernel with
a different HZ.  Will also check the datasheets and see if Conexant
documented any sort of time for power ramping.  It's not uncommon for
such documentation to include a diagram showing timing for power up.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
