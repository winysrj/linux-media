Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5EAuNNU022058
	for <video4linux-list@redhat.com>; Sat, 14 Jun 2008 06:56:23 -0400
Received: from mailmxout.mailmx.agnat.pl (mailmxout.mailmx.agnat.pl
	[193.239.44.238])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5EAuA0A027275
	for <video4linux-list@redhat.com>; Sat, 14 Jun 2008 06:56:11 -0400
Received: from smtp.agnat.pl ([193.239.44.82])
	by mailmxout.mailmx.agnat.pl with esmtp (Exim 4.69)
	(envelope-from <admin@satland.com.pl>) id 1K7TQX-000299-Od
	for video4linux-list@redhat.com; Sat, 14 Jun 2008 12:56:09 +0200
Received: from [79.187.82.59] (helo=[192.168.0.2])
	by smtp.agnat.pl with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.67) (envelope-from <admin@satland.com.pl>)
	id 1K7TQX-0008H4-Ik
	for video4linux-list@redhat.com; Sat, 14 Jun 2008 12:56:09 +0200
Message-ID: <4853745E.6000805@satland.com.pl>
Date: Sat, 14 Jun 2008 09:33:50 +0200
From: =?ISO-8859-2?Q?=A3ukasz_=A3ukoj=E6?= <admin@satland.com.pl>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Subject: multiple saa7130 chipsets problem
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


Hi

I'm using 8 x saa7130hl chipset  based surveillance card and recently 
bought another one.
Just wanted to achieve 16 channels for cams recording.
Problem is that saa7134 module will only see eight integrals of card 
array 'card=x,x,x,x,x,x,x,x' and while i'm putting 
'card=x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x' - dmesg will print 

card: can only take 8 arguments
saa734: '69' invalid for parameter 'card'

Modprobing with 'only' eight parameters will result that saa714 will be 
try to autodetect chipsets, which is appraently ends with hang errors.
Is there a siple hack to ovverride this behaviour ?

Lucas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
