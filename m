Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6AHPxQa009000
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 13:25:59 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6AHP5OU030899
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 13:25:13 -0400
From: Rainer Koenig <Rainer.Koenig@gmx.de>
To: video4linux-list@redhat.com
Date: Thu, 10 Jul 2008 19:24:58 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807101924.58802.Rainer.Koenig@gmx.de>
Subject: Flipping the video from webcams
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

Hello,

I've got a notebook with an integrated webcam and I got a driver (r5u870) that 
works fine with it, except that the camera images I get are all upside down. 
It seems that due to a desgin flaw the camera was assembled upside down and 
there is no easy way to turn it. So I need to rotate the picture with 
software, which practically means "flip X" and "flip Y". I even found some 
bits in the driver that look like they address this issue, but turning them 
to "1" (instead of 0) doesn't help at all. 

So I wonder: Is there a way to flip the picture that is coming from the camera 
by setting some options somewhere so that my IM client gets the picture in 
the right orientation?

TIA
Rainer
-- 
Rainer Koenig, Diplom-Informatiker (FH), Augsburg, Germany

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
