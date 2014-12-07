Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36961 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaLGOu3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Dec 2014 09:50:29 -0500
Message-ID: <5484692D.2020009@iki.fi>
Date: Sun, 07 Dec 2014 16:50:21 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jurgen Kramer <gtmkramer@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: DVBSky T980C: Si2168 fw load failed
References: <2eea6b3b11e395b7fb238f350a804dc9.squirrel@webmail.xs4all.nl>	 <54834B0D.6070502@iki.fi> <1417940144.2720.1.camel@xs4all.nl>
In-Reply-To: <1417940144.2720.1.camel@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/07/2014 10:15 AM, Jurgen Kramer wrote:
> On Sat, 2014-12-06 at 20:29 +0200, Antti Palosaari wrote:
>> On 12/06/2014 06:48 PM, Jurgen Kramer wrote:
>>> On my new DVBSky T980C the tuner firmware failes to load:
>>> [   51.326525] si2168 2-0064: found a 'Silicon Labs Si2168' in cold state
>>> [   51.356233] si2168 2-0064: downloading firmware from file
>>> 'dvb-demod-si2168-a30-01.fw'
>>> [   51.408166] si2168 2-0064: firmware download failed=-110
>>> [   51.415457] si2157 4-0060: found a 'Silicon Labs Si2146/2147/2148/2157/2158'
>>> in cold state
>>> [   51.521714] si2157 4-0060: downloading firmware from file
>>> 'dvb-tuner-si2158-a20-01.fw'
>>> [   52.330605] si2168 2-0064: found a 'Silicon Labs Si2168' in cold state
>>> [   52.330784] si2168 2-0064: downloading firmware from file
>>> 'dvb-demod-si2168-a30-01.fw'
>>> [   52.382145] si2168 2-0064: firmware download failed=-110
>>>
>>> 110 seems to mean connection timeout. Any pointers how to debug this further?
>>>
>>> This is with the latest media_build from linuxtv.org on 3.17.4.
>>
>> Looks like si2168 firmware failed to download, but si2157 succeeded.
>> Could you add some more time for driver timeout? Current timeout is
>> selected by trial and error, lets say it takes always max 43ms for my
>> device I coded it 50ms.
>>
>>
>> drivers/media/dvb-frontends/si2168.c
>> /* wait cmd execution terminate */
>> #define TIMEOUT 50
>>
>> change it to
>> #define TIMEOUT 500
>
> Thanks, with the larger timeout the fw load works:
>
> [   56.960982] si2168 4-0064: found a 'Silicon Labs Si2168' in cold
> state
> [   56.972650] si2168 4-0064: downloading firmware from file
> 'dvb-demod-si2168-a30-01.fw'
> [   60.103509] si2168 4-0064: found a 'Silicon Labs Si2168' in warm
> state
> [   60.110739] si2157 6-0060: found a 'Silicon Labs
> Si2146/2147/2148/2157/2158' in cold state
> [   60.123720] si2157 6-0060: downloading firmware from file
> 'dvb-tuner-si2158-a20-01.fw'

Have to find out some suitable value. For that I need know how long it 
took maximum in your case. There is already dubug printing to print 
execution time of each command, but it is behind dynamic debug. Maybe 
the most easiest way is change that debug line to info:
drivers/media/dvb-frontends/si2168.c
-               dev_dbg(&s->client->dev, "cmd execution took %d ms\n",
+               dev_info(&s->client->dev, "cmd execution took %d ms\n",

and then compile and install and issue command:
$ dvb-fe-tool --set-delsys=DVBT2

After that is should print a lot of times to log, like:

si2168 6-0064: cmd execution took 1 ms
si2168 6-0064: cmd execution took 1 ms
si2168 6-0064: found a 'Silicon Labs Si2168' in cold state
si2168 6-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
si2168 6-0064: cmd execution took 26 ms
si2168 6-0064: cmd execution took 1 ms

>
> BTW Is there a way to switch between T/T2 and DVB-C mode?

$ dvb-fe-tool --set-delsys=xxx

but maybe that does not change it permanently. It is application job to 
tell proper standard used.

regards
Antti


-- 
http://palosaari.fi/
