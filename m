Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:36457 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbZLISxB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 13:53:01 -0500
Received: by fxm5 with SMTP id 5so7905592fxm.28
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 10:53:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ad6681df0912091021j63de38f1t17e5beaa935931d1@mail.gmail.com>
References: <ad6681df0912090617k768b7f22p9abfb462ff32026f@mail.gmail.com>
	 <829197380912090754j416e7058obae074df83420704@mail.gmail.com>
	 <ad6681df0912090806o173d3e0do6d48a125e21a49f8@mail.gmail.com>
	 <829197380912090826w3821ce97i3df653a2d7c83f0f@mail.gmail.com>
	 <ad6681df0912090911w13a1c2e1q2a4e59cec2c4e000@mail.gmail.com>
	 <829197380912090916q61d45ddbraf89852dc524dcf3@mail.gmail.com>
	 <ad6681df0912090949k2bbdd926tc6b14ab690e9bb26@mail.gmail.com>
	 <829197380912090951u38928896ne85d1202d22eba8a@mail.gmail.com>
	 <829197380912090952g3ade79dbg9bbba03dcb18a4a7@mail.gmail.com>
	 <ad6681df0912091021j63de38f1t17e5beaa935931d1@mail.gmail.com>
Date: Wed, 9 Dec 2009 13:53:06 -0500
Message-ID: <829197380912091053o7cad8737o8acf76a3d6abe8fd@mail.gmail.com>
Subject: Re: v4l-dvb from source on 2.6.31.5 opensuse kernel - not working
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Valerio Bontempi <valerio.bontempi@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 9, 2009 at 1:21 PM, Valerio Bontempi
> I don't know how it is happened, because I followed the normal way to
> compile v4l-dvb, so it seems a very strange behaviour...
>
> however, how can I solve, cleaning out all the in-kernel modules and
> all the modules I need to remove?

Well, the problem wasn't that you compiled v4l-dvb.  It's that you had
these third party em28xx modules installed (which rely on v4l-dvb).
And a recompile of v4l-dvb breaks compatibility for those third party
modules.

Without knowing how you installed the third party em28xx stuff, I
cannot really advise you on the best way to remove them.  If it were
me, I would probably just move all of those files to some temporary
directory and reboot (which would allow me to restore them if I
screwed something up).  However, I wouldn't want to be held
responsible for a user screwing up his machine.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
