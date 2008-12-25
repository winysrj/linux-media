Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBPDhDVa012610
	for <video4linux-list@redhat.com>; Thu, 25 Dec 2008 08:43:13 -0500
Received: from mail.anno.name (baal.anno.name [92.51.131.125])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBPDgxZx022392
	for <video4linux-list@redhat.com>; Thu, 25 Dec 2008 08:42:59 -0500
Received: from [192.168.178.24] (p579C278B.dip.t-dialin.net [87.156.39.139])
	by mail.anno.name (Postfix) with ESMTPA id 02F1E22C4C244
	for <video4linux-list@redhat.com>; Thu, 25 Dec 2008 14:42:58 +0100 (CET)
Message-ID: <49538DFE.5040306@wakelift.de>
Date: Thu, 25 Dec 2008 14:43:26 +0100
From: Timo Paulssen <timo@wakelift.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <49528845.20904@wakelift.de> <1230196224.1728.10.camel@localhost>
In-Reply-To: <1230196224.1728.10.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: recording from a playstation eye
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

Jean-Francois Moine wrote:
>> I just got a Playstation Eye (yay for Jesus!), but I am struggling to
>> record anything with it.
>> My log of attempts so far:
>>     
> 	[snip]
>
> Which webcam is it, and what is the associated driver? (do
> "dmesg | tail -20" after plugging the webcam).
>
> Regards.
>   
These are the relevant parts:

[ 3899.120024] usb 1-5: new high speed USB device using ehci_hcd and
address 7
[ 3899.255246] usb 1-5: configuration #1 chosen from 1 choice
[ 3899.256076] usb 1-5: New USB device found, idVendor=1415, idProduct=2000
[ 3899.256080] usb 1-5: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[ 3899.256083] usb 1-5: Product: USB Camera-B4.04.27.1
[ 3899.256086] usb 1-5: Manufacturer: OmniVision Technologies, Inc.
[ 3899.817590] Linux video capture interface: v2.00
[ 3899.842437] gspca: main v2.4.0 registered
[ 3899.860516] gspca: probing 1415:2000
[ 3899.869056] ov534: sensor is ov7721
[ 3899.917040] ov534: frame_rate: 30
[ 3899.917212] gspca: probe ok
[ 3899.917225] gspca: probing 1415:2000
[ 3899.923852] usbcore: registered new interface driver ov534
[ 3899.923856] ov534: registered
[ 3899.928082] usbcore: registered new interface driver snd-usb-audio


Update to my log:

I tried fiddling around with VLC yesterday evening and it was the
closest I could get to recording a video and audio stream from that cam
yet: I get a nice video stream and also sound, but as soon as I use
"convert" or "stream" instead of playback, it fails to initiate sound...
I'll hit the vlc forums with this issue later.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
