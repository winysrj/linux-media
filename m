Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns218.ovh.net ([213.186.34.114])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <webdev@chaosmedia.org>) id 1Jwut0-0006D9-EV
	for linux-dvb@linuxtv.org; Fri, 16 May 2008 10:01:54 +0200
Message-ID: <482D3F41.80402@chaosmedia.org>
Date: Fri, 16 May 2008 10:01:05 +0200
From: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
MIME-Version: 1.0
To: LinuxTV DVB Mailing <linux-dvb@linuxtv.org>
References: <482D1AB7.3070101@kipdola.com>	<E1Jwsxt-000E0b-00.goga777-bk-ru@f151.mail.ru>	<482D2A0E.1030307@okg-computer.de>
	<482D3359.2020506@kipdola.com>
In-Reply-To: <482D3359.2020506@kipdola.com>
Cc: Jelle De Loecker <skerit@kipdola.com>
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


>> you have to patch the szap and scan from this sources:
>>
>> http://abraham.manu.googlepages.com/szap.c
>> http://abraham.manu.googlepages.com/szap.c
>>     
> I fear things have changed too much for the patches to work. (Or I'm 
> messing up a simple command like patch)
>
> Szap: (Using the other szap.c file I can actually apply the patch, but 
> the new szap.c seems to be incompatible)
>   

hi, i installed multiproto a couple of weeks ago and tried a lot of 
patches for szap / scan or already patched szap2 sources and none would 
work..

But i did find out that szap2 available in v4l dvb-apps tree, in the 
test directory, works fine with current multiproto.

I've tested it with my tt s2-3200 and can tune to dvb-s2 transponders 
with no problem, although i noticed it misses some options from some 
other szap2 i first tested..

Marc

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
