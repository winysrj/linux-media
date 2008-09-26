Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8Q15CfB028109
	for <video4linux-list@redhat.com>; Thu, 25 Sep 2008 21:05:12 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.232])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8Q14xjS007135
	for <video4linux-list@redhat.com>; Thu, 25 Sep 2008 21:04:59 -0400
Received: by rv-out-0506.google.com with SMTP id f6so689150rvb.51
	for <video4linux-list@redhat.com>; Thu, 25 Sep 2008 18:04:58 -0700 (PDT)
Message-ID: <7b6d682a0809251804j1277af44i80c53529a3c33d62@mail.gmail.com>
Date: Thu, 25 Sep 2008 22:04:57 -0300
From: "Eduardo Fontes" <eduardo.fontes@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Pinnacle PCTV HD Pro Stick
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

Hello fellows,

I use Ubuntu Hardy (8.04), kernel 2.6.24-19, and I try to install a Pinnacle
PCTV HD Pro Stick USB2.0 device without success.
I download the v4l newer source drivers from Mercurial and compile it. When
module is loaded, it detects the USB device (em28xx #0: Found Pinnacle PCTV
HD Pro Stick), but sound (em28xx Doesn't have usb audio class).
I download too the firmware (
http://konstantin.filtschew.de/v4l-firmware/firmware_v4.tgz) and put it on
/lib/firmware.
In V4L Wiki page, inform that EM2880 chips don't have de USB Audio Class,
only a USB Vendor Class for digital audio, and here is the big question:
where I find the em28xx-alsa module for the kernel version that I have and
compatible with firmware and v4l drivers!?

Thanks a lot.

-- 
Eduardo Mota Fontes
A brazilian linux user.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
