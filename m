Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4DHsjHH015289
	for <video4linux-list@redhat.com>; Wed, 13 May 2009 13:54:45 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n4DHsU8j011970
	for <video4linux-list@redhat.com>; Wed, 13 May 2009 13:54:30 -0400
Received: by fg-out-1718.google.com with SMTP id e12so248636fga.7
	for <video4linux-list@redhat.com>; Wed, 13 May 2009 10:54:30 -0700 (PDT)
Message-ID: <4A0B08B1.5020700@gmail.com>
Date: Wed, 13 May 2009 20:51:45 +0300
From: mahmut <m.gundes@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: philips webcam and V4L2
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

    I want to capture video from my philips web cam. I can do this with 
xawtv or camstream. My aim is capturing with my own application by using 
v4l2. I need to know just sequence of this capturing way and a simple 
small example to cover how v4l2 is being used. There is an example 
capture.c but I couldnt use it because of unsupporting IOCTL error. I 
use pwc driver. May you have a simle example of capturing image or 
video? Thank you very much.

Mahmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
