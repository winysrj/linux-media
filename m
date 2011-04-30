Return-path: <mchehab@pedra>
Received: from mx5.orcon.net.nz ([219.88.242.55]:58425 "EHLO mx5.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab1D3LQJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 07:16:09 -0400
Received: from Debian-exim by mx5.orcon.net.nz with local (Exim 4.69)
	(envelope-from <mstuff@read.org.nz>)
	id 1QG89g-0006o4-I9
	for linux-media@vger.kernel.org; Sat, 30 Apr 2011 23:16:08 +1200
Message-ID: <4DBBEF77.8000208@read.org.nz>
Date: Sat, 30 Apr 2011 23:16:07 +1200
From: Morgan Read <mstuff@read.org.nz>
MIME-Version: 1.0
To: Stu Fleming <stewart@wic.co.nz>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Optus D1 tuning?
References: <BANLkTikXWx-E_rOyEb47S1TFfh3KBd0oNw@mail.gmail.com> <1304154990.3962.48.camel@media-centre>
In-Reply-To: <1304154990.3962.48.camel@media-centre>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Yes, I have too - amongst others...

My hope was that someone might stick the info below in a file called
OptusD1-160E and package it up to arrive in /dvb-apps/dvb-s so others
don't have to use the myriad of little bits of information out there and
it would just work...

Many thanks,
M.

On 30/04/11 21:16, Stu Fleming wrote:
> I used http://www.wlug.org.nz/FreeViewMythTvSetup as a guide to set up
> my Freeview on Mythtv.
> 
> Hope this helps.
> Regards,
> Stu
> 
> On Sat, 2011-04-30 at 21:05 +1200, Morgan Read wrote:
>> Hello list
>>
>> I've been trying to connect to the Optus D1 satellite from NZ, and I'm
>> tearing my hair out.
>>
>> There is no config file dvb-apps/dvb-s so I've constructed the following from:
>> http://www.lyngsat.com/optusd1.html
>>
>> # Optus D1 satellite 160E
>> # freq pol sr fec
>>
>> ### Freeview: DVB-S, Prime TV, Shine TV, C4, TV 3, Four, Stratos,
>> Parliament TV, Cue TV, Te Reo, TV 3 +1
>> S 12456000 H 22500000 3/4
>> ### Freeview: DVB-S, Maori TV, TVNZ TV One Auckland, TVNZ TV 2, TVNZ7,
>> TVNZ U, TVNZ TV One Hamilton, TVNZ TV One Wellington, TVNZ TV One
>> Christchurch
>> S 12483000 H 22500000 3/4
>>
>> ### DVB-S2, Channel Nine, GEM, Go!
>> S 12398000 V 11909000 2/3
>> ### SBS Tasmania: DVB-S, SBS One Tasmania, SBS Two Tasmania, SBS One
>> Tasmania HD, SBS Radio Tasmania AM, SBS Radio Tasmania FM
>> S 12648000 V 12600000 5/6
>>
>> ### Sky New Zealand: DVB-S2 Videoguard
>> S 12267000 H 22500000 2/3
>> S 12331000 H 22500000 2/3
>> S 12358000 H 22500000 2/3
>> ### Sky	New Zealand: DVB-S Videoguard
>> S 12394000 H 22500000 3/4
>> S 12421000 H 22500000 3/4
>> ### Sky New Zealand: DVB-S Videoguard, Radio New Zealand National,
>> Radio New Zealand Concert, Niu FM, Tahu FM
>> S 12519000 H 22500000 3/4
>> ### Sky New Zealand: DVB-S Videoguard, Calvary Chapel Radio New Zealand
>> S 12546000 H 22500000 3/4
>> ### Sky New Zealand: DVB-S Videoguard, The Edge FM
>> S 12581000 H 22500000 3/4
>> ### Sky New Zealand: DVB-S Videoguard, Maori TV
>> S 12608000 H 22500000 3/4
>> ### Sky New Zealand: DVB-S Videoguard
>> S 12644000 H 22500000 3/4
>> ### Sky New Zealand: DVB-S Videoguard, TVNZ TV One, TVNZ TV 2, Trackside
>> S 12671000 H 22500000 3/4
>> ### Sky New Zealand: DVB-S Videoguard
>> S 12707000 H 22500000 3/4
>> S 12734000 H 22500000 3/4
>>



-- 
Morgan Read
NEW ZEALAND
<mailto:mstuffATreadDOTorgDOTnz>

Confused about DRM?
Get all the info you need at:
http://drm.info/
