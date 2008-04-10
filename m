Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3A5jqcT002090
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 01:45:52 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3A5jdOZ027378
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 01:45:39 -0400
From: Michael Bergmann <mbergmann-sh@gmx.de>
To: video4linux-list@redhat.com
Date: Thu, 10 Apr 2008 07:45:30 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804100745.30831.mbergmann-sh@gmx.de>
Subject: Installation guide for LeadTec WinFast tv2000 XP without FM
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

Hi List,

my WinFast tv2000 XP rev. 11 refuses to work, even if recognized by the 
Kernel. I guess it must have to do something with the receiver chip. Under 
Windows, it uses a phillips device. With Linux, I tried to install it via 
bttv. It is recognized as card 34 with tuner 5, but if I scan the channels, I 
always get a "no station". The card seems to lack a fm tuner, too.

Could somebody telll me if this is a special case of my model? Do I need to 
install some firmware first?

Thanks for any hint!

Michael

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
