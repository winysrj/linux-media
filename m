Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m735jL8k010237
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 01:45:21 -0400
Received: from QMTA09.emeryville.ca.mail.comcast.net
	(qmta09.emeryville.ca.mail.comcast.net [76.96.30.96])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m735j8Vv006645
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 01:45:08 -0400
Message-ID: <48954612.7000906@comcast.net>
Date: Sat, 02 Aug 2008 22:45:54 -0700
From: Brian Rogers <brian_rogers@comcast.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: gspca "scheduling while atomic" crash
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

I have the following device:
Bus 007 Device 002: ID 0c45:60fc Microdia PC Camera with Mic (SN9C105)

Whether I build 2.6.27-rc1 or merge the stable branch of 
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git 
into my Intrepid kernel (2.6.26), the system will lock up when I try to 
get video from my webcam.

To see the kernel output, I do this in the console:
mplayer -ao aa -tv device=v4l2:width=640:height=480:fps=30 tv://

The result is a rapid stream of two alternating messages:
BUG: scheduling while atomic: swapper/0/0x8001???? (didn't get it all)
bad: scheduling from the idle thread!

During this the system doesn't respond to anything. It's a Core2 Duo 
running 64-bit Ubuntu Intrepid with 4GB of RAM. What other info should I 
provide to investigate this problem?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
