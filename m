Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9ILpxHn012539
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 17:51:59 -0400
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9ILplhH021337
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 17:51:47 -0400
Received: by ey-out-2122.google.com with SMTP id 4so364804eyf.39
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 14:51:46 -0700 (PDT)
Message-ID: <48FA5A6F.9000407@gmail.com>
Date: Sat, 18 Oct 2008 22:51:43 +0100
From: Stephen C Weston <stephencweston@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Leadtek VC100 U Video Editor device (em28xx driver)
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

Would it be at all possible to support the 'Leadtek VC100 U' video 
capture dongle. I understand the device is based on the em2861 chip set. 
The device's ID appears in lsusb as '0413:6f07 Leadtek Research, Inc.'

After doing a Google image search I have found the device looks very 
similar to the 'Yakumo MovieMixer' device. Indeed it advertises with the 
same specs and features and is bundled with the same software for 
windows. It could quite possibly be exactly the same hardware inside.

I have tried modifying the em28xx-cards.c in the v4l-dvb folder to get 
it to recognize the device as the 'Yakumo MovieMaker', but this has only 
been of limited success. The output from the 'dmesg |grep em28xx' 
command looks promising and the device registers as /dev/video0, but 
when trying to view a composite video input from the device in mplayer I 
get a distorted picture (the colour is fine, but the picture is all 
skewed, especially at the top). The composite video is in PAL-BG format. 
I also have no sound.

Any advice to enable me to fix the problem or if someone else with 
greater expertise could have go, then I would be very appreciative!!

Thank you for all your continued work.
Stephen

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
