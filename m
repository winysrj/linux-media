Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o6RBH4Lj025822
	for <video4linux-list@redhat.com>; Tue, 27 Jul 2010 07:17:04 -0400
Received: from mail-px0-f174.google.com (mail-px0-f174.google.com
	[209.85.212.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6RBGtEU011054
	for <video4linux-list@redhat.com>; Tue, 27 Jul 2010 07:16:55 -0400
Received: by pxi14 with SMTP id 14so483740pxi.33
	for <video4linux-list@redhat.com>; Tue, 27 Jul 2010 04:16:55 -0700 (PDT)
Message-ID: <4C4EB91B.1080908@gmail.com>
Date: Tue, 27 Jul 2010 20:46:51 +1000
From: John Palmer <thepalm2@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: Shutdown not working
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

I submitted this as a bug to ubuntu 
(https://bugs.launchpad.net/ubuntu/+bug/609946).

I thought I would try here as this is probably more relevant


    Bug Description

I have a laptop running 10.04 server, running mythtv.

If I don't use my USB TV tuner, "sudo shutdown -P now" works as 
expected. After I use the tuner in MythTV, shutdown no longer works, 
specifically I get the line "/ will now halt", the screen goes black, 
but the power / fans etc all stay on.

The tuner is a leadtek WinFast DTV Dongle Gold.

To get it working I followed these instructions: 
http://www.linuxtv.org/wiki/index.php/Leadtek_WinFast_DTV_Dongle_Gold 
<http://www.linuxtv.org/wiki/index.php/Leadtek_WinFast_DTV_Dongle_Gold>, 
although I had to disable one the "firedtv" options in order to get the 
compile working in step 3.

john@tv:~$ lsb_release -rd
Description: Ubuntu 10.04 LTS
Release: 10.04

john@tv:~$ uname -r
2.6.32-21-server


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
