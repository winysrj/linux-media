Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2IGfJ0C026081
	for <video4linux-list@redhat.com>; Wed, 18 Mar 2009 12:41:19 -0400
Received: from mcgi27.rambler.ru (mcgi27.rambler.ru [81.19.67.86])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2IGf23M016490
	for <video4linux-list@redhat.com>; Wed, 18 Mar 2009 12:41:02 -0400
From: Main Backup <vvb.backup@rambler.ru>
To: <video4linux-list@redhat.com>
Date: Wed, 18 Mar 2009 19:41:01 +0300
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Message-Id: <1195761635.1237394461.164637724.85123@mcgi27.rambler.ru>
Subject: AverTV problem
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

 I'm terribly sorry, may be you can't help me, but I don't know whom 
should I wrote this.

 Under WindowsXP I can see channel at frequency 215.25 MHz, but under 
linux I can not.
 This channel cannot be found at automatic scan and even if I write 
correct numbers at stationlist.xml file, I can not see nothing but white 
noise at this frequency.
 It seems strange a little bit, because under Linux I can easily see 
channels at 207.00 MHz and 223.25 MHz.

 I have AverMedia 7133/7135 tuner AverTV 305/307/505/507 (information 
was taken from Windows).

 I have Fedora Core 10, x86_64.
 There are two lines in /etc/modprobe.conf:
----
options saa7134 secam=d card=102 tuner=38 i2c_scan=1
options tuner secam=d radio_range=66
----

vadim v. balashoff

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
