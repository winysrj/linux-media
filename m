Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8SFfo27015634
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 11:41:51 -0400
Received: from mxb01.ya.com (mxb01.ya.com [62.151.11.208])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8SFeqxH023602
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 11:41:19 -0400
Received: from [89.129.167.125] (helo=[192.168.1.9])
	by mxb01.ya.com with esmtpa (Exim 4.68)
	(envelope-from <afarguell@ya.com>) id 1KjyO6-0005vr-SQ
	for video4linux-list@redhat.com; Sun, 28 Sep 2008 17:40:48 +0200
Message-ID: <48DFA5F7.8000807@ya.com>
Date: Sun, 28 Sep 2008 17:42:47 +0200
From: Albert Farguell <afarguell@ya.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Pinnacle PCTV Sat Pro PCI.
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

I can't get this card working. Did someone find the way to achieve it?
This is what I get with /sbin/lspci, using OpenSUSE 10.3

01:00.0 Multimedia controller: Pinnacle Systems Inc. Royal TS Function 1
        Subsystem: Pinnacle Systems Inc. Unknown device 0048
        Flags: bus master, medium devsel, latency 64, IRQ 11
        Memory at f9ffd000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>

01:00.2 Multimedia controller: Pinnacle Systems Inc. Royal TS Function 3
        Subsystem: Pinnacle Systems Inc. Unknown device 0048
        Flags: bus master, medium devsel, latency 64, IRQ 11
        Memory at f9ffe000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>

Thank you in advance,
Albert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
