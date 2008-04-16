Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3GMHxd9002083
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 18:17:59 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3GMHlT0012664
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 18:17:48 -0400
From: Michael Bergmann <mbergmann-sh@gmx.de>
To: video4linux-list@redhat.com
Date: Thu, 17 Apr 2008 00:17:40 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804170017.40892.mbergmann-sh@gmx.de>
Subject: Leadtek WinFAST TV2000 XP picture working, but no sound
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

I finally managed to bring the device to live, partially, nevertheless...
Chip is a Connexant bt878, tuner is  PA2MF52DAM made by Partsnic, working with 
a Philips driver for PAL devices.
If I load it with card=34 tuner=41, followed by modprobing 
bttv, bt878, dvb_core, dst, and dvb-bt8xx,  I'm able to scan the channels. The 
Picture is there, but audio is not! I've connected the TV 2000 directly to my 
soundcard via internal cable. Under Windows, sound works fine, but under 
Linux it refuses. 
Has anybody a Tip on how to get the sound to work?

Thanks fpr any idea,

Michael

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
