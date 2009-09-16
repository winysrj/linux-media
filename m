Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8GHjMaa009622
	for <video4linux-list@redhat.com>; Wed, 16 Sep 2009 13:45:22 -0400
Received: from relay2.ptmail.sapo.pt (relay1.ptmail.sapo.pt [212.55.154.21])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n8GHjAgL013018
	for <video4linux-list@redhat.com>; Wed, 16 Sep 2009 13:45:11 -0400
Received: from unknown (HELO [10.231.11.40])
	(paulojlfreitas@sapo.pt@[193.136.205.253])
	(envelope-sender <paulojlfreitas@sapo.pt>)
	by mta14 (qmail-ldap-1.03) with AES256-SHA encrypted SMTP
	for <video4linux-list@redhat.com>; 16 Sep 2009 17:03:20 -0000
From: Paulo Freitas <paulojlfreitas@sapo.pt>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Wed, 16 Sep 2009 18:08:12 +0100
Message-Id: <1253120892.3669.11.camel@paulo-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Create a /dev/video0 file and write directly into it images
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

Hi everyone,

I have an Ethernet Camera, from Prosilica, and I need to somehow emulate
this camera in a /dev/video0 file. My idea is, mount a driver file using
'makedev', pick up images from the camera and write them into
the /dev/video0 file. You know how V4L can be used to write images
in /dev/video files? I don't know if it is needed to use makedev
probably not. Any suggestion is welcome.

Thank you for your help.
Best regards, Paulo Freitas.



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
