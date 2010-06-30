Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1358 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab0F3Rst (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 13:48:49 -0400
Date: Wed, 30 Jun 2010 19:48:45 +0200 (CEST)
From: Hans Houwaard <hans@ginder.xs4all.nl>
To: linux-media@vger.kernel.org, mo ucina <mo.ucina@gmail.com>
Message-ID: <20081599.48.1277920125030.JavaMail.root@ginder>
In-Reply-To: <4C2B33B6.90408@gmail.com>
Subject: Re: [linux-dvb] TeVii S470 in mythtv  - diseqc problems
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I had the same issue, I have a combination of Hauppauge and Tevii card. The problems arrise when the order of loading of the cards differ from the order of card installed in MythTV. I have added module options to get the modules to use the same /dev/dvb device on boot.

Hope this helps for you,

Hans 

----- Oorspronkelijk bericht -----
Van: "O&M Ugarcina" <mo.ucina@gmail.com>
Aan: linux-dvb@linuxtv.org
Verzonden: Woensdag 30 juni 2010 14:08:22
Onderwerp: [linux-dvb] TeVii S470 in mythtv  - diseqc problems

Hello Guys,

Just installed a S470 into my mythbox , fedora 12 kernel 
2.6.32.14-127.fc12.i686.PAE . Myth is .23 the most recent fedora package 
, the drivers for dvb card I have at the moment were pulled in 
2010-04-01 . I assume they are pretty current . The problem that I have 
is as follows :
Most of my viewing is done on a Satellite connected to diseqc port 2 , 
and myth tunes into that with no probs at all , but occasionally I try 
to watch a channel that is on a second satellite - port 1 and here 
things fail . Myth tries to tune into the channel - then times out with 
error , during this the dvb driver crashes , and when I try to retune 
again with myth there is no lock on either satellite  . So I need to 
restart pc , then everything comes back on port 2 and myth is able to 
tune again channels within that first satellite . Any one else 
experienced diseqc issues with this card and myth ?

Second question what is the tool of choice to use to scan dvbs2 
satellites ? I tried dvbscan but it only picked up dvbs transponders , 
on dvbs2 it failed to tune . I saw that there used to be this utillity 
scan-s2 , but looks like it was abandoned a couple of years ago and has 
not been maintained since . So how do you guys do a transponder scan for 
dvbs2 ?

Best Regards

Milorad



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
