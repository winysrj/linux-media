Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KebKJ-0003so-ST
	for linux-dvb@linuxtv.org; Sat, 13 Sep 2008 22:02:41 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K75008X2GZG65E0@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sat, 13 Sep 2008 16:02:04 -0400 (EDT)
Date: Sat, 13 Sep 2008 16:02:04 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <alpine.LRH.1.10.0809121112350.29931@pub3.ifh.de>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Message-id: <48CC1C3C.6020701@linuxtv.org>
MIME-version: 1.0
References: <48CA0355.6080903@linuxtv.org>
	<alpine.LRH.1.10.0809121112350.29931@pub3.ifh.de>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] S2API - Status  - Thu Sep 11th
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

Patrick Boettcher wrote:
> Hi Steve,
> 
> On Fri, 12 Sep 2008, Steven Toth wrote:
>> Patrick, I haven't looked at your 1.7MHz bandwidth suggestion - I'm open
>> to ideas on how you think we should do this. Take a look at todays
>> linux/dvb/frontend.h and see if these updates help, or whether you need
>> more changes.
> 
> I attached a patch which adds a DTV_BANDWIDTH_HZ command. That's all. I 
> would like to have the option to pass any bandwidth I want to the frontend.
> 

...

> 
> Sorry for not integrating this into the frontend_cache yet. But I'm 
> really out of time (at work and even at home, working on cx24120) and I 
> will not be able to supply the DiBcom ISDB-T demod-driver (which would 
> use all that) right now.

Great, thanks, I Merged with minor cleanup of comments.

We should discuss the ISDB specifics at plumbers. The LAYER commands are 
not currently implemented and it would be good to understand atleast two 
different demodulators so we can abstract their controls into an API - 
and avoid any device specifics.

Changes to tune.c (v0.0.6) on steventoth.net/linux/s2

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
