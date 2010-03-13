Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2DHGsfP003241
	for <video4linux-list@redhat.com>; Sat, 13 Mar 2010 12:16:54 -0500
Received: from web34405.mail.mud.yahoo.com (web34405.mail.mud.yahoo.com
	[66.163.178.154])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o2DHGfqJ017858
	for <video4linux-list@redhat.com>; Sat, 13 Mar 2010 12:16:42 -0500
Message-ID: <737952.62741.qm@web34405.mail.mud.yahoo.com>
Date: Sat, 13 Mar 2010 08:50:00 -0800 (PST)
From: Muppet Man <muppetman4662@yahoo.com>
Subject: support for hauppauge wintv-hvr 950Q
To: video4linux-list@redhat.com
MIME-Version: 1.0
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

Greetings all,
I purchased a hauppauge wintv-hvr 950Q.  I downloaded and installed the lastest drivers from the v4l website.

When attempting to use with TVtime, the only "video" device I can find is my webcam.  
When running lsusb, this is what I get:

Bus 007 Device 005: ID 0a5c:4503 Broadcom Corp. 
Bus 007 Device 004: ID 0a5c:4502 Broadcom Corp. 
Bus 007 Device 003: ID 413c:8126 Dell Computer Corp. Wireless 355 Bluetooth
Bus 007 Device 002: ID 0a5c:4500 Broadcom Corp. 
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 004: ID 2040:7200 Hauppauge 
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 002: ID 05a9:2640 OmniVision Technologies, Inc. OV2640 Webcam
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

So I believe my tuner is found, but I don't know what I am doing wrong in order to use it.  Any help would be greatly appreciated.
Thanks


      
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
