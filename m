Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3FH9L0x029053
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 13:09:21 -0400
Received: from mail-ew0-f170.google.com (mail-ew0-f170.google.com
	[209.85.219.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3FH94To027266
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 13:09:04 -0400
Received: by ewy18 with SMTP id 18so3074122ewy.3
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 10:09:03 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 15 Apr 2009 19:09:03 +0200
Message-ID: <b01190d0904151009q3788f96ek1aa86e160e60398a@mail.gmail.com>
From: ben pezzei <ben.pezzei@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Progress on the Twinhan vp1034 CI?
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

Hello

I am wondering if there will be a release for a working CI Module for
this dvb-s card any time soon?

I tried the most different Sources from
http://jusst.de/hg/mantis-v4l
http://jusst.de/hg/mantis
and
http://mercurial.intuxication.org/hg/s2-liplianin

but none was really working (tuning was fine though). At least the Sources
from http://mercurial.intuxication.org/hg/s2-liplianin came up with a
log-Message
that a cam was detected.

Has anyone got a running/working CAM within this card?

lsipci -vnn
03:09.0 Multimedia controller [0480]: Twinhan Technology Co. Ltd
Mantis DTV PCI Bridge Controller [Ver 1.0] [1822:4e35] (rev 01)
        Subsystem: Twinhan Technology Co. Ltd Device [1822:0014]
        Flags: bus master, medium devsel, latency 64, IRQ 17
        Memory at fdaff000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis

Since I spend many hours to configure this (latest mythbuntu) I
meanwhile am willing to swap to
another card. Are there any recommandations for a dbv-s pci card with
CI which is working
out of the box?

tnx alot

greetings

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
