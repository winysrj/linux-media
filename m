Return-path: <mchehab@pedra>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48923 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab1FZVDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2011 17:03:44 -0400
Message-ID: <4E079E9F.7050004@free.fr>
Date: Sun, 26 Jun 2011 23:03:27 +0200
From: mossroy <mossroy@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Christoph Pfister <christophpfister@gmail.com>, n_estre@yahoo.fr,
	alkahan@free.fr, alexis@via.ecp.fr, ben@geexbox.org,
	xavier@dalaen.com, jean-michel.baudrey@orange.fr,
	lissyx@dyndns.org, sylvestre.cartier@gmail.com,
	brossard.damien@gmail.com, johann.ollivierlapeyre@gmail.com,
	jean-michel-62@orange.fr
Subject: Re: Updates to French scan files
References: <4DFFA7B6.9070906@free.fr>	<4DFFA917.5060509@iki.fi>	<4E017D7D.4050307@free.fr> <BANLkTimQymz5K6YhhUgPeWjMFkkVoU6j4A@mail.gmail.com>
In-Reply-To: <BANLkTimQymz5K6YhhUgPeWjMFkkVoU6j4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks for your answer.

The French frequencies are (almost) all included in the 
"auto-With167kHzOffsets" file.
In fact, the offset can officially be -167, 0, +167 (which are included 
in this file), but also +333 and +500 (see page 11 of 
http://www.csa.fr/upload/publication/CSATNT.pdf )

I checked that all the frequencies currently declared in the 19 fr-* 
files (remaining after this cleanup : 
http://linuxtv.org/hg/dvb-apps/rev/795f75601b73 ) are included in 
"auto-With167kHzOffsets" (except that some use a 166kHz offset instead 
of 167kHz : I suppose this difference of 1kHz can be ignored)

I checked each of these 19 existing fr-* files (see 
http://linuxtv.org/hg/dvb-apps/file/93a96e9ce765/util/scan/dvb-t ) to 
see if the frequencies were outdated (compared to the official 
frequencies : 
http://www.tousaunumerique.fr/professionnels/en-savoir-plus/documentation/categorie-doc/plans-de-frequences/ 
)
Most of them ARE outdated, except :
- Brest and Laval (frequencies are correct)
- Toulouse, because the frequencies will only change on November 8th 2011
- I have a doubt for Villebon because I did not find which transponder 
it uses

I saw that w-scan uses only the offsets -167, 0, and +167 for country 
FR. I suppose they're the most usual ones.

I would suggest to :
- delete the 19 remaining fr-* files
- make the French users use the auto-With167kHzOffsets file (should we 
create a fr-All file, that would be a link to auto-With167kHzOffsets ?)
- create a file with a more complete list of frequencies, that would 
also include the +333 and +500 offsets, in case they were used. We might 
call it auto-WithUnusualOffsets for example
I might provide a patch for that, of course.

I have put in copy of this email the authors of some of the existing 
fr-* files (Maybe some of these addresses are now invalid). If you 
missed the beginning of the thread : 
http://www.mail-archive.com/linux-media@vger.kernel.org/msg33394.html

What's your opinion?

Le 26/06/2011 16:56, Christoph Pfister a écrit :
> 2011/6/22 mossroy<mossroy@free.fr>:
> <snip>
>> Would it be harmful to have only one list with all those frequencies (there
>> are 57) for all the country?
> <snip>
>
> http://linuxtv.org/hg/dvb-apps/file/tip/util/scan/dvb-t/auto-Default
> http://linuxtv.org/hg/dvb-apps/file/tip/util/scan/dvb-t/auto-With167kHzOffsets
> http://linuxtv.org/hg/dvb-apps/file/tip/util/scan/dvb-t/auto-Australia
> http://linuxtv.org/hg/dvb-apps/file/tip/util/scan/dvb-t/auto-Italy
> http://linuxtv.org/hg/dvb-apps/file/tip/util/scan/dvb-t/auto-Taiwan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html
