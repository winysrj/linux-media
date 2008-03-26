Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2Q7jNhc000423
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 03:45:23 -0400
Received: from m13-87.163.com (m13-87.163.com [220.181.13.87])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2Q7imFw019774
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 03:44:50 -0400
Date: Wed, 26 Mar 2008 15:44:42 +0800 (CST)
From: =?GBK?B?zfXL2A==?= <wangsu820@163.com>
To: video4linux-list@redhat.com
Message-ID: <3358587.1081301206517482981.JavaMail.coremail@bj163app87.163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 7bit
Subject: ask about kernel video4linux module
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

 hi guys,
 
it's my first time to email video4linux-list@redhat.com! These days i study v4l. In my opinion, I think the arch of sth is as below:
 
application
--------------
v4l api
--------------
CMOS camera driver
--------------
hardware 
 
and I have read <video4linux programming>by Alan Cox and other relative articles. I enter the linux kernel (version is 2.6.8.1) and wanna get the videodev module,unfortunately I only got videodev.h or some other .h files, also I browsed the Makefile and Kconfig files but didn't get any code of v4l! so which dir the v4l code is in? I wanna study the source code of v4l ioctls further and want to know how is the v4l core related with CMOS camera driver!
 
maybe u think my question is so stupid , but I am a newbie and hopefully get some help from you!
 
thanks again,
 
Matthew Wang!
 
 
 
 

--
Matthew Wang Email: wangsu820@163.com 
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
