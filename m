Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3EBKt34007853
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 07:20:55 -0400
Received: from mu-out-0910.google.com (mu-out-0910.google.com [209.85.134.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3EBKiC4019699
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 07:20:45 -0400
Received: by mu-out-0910.google.com with SMTP id w8so848846mue.1
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 04:20:44 -0700 (PDT)
Message-ID: <461039140804140420q1fcce3eexad090ce78e3e497e@mail.gmail.com>
Date: Mon, 14 Apr 2008 12:20:44 +0100
From: "Jaime Velasco" <jsagarribay@gmail.com>
To: "Stefan Herbrechtsmeier" <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <48030F6F.1040007@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48030F6F.1040007@hni.uni-paderborn.de>
Cc: video4linux-list@redhat.com
Subject: Re: OmniVision OV9655 camera chip via soc-camera interface
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

Hello, Stefan,

2008/4/14, Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>:
> Hi,
>
>  I'm writing a driver for the OmniVision OV9655 camera chip connected to a
> PXA270 processor. I based my work on the soc_camera interface, but I need
> some additional gpios for reset and power_enable. What is the best way to
> pass this information to the driver?
>

I don't know about soc_camera, but the stkwebcam driver has code to drive
the ov9650 sensors. I'd like to use some generic interface in it, instead of the
current code. IIRC, Mauro suggested v4l2-int-device when the driver
was submitted.
Do you think your work could be used by stkwebcam? note that I don't know much
about the syntek camera controller, and stkwebcam is a reverse
engineered driver.

Anyway, maybe the code in drivers/media/video/stk-sensor.c is useful for you, so
feel free to use it if you want.

Regards,
Jaime

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
