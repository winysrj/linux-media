Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n924ZiKa027597
	for <video4linux-list@redhat.com>; Fri, 2 Oct 2009 00:35:44 -0400
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n924ZPWd020177
	for <video4linux-list@redhat.com>; Fri, 2 Oct 2009 00:35:26 -0400
Received: from tervel.nabble.com ([192.168.236.150])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <bounces@n2.nabble.com>) id 1MtZrZ-0006Lb-GR
	for video4linux-list@redhat.com; Thu, 01 Oct 2009 21:35:25 -0700
Date: Thu, 1 Oct 2009 21:35:25 -0700 (PDT)
From: razvanz <viperzden2003@yahoo.com>
To: video4linux-list@redhat.com
Message-ID: <1254458125504-3753543.post@n2.nabble.com>
In-Reply-To: <e48b28270812041409t31139b4v1ca6c8ab1578b4e9@mail.gmail.com>
References: <e48b28270812041409t31139b4v1ca6c8ab1578b4e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: Re: WinFast PalmTop DTV200H USB TvTuner
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




Nagy Gabor wrote:
> 
> I've got a Leadtek
> dtv200h<http://www.leadtek.com/eng/tv_tuner/overview.asp?lineid=6&pronameid=413>usb
> tv tuner, and it got 4 chips:
> 
> EMPIA
> 2882<http://kepfeltoltes.hu/081204/EMPIA_2882_www.kepfeltoltes.hu_.jpg>
> WJCE6353 <http://kepfeltoltes.hu/081204/WJCE6353_www.kepfeltoltes.hu_.jpg>
> CX25843-24Z<http://kepfeltoltes.hu/081204/CX25843-242_www.kepfeltoltes.hu_.jpg>
> XCEIVE
> XC3028LCQ<http://kepfeltoltes.hu/081204/XCEIVE_XC3028LCQ_www.kepfeltoltes.hu_.jpg>
> front<http://kepfeltoltes.hu/081204/258590942front_www.kepfeltoltes.hu_.jpg>
> back <http://kepfeltoltes.hu/081204/22578894back_www.kepfeltoltes.hu_.jpg>
> 
> distro: I use Debian Lenny
> 2.6.26-1-amd64<http://cdimage.debian.org/cdimage/lenny_di_rc1/amd64/bt-cd/debian-testing-amd64-kde-CD-1.iso.torrent>-
> "or anything you want" :D
> 
> lsusb:
> Bus 007 Device 005: ID 0413:6f02 Leadtek Research, Inc.
> 
> dmesg:
> [    2.787953] usb 7-1: new high speed USB device using ehci_hcd and
> address
> 2
> [    2.928702] usb 7-1: configuration #1 chosen from 1 choice
> [    2.928702] usb 7-1: New USB device found, idVendor=0413,
> idProduct=6f02
> [    2.928702] usb 7-1: New USB device strings: Mfr=0, Product=1,
> SerialNumber=2
> [    2.928702] usb 7-1: Product: WinFast PalmTop DTV200 H
> [    2.928702] usb 7-1: SerialNumber: 2222
> 
> tvtime-scanner:
> videoinput: Cannot open capture device /dev/video0: No such file or
> directory
> 
> Does someone know, how to get it work under Linux?
> Thank you!
> 
> -- 
> Nagy Gabor
> http://szabadlinuxot.blogspot.com/
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 
> 

Hi, 
   I have a Leadtek DTV 200H tv tuner and I was wandering if u managed to
get it to work under linux. 

Thanks!

-- 
View this message in context: http://n2.nabble.com/WinFast-PalmTop-DTV200H-USB-TvTuner-tp1615551p3753543.html
Sent from the video4linux-list mailing list archive at Nabble.com.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
