Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:40756 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162AbZLIRvR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 12:51:17 -0500
Received: by fxm5 with SMTP id 5so7824840fxm.28
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 09:51:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ad6681df0912090949k2bbdd926tc6b14ab690e9bb26@mail.gmail.com>
References: <ad6681df0912090617k768b7f22p9abfb462ff32026f@mail.gmail.com>
	 <829197380912090723s56ef100fpe0e7182a885ddf13@mail.gmail.com>
	 <ad6681df0912090748i709fb67dn5c5fd889835913ea@mail.gmail.com>
	 <829197380912090754j416e7058obae074df83420704@mail.gmail.com>
	 <ad6681df0912090806o173d3e0do6d48a125e21a49f8@mail.gmail.com>
	 <829197380912090826w3821ce97i3df653a2d7c83f0f@mail.gmail.com>
	 <ad6681df0912090911w13a1c2e1q2a4e59cec2c4e000@mail.gmail.com>
	 <829197380912090916q61d45ddbraf89852dc524dcf3@mail.gmail.com>
	 <ad6681df0912090949k2bbdd926tc6b14ab690e9bb26@mail.gmail.com>
Date: Wed, 9 Dec 2009 12:51:22 -0500
Message-ID: <829197380912090951u38928896ne85d1202d22eba8a@mail.gmail.com>
Subject: Re: v4l-dvb from source on 2.6.31.5 opensuse kernel - not working
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Valerio Bontempi <valerio.bontempi@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 9, 2009 at 12:49 PM, Valerio Bontempi
> Hi Devin
>
> attached you find the output.log requested
>
> Thanks a lot
>

Ah, there is your problem.  You have updates installed, presumably by
your distro.

/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/em28xx
/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/em28xx/em28xx-alsa.ko
/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/em28xx/em28xx.ko

Those modules are conflicting with the base modules you replaced when
you installed the latest v4l-dvb tree.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
