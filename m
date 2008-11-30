Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAU8xB1t015703
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 03:59:11 -0500
Received: from topnetmail3.outgw.tn (topnetmail3.outgw.tn [193.95.97.76])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAU8wuCa013391
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 03:58:56 -0500
Received: from mail1.topnet.tn (smtp.topnet.tn [213.150.176.204])
	by tounes-27.ati.tn (Postfix) with ESMTP id 1228625B0141
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 09:58:55 +0100 (CET)
From: Nicolas <progweb@free.fr>
To: kin2031@yahoo.com
In-Reply-To: <980206.90162.qm@web39701.mail.mud.yahoo.com>
References: <980206.90162.qm@web39701.mail.mud.yahoo.com>
Content-Type: text/plain; charset=utf-8
Date: Sun, 30 Nov 2008 09:58:54 +0100
Message-Id: <1228035534.8292.1.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Unable to achieve 30fps using 'read()' in C
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

With my driver stk11xx 
http://syntekdriver.sourceforge.net

I can read a V4L (1/2) stream with read or map access.

I can reache 30 fps. (with the device 174f:a311)

Regards,

Nicolas

Le samedi 29 novembre 2008 à 21:26 -0800, wei kin a écrit :
> Hi guys, thanks for the advice. However, after I install gspca v2 and run the API example in http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec/a16706.htm, I still get only 5fps. I am still wondering how others manage to get higher fps. Or do I need other programming technique such as thread programming to achieve that?
> 
> Thanks.
> Rgds,
> nik2031
> 
> On Sat, 2008-11-29 at 00:27 -0800, wei kin wrote:
> > I installed qc-usb-0.6.6 and gspca-modules-2.6.18-5-xen-686 in my debian 2.6.18-5-xen. Below are what I got:
> > 
> > lsusb
> > Bus 004 Device 004: ID 046d:0920 Logitech, Inc. QuickCam Express
> > 
> > dmesg | grep usb
> > usbcore: registered new driver usbfs
> > usbcore: registered new driver hub
> > usb usb1: configuration #1 chosen from 1 choice
> > usb usb2: configuration #1 chosen from 1 choice
> > usb usb3: configuration #1 chosen from 1 choice
> > usb usb4: configuration #1 chosen from 1 choice
> > usb 4-1: new full speed USB device using uhci_hcd and address 2
> > usb 4-1: configuration #1 chosen from 1 choice
> > usb usb5: configuration #1 chosen from 1 choice
> >  sda:<6>usb 4-1: USB disconnect, address 2
> > usb 4-1: new full speed USB device using uhci_hcd and address 3
> > usb 4-1: configuration #1 chosen from 1 choice
> > usbcore: registered new driver gspca
> > usb 4-1: USB disconnect, address 3
> > usb 4-1: new full speed USB device using uhci_hcd and address 4
> > usb 4-1: configuration #1 chosen from 1 choice
> > 
> > dmesg | grep Logitech
> > input: ImPS/2 Logitech Wheel Mouse as /class/input/input2
> > 
> > I did try out the API example in http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec/a16706.htm. However, I get error message stated that  '/dev/video0 is no V4L2 device'.
> > 
> > Do anyone have any idea?
> 
> 
>       
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

-- 
Nicolas VIVIEN

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
