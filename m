Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nAUEEgut031203
	for <video4linux-list@redhat.com>; Mon, 30 Nov 2009 09:14:42 -0500
Received: from mail-yw0-f179.google.com (mail-yw0-f179.google.com
	[209.85.211.179])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAUEEQPu012713
	for <video4linux-list@redhat.com>; Mon, 30 Nov 2009 09:14:26 -0500
Received: by ywh9 with SMTP id 9so3049120ywh.19
	for <video4linux-list@redhat.com>; Mon, 30 Nov 2009 06:14:26 -0800 (PST)
Message-ID: <4B13D33D.6030509@gmail.com>
Date: Mon, 30 Nov 2009 15:14:21 +0100
From: Ryan Raasch <ryan.raasch@gmail.com>
MIME-Version: 1.0
To: V4L-Linux <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Sensor Still capture
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

I am writing a driver for a CCD camera sensor. I have gotten the 
streaming and basic mmap functionality working. The images size in 
preview mode is 384x320 and the still size capture is 1280x960. My 
problem is when i call the STREAMOFF, the sensor needs to "warm up" 
again and before a decent image can be captured. This can take several 
seconds, which is too long.

Is there a way to change the image size (not the format btw), from one 
image frame to the next without disabling the stream? There is ample 
time to do this in our system (7 fps).

Thanks,
Ryan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
