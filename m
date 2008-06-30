Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5UKiTPd030950
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 16:44:29 -0400
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5UKhkpB009536
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 16:43:46 -0400
Received: from smtp4-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp4-g19.free.fr (Postfix) with ESMTP id 090D23EA0F9
	for <video4linux-list@redhat.com>;
	Mon, 30 Jun 2008 22:43:45 +0200 (CEST)
Received: from [192.168.0.13] (lns-bzn-38-82-253-110-254.adsl.proxad.net
	[82.253.110.254])
	by smtp4-g19.free.fr (Postfix) with ESMTP id 4EBD33EA0FF
	for <video4linux-list@redhat.com>;
	Mon, 30 Jun 2008 22:43:44 +0200 (CEST)
From: Jean-Francois Moine <moinejf@free.fr>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Date: Mon, 30 Jun 2008 22:40:07 +0200
Message-Id: <1214858407.1677.27.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PULL] gspca v4l2
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

Hi Mauro,

And here it is, the gspca driver, full v4l2!

Please pull it from﻿ http://linuxtv.org/hg/~jfrancois/gspca/
	
for:

7508:f2c87fe32228    Initial release of gspca with only one driver.
7509:e1b31878bd59    Subdriver pac207 added and minor changes.
7510:ee85360b66f5    Fix protection problems in the main driver.
8014:6f27ca5b89b2    Many bug fixes, zc3xx added.
8155:915ca96f9b4a    gspca: all subdrivers
8156:4bc068802c9f    gspca: minor changes
8157:f7b6cf1bd609    merge...

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
