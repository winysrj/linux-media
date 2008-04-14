Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3E83WsP021508
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 04:03:32 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3E81sD5030864
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 04:01:55 -0400
Received: from [131.234.87.115] by mail.uni-paderborn.de with esmtpsa
	(TLS-1.0:DHE_RSA_AES_256_CBC_SHA:32) (Exim 4.62 cyclopia)
	id 1JlJdQ-0005ey-CD
	for video4linux-list@redhat.com; Mon, 14 Apr 2008 10:01:53 +0200
Message-ID: <48030F6F.1040007@hni.uni-paderborn.de>
Date: Mon, 14 Apr 2008 10:01:51 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Subject: OmniVision OV9655 camera chip via soc-camera interface
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

I'm writing a driver for the OmniVision OV9655 camera chip connected to 
a PXA270 processor. I based my work on the soc_camera interface, but I 
need some additional gpios for reset and power_enable. What is the best 
way to pass this information to the driver?

Thanks
    Stefan

-- 
Dipl.-Ing. Stefan Herbrechtsmeier

Heinz Nixdorf Institute
University of Paderborn 
System and Circuit Technology 
Fürstenallee 11
D-33102 Paderborn (Germany)

office : F0.415
phone  : + 49 5251 - 60 6342
fax    : + 49 5251 - 60 6351

mailto : hbmeier@hni.upb.de

www    : http://wwwhni.upb.de/sct/mitarbeiter/hbmeier


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
