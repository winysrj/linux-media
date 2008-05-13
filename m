Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4D9L027027121
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 05:21:00 -0400
Received: from mgw-mx03.nokia.com (smtp.nokia.com [192.100.122.230])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4D9Kndo013516
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 05:20:50 -0400
Received: from esebh108.NOE.Nokia.com (esebh108.ntc.nokia.com [172.21.143.145])
	by mgw-mx03.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id
	m4D9KVgt005315
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 12:20:43 +0300
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by maxwell.research.nokia.com (Postfix) with ESMTP id 398A14674E
	for <video4linux-list@redhat.com>;
	Tue, 13 May 2008 12:20:33 +0300 (EEST)
Message-ID: <48295D60.90504@nokia.com>
Date: Tue, 13 May 2008 12:20:32 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: TCM825x: invertation of image mirroring register bits
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

The patch I'm about to send adds invertation of image mirroring register 
bits to the sensor configuration. This is useful if the sensor is 
actually mounted upside down, which is the case for example in Nokia 
N810 --- the V4L2 mirroring controls for the sensor still work properly.

-- 
Sakari Ailus
sakari.ailus@nokia.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
