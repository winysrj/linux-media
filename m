Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JP2Wu-00079h-Lu
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 22:19:04 +0100
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JW500ATU9USCEK0@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 12 Feb 2008 16:18:28 -0500 (EST)
Date: Tue, 12 Feb 2008 16:18:27 -0500
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200802121149.15425.linuxdreas@launchnet.com>
To: Andreas <linuxdreas@launchnet.com>
Message-id: <47B20D23.6070305@linuxtv.org>
MIME-version: 1.0
References: <200802111739.47956.linuxdreas@launchnet.com>
	<200802112310.38960.linuxdreas@launchnet.com>
	<47B1B324.9050309@linuxtv.org>
	<200802121149.15425.linuxdreas@launchnet.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge WinTV-HVR 1600
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Andreas wrote:
> Am Dienstag, 12. Februar 2008 06:54:28 schrieben Sie:
>> Andreas wrote:
>>> Am Montag, 11. Februar 2008 17:49:51 schrieben Sie:
>>>> Andreas wrote:
>>>>> Hallo,
>>>>> I bought the card today and naturally I am wondering how/what/when
>>>>> the card is supported?
>>>>>
>>>>> Thank you
>>>> Look for the cx18 development trees on linuxtv.org
>>>>
>>>> - Steve
>>> Steve,
>>> Thank you, I checked out Hans' cx18 tree and tried to compile the
>>> moduiles. On my AMD x86-64 (Kernel 2.6.24.1) I get an error during
>>> compilation. Any idea how I can fix that? Going further with make -k
>>> compiles the other modules, but then make install fails with an error
>>> about stripping the debug info.
>> No idea, the last time I built it (3-4 weeks ago) it was fine.
>>
>> Does the master tree (http://linuxtv.org/hg/v4l-dvb) build cleanly in
>> your environment?
>>
>> (See the wiki for build instructions).
>>
>> - Steve
> 
> I got the cx18 tree to bulid, installed the card and the driver, and now 
> dvbscan gives:
> andreas@hal9004:~> dvbscan us-atsc/Cable-Standard-center-frequencies-QAM256
> Unable to query frontend status
> 
> I get the same message with any of the files in scan/atsc. The card is 
> connected to my cable tv outlet.
> 
> The card shows up in /dev/dvb/adapter0:
> andreas@hal9004:~> ls /dev/dvb/adapter0/
> demux0  dvr0  frontend0  net0
> 
> What am I missing here? Any pointers?

ATSC isn't supported yet. Try analog.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
