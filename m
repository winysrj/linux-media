Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBDMx8Uv010532
	for <video4linux-list@redhat.com>; Sat, 13 Dec 2008 17:59:08 -0500
Received: from smtp-out26.alice.it (smtp-out26.alice.it [85.33.2.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBDMwsdu019479
	for <video4linux-list@redhat.com>; Sat, 13 Dec 2008 17:58:54 -0500
Message-Id: <20081213225653.943975535@studenti.unina.it>
Date: Sat, 13 Dec 2008 23:56:53 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Cc: 
Subject: [PATCH 0/2] ov534: fix typo + show sensor ID
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

Hi,

printing the sensor ID can useful to find out different sensors attached
to ov534. I know that, as it is now, it is not going to work always
because different sensors may be on different i2c slave address, but it
will serve as a base for some ad-hoc debugging code.

Regards,
   Antonio Ospite
-- 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
