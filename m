Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o3E8UccA004405
	for <video4linux-list@redhat.com>; Wed, 14 Apr 2010 04:30:38 -0400
Received: from teledigit.hu (fxip-0059e.externet.hu [88.209.247.158])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o3E8UNgJ017388
	for <video4linux-list@redhat.com>; Wed, 14 Apr 2010 04:30:25 -0400
Received: from linux-x5ej.localnet ([91.82.209.142]:40592)
	by teledigit.hu with [XMail 1.25 ESMTP Server]
	id <S8E23> for <video4linux-list@redhat.com> from <kgy@teledigit.hu>;
	Wed, 14 Apr 2010 10:29:00 +0200
From: =?iso-8859-1?q?K=F6vesdi_Gy=F6rgy?= <kgy@teledigit.hu>
To: video4linux-list@redhat.com
Subject: pan/tilt/focus control on UVC webcams
Date: Wed, 14 Apr 2010 10:28:43 +0200
MIME-Version: 1.0
Message-Id: <201004141028.43935.kgy@teledigit.hu>
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

Hi,

I have a Logitech Sphere webcam on an OpenWRT machine.

I am using such webcams for my surveillance system, and it would be good to 
use the pan/tilt/focus control. (Currently it have been set using Windows.)

For the first try the VIDIOC_QUERYCTRL ioctl call is failed for all extended 
features (like V4L2_CID_PAN_ABSOLUTE).
Is it supported anyway? Is it necessary to use some additional tool or 
library?

Thanx in advance
K. Gy.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
