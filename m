Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39189 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab0F3MUb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 08:20:31 -0400
Received: by pvc7 with SMTP id 7so329750pvc.19
        for <linux-media@vger.kernel.org>; Wed, 30 Jun 2010 05:20:31 -0700 (PDT)
Message-ID: <4C2B368A.7030007@gmail.com>
Date: Wed, 30 Jun 2010 22:20:26 +1000
From: O&M Ugarcina <mo.ucina@gmail.com>
Reply-To: mo.ucina@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: TeVii S470 in mythtv - diseqc problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
