Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m548KFcW008203
	for <video4linux-list@redhat.com>; Wed, 4 Jun 2008 04:20:15 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m548K3ID032474
	for <video4linux-list@redhat.com>; Wed, 4 Jun 2008 04:20:03 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1K3oDy-0000G5-8d
	for video4linux-list@redhat.com; Wed, 04 Jun 2008 08:20:02 +0000
Received: from 178.121.221.87.dynamic.jazztel.es ([87.221.121.178])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 04 Jun 2008 08:20:02 +0000
Received: from svoop by 178.121.221.87.dynamic.jazztel.es with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 04 Jun 2008 08:20:02 +0000
To: video4linux-list@redhat.com
From: Sven <svoop@delirium.ch>
Date: Wed, 4 Jun 2008 07:25:14 +0000 (UTC)
Message-ID: <loom.20080604T072013-7@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: Hauppauge WinTV-HVR-1110 (saa7134) causes freezes
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

Hi

I'm using a Hauppauge WinTV-HVR-1110 (triangular shape) using saa7134 and
tda1004x modules. Unfortunately, the signal strength I get from our house
antenna to this DVB-T card is not very good on some channels which causes
"frontend lost/regained" showers in the log.

Yet what's much worse: After a while (hours to days), the amd64 box freezes.
This does not happen if I don't load the above modules.

Anybody seen this behaviour before?

-sven


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
