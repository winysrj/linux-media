Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:59245 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab3COMHz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 08:07:55 -0400
Message-ID: <51430F15.6090706@schinagl.nl>
Date: Fri, 15 Mar 2013 13:07:49 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Dmitry Katsubo <dmitry.katsubo@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb-apps: Additional channels for Netherlands
References: <513B4B24.5000605@gmail.com> <513DC999.2090203@schinagl.nl> <51425E3D.7080003@gmail.com>
In-Reply-To: <51425E3D.7080003@gmail.com>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15-03-13 00:33, Dmitry Katsubo wrote:
> On 11.03.2013 13:10, Oliver Schinagl wrote:
>>> and what is interesting the comments refer to radio-stations only.
>> TV zenderlijst is pure DVB-T frequencies. I have not found a single FM
>> frequency there. Note that if you open it via their website, there are
>> two lists, FM zenderlijst and TV zenderlijst.
> I see. I think I have overlooked something.
>
>> You are probably using an old scan file. I pushed an updated version a
>> week or two ago. I'm still working on an automated way to have daily
>> frequency releases, but even then it can take a while before packagers
>> pick it up.
>>
>> Until then, you are free to use:
>> http://git.linuxtv.org/dtv-scan-tables.git/blob_plain/HEAD:/dvb-t/nl-All
> Great! Thanks for updating the nl-All file. What will be the dvb-apps
> future version which will include the fix?
We've split the dvb-tables from dvb-apps, so never :p I'll work in the 
next few weeks on having 'releases' when there are changes so that 
package maintainers can start picking it up.
>
> Also what is the relation between git repo you've referred and this repo:
> http://linuxtv.org/hg/dvb-apps/log/f3a70b206f0f/util/scan/dvb-t/nl-All
> ?
>
>> As for your patch, I think it's wrong. On 522 Mhz (through the country,
>> Delft as well) we have NTS4 (Bouquet 5) which is on a 2/3 coding rate,
>> in your patch it's at 1/2.
> You're absolutely correct. Perhaps that is the reason why I cannot watch
> TV on 522 MHz.
Very likly ;)
>
>> On 698 MHz we have NTS1 (Bouquet 2) which is on a code rate of 1/2.
> Still I cannot make them working. More exactly:
>
> This works (722 MHz):
> xine "dvb://Nederland 1"
> xine "dvb://Nederland 2"
> xine "dvb://Nederland 3"
>
> These do not (522 MHz and 698 MHz):
> xine "dvb://Nickelodeon"
> xine "dvb://RTL 4"
> ...
I don't 522 or 698 MHz, RTL4 is on 768 MHz here in Eindhoven.

Try scanning with w_scan; wscan tells you exactly where what exactly is. 
It can produce an inital scanning file. Send me and I'll fix it up for you.
>
> It can be the case the signal is better on 722 MHz... Could you share
> your channels.conf? Are there any specific options you pass to scan
> utility? But it's likely I need to buy better antenna. Can scan utility
> show the signal level?
Try tzap to tune to a channel, depending on your driver, it should 
output some rudimentary signal strength.
Signal is indeed important, Remember that RTL4 etc are all encrypted and 
need  a hardware cam or softcam (oscam) to properly work.
>
> Thanks.
>

