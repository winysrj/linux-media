Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1I5CfVo018581
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 00:12:41 -0500
Received: from qb-out-0506.google.com (qb-out-0506.google.com [72.14.204.234])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1I5CV7o032182
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 00:12:31 -0500
Received: by qb-out-0506.google.com with SMTP id o21so2756664qba.7
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 21:12:31 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 18 Feb 2009 05:12:30 +0000
Message-ID: <83b2c1480902172112p6fb23235w53d9bb750e8bc8cb@mail.gmail.com>
From: Sumanth V <sumanth.v@allaboutif.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: setting up dvb-s card
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

Hi All,

      i am trying to set up a dvb-s card on my system. when i do lspci -v i
get this.

 00:0b.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: KNC One Unknown device 0019
        Flags: bus master, medium devsel, latency 32, IRQ 5
        Memory at ea000000 (32-bit, non-prefetchable) [size=512]

i am using the kernel version 2.6.28.

How do i set up this card??

Thanks
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
