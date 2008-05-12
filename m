Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JvVlR-0004Gg-M3
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 13:00:22 +0200
Date: Mon, 12 May 2008 12:59:35 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Rogan Dawes <lists@dawes.za.net>
In-Reply-To: <48281E7A.8010006@dawes.za.net>
Message-ID: <Pine.LNX.4.64.0805121254410.11078@pub3.ifh.de>
References: <48281E7A.8010006@dawes.za.net>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-T South Africa
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

Hi Rogan,

your dvbtraffic output raises a question: What happens when you run it for 
several seconds ?

Are the PIDs always the same? Especially the one with the higher bitrate?

I'm asking because if that is the case, it could be that this is a DVB-H 
transmission.

I have some tools (which I did not commit yet) which "scan", in a very 
basic way, for DVB-H services, maybe this could help you.

Before that you can try to use dvbsnoop on PID 0x00 and 0x10 to see 
whether it signals a INT-section.

I could also be a pure radio transmission, but in that case scan should 
detect those channels.

Patrick.


On Mon, 12 May 2008, Rogan Dawes wrote:

> Hi folks,
>
> I am trying to get my FlyDVB Trio card working with the trial broadcasts
> that are currently underway in South Africa (Johannesburg).
>
> I have got the drivers loaded fine, and used "w_scan" as described on
> the wiki to generate an initial tuning file (attached). From there I
> used "scan" to construct a channels.conf file (also attached).
>
> However, my problem arises is that there do not seem to be any audio or
> video PIDs identified. It is possible that the broadcast is encrypted,
> since I see many station names operated by MultiChoice (normally DVB-S
> with CA).
>
> I did try using dvbtraffic to see which PIDs were generating the most
> data, but entering that as the video PID for an arbitrary station was
> unsuccessful. Any ideas what I can try further? Unfortunately, our
> "Department of Communications" has not been very communicative about
> these trials, so I don't have any more information about how these
> stations are being transmitted.
>
> A snippet of dvbtraffic while "tzap RT" was running follows:
>
> -PID--FREQ-----BANDWIDTH-BANDWIDTH-
> 0000     4 p/s     0 kb/s     7 kbit
> 0010     1 p/s     0 kb/s     2 kbit
> 0011    13 p/s     2 kb/s    20 kbit
> 0015     1 p/s     0 kb/s     2 kbit
> 0065     3 p/s     0 kb/s     5 kbit
> 0066     0 p/s     0 kb/s     1 kbit
> 006f     2 p/s     0 kb/s     4 kbit
> 0078   106 p/s    19 kb/s   159 kbit
> 0079     2 p/s     0 kb/s     4 kbit
> 0083     2 p/s     0 kb/s     4 kbit
> 008d     2 p/s     0 kb/s     4 kbit
> 0097     5 p/s     0 kb/s     8 kbit
> 0098     2 p/s     0 kb/s     4 kbit
> 00a0   291 p/s    53 kb/s   438 kbit
> 00a1     2 p/s     0 kb/s     4 kbit
> 00aa   345 p/s    63 kb/s   519 kbit
> 00ab     2 p/s     0 kb/s     4 kbit
> 00b4   381 p/s    69 kb/s   573 kbit
> 00b5     2 p/s     0 kb/s     4 kbit
> 00ba     2 p/s     0 kb/s     4 kbit
> 00bc   246 p/s    45 kb/s   371 kbit
> 00bd     2 p/s     0 kb/s     4 kbit
> 00be   400 p/s    73 kb/s   601 kbit
> 00bf     2 p/s     0 kb/s     4 kbit
> 00c8   382 p/s    70 kb/s   574 kbit
> 00c9     2 p/s     0 kb/s     4 kbit
> 00d2    59 p/s    10 kb/s    89 kbit
> 00d3     2 p/s     0 kb/s     4 kbit
> 00dc   435 p/s    79 kb/s   655 kbit
> 00dd     2 p/s     0 kb/s     4 kbit
> 0104   341 p/s    62 kb/s   513 kbit
> 0105     2 p/s     0 kb/s     4 kbit
> 0118   137 p/s    25 kb/s   206 kbit
> 0119     2 p/s     0 kb/s     4 kbit
> 012d     2 p/s     0 kb/s     4 kbit
> 0141     2 p/s     0 kb/s     4 kbit
> 014b     2 p/s     0 kb/s     4 kbit
> 1fff    93 p/s    17 kb/s   140 kbit
> 2000  3311 p/s   607 kb/s  4980 kbit
>
> To my mind, these all seem *way* too low to be meaningful, right?
>
> Is there anything else I can try?
>
> Thanks
>
> Rogan
> P.S. Cc: appreciated, but I do read the list via GMANE as well occasionally.
>
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
