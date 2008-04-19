Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3JDxXbV014561
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 09:59:33 -0400
Received: from imo-m24.mx.aol.com (imo-m24.mx.aol.com [64.12.137.5])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3JDxJHo011826
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 09:59:19 -0400
Received: from JonLowe@aol.com
	by imo-m24.mx.aol.com (mail_out_v38_r9.3.) id e.d49.285ddf5f (34893)
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 09:59:05 -0400 (EDT)
To: video4linux-list@redhat.com
Date: Sat, 19 Apr 2008 09:59:04 -0400
MIME-Version: 1.0
From: Jon Lowe <jonlowe@aol.com>
Message-Id: <8CA703CA994FDB6-D6C-ADB@webmail-me16.sysops.aol.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Subject: [BUG] HVR-1500 Hot swap causes lockup
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


 Hope this is the right place to do this.

Hauppauge HVR-1500 Expresscard, Ubuntu 8.04, latest V4L drivers.

Removing (hotswap) this card from a ASUS F3SV laptop running Ubuntu 8.04 causes a hard lock up of the computer.? Unresponsive to any input. Requires complete shutdown of the computer and restart.? Easily repeatable.? Same card is hot swappable under Windows Vista.? 

This is critical because Expresscards are notoriously easy to dislodge in notebooks.? 


 


Jon Lowe
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
