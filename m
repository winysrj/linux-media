Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.adfinis.com ([212.103.64.13])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@0x17.ch>) id 1K4gCf-0005gW-22
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 19:58:18 +0200
From: Nicolas Christener <lists@0x17.ch>
To: Dennis Noordsij <dennis.noordsij@movial.fi>
In-Reply-To: <484950D4.7050600@movial.fi>
References: <1212736555.4264.12.camel@oipunk.loozer.local>
	<4849016A.8050607@movial.fi>
	<1212763110.14191.12.camel@oipunk.loozer.local>
	<484950D4.7050600@movial.fi>
Date: Fri, 06 Jun 2008 19:58:12 +0200
Message-Id: <1212775092.5123.12.camel@oipunk.loozer.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy Piranha
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

Hi Dennis, hello list

Am Freitag, den 06.06.2008, 16:59 +0200 schrieb Dennis Noordsij:

[...]

> Ah, yes. Sorry forgot to mention one part. As you can tell from the log,
> the default mode is DVB-H.
> 
> use:    modprobe sms1xxx default_mode=0

ah yep this does the trick :)
Now I got the devices:
[nicolas@oipunk:/dev/dvb]$ find .
.
./adapter0
./adapter0/frontend0
./adapter0/dvr0
./adapter0/demux0

and `dmesg' looks good too. Thanks very much!

However there is something left and I'm not sure, if it is a driver
issue. Most probably the driver is OK and I'm doing something wrong ;)
As far as I know, I now need to create a channels.conf file for xine,
mplayer... Thats what I did:

[nicolas@oipunk:~/temp/tv/dvb-apps-9311c900f746/util/scan]$ ./scan
dvb-t/ch-All 
scanning dvb-t/ch-All
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 482000000 0 5 9 1 1 3 0
[...]
>>> tune to:
482000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
482000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to:
514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
[...]
ERROR: initial tuning failed
dumping lists (0 services)
Done.

I hope this is not a stupid newbie problem, but until now I couldn't
find a solution. I also tried the `w_scan' utility which couldn't find
any channels either.

I would very much appreciate any help.

kind regards
Nicolas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
