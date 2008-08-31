Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7VIThvn024007
	for <video4linux-list@redhat.com>; Sun, 31 Aug 2008 14:29:44 -0400
Received: from smtp.agh.edu.pl (smtp.agh.edu.pl [149.156.96.16])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7VITWEl015379
	for <video4linux-list@redhat.com>; Sun, 31 Aug 2008 14:29:33 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.agh.edu.pl (Postfix) with ESMTP id BDB112F014F
	for <video4linux-list@redhat.com>;
	Sun, 31 Aug 2008 20:29:31 +0200 (CEST)
Received: from smtp.agh.edu.pl ([127.0.0.1])
	by localhost (smtp.agh.edu.pl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H3wZ5JaEarQp for <video4linux-list@redhat.com>;
	Sun, 31 Aug 2008 20:29:31 +0200 (CEST)
Received: from [192.168.195.119] (unknown [192.168.195.119])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.agh.edu.pl (Postfix) with ESMTPSA id 9BAEE2F014B
	for <video4linux-list@redhat.com>;
	Sun, 31 Aug 2008 20:29:31 +0200 (CEST)
From: Szymon Zygmunt <zigi@student.agh.edu.pl>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Sun, 31 Aug 2008 20:29:31 +0200
Message-Id: <1220207371.19937.27.camel@zigi.ds14.agh.edu.pl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: remote control
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

Hi,

I have a problem with my ir receiver in my tv card (AVerMedia TVPhone
98, card = 41). Previously I was using lirc with "avermedia98" driver
under 2.4.xx kernel and everything was fine. I have read that since
2.6.22 version, this method is deprecated, so I compiled lirc with
"devinput" (now I have 2.6.24 kernel). Next I started irrecord using
this method:
irrecord -H dev/input -d phys=pci-0000:00:0a.0/ir0
(I have this in my /proc/bus/input/devices:

I: Bus=0001 Vendor=1461 Product=0001 Version=0001
N: Name="bttv IR (card=41)"
P: Phys=pci-0000:00:0a.0/ir0
S: Sysfs=/devices/pci0000:00/0000:00:0a.0/input/input6
U: Uniq=
H: Handlers=kbd event6
B: EV=100003
B: KEY=40fc310 82140000 0 0 0 0 2048000 180 4001 9e0000 0 0 ffc

and I get nothing (actually Pres RETURN to continue...).
Has anybody had such problem? Where can I find some information to solve
the problem (mayby something similar occured on this list?)

Thansk.

-- 
Szymon Zygmunt

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
