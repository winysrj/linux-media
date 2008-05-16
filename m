Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway16.websitewelcome.com ([69.56.238.10])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1JwsRS-0006lK-DC
	for linux-dvb@linuxtv.org; Fri, 16 May 2008 07:25:20 +0200
Message-ID: <482D1AB7.3070101@kipdola.com>
Date: Fri, 16 May 2008 07:25:11 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: Igor <goga777@bk.ru>, linux-dvb@linuxtv.org
References: <482CC0F0.30005@kipdola.com>
	<E1JwrWW-0006Ye-00.goga777-bk-ru@f139.mail.ru>
In-Reply-To: <E1JwrWW-0006Ye-00.goga777-bk-ru@f139.mail.ru>
Subject: Re: [linux-dvb] Technotrend S2-3200 Scanning
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Igor,

I've tried using a version from the repository, dvb-utils 1.1.1-3

I also tried to compile the originals from the source tree, unpatched, 
http://linuxtv.org/hg/dvb-apps

I tried to patch "scan" with this scan source: 
http://jusst.de/manu/scan.tar.bz2

And I tried to patch szap with this file:  
http://abraham.manu.googlepages.com/szap.c

But those patched versions won't compile, except for ONE time:

I finally got to compile the patched "scan" (but trying to recompile 
afterwards failed again, very strange) but it *still* didn't scan:

$ sudo scan -t 1 -s 1 dvb-s/Astra-19.2E > ~/channels.conf
scanning dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12551500 V 22000000 22000000
ioctl DVBFE_GET_INFO failed: Operation not supported
ERROR: initial tuning failed
dumping lists (0 services)
Done.



Igor schreef:
> which version of multiproto, szap2, scan did you use ?
>
> -----Original Message-----
> From: Jelle De Loecker <skerit@kipdola.com>
> To: linux-dvb@linuxtv.org
> Date: Fri, 16 May 2008 01:02:08 +0200
> Subject: [linux-dvb] Technotrend S2-3200 Scanning
>
>   
>> But now I'm stuck again, and it seems to me this is a problem which has 
>> been faced, and fixed, before - I just can't fix it now because 
>> apparently so much has changed that all the patches don't work on the 
>> new source files anymore: any hacked "scan" or "szap" program won't compile.
>>
>> (Keep in mind I'm using a switch between my S2-3200 card and my 4 LNBs - 
>> will this cause any problems?)
>>
>> This is the problem you've no doubt seen before.
>>
>> $ sudo scan /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E 
>>  >channels.conf
>>
>> scanning /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> initial transponder 12551500 V 22000000 5
>>  >>> tune to: 12551:v:0:22000
>> __tune_to_transponder:1491: ERROR: FE_READ_STATUS failed: 22 Invalid 
>> argument
>>  >>> tune to: 12551:v:0:22000
>> __tune_to_transponder:1491: ERROR: FE_READ_STATUS failed: 22 Invalid 
>> argument
>> ERROR: initial tuning failed
>> dumping lists (0 services)
>> Done

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
