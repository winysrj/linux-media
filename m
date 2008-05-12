Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CE9dSZ031519
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 10:09:39 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4CE8qf1017055
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 10:08:52 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JvYhr-0003Aq-De
	for video4linux-list@redhat.com; Mon, 12 May 2008 14:08:47 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 14:08:47 +0000
Received: from augulis.darius by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 14:08:47 +0000
To: video4linux-list@redhat.com
From: Darius <augulis.darius@gmail.com>
Date: Mon, 12 May 2008 17:03:52 +0300
Message-ID: <g09j17$3m9$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-13; format=flowed
Content-Transfer-Encoding: 7bit
Subject: question about SoC Camera driver (Micron)
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

I have question regarding both camera drivers for mt9v022 and mt9m001.
How does attach these drivers to i2c adapter? In i2c_driver structure 
there are neither .attach_adapter nor .detach_client members. So, how 
does these drivers comunicate via i2c bus? Have I something missed...?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
