Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o68K8oUe027885
	for <video4linux-list@redhat.com>; Thu, 8 Jul 2010 16:08:50 -0400
Received: from wegener-net.de (www.uli-eichhorn.de [145.253.158.94])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o68K8bgO024454
	for <video4linux-list@redhat.com>; Thu, 8 Jul 2010 16:08:38 -0400
Received: from localhost (localhost [127.0.0.1])
	by wegener-net.de (Postfix) with ESMTP id 4B9D24713
	for <video4linux-list@redhat.com>;
	Thu,  8 Jul 2010 22:54:24 +0200 (CEST)
Received: from wegener-net.de ([127.0.0.1])
	by localhost (linux-shhd.site [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V2ARoacWaKpH for <video4linux-list@redhat.com>;
	Thu,  8 Jul 2010 22:54:23 +0200 (CEST)
Received: from www.wegener-net.de (localhost [127.0.0.1])
	by wegener-net.de (Postfix) with ESMTP id 8C87C441D
	for <video4linux-list@redhat.com>;
	Thu,  8 Jul 2010 22:54:23 +0200 (CEST)
Message-ID: <c1892bff73376fe4888d83d4da91eeed.squirrel@www.wegener-net.de>
Date: Thu, 8 Jul 2010 22:54:23 +0200
Subject: 1b80:d393 Afatech supported?
From: "Norbert Wegener" <nw@wegener-net.de>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Reply-To: nw@wegener-net.de
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I got a Conceptronics usb dvb-t stick. lsusb displays it as:
...
Bus 001 Device 007: ID 1b80:d393 Afatech
...
When insterting it /var/log/messages shows:
Jul  8 22:05:24 norbert-laptop kernel: [40109.230106] usb 1-1: new high
speed USB device using ehci_hcd and address 9
Jul  8 22:05:24 norbert-laptop kernel: [40109.390630] usb 1-1:
configuration #1 chosen from 1 choice

but no dvb driver is loaded.
Is this stick supposed to work under a current distribution as Ubuntu
10.04 64Bit?
Thanks
Norbert Wegener



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
