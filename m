Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3387wdE013028
	for <video4linux-list@redhat.com>; Fri, 3 Apr 2009 04:07:58 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3387gVP018209
	for <video4linux-list@redhat.com>; Fri, 3 Apr 2009 04:07:42 -0400
Received: by fg-out-1718.google.com with SMTP id 19so448750fgg.7
	for <video4linux-list@redhat.com>; Fri, 03 Apr 2009 01:07:41 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 3 Apr 2009 10:07:41 +0200
Message-ID: <a2831f3f0904030107n6f015784p8c9814fbb84d2c84@mail.gmail.com>
From: Butrus Damaskus <butrus.butrus@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Can I use I2C on saa7134?
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

Hello!

I found that there is i2c bus on my saa7134 that I could add an
pinheader to the board and hook my own i2c chips (my motherboard
doesn't provide i2c/smbus header). Is it possible to use it under
linux? Or would it mean I would need to hack the card's driver?

(Actually I run some older kernel on that particular machine just now
and there is a registered device for the motheboard's i2c bus but not
for saa7134...)

Thank You!

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
