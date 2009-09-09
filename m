Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f191.google.com ([209.85.221.191])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <spongelavapaul@googlemail.com>) id 1MlIvj-0000G5-Ob
	for linux-dvb@linuxtv.org; Wed, 09 Sep 2009 10:53:32 +0200
Received: by qyk29 with SMTP id 29so3455512qyk.16
	for <linux-dvb@linuxtv.org>; Wed, 09 Sep 2009 01:52:55 -0700 (PDT)
Message-Id: <6291B5B1-250A-4AF7-A59E-75C9EEC22FCC@googlemail.com>
From: Paul Thomas <spongelavapaul@googlemail.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v936)
Date: Wed, 9 Sep 2009 09:52:52 +0100
Subject: [linux-dvb] Unable to get dvbnet working on Ubuntu 9.04
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,
I'm trying to use dvbnet to get at data from an Avermedia 771 and I'm  
not seeing any activity on the new interface. I've done just about  
everything I can find with my weak google-fu including turning off the  
default rp_filter setting. I hope someone with experience of this can  
spot an obvious mistake! I'm going to drop back to 8.04.03 to see if  
that helps.


* tzap is running. *
* dvbtraffic reports good data on the expected pids *

 > uname -a
Linux ubuntu9 2.6.28-11-server #42-Ubuntu SMP Fri Apr 17 02:48:10 UTC  
2009 i686 GNU/Linux

 > sudo dvbnet -p 0

DVB Network Interface Manager
Copyright (C) 2003, TV Files S.p.A

Status: device dvb0_0 for pid 0 created successfully.
 > sudo ifconfig dvb0_0 hw ether 00:30:1b:b7:32:31 promisc up  
192.168.145.1 netmask 255.255.255.0
 > cat /proc/sys/net/ipv4/conf/dvb0_0/rp_filter
0
 > ifconfig dvb0_0
dvb0_0    Link encap:Ethernet  HWaddr 00:30:1b:b7:32:31
           inet addr:192.168.145.1  Bcast:192.168.145.255  Mask: 
255.255.255.0
           inet6 addr: fe80::230:1bff:feb7:3231/64 Scope:Link
           UP BROADCAST RUNNING NOARP PROMISC MULTICAST  MTU:4096   
Metric:1
           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
 > sudo tcpdump -n -i dvb0_0
tcpdump: verbose output suppressed, use -v or -vv for full protocol  
decode
listening on dvb0_0, link-type EN10MB (Ethernet), capture size 96 bytes


Paul.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
