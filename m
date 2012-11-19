Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-14.websupport.sk ([37.9.172.143]:33215 "EHLO
	mailout-14.websupport.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2KSP4k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 10:56:40 -0500
Received: from lb1.websupport.sk (localhost [127.0.0.1])
	by smtp-cf.websupport.sk (Postfix) with ESMTP id 1A71D1004B88
	for <linux-media@vger.kernel.org>; Mon, 19 Nov 2012 16:47:04 +0100 (CET)
Received: from [192.168.1.217] (dsl-static-135.212-5-193.telecom.sk [212.5.193.135])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: topolsky@maindata.sk)
	by mail1.websupport.sk (Postfix) with ESMTPSA
	for <linux-media@vger.kernel.org>; Mon, 19 Nov 2012 16:47:03 +0100 (CET)
Message-ID: <50AA54BB.1010107@maindata.sk>
Date: Mon, 19 Nov 2012 16:48:11 +0100
From: Ondrej Topolsky <topolsky@maindata.sk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: dvbnet error
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear linuxtv developer-s

I am trying (it is now couple of days - of no avail) to create interface 
with dvbnet utility for decoding IP with MPE (tested with DVB-H signal 
containing IP packets). I run:
dvbnet -a 0 -p 1002
gives me this output:
Error: couldn't open device 0: 2 No such file or directory
But the char device /dev/dvb/adapter0/net0 is definitely there (in it's 
default location).
For some reason dvbnet_open function in dvb-apps/lib/libdvbapi/dvbnet.c 
cannot open this device
I have search mailing(and intenet) list but I haven't found any issue 
similar to this.

Specs:

I have embedded linux set-top Skytec JOBI box which has sh4 architecture 
and 2.6.32.28_stm24_0207 kernel. It is this device: 
http://www.satmultimedia.tv/skytec-hd-jobi
as Os i have installed enigma2 linux.

I thought that maybe there isn't kernel support for MPE, but why should 
there be net0 device which was created by driver..

My attempts:

After no success with debian  .deb packege of dvb-apps for sh4 
(installed with ipkg ),
I cross-compiled dvb-apps staticaly(from mercurial repository).
Eeverything works: szap, scan.. dvbsnoop. I can tune to signal, zap 
channels, sniff traffic with dvbtraffic, but dvbnet is giving me that 
"no such file.." error.

I have other machine which is running debian and is receiving same 
signal as is STB and I successfuly received IP from MPE (tested with 
tcpdump) on that other machine with no problem.

I noticed that in /sys/class/dvb/ there is no dvb0.net0 folder (but i am 
not exactly sure what is /sys/class/dvb folder used for).

Another wierd thing is that when I run dvbnet -h it segfaults and when I 
run /usr/bin/dvbnet -h it works (its definitely the same binary - with 
my debug messages).

Questions:
Can You please tell me why dvbnet cannot open this net0 device - or what 
should I do to find out?
Maybe it is used by some process, but i killed TV interface enigma2 
before trying anything(init 3, init 4 - it is not longer displayed in ps).
And can You please tell me how to detect if my kernel/driver has MPE 
support (there is no /proc/kallsyms file on STB) - maybe some C code.
Finaly I was trying to find some info about MPE but there seem to be 
very little on internet.
I would be grateful for any informations or links..

All the best

Ondrej Topolsky
Programmer at Maindata inc. Slovakia






