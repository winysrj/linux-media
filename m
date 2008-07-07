Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m67E7we5014648
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 10:07:58 -0400
Received: from nlpi053.prodigy.net (nlpi053.sbcis.sbc.com [207.115.36.82])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m67E7jW1005824
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 10:07:45 -0400
Message-ID: <4872232A.2090109@xnet.com>
Date: Mon, 07 Jul 2008 09:07:38 -0500
From: stuart <stuart@xnet.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Looking for support for KWorld 120 ATSC tuner card (VS-ATSC120)...
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


Hi, This the right place to post this?

Looking for support for KWorld 120 ATSC tuner...

Anyone try a Kworld PlusTV hd pci 120?

Guess the manufacturer's part number is: VS-ATSC120

Looking around, I see this K-World card is nothing close to
the ATSC 110 or 115 K-World cards.  Looking at the chips on the board (A
Conexant CX23880 Bridge Interface and Samsung S5H1409 demodulator) makes
me think I would have a better chance configuring it like a Pinnacle
PCTV HD Card (800i).  Note, I checked images of the boards and they are 
slightly different.

I found the above information here:
http://www.linuxtv.org/wiki/index.php/ATSC_PCI_Cards

However, I don't know if the Kworld card uses the same tuner chip (I 
believe it's under a metal can).  Is there a way to tell what tuner chip 
is on board w/o un-soldering the metal can?

Even if all the chips were the same, how do the drivers work across 
different boards (i.e. is the addressing the same?)?

...thanks

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
