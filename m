Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6V1b55J032237
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 21:37:05 -0400
Received: from QMTA09.emeryville.ca.mail.comcast.net
	(qmta09.emeryville.ca.mail.comcast.net [76.96.30.96])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6V1a6k9016136
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 21:36:53 -0400
Message-ID: <4891108C.9020008@comcast.net>
Date: Wed, 30 Jul 2008 21:08:28 -0400
From: Harry Devine <lifter89@comcast.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Problem with v4l in MythTV
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

Hello everyone.  I'm new to this list (it's my first post), so I hope 
this hasn't been covered already.  I'm running Fedora 8 x64 and MythTV 
0.21 (fixes branch).  I have a pcHD5500 capture card and have it 
configured for the 2 available portions: analog and digital (analog via 
v4l and digital via DVB).  The digital portion works great, but the 
analog looks horrible.

When I try to tune a channel in MythTV, or watch a recording that was 
made via the analog portion, it looks very static-y and jumpy (a mix of 
snow and green lines on the right hand side) and the audio is very 
erratic.  I tried using tvtime to check the tuning, and when I tune a 
station, I get the first second or 2 of it, then it goes to an all blue 
background and a "No signal" message on it.

Any ideas on where I can start looking to resolve this?  I'm using 
kernel 2.6.24.5-85.fc8.  BTW, I see no errors in /var/log/messages, and 
I get messages similar to the following when I run dmesg:

cx88[0]:   iq f: 0x140000c0 [ write eol count=192 ]
cx88[0]:   iq 10: 0x00180c00 [ arg #1 ]
cx88[0]: fifo: 0x00180c00 -> 0x183400
cx88[0]: ctrl: 0x00180400 -> 0x180460
cx88[0]:   ptr1_reg: 0x00181a88
cx88[0]:   ptr2_reg: 0x00180478
cx88[0]:   cnt1_reg: 0x00000069
cx88[0]:   cnt2_reg: 0x00000000
cx88[0]/0: [ffff81004ccf4000/0] timeout - dma=0x5a835000


Thanks!
Harry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
