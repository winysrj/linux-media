Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5BJJMXt020645
	for <video4linux-list@redhat.com>; Thu, 11 Jun 2009 15:19:22 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n5BJJ7RY030379
	for <video4linux-list@redhat.com>; Thu, 11 Jun 2009 15:19:07 -0400
Message-ID: <4A3158F8.5090504@hhs.nl>
Date: Thu, 11 Jun 2009 21:20:24 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: James <bjlockie@lockie.ca>
References: <4A2D439E.4080209@lockie.ca>
In-Reply-To: <4A2D439E.4080209@lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Video 4 Linux Mailing List <video4linux-list@redhat.com>
Subject: Re: who  to ask (wireless mouse and ov511 driver)
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

On 06/08/2009 07:00 PM, James wrote:
> My wireless mouse gets jerky (or freezes)  when I plug in my USB webcam.
>
> usb 2-6: Product: USB Receiver
> usb 2-6: Manufacturer: Logitech
> usb 2-6: configuration #1 chosen from 1 choice
> input: Logitech USB Receiver as
> /devices/pci0000:00/0000:00:02.0/usb2/2-6/2-6:1.0/input/input0
> logitech 0003:046D:C517.0001: input,hidraw0: USB HID v1.10 Keyboard
> [Logitech USB Receiver] on usb-0000:00:02.0-6/input0
> logitech 0003:046D:C517.0002: fixing up Logitech keyboard report descriptor
> input: Logitech USB Receiver as
> /devices/pci0000:00/0000:00:02.0/usb2/2-6/2-6:1.1/input/input1
> logitech 0003:046D:C517.0002: input,hiddev96,hidraw1: USB HID v1.10
> Mouse [Logitech USB Receiver] on usb-0000:00:02.0-6/input1
>
> ov511 2-1:1.0: USB OV511+ video device found
> usb 2-1: model: Creative Labs WebCam 3
> usb 2-1: Sensor is an OV7620
>
> The webcam worked fine with a regular USB mouse and keyboard.
> Who should I talk to?

Ah, thanks that is important info. In that case I think what you are seeing
is electronic interference from the webcam. I have that exact same mode,
and I opened it up once, there are 2 crystals in there for high frequency
clocks in about the same frequency as the radio frequency used by some wireless
devices, and all the electronics in the webcam are completely unshielded (as they
are in most webcams).

So I think your options are limited to:
1 do not use a wireless mouse
2 get one of those new wireless mouses which use one of the Gigahertz bands to
   communicate
3 get a new webcam

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
