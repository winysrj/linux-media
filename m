Return-path: <mchehab@pedra>
Received: from blu0-omc2-s31.blu0.hotmail.com ([65.55.111.106]:27696 "EHLO
	blu0-omc2-s31.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754796Ab1CWSZp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 14:25:45 -0400
Message-ID: <BLU0-SMTP178757907CEF2BB7BC4D728D8B70@phx.gbl>
From: "H. Ellenberger" <tuxoholic@hotmail.de>
To: linux-media@vger.kernel.org
Subject: Re: S2-3200 switching-timeouts on 2.6.38
Date: Wed, 23 Mar 2011 19:19:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi list,

Follow up to: [1]

@Manu: Your argumentation is inconsistent and lacks any proof.

Running a full scan of Astra 19.2 E with Kaffeine together with cards model 
Skystar HD and Twinhan/Azurewave VP-1041 results in a channel list of approx 
400 stations only. When I apply my patch then almost all stations are found:

patch in tuner: 400 stations found, not usable, 
patch in tuner + demod: 1127 stations found, better but less than without 
tuner patch.
patch in demod only: 1145 stations found, slightly more than with tuner patch.

This proves that the patch in demod stb0899 is still a mandatory must.

Discussions in vdr-portal.de [2] have shown that this patch solved the year 
old problems with these cards for everybody.

My conjecture is that maybe your patch in the code of stb6100 tuner might 
improve the situation for weak signals. With high signal levels as seen from 
Astra 19.2 the modification of the tuner code does not show any positive 
effect, while the cards without my patch in the demodulator code are not 
usable at all!!

So I kindly ask to include this patch.

Thanks and best regards

H .Ellenberger

[1] http://www.spinics.net/lists/linux-media/msg30490.html
[2] http://www.vdr-portal.de/board/thread.php?threadid=99603
