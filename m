Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36680 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab2FVFIO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 01:08:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Shw6O-0002bq-0W
	for linux-media@vger.kernel.org; Fri, 22 Jun 2012 07:08:12 +0200
Received: from aant209.neoplus.adsl.tpnet.pl ([83.5.101.209])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 07:08:11 +0200
Received: from acc.for.news by aant209.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 07:08:11 +0200
To: linux-media@vger.kernel.org
From: Marx <acc.for.news@gmail.com>
Subject: Re: How to make bug report
Date: Fri, 22 Jun 2012 07:03:01 +0200
Message-ID: <5tadb9-l68.ln1@wuwek.kopernik.gliwice.pl>
References: <p4v2b9-nd7.ln1@wuwek.kopernik.gliwice.pl> <4FE1FD7B.4050108@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4FE1FD7B.4050108@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 2012-06-20 18:42, Antti Palosaari pisze:
> As author of the AF9015 I would like to see some of those errors. And
> your driver version. Use latest v4l-dvb if possible as I have changed it
> very much recently.
>
I was viewing/recording EURO match an everything was ok. I've scanned 
channels with w_scan, I was able to switch to every channel without any 
problem for a few hour. Today stick has switched off (LED doesn't light) 
and in log there are such errors:

Jun 22 01:22:09 wuwek kernel: [18522.492454] af9015: recv bulk message 
failed:-110
Jun 22 01:22:09 wuwek kernel: [18522.492490] af9015: af9015_rc_query: 
failed:-1
Jun 22 01:22:09 wuwek kernel: [18522.492509] dvb-usb: error -1 while 
querying for an remote control event.
Jun 22 03:43:51 wuwek kernel: [27010.597986] af9015: recv bulk message 
failed:-110
Jun 22 03:43:51 wuwek kernel: [27010.598021] af9015: af9015_rc_query: 
failed:-1
Jun 22 03:43:51 wuwek kernel: [27010.598040] dvb-usb: error -1 while 
querying for an remote control event.
Jun 22 04:14:05 wuwek kernel: [28821.371758] af9015: recv bulk message 
failed:-110
Jun 22 04:14:05 wuwek kernel: [28821.371794] af9015: af9015_rc_query: 
failed:-1
Jun 22 04:14:05 wuwek kernel: [28821.371813] dvb-usb: error -1 while 
querying for an remote control event.

Now if I try to play and channel - it doesn't work and there is nothing 
in kern.log

 From the user.log: VDR was querying card all the time but suddenly at 
00:38 it lost lock.

Jun 22 00:00:25 wuwek vdr: [7018] streamdev-server: closing VTP 
connection to 127.0.0.1:57560
Jun 22 00:04:54 wuwek vdr: [7009] cleaning up schedules data
Jun 22 00:05:25 wuwek vdr: [7018] Streamdev: Accepted new client (VTP) 
127.0.0.1:57561
Jun 22 00:05:26 wuwek vdr: [7018] streamdev-server: closing VTP 
connection to 127.0.0.1:57561
Jun 22 00:05:31 wuwek vdr: [7018] Streamdev: Accepted new client (VTP) 
127.0.0.1:57562
Jun 22 00:05:31 wuwek vdr: [7018] streamdev-server: closing VTP 
connection to 127.0.0.1:57562
Jun 22 00:10:26 wuwek vdr: [7018] Streamdev: Accepted new client (VTP) 
127.0.0.1:57567
Jun 22 00:10:26 wuwek vdr: [7018] streamdev-server: closing VTP 
connection to 127.0.0.1:57567
Jun 22 00:15:26 wuwek vdr: [7018] Streamdev: Accepted new client (VTP) 
127.0.0.1:57569
Jun 22 00:15:26 wuwek vdr: [7018] streamdev-server: closing VTP 
connection to 127.0.0.1:57569
Jun 22 00:15:31 wuwek vdr: [7018] Streamdev: Accepted new client (VTP) 
127.0.0.1:57570
Jun 22 00:15:31 wuwek vdr: [7018] streamdev-server: closing VTP 
connection to 127.0.0.1:57570
Jun 22 00:16:00 wuwek vdr: [7019] EPGSearch: search timer update started
Jun 22 00:16:00 wuwek vdr: [7019] EPGSearch: search timer update finished
Jun 22 00:16:00 wuwek vdr: [7020] EPGSearch: timer conflict check started
Jun 22 00:16:00 wuwek vdr: [7020] EPGSearch: timer conflict check finished
Jun 22 00:20:26 wuwek vdr: [7018] Streamdev: Accepted new client (VTP) 
127.0.0.1:57572
Jun 22 00:20:27 wuwek vdr: [7018] streamdev-server: closing VTP 
connection to 127.0.0.1:57572
Jun 22 00:25:27 wuwek vdr: [7018] Streamdev: Accepted new client (VTP) 
127.0.0.1:57573
Jun 22 00:25:27 wuwek vdr: [7018] streamdev-server: closing VTP 
connection to 127.0.0.1:57573
Jun 22 00:25:32 wuwek vdr: [7018] Streamdev: Accepted new client (VTP) 
127.0.0.1:57574
Jun 22 00:25:32 wuwek vdr: [7018] streamdev-server: closing VTP 
connection to 127.0.0.1:57574
Jun 22 00:30:27 wuwek vdr: [7018] Streamdev: Accepted new client (VTP) 
127.0.0.1:57575
Jun 22 00:30:27 wuwek vdr: [7018] streamdev-server: closing VTP 
connection to 127.0.0.1:57575
Jun 22 00:35:27 wuwek vdr: [7018] Streamdev: Accepted new client (VTP) 
127.0.0.1:57577
Jun 22 00:35:28 wuwek vdr: [7018] streamdev-server: closing VTP 
connection to 127.0.0.1:57577
Jun 22 00:38:37 wuwek vdr: [7014] frontend 1/0 lost lock on channel 1, 
tp 177
Jun 22 00:38:39 wuwek vdr: [7014] frontend 1/0 timed out while tuning to 
channel 1, tp 177
Jun 22 00:39:07 wuwek vdr: [7014] frontend 1/0 timed out while tuning to 
channel 9, tp 184
Jun 22 00:39:33 wuwek vdr: [7014] frontend 1/0 timed out while tuning to 
channel 1, tp 177
Jun 22 00:39:59 wuwek vdr: [7014] frontend 1/0 timed out while tuning to 
channel 9, tp 184
Jun 22 00:40:25 wuwek vdr: [7014] frontend 1/0 timed out while tuning to 
channel 1, tp 177
Jun 22 00:40:28 wuwek vdr: [7018] Streamdev: Accepted new client (VTP) 
127.0.0.1:57578
Jun 22 00:40:28 wuwek vdr: [7018] streamdev-server: closing VTP 
connection to 127.0.0.1:57578
Jun 22 00:40:51 wuwek vdr: [7014] frontend 1/0 timed out while tuning to 
channel 9, tp 184
Jun 22 00:41:17 wuwek vdr: [7014] frontend 1/0 timed out while tuning to 
channel 1, tp 177
Jun 22 00:41:43 wuwek vdr: [7014] frontend 1/0 timed out while tuning to 
channel 9, tp 184
Jun 22 00:42:09 wuwek vdr: [7014] frontend 1/0 timed out while tuning to 
channel 1, tp 177

Above messages reapets till now.

Reinsterting tuner and restarting VDR will help but after some time it 
will stop working again.
Marx

