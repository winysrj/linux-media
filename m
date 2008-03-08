Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m28LiVK0019311
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 16:44:31 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m28LhsWg025417
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 16:43:54 -0500
Received: by wf-out-1314.google.com with SMTP id 28so1090177wfc.6
	for <video4linux-list@redhat.com>; Sat, 08 Mar 2008 13:43:53 -0800 (PST)
Message-ID: <963eb15e0803081343l223220d3m4d34b79ec7dc7e84@mail.gmail.com>
Date: Sat, 8 Mar 2008 22:43:53 +0100
From: "Serge SMEESTERS" <sergesmeesters@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Plextor ConvertX PX-AV200U (usb digital video converter mpeg2/4)
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
(My English is not very good...)


I'm looking for easy to use analogue video with some usb device.
Asking to my local LUG malling list → no response :(
I suppose to be the first one looking for that !?. :/
Nobody to help me...
So, I bought what I found and vendor tell me "It work fine !" (on
Windows of course, should I understand)


Now, I've a nice "Plextor ConvertX PX-AV200U" usb device but not
working at all :(
http://www.plextor.be/products/px-av200u.asp?choice=ConvertX%20PX-AV200U
When I plug it, dmesg :

[ 3913.856000] usb 6-7: USB disconnect, address 5
[ 3915.636000] usb 6-7: new high speed USB device using ehci_hcd and address 6
[ 3915.768000] usb 6-7: configuration #1 chosen from 1 choice

lsusb :
Bus 006 Device 006: ID eb1a:2821 eMPIA Technology, Inc.


I've find, searching hours, some references to em28xx module...
Then, I try : modprobe em28xx && dmesg :

[ 5615.824000] Linux video capture interface: v2.00
[ 5615.828000] em28xx v4l2 driver version 0.0.1 loaded
[ 5615.828000] usbcore: registered new interface driver em28xx

But no /dev/video* item :(

dvr-qtgui → No device found

I'm using Ubuntu Gutsy with 2.6.22-14-generic kernel

Please, help me ! :)


Extra question : should the device make the mpeg2/4 compression itself ?
.. or only a/d and some v4l software make compression ?!.

Witch "modern" softwares should I use to make digital conversion with
this kind of device ?
camorama ?
dvr-qtgui ?


Thanks,
Serge.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
