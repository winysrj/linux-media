Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:43018 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab3CKMK2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 08:10:28 -0400
Message-ID: <513DC999.2090203@schinagl.nl>
Date: Mon, 11 Mar 2013 13:10:01 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Dmitry Katsubo <dmitry.katsubo@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: dvb-apps: Additional channels for Netherlands
References: <513B4B24.5000605@gmail.com>
In-Reply-To: <513B4B24.5000605@gmail.com>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09-03-13 15:45, Dmitry Katsubo wrote:
> Dear LinuxTV developers,
Hoi Dimitry,
>
> When I was playing with "scan" utility, I paid attention to comments in
> file /usr/share/dvb/dvb-t/nl-All
>
>> # The Netherlands, whole country
>> # Created from http://radio-tv-nederland.nl/TV%20zenderlijst%20Nederland.xls
>> # and http://radio-tv-nederland.nl/dvbt/dvbt-lokaal.html
> and what is interesting the comments refer to radio-stations only.
TV zenderlijst is pure DVB-T frequencies. I have not found a single FM 
frequency there. Note that if you open it via their website, there are 
two lists, FM zenderlijst and TV zenderlijst.
>
> After I have completed the scan (I leave in the Netherlands in Delft
> area) I have not found few TV stations. I think that the list is missing
> 522MHz and 698MHz. After I have added them (see patch file), I was able
> to complete the scan. However I think that I have made an error, because
> I can't watch TV channels fount on the newly added frequencies.
>
> Can somebody help me to improve "nl-All" file?
You are probably using an old scan file. I pushed an updated version a 
week or two ago. I'm still working on an automated way to have daily 
frequency releases, but even then it can take a while before packagers 
pick it up.

Until then, you are free to use:
http://git.linuxtv.org/dtv-scan-tables.git/blob_plain/HEAD:/dvb-t/nl-All


As for your patch, I think it's wrong. On 522 Mhz (through the country, 
Delft as well) we have NTS4 (Bouquet 5) which is on a 2/3 coding rate, 
in your patch it's at 1/2.

On 698 MHz we have NTS1 (Bouquet 2) which is on a code rate of 1/2.

Feel free to correct me if I'm wrong.
>
> Thanks.
>
> Additional links:
>
> http://dvbt4all.nl/digitenne/zenders/zuid-holland-noord/delft/
> http://nl.wikipedia.org/wiki/DVB-T-frequenties
>

