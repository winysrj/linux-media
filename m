Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m629UAaW016563
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 05:30:10 -0400
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m629TvDY018751
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 05:29:57 -0400
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 55AF2322819
	for <video4linux-list@redhat.com>;
	Wed,  2 Jul 2008 11:29:57 +0200 (CEST)
Received: from [192.168.0.13] (lns-bzn-32-82-254-38-232.adsl.proxad.net
	[82.254.38.232])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 0F7B232282B
	for <video4linux-list@redhat.com>;
	Wed,  2 Jul 2008 11:29:57 +0200 (CEST)
From: Jean-Francois Moine <moinejf@free.fr>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Date: Wed, 02 Jul 2008 11:25:10 +0200
Message-Id: <1214990710.6624.6.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PULL] gspca read() problems
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

There were bad bugs in the driver, mainly on read().

Please, pull from﻿ http://linuxtv.org/hg/~jfrancois/gspca/ for:

8163:2bbb47f61a95
gspca: read() did not work (loop in kernel, timeout...)

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
