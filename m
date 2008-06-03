Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m53FQiVr020420
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 11:26:44 -0400
Received: from mgw-mx06.nokia.com (smtp.nokia.com [192.100.122.233])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m53FPNes012951
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 11:25:23 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Date: Tue,  3 Jun 2008 11:25:40 -0400
Message-Id: <1212506741-17056-1-git-send-email-edubezval@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>,
	Eduardo Valentin <eduardo.valentin@indt.org.br>,
	Sakari Ailus <sakari.ailus@nokia.com>
Subject: [PATCH 0/1] Add support for TEA5761 (from linux-omap)
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

From: Eduardo Valentin <eduardo.valentin@indt.org.br>

Hi guys,

This patch is just an update from linux-omap tree.
It is a v4l2 driver which is only in linux-omap tree.
I'm just sendint it to proper repository.

It adds support for tea5761 chip.
It is a v4l2 driver which exports a radio interface.

Comments are wellcome!

Cheers,

Eduardo Valentin (1):
  Add support for tea5761 chip

 drivers/media/radio/Kconfig         |   13 +
 drivers/media/radio/Makefile        |    1 +
 drivers/media/radio/radio-tea5761.c |  516 +++++++++++++++++++++++++++++++++++
 3 files changed, 530 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/radio/radio-tea5761.c

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
