Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0NG1Mx5008312
	for <video4linux-list@redhat.com>; Fri, 23 Jan 2009 11:01:22 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.230])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0NG0Slm018141
	for <video4linux-list@redhat.com>; Fri, 23 Jan 2009 11:00:28 -0500
Received: by rv-out-0506.google.com with SMTP id f6so5232172rvb.51
	for <video4linux-list@redhat.com>; Fri, 23 Jan 2009 08:00:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fb065a000901230724p40f99fd9xab2adea025a336@mail.gmail.com>
References: <fb065a000901230724p40f99fd9xab2adea025a336@mail.gmail.com>
Date: Fri, 23 Jan 2009 13:00:28 -0300
Message-ID: <fb065a000901230800l621ae1a4i2ec00bfffa240c8a@mail.gmail.com>
From: Cristhian Daniel Parra Trepowski <cdparra@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Re: Gspca problem with kernel 2.6.27
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

This are the error message that I get when I try to load de module:

Jan 23 12:57:48 cparranb kernel: usb 1-4: new high speed USB device using
ehci_hcd and address 50
Jan 23 12:57:49 cparranb kernel: usb 1-4: configuration #1 chosen from 1
choice
Jan 23 12:57:49 cparranb kernel: usb 1-4: New USB device found,
idVendor=3D046d, idProduct=3D0896
Jan 23 12:57:49 cparranb kernel: usb 1-4: New USB device strings: Mfr=3D1,
Product=3D2, SerialNumber=3D0
Jan 23 12:57:49 cparranb kernel: usb 1-4: Product: Camera
Jan 23 12:57:49 cparranb kernel: usb 1-4: Manufacturer: OEM
Jan 23 12:57:49 cparranb kernel: gspca: probing 046d:0896
Jan 23 12:57:49 cparranb kernel: vc032x: check sensor header 2c
Jan 23 12:57:49 cparranb kernel: usb 1-4: USB disconnect, address 50
Jan 23 12:57:49 cparranb kernel: vc032x: I2c Bus Busy Wait 0
Jan 23 12:57:49 cparranb kernel: vc032x: I2c Bus Busy Wait 0
Jan 23 12:57:49 cparranb kernel: vc032x: I2c Bus Busy Wait 0
Jan 23 12:57:49 cparranb kernel: vc032x: I2c Bus Busy Wait 0
Jan 23 12:57:49 cparranb kernel: vc032x: I2c Bus Busy Wait 0
Jan 23 12:57:49 cparranb kernel: vc032x: I2c Bus Busy Wait 0
Jan 23 12:57:49 cparranb kernel: vc032x: I2c Bus Busy Wait 0
Jan 23 12:57:49 cparranb kernel: vc032x: Unknown sensor...
Jan 23 12:57:49 cparranb kernel: vc032x: probe of 1-4:1.0 failed with error
-22

Best regards,

On Fri, Jan 23, 2009 at 12:24 PM, Cristhian Daniel Parra Trepowski <
cdparra@gmail.com> wrote:

> Hello Everyone,
>
> I've been looking a lot for a fix to the problem of gspca_vc032x module
> with kernels 2.6.27.xx without any luck. A description of the problem can=
 be
> found here <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/271258>.
>
> I installed the jfrancois<http://linuxtv.org/hg/%7Ejfrancois/gspca/summar=
y>version of the driver from mercurial, and still have the same problem.
>
> Basically, the module can't be loaded and when you try to do it, it hangs
> up.
>
> modprobe -s -v gspca_vc032x
> insmod
> /lib/modules/2.6.27.9-159.fc10.i686/kernel/drivers/media/video/v4l1-compa=
t.ko
>
> insmod
> /lib/modules/2.6.27.9-159.fc10.i686/kernel/drivers/media/video/videodev.k=
o
> insmod
> /lib/modules/2.6.27.9-159.fc10.i686/kernel/drivers/media/video/gspca/gspc=
a_main.ko
>
> insmod
> /lib/modules/2.6.27.9-159.fc10.i686/kernel/drivers/media/video/gspca/gspc=
a_vc032x.ko
>
> ...
> It hangs here.
>
>   My hardware is:
>   Bus 001 Device 002: ID 046d:0896 Logitech, Inc. OrbiCam
>
>   My Kernel:
>   2.6.27.9-159.fc10.i686
>
>   =BFDoes someone know about a workaround on this?.
>
> Thanks,
> --
> Cristhian Daniel Parra Trepowski....
>



--=20
Cristhian Daniel Parra Trepowski....
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
