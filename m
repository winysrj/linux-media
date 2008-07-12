Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6CMl4c2023701
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 18:47:04 -0400
Received: from fmmailgate02.web.de (fmmailgate02.web.de [217.72.192.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6CMkNiP031621
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 18:46:23 -0400
Received: from smtp06.web.de (fmsmtp06.dlan.cinetic.de [172.20.5.172])
	by fmmailgate02.web.de (Postfix) with ESMTP id DD6F2E57661C
	for <video4linux-list@redhat.com>;
	Sun, 13 Jul 2008 00:46:17 +0200 (CEST)
Received: from [217.95.177.228] (helo=[192.168.1.40])
	by smtp06.web.de with esmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.109 #226) id 1KHnr7-0001Cs-00
	for video4linux-list@redhat.com; Sun, 13 Jul 2008 00:46:17 +0200
Message-ID: <48793439.20700@web.de>
Date: Sun, 13 Jul 2008 00:46:17 +0200
From: Peter Schlaf <peter.schlaf@web.de>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: smscoreapi.c:689: error: 'uintptr_t' undeclared
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

to workaround this i edited v4l/Makefile.media and commented out

   sms1xxx-objs := smscoreapi.o smsusb.o smsdvb.o sms-cards.o

   obj-$(CONFIG_DVB_SIANO_SMS1XXX) += sms1xxx.o


after that, compiling all the other modules ended successfully.

cu

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
