Return-path: <mchehab@pedra>
Received: from smtp4-g21.free.fr ([212.27.42.4]:34495 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab1FZWAi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2011 18:00:38 -0400
Subject: Re: Updates to French scan files
From: Alexis de Lattre <alexis@via.ecp.fr>
To: mossroy <mossroy@free.fr>
Cc: linux-media@vger.kernel.org,
	Christoph Pfister <christophpfister@gmail.com>,
	n_estre@yahoo.fr, alkahan@free.fr, ben@geexbox.org,
	xavier@dalaen.com, jean-michel.baudrey@orange.fr,
	lissyx@dyndns.org, sylvestre.cartier@gmail.com,
	brossard.damien@gmail.com, johann.ollivierlapeyre@gmail.com,
	jean-michel-62@orange.fr
In-Reply-To: <4E079E9F.7050004@free.fr>
References: <4DFFA7B6.9070906@free.fr>	<4DFFA917.5060509@iki.fi>
	 <4E017D7D.4050307@free.fr>
	 <BANLkTimQymz5K6YhhUgPeWjMFkkVoU6j4A@mail.gmail.com>
	 <4E079E9F.7050004@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 00:00:22 +0200
Message-ID: <1309125622.5421.15.camel@wide>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear LinuxTV friends,

Le dimanche 26 juin 2011 à 23:03 +0200, mossroy a écrit :
> I would suggest to :
> - delete the 19 remaining fr-* files
> - make the French users use the auto-With167kHzOffsets file (should we 
> create a fr-All file, that would be a link to auto-With167kHzOffsets ?)
> - create a file with a more complete list of frequencies, that would 
> also include the +333 and +500 offsets, in case they were used. We might 
> call it auto-WithUnusualOffsets for example
> I might provide a patch for that, of course.

I fully support your suggestion. I think that the
one-scan-file-per-transmitter is a non-sense (unfortunately, I
participated to this non-sense... but I was just doing "as everybody
else"). We should have one freq file per country, even if it takes more
time to scan... but as scanning is done only once, it is not a problem.
I think that we should have switched to the "one-scan-file-per-country"
a long time ago, because it would have simplified the job of Linux users
of lot !

I am aware that, for France :
Freq in Mhz = 306 + (8 x N) + (0,166 x D)

N = UHF channel number, between 21 et 69
D can be -1 , 0 , 1 , 2 or 3 = small freq offset

In order to simplify things, I would propose only ONE scan file with
offset -166, 0, 166, 333 and 500. OK, it will take more time for users
to run a scan (+66 %) compared to having a file with only offsets -166,
0, 166 but at least we are sure to cover all the possible offset that
can be used in France, and we simplify things as much as we can for
users.

Regards,

-- 
Alexis de Lattre

