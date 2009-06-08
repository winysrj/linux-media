Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n58H0xqe020065
	for <video4linux-list@redhat.com>; Mon, 8 Jun 2009 13:00:59 -0400
Received: from smtp.nexicom.net (smtp.nexicom.net [216.168.96.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n58H0ima004862
	for <video4linux-list@redhat.com>; Mon, 8 Jun 2009 13:00:44 -0400
Received: from gw.lockie.ca (dyn-dsl-mb-76-75-91-197.nexicom.net
	[76.75.91.197])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id n58H0hGT019954
	for <video4linux-list@redhat.com>; Mon, 8 Jun 2009 13:00:43 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by gw.lockie.ca (Postfix) with ESMTP id 1767E18AD3
	for <video4linux-list@redhat.com>; Mon,  8 Jun 2009 13:00:42 -0400 (EDT)
Message-ID: <4A2D439E.4080209@lockie.ca>
Date: Mon, 08 Jun 2009 13:00:14 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: Video 4 Linux Mailing List <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: who  to ask (wireless mouse and ov511 driver)
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

My wireless mouse gets jerky (or freezes)  when I plug in my USB webcam.

usb 2-6: Product: USB Receiver
usb 2-6: Manufacturer: Logitech
usb 2-6: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:02.0/usb2/2-6/2-6:1.0/input/input0
logitech 0003:046D:C517.0001: input,hidraw0: USB HID v1.10 Keyboard 
[Logitech USB Receiver] on usb-0000:00:02.0-6/input0
logitech 0003:046D:C517.0002: fixing up Logitech keyboard report descriptor
input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:02.0/usb2/2-6/2-6:1.1/input/input1
logitech 0003:046D:C517.0002: input,hiddev96,hidraw1: USB HID v1.10 
Mouse [Logitech USB Receiver] on usb-0000:00:02.0-6/input1

ov511 2-1:1.0: USB OV511+ video device found
usb 2-1: model: Creative Labs WebCam 3
usb 2-1: Sensor is an OV7620

The webcam  worked fine with a regular USB mouse and keyboard.
Who should I talk to?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
