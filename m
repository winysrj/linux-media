Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5UKpQFh004324
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 16:51:26 -0400
Received: from rs25s12.datacenter.cha.cantv.net
	(rs25s12.datacenter.cha.cantv.net [200.44.33.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5UKoKY5014456
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 16:50:43 -0400
From: Emilio Lazo Zaia <emiliolazozaia@gmail.com>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	video4linux-list@redhat.com
In-Reply-To: <4820BD94.90005@t-online.de>
References: <88771.83842.qm@web83107.mail.mud.yahoo.com>
	<1209512868.5699.32.camel@palomino.walls.org>
	<1209863718.546.24.camel@localhost.localdomain>
	<481E1AD3.2060304@t-online.de>
	<1210045099.21581.6.camel@localhost.localdomain>
	<4820BD94.90005@t-online.de>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 30 Jun 2008 16:20:12 -0430
Message-Id: <1214859012.20886.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: 
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

﻿Inside the adapter I see these four major chips:

SAA7135HL/203
CH7329  10
TS607372

TDA8290
SC8386
.1  01
ZPG06221

74HC4052D
AC234 08
Un60540D

8275AC1
CH8688
   04
TPG07371

Clearly first three chips are Philips. 

This cardbus module can't be autodetected, has no eeprom and still not
working to watch tv input, only radio works and seems to be swapped
Television and Composite modes because composite input can be seen in
Television mode and when Composite input is selected, TV noise is being
watched.

El mar, 06-05-2008 a las 22:20 +0200, Hartmut Hackmann escribió:

> You need to be careful but you can bend most modules open with a
> not too sharp knife. You need to start this from the far side of the
> cardbus connector.
> I did this several times.

-- 
Emilio Lazo Zaia <emiliolazozaia@gmail.com>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
