Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m394og7l027931
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 00:50:42 -0400
Received: from smtp.nexicom.net (smtp1.nexicom.net [216.168.96.23])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m394oU4i017779
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 00:50:31 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-121-43.nexicom.net
	[216.168.121.43])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id m395pKp6014669
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 01:51:21 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 8FA0DCA986
	for <video4linux-list@redhat.com>; Wed,  9 Apr 2008 00:50:28 -0400 (EDT)
Message-ID: <47FC4B14.50703@lockie.ca>
Date: Wed, 09 Apr 2008 00:50:28 -0400
From: James Lockie <bjlockie@lockie.ca>
MIME-Version: 1.0
To: Video 4 Linux Mailing List <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: one speaker only
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

I have an Hauppauge WinTV GO-Plus.
It has mono audio and I expected it to out the same signal to both L&R 
speaker but it only outputs to the L speaker.
I use tvtime.
The sound outputs to both speakers in Windows so it is a Linux problem.


tveeprom 0-0050: Hauppauge model 44981, rev E1B2, serial# 10428076
tveeprom 0-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
tveeprom 0-0050: audio processor is None (idx 0)
tveeprom 0-0050: decoder processor is BT878 (idx 14)
tveeprom 0-0050: has no radio, has IR receiver, has IR transmitter
bttv0: Hauppauge eeprom indicates model#44981

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
