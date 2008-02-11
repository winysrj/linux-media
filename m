Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1BL4Dwa002810
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 16:04:13 -0500
Received: from smtp3.versatel.nl (smtp3.versatel.nl [62.58.50.90])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1BL3qxs021554
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 16:03:52 -0500
Message-ID: <20080211220338.6vld5hfrfbk8gs8w@webmail.versatel.nl>
Date: Mon, 11 Feb 2008 22:03:38 +0100
From: hansfong@zonnet.nl
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Subject: bttv driver freezes my machine
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

I'm running a Debian Etch webserver with a Pinnacle PCTV Pro TV card 
which I use to pull in images from an old CCTV cam. It works, but the 
server freezes randomly and after checking all the logs the only 
culprit I can find is the bttv driver. This is in /var/log/messages....

Feb 11 04:56:21 neo kernel: bttv0: timeout: drop=691 
irq=2065488/2065488, risc=070af03c, bits: HSYNC OFLOW
Feb 11 04:59:52 neo kernel: bttv0: reset, reinitialize

When the bttv driver resets and reinitializes there is no problem, but 
for some reason this doesn't always happen and the server freezes.

Feb 11 08:39:35 neo kernel: bttv0: timeout: drop=887 
irq=2800261/2800261, risc=070af03c, bits: HSYNC OFLOW
Feb 11 18:56:51 neo syslogd 1.4.1#18: restart.

Can anyone tell me what is exactly going on here and if there is a 
solution to this problem? I'm not only thinking of software/driver 
solutions, but also other hardware options. Thanks for the help.

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
