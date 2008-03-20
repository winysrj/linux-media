Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2KBLCcN032344
	for <video4linux-list@redhat.com>; Thu, 20 Mar 2008 07:21:12 -0400
Received: from eeyore.nlsn.nu (eeyore.nlsn.nu [213.115.133.58])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2KBKba5011318
	for <video4linux-list@redhat.com>; Thu, 20 Mar 2008 07:20:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by eeyore.nlsn.nu (Postfix) with ESMTP id 14E9E1C059
	for <video4linux-list@redhat.com>; Thu, 20 Mar 2008 12:20:36 +0100 (CET)
Date: Thu, 20 Mar 2008 12:20:36 +0100 (CET)
From: dlist2@nlsn.nu
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0803201214570.4638@eeyore.nlsn.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: TT-Budget C-1501 not working
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

I just purchased a Technotrend Budget C-1501.
Im running Mythbuntu Beta, and downloaded the latest v4l drivers but it 
still fails.

lspci -v

05:04.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: Technotrend Systemtechnik GmbH Unknown device 101a
        Flags: bus master, medium devsel, latency 66, IRQ 5
        Memory at fc501000 (32-bit, non-prefetchable) [size=512]

lspci -n

05:04.0 0480: 1131:7146 (rev 01)
        Subsystem: 13c2:101a
        Flags: bus master, medium devsel, latency 66, IRQ 5
        Memory at fc501000 (32-bit, non-prefetchable) [size=512]

log says

 kernel: [   54.207308] Linux video capture  interface: v2.00
 kernel: [   54.501753] saa7146: register extension 'dvb'.
 runvdr: stopping after fatal fail (vdr: warning - cannot set dumpable: Invalid argument vdr: no primary device found - using 
first device!)

And /dev/dvb is empty of course.
Im not a kernel hacker, but if you have any hits on how to get this card 
working please let me know.

Thanks

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
