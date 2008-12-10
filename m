Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from correo.cdmon.com ([212.36.74.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jordi@cdmon.com>) id 1LASw7-0001n9-SN
	for linux-dvb@linuxtv.org; Wed, 10 Dec 2008 18:33:25 +0100
Received: from localhost (localhost.cdmon.com [127.0.0.1])
	by correo.cdmon.com (Postfix) with ESMTP id 17A87130E6E
	for <linux-dvb@linuxtv.org>; Wed, 10 Dec 2008 18:32:50 +0100 (CET)
Received: from correo.cdmon.com ([127.0.0.1])
	by localhost (correo.cdmon.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 2y+iqLDMLNjD for <linux-dvb@linuxtv.org>;
	Wed, 10 Dec 2008 18:32:44 +0100 (CET)
Received: from [192.168.0.174] (62.Red-217-126-43.staticIP.rima-tde.net
	[217.126.43.62])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by correo.cdmon.com (Postfix) with ESMTP id C82BC130D79
	for <linux-dvb@linuxtv.org>; Wed, 10 Dec 2008 18:32:43 +0100 (CET)
Message-ID: <493FFD3A.80209@cdmon.com>
Date: Wed, 10 Dec 2008 18:32:42 +0100
From: Jordi Moles Blanco <jordi@cdmon.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] lifeview pci trio (saa7134) not working through diseqc
	anymore
Reply-To: jordi@cdmon.com
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

Hi everyone,

i've got 2 satellite dishes home and a diseqc 2.0.

i've been using ubuntu/kubuntu for quite a while now but until hardy
came out, i couldn't use my "lifeview pci trio" pci card at all, as i
want it to work throught diseqc, to get channels from both dishes, so i
kept going back to windows, unfortunately.

The thing is that my whole setup works, as i've got a machine with dual
boot and window xp installed on one partition. Needless to say that i
can , with prodvb, altdvb, etc, tune both satellites through diseqc.

so... when hardy came out i decided to try again... i downloaded the cd,
i386 version and installed. I almost went crazy when i launched kaffeine
and i was able to tune channels from both satellites... almost out of
the box!!! i hadn't been able to do this in earlier versions (well... a
part from having to call modprobe saa7134 front_end=1 to use the
satellite chip)

so... i searched for all the channels with kaffeine and i started
watching channels without any problem.

Then, i had the bad idea of doing

apt-get update
apt-get upgrade

i didn't get any error message at all... but when i ran kaffeine
again..... no channels could be viewed.

Then i started to go crazy trying to get it working again. I deleted the
whole list of channels and tried to tune again... with no luck... i
would only get channels from one satellite, that on on switch 1 in the
diseqc.

After 2 days i loaded windows to see if i had broken something... but i
hadn't, everything was working fine there.

then i loaded the old kernel, linux-image-2.6.24-19-generic, then the
updated one again linux-image-2.6.24-22-generic

then i tried to go back to an earlier version of kaffeine (just in case)

i'm using 0.8.6-0ubuntu8.3 and i went back to 0.8.6-0ubuntu8.1 and even
0.8.6-0ubuntu8

no luck with all that.

and then i found out how to scan channels from command line, and i saw
that no matter what switch you tell saa7134 to scan on, i will always go
to "switch 1" on the diseqc.

here's what i got from scanning........

switch 1 (astra 28.2E)

********
scan -s 1 /home/servidor/.kde/share/apps/kaffeine/dvb-s/Astra-28.2E
>>> tune to: 10729:v:1:22000
0x0000 0x206c: pmt_pid 0x0100 BSkyB -- E4+1 (running)
0x0000 0x2071: pmt_pid 0x0103 BSkyB -- E4 (running)
0x0000 0x2077: pmt_pid 0x0101 BSkyB -- Channel 4 +1 (running)
0x0000 0x2078: pmt_pid 0x0102 BSkyB -- Channel 4 +1 (running)
0x0000 0x2079: pmt_pid 0x010f BSkyB -- Channel 4 +1 (running)
0x0000 0x207a: pmt_pid 0x0107 BSkyB -- Channel 4 +1 (running)
0x0000 0x207b: pmt_pid 0x0108 BSkyB -- Channel 4 +1 (running, scrambled)
0x0000 0x207c: pmt_pid 0x010a BSkyB -- Channel 4 +1 (running)
0x0000 0x2094: pmt_pid 0x010c BSkyB -- More4 (running)
0x0000 0x20c5: pmt_pid 0x0106 BSkyB -- 8389 (running, scrambled)
0x0000 0x23f7: pmt_pid 0x0104 BSkyB -- c4 l +1 (running)
0x0000 0x23f8: pmt_pid 0x0109 BSkyB -- e4 (running)
********

switch 2 (astra 19E)
********
scan -s 2 /home/servidor/.kde/share/apps/kaffeine/dvb-s/Astra-19.2E
>>> tune to: 10788:v:2:22000
0x0000 0x283d: pmt_pid 0x0100 BSkyB -- BBC 1 W Mids (running)
0x0000 0x283e: pmt_pid 0x0101 BSkyB -- BBC 1 N West (running)
0x0000 0x283f: pmt_pid 0x0102 BSkyB -- BBC 1 Yrks&Lin (running)
0x0000 0x2840: pmt_pid 0x0103 BSkyB -- BBC 1 Yorks (running)
0x0000 0x2841: pmt_pid 0x0104 BSkyB -- BBC 1 E Mids (running)
0x0000 0x2842: pmt_pid 0x0105 BSkyB -- BBC 1 East (E) (running)
0x0000 0x2851: pmt_pid 0x0106 BSkyB -- ETV5 (running)
********

And this is the problem!!! on Astra-19.2 there's no "BBC 1 W Mids". It's
getting signal from switch 1 and scanning from the correct transponders
list on  /home/servidor/.kde/share/apps/kaffeine/dvb-s/Astra-19.2E

And it doesn't matter if i run "scan -s 1" or "scan -s 2" or "scan -s
3", it will always scan from "switch 1"

through kaffeine i get to the same point, i get a scan on swith 1 only.

is this a bug? has anyone experienced this? is there a warkaround for
this? how could i get it working in the first place?
what could i break by upgrading the system?

Please, let me know if i can provide any further information.

here are my system details:

********
# lsb_release -rd

Description:    Ubuntu 8.04.1
Release:        8.04
**********

i've looked through the system logs and i can't find anything, nothing
related to diseqc or kaffeine, there seem to be no errors with those words.

Thanks.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
