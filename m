Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:58341 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbZLIRwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 12:52:22 -0500
Received: by fxm5 with SMTP id 5so7826320fxm.28
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 09:52:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380912090951u38928896ne85d1202d22eba8a@mail.gmail.com>
References: <ad6681df0912090617k768b7f22p9abfb462ff32026f@mail.gmail.com>
	 <829197380912090723s56ef100fpe0e7182a885ddf13@mail.gmail.com>
	 <ad6681df0912090748i709fb67dn5c5fd889835913ea@mail.gmail.com>
	 <829197380912090754j416e7058obae074df83420704@mail.gmail.com>
	 <ad6681df0912090806o173d3e0do6d48a125e21a49f8@mail.gmail.com>
	 <829197380912090826w3821ce97i3df653a2d7c83f0f@mail.gmail.com>
	 <ad6681df0912090911w13a1c2e1q2a4e59cec2c4e000@mail.gmail.com>
	 <829197380912090916q61d45ddbraf89852dc524dcf3@mail.gmail.com>
	 <ad6681df0912090949k2bbdd926tc6b14ab690e9bb26@mail.gmail.com>
	 <829197380912090951u38928896ne85d1202d22eba8a@mail.gmail.com>
Date: Wed, 9 Dec 2009 12:52:28 -0500
Message-ID: <829197380912090952g3ade79dbg9bbba03dcb18a4a7@mail.gmail.com>
Subject: Re: v4l-dvb from source on 2.6.31.5 opensuse kernel - not working
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Valerio Bontempi <valerio.bontempi@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 9, 2009 at 12:51 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Wed, Dec 9, 2009 at 12:49 PM, Valerio Bontempi
>> Hi Devin
>>
>> attached you find the output.log requested
>>
>> Thanks a lot
>>
>
> Ah, there is your problem.  You have updates installed, presumably by
> your distro.
>
> /lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/em28xx
> /lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/em28xx/em28xx-alsa.ko
> /lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
> /lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/em28xx/em28xx.ko
>
> Those modules are conflicting with the base modules you replaced when
> you installed the latest v4l-dvb tree.
>
> Devin

Also, looks like you somehow managed to simultaneously have both the
in-kernel em28xx driver installed at the same time as the mrec driver:

/lib/modules/2.6.31.5-0.1-desktop/updates/em28xx-alsa.ko
/lib/modules/2.6.31.5-0.1-desktop/updates/em28xx-audio.ko
/lib/modules/2.6.31.5-0.1-desktop/updates/em28xx-audioep.ko
/lib/modules/2.6.31.5-0.1-desktop/updates/em28xx-dvb.ko
/lib/modules/2.6.31.5-0.1-desktop/updates/em28xx-aad.ko
/lib/modules/2.6.31.5-0.1-desktop/updates/em28xx.ko

You cannot have both of these installed at the same time.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
