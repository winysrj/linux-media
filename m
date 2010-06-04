Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o54KhjJu007183
	for <video4linux-list@redhat.com>; Fri, 4 Jun 2010 16:43:45 -0400
Received: from mail-iw0-f174.google.com (mail-iw0-f174.google.com
	[209.85.214.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o54KhX2l014969
	for <video4linux-list@redhat.com>; Fri, 4 Jun 2010 16:43:33 -0400
Received: by iwn37 with SMTP id 37so1726159iwn.33
	for <video4linux-list@redhat.com>; Fri, 04 Jun 2010 13:43:32 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 4 Jun 2010 16:43:32 -0400
Message-ID: <AANLkTilWmUN9ZHCHs2wDoeDH5iXOFJoI5Zk53vmg8N3c@mail.gmail.com>
Subject: Pixelview prokink PlayTV USB Ultra on Fedora 9 Question
From: Osvaldo Sarubbi <osarubbi@gmail.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I have a card Pixelview Prolink PlayTV USB Ultra, model PV-A6600U1(FRT)-F.
OS: Fedora 9, 2.6.27.25-78.2.56.fc9.i686

The problem is that apparently the em28xx driver does not detect the device
and does not create / dev/video0

Any Ideas?


lsusb:
*Bus 001 Device 005: ID 1554:5018 Prolink Microsystems Corp. *
Bus 001 Device 002: ID 0409:0058 NEC Corp. HighSpeed Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 002: ID 04b3:310b IBM Corp. Red Wheel Mouse
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

dmesg:
em28xx driver loaded
usb 1-1.3: new high speed USB device using ehci_hcd and address 5
usb 1-1.3: configuration #1 chosen from 1 choice
usb 1-1.3: New USB device found, idVendor=1554, idProduct=5018
usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1.3: Product: A6600U
usb 1-1.3: Manufacturer: Conexant Corporation
usb 1-1.3: SerialNumber: CIR000000000001
usbcore: deregistering interface driver em28xx
usbcore: registered new interface driver em28xx
em28xx driver loaded














-- 
Osvaldo L. Sarubbi B.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
