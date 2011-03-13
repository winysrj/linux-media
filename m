Return-path: <mchehab@pedra>
Received: from alia.ip-minds.de ([84.201.38.2]:33012 "EHLO alia.ip-minds.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab1CMBWM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 20:22:12 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by alia.ip-minds.de (Postfix) with ESMTP id 86D0C66A089
	for <linux-media@vger.kernel.org>; Sun, 13 Mar 2011 02:22:31 +0100 (CET)
Received: from alia.ip-minds.de ([127.0.0.1])
	by localhost (alia.ip-minds.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BTgPKDmw6p89 for <linux-media@vger.kernel.org>;
	Sun, 13 Mar 2011 02:22:31 +0100 (CET)
Received: from localhost (pD9E1A3D9.dip.t-dialin.net [217.225.163.217])
	by alia.ip-minds.de (Postfix) with ESMTPA id 1D02666A088
	for <linux-media@vger.kernel.org>; Sun, 13 Mar 2011 02:22:31 +0100 (CET)
Date: Sun, 13 Mar 2011 03:22:08 +0100
From: Jean-Michel Bruenn <jean.bruenn@ip-minds.de>
To: linux-media@vger.kernel.org
Subject: Re: WinTV 1400 broken with recent versions?
Message-Id: <20110313032208.ab1b6488.jean.bruenn@ip-minds.de>
In-Reply-To: <3DAC424F-1318-4E9D-B1E6-949ABE9E3CBB@wilsonet.com>
References: <20110309175231.16446e92.jean.bruenn@ip-minds.de>
	<76A39CFB-2838-4AD7-B353-49971F9F7DFF@wilsonet.com>
	<ba12e998349efa465be466a4d7f9d43f@localhost>
	<3AF3951C-11F6-48E4-A0EE-85179B013AFC@wilsonet.com>
	<81E0AF02-0837-4DF8-BFEA-94A654FFF471@wilsonet.com>
	<af7d57a1bb478c0edac4cd7afdfd6f41@localhost>
	<AANLkTimqGxS6OYNarqQwZNxFk+rccPn40UcK+6Oo72SC@mail.gmail.com>
	<3934d121118af31f8708589189a42b95@localhost>
	<AANLkTikYjaeXnhA3iP+kxjpA-NU4QQw-_YhRFf4U=30a@mail.gmail.com>
	<3DAC424F-1318-4E9D-B1E6-949ABE9E3CBB@wilsonet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

So i guess, nobody here can help me to solve that problems?

xc2028 1-0064: i2c output error: rc = -6 (should be 64)
xc2028 1-0064: -6 returned from send
xc2028 1-0064: Error -22 while loading base firmware
xc2028 1-0064: Loading firmware for type=BASE F8MHZ (3), id
0000000000000000.

and nobody can tell me, whether thats a firmware problem, or is it an
i2c problem? At least someone who could explain me, what the above
errors mean? Also, nobody has any idea what i could try (except for what
i already did, including reverting patches and downgrading the kernel)?
I don't think the card is that uncommon, because i've already seen some
pages stating problems with that card, at least 3 on this maillinglist
with exactly the same problem (not to talk about those people, who just
send the card back and replace it with something else/people who don't
use maillinglists/bugtracker) however, whether the card is common or
uncommon is not very helpful/useful, so.. it shouldn't really matter.

heh. I'm about to give up. just a pity because the card wasn't 
cheap when it came out and every page states "supported in linux" which
seems to be not true anymore. I know that it was, back in 2008 when i
wrote with S. Toth about it.

http://git.linuxtv.org/anttip/media_tree.git?a=commit;h=6676237398d0c2e61e5a3a27e0951f60d6ef6fe3

Here's the commit when the card was added. I was using it without any
trouble around that time. Well if someone knows what i could try (i
could also hack around in the source if someone tells me what to
change/where to change) i'd be very happy about ANY information.

thanks so far.
