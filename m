Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx14.extmail.prod.ext.phx2.redhat.com
	[10.5.110.19])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p1AEVfc4032236
	for <video4linux-list@redhat.com>; Thu, 10 Feb 2011 09:31:41 -0500
Received: from ns.setelcom.org (ns.setelcom.org [195.230.2.69])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1AEVUoc008808
	for <video4linux-list@redhat.com>; Thu, 10 Feb 2011 09:31:30 -0500
Received: from localhost (localhost [127.0.0.1])
	by ns.setelcom.org (Postfix) with ESMTP id 2BE4D29DD4
	for <video4linux-list@redhat.com>; Thu, 10 Feb 2011 16:31:29 +0200 (EET)
Received: from ns.setelcom.org ([127.0.0.1])
	by localhost (ns.setelcom.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AHiu3CnZpJya for <video4linux-list@redhat.com>;
	Thu, 10 Feb 2011 16:31:28 +0200 (EET)
Received: from [192.168.16.226] (setelcom.gcn.bg [93.155.252.130])
	by ns.setelcom.org (Postfix) with ESMTP id B05C829DD3
	for <video4linux-list@redhat.com>; Thu, 10 Feb 2011 16:31:28 +0200 (EET)
Message-ID: <4D53F702.6010802@setelcom.org>
Date: Thu, 10 Feb 2011 16:32:34 +0200
From: "penio@setelcom.org" <penio@setelcom.org>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: Support to TT-budget S-1500b ?
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hi!
I bought PCI card  TT-budget S-1500 from dvbshop.net, but they send me 
new modification TT-budget S-1500b. The difference is in tuner - new 
code is BSBE1-D01A. The tuner itself is STB6000, but the QPSK 
demodulator is STx0288.
The card identify itself as:
Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
     Subsystem: Technotrend Systemtechnik GmbH Unknown device 101b
Is there any plan to support this device?

Thank you,
Penio Slavchev

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
