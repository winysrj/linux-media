Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4L0gx7Q024594
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 20:42:59 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.184])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4L0gUbT021955
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 20:42:30 -0400
Received: by ti-out-0910.google.com with SMTP id 24so1399873tim.7
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 17:42:29 -0700 (PDT)
Message-ID: <a8474bd70805201742o56ebdbb7p91655e69b4425ee4@mail.gmail.com>
Date: Wed, 21 May 2008 06:12:29 +0530
From: "renjith kumar" <renjithkumar@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Doubt on debugging method
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

Hi ,

I have a video capture card (PCI based dvr).
The driver works fine in 32 bit arch (i386).

Now I wanted to port it to 64 bit architecture.
As it is 32 bit PCI based, I have less data structure to change.

But now the driver is not receiving interrupts from the device.
(it should be 240 irqs/sec, but now getting only 2 or 3 int, totally ).
Could anybody suggest a method to debug this issue....

The request_irq register it as IRQ = 20.
Device is listed in lspci , /proc/devices with Major 244.
All these looks same as i386 wirking model.

Do I need to Use any special function/API for PCI, in 64 bit architecture?

Please advice ,

Regards,
Ren.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
