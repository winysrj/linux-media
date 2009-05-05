Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp103.mail.ukl.yahoo.com ([77.238.184.35]:26151 "HELO
	smtp103.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754434AbZEETkN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2009 15:40:13 -0400
Subject: saa7134-alsa and snd_card_new only error with alsa 1.0.19 / ubuntu
 9.04 jaunty - tracked down, further help appreciated
From: Lars Oliver Hansen <lars.hansen@yahoo.co.uk>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 05 May 2009 21:33:35 +0200
Message-Id: <1241552015.7752.29.camel@lars-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm getting exactly one error message in dmesg: saa7134_alsa: Unknown
symbol snd_card_new  which means I don't have any sound with analog tv.

I've tracked down the call to snd_card_new to the only location in
compat.h where it is called if #ifdef NEED_SND_CARD_CREATE is true. If
#ifdef NEED_SND_CARD_CREATE is true, there is also done an inclusion of
sound/core.h. Core.h is an alsa header which in the latest alsa 1.0.19
includes a definition of snd_card_new. However this definition is
missing in the sources that come with Ubuntu 9.04 Jaunty against which I
compiled the v4l-dvb sources (The saa7134-alsa error occurs with both my
compilation and did occur with the pre-compiled drivers which came with
9.04 Jaunty!).

Adding snd_card_new to the Ubuntu 9.04 sources was/is no good idea as it
calls its own snd_card_create from init.c which conflicts with
snd_card_create from compat.h which is the wrapper around snd_card_new
there.

As the call to snd_card_create in compat.h passes the identical argument
list as would be passed to init.c s snd_card_create later, I figured I
can add the declaration of snd_card_create to the core.h of the Ubuntu
9.04 sources which is/was missing too there as extern and disable the
snd_card_create in compat.h (compat.h includes core.h thus core.h s
extern snd_card_create should be called). As init.c does an
export_symbol of snd_card_create I guessed this could work.

So I would have instead of a wrapped call to a non-existant snd_card_new
a direct call to an exported snd_card_create.
Unfortunately I get this in dmesg now:

saa7134_alsa: no symbol version for snd_card_create
[ 4383.422044] saa7134_alsa: Unknown symbol snd_card_create

What can I do now?

Any help?

Thanks!


Best Regards

Lars

