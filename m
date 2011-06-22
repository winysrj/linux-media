Return-path: <mchehab@pedra>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45065 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1FVF2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 01:28:33 -0400
Received: from mfilter4-d.gandi.net (mfilter4-d.gandi.net [217.70.178.134])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 7A386A8075
	for <linux-media@vger.kernel.org>; Wed, 22 Jun 2011 07:28:32 +0200 (CEST)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter4-d.gandi.net (mfilter4-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id nRagY6Bu0dSi for <linux-media@vger.kernel.org>;
	Wed, 22 Jun 2011 07:28:31 +0200 (CEST)
Received: from [192.168.10.60] (tri69-3-82-235-23-7.fbx.proxad.net [82.235.23.7])
	(Authenticated sender: bmaras@flaht.eu)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 93693A8068
	for <linux-media@vger.kernel.org>; Wed, 22 Jun 2011 07:28:29 +0200 (CEST)
Message-ID: <4E017D7D.4050307@free.fr>
Date: Wed, 22 Jun 2011 07:28:29 +0200
From: mossroy <mossroy@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Updates to French scan files
References: <4DFFA7B6.9070906@free.fr> <4DFFA917.5060509@iki.fi>
In-Reply-To: <4DFFA917.5060509@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Le 20/06/2011 22:09, Antti Palosaari a écrit :
> On 06/20/2011 11:04 PM, mossroy wrote:
>> In France, the DVB-T channels are currently moving (because the analog
>> TV is being removed at the same time)
>> The frequencies are modified region by region, with a calendar that
>> started in late 2009, and will end on november 29th 2011 (see
>> http://www.tousaunumerique.fr/ou-et-quand/ )
>>
>> All the new channels are listed here :
>> http://www.tousaunumerique.fr/professionnels/en-savoir-plus/documentation/categorie-doc/plans-de-frequences/ 
>>
>> . The PDF files also lists channels that are planned to be used in the
>> future (but are unused at the moment)
>>
>> Is there already a plan to update the scan files to reflect these 
>> changes?
>
> Feel free to do that.
>
> regards
> Antti
>
It looks like there is a limited number of frequencies used over the 
country :
http://www.cgvforum.fr/phpBB3/html/faq_tnt.html#recept7

I am lazy so I was wondering why there was one file of frequencies for 
each town in /usr/share/dvb/dvb-t/.
Would it be harmful to have only one list with all those frequencies 
(there are 57) for all the country?
I suppose the DVB-T softwares will take longer to find the channels in 
all these frequencies, instead of scanning only the ~10 relevant ones. 
But isn't it what every television does? All the hardware TNT receiver I 
know scan all the frequencies without knowing in which town you are.
Plus it would enable future usage of the currently unused frequencies, 
without the need to modify the files again

I suppose I missed something because that would be too easy ;-)
