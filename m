Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n38HJCag012673
	for <video4linux-list@redhat.com>; Wed, 8 Apr 2009 13:19:12 -0400
Received: from mail-ew0-f170.google.com (mail-ew0-f170.google.com
	[209.85.219.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n38HIrFd022484
	for <video4linux-list@redhat.com>; Wed, 8 Apr 2009 13:18:53 -0400
Received: by ewy18 with SMTP id 18so245516ewy.3
	for <video4linux-list@redhat.com>; Wed, 08 Apr 2009 10:18:53 -0700 (PDT)
MIME-Version: 1.0
From: Pirlouwi <pirlouwi@gmail.com>
Date: Wed, 8 Apr 2009 19:18:37 +0200
Message-ID: <34d8b2fe0904081018j7b91d3d1j9e03c5724264c2df@mail.gmail.com>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Belkin DVD Creator
Reply-To: pirlouwi@gmail.com
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
I would like to know if there is an existing linux support for this device:

#lsusb
Bus 001 Device 005: ID 050d:0210 Belkin Components F5U228 Hi-Speed USB 2.0
DVD Creator

#usbview
Hi-Speed USB DVD Creator
Manufacturer: BELKIN
Speed: 480Mb/s (high)
USB Version:  2.00
Device Class: 00(>ifc )
Device Subclass: 00
Device Protocol: 00
Maximum Default Endpoint Size: 64
Number of Configurations: 1
Vendor Id: 050d
Product Id: 0210
Revision Number:  0.01

Config Number: 1
    Number of Interfaces: 3
    Attributes: 80
    MaxPower Needed: 484mA

    Interface Number: 0
        Name: (none)
        Alternate Number: 0
        Class: ff(vend.)
        Sub Class: ff
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 0
            Interval: 2ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 0
            Interval: 125us

            Endpoint Address: 83
            Direction: in
            Attribute: 2
            Type: Bulk
            Max Packet Size: 512
            Interval: 0ms

    Interface Number: 0
        Name: (none)
        Alternate Number: 1
        Class: ff(vend.)
        Sub Class: ff
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 2
            Interval: 2ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 512
            Interval: 125us

            Endpoint Address: 83
            Direction: in
            Attribute: 2
            Type: Bulk
            Max Packet Size: 512
            Interval: 0ms

    Interface Number: 0
        Name: (none)
        Alternate Number: 2
        Class: ff(vend.)
        Sub Class: ff
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 2
            Interval: 2ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 1020
            Interval: 125us

            Endpoint Address: 83
            Direction: in
            Attribute: 2
            Type: Bulk
            Max Packet Size: 512
            Interval: 0ms

    Interface Number: 0
        Name: (none)
        Alternate Number: 3
        Class: ff(vend.)
        Sub Class: ff
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 2
            Interval: 2ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 1024
            Interval: 125us

            Endpoint Address: 83
            Direction: in
            Attribute: 2
            Type: Bulk
            Max Packet Size: 512
            Interval: 0ms

    Interface Number: 0
        Name: (none)
        Alternate Number: 4
        Class: ff(vend.)
        Sub Class: ff
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 2
            Interval: 2ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 2048
            Interval: 125us

            Endpoint Address: 83
            Direction: in
            Attribute: 2
            Type: Bulk
            Max Packet Size: 512
            Interval: 0ms

    Interface Number: 0
        Name: (none)
        Alternate Number: 5
        Class: ff(vend.)
        Sub Class: ff
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 2
            Interval: 2ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 3072
            Interval: 125us

            Endpoint Address: 83
            Direction: in
            Attribute: 2
            Type: Bulk
            Max Packet Size: 512
            Interval: 0ms

    Interface Number: 1
        Name: snd-usb-audio
        Alternate Number: 0
        Class: 01(audio)
        Sub Class: 01
        Protocol: 00
        Number of Endpoints: 0

    Interface Number: 2
        Name: snd-usb-audio
        Alternate Number: 0
        Class: 01(audio)
        Sub Class: 02
        Protocol: 00
        Number of Endpoints: 1

            Endpoint Address: 84
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 0
            Interval: 1ms

    Interface Number: 2
        Name: snd-usb-audio
        Alternate Number: 1
        Class: 01(audio)
        Sub Class: 02
        Protocol: 00
        Number of Endpoints: 1

            Endpoint Address: 84
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 9
            Interval: 1ms
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
