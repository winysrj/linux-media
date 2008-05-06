Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m463cd0E029485
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 23:38:39 -0400
Received: from rs26s12.datacenter.cha.cantv.net
	(rs26s12.datacenter.cha.cantv.net [200.44.33.17])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m463cRsH029747
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 23:38:27 -0400
From: Emilio Lazo Zaia <emiliolazozaia@gmail.com>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <481E1AD3.2060304@t-online.de>
References: <88771.83842.qm@web83107.mail.mud.yahoo.com>
	<1209512868.5699.32.camel@palomino.walls.org>
	<1209863718.546.24.camel@localhost.localdomain>
	<481E1AD3.2060304@t-online.de>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 05 May 2008 23:08:19 -0430
Message-Id: <1210045099.21581.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: MCE TV Philips 7135 Cardbus don't work
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

﻿﻿Hi Hartmut!

This is a Cardbus adapter, so maybe I need to break in to have a
look :-)
If this is possible without a possible physical damage, I can try!

What you say is that "no eeprom present" is not an error and can be
ignored if the correct configuration is found the hard way?

In the case of a PCI adapter, what can be deduced about the presence of
these metal box? I saw some board with and without it.

Thanks,
Regards!

El dom, 04-05-2008 a las 22:21 +0200, Hartmut Hackmann escribió:

> There are many saa713x based cards without eeprom. It stores the vendor ID and
> - in many cases - the board configuration. For you this means
> - you need to find out the configuration the hard way
>    * identify the chips on the card
>    * find the input configuration by try and error
> - You will always need to force the card type with a card=xxx option, there is
>    no way to automatically identify the card.
> 
> So please have a close look at the card and write down all chip types. Is there
> a metal box with the antenna connector on the card? What is its type?
> 
> Hartmut
-- 
Emilio Lazo Zaia <emiliolazozaia@gmail.com>

Escuela de Física
Universidad Central de Venezuela


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
