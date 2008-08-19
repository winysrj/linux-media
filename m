Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7JHEnEm021727
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 13:14:49 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7JHEdJb014114
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 13:14:39 -0400
Received: by yx-out-2324.google.com with SMTP id 31so11504yxl.81
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 10:14:38 -0700 (PDT)
Message-ID: <e63fe7530808191014naa031eke61963831fb9bc2b@mail.gmail.com>
Date: Tue, 19 Aug 2008 13:14:38 -0400
From: "rob koendering" <susegebr@gmail.com>
To: "Jean-Francois Moine" <moinejf@free.fr>
In-Reply-To: <1219164378.1694.24.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <48A8ACFB.4070506@gmail.com> <1219046076.1707.30.camel@localhost>
	<e63fe7530808181758i1ffc1e38r7d388ad848f41e2b@mail.gmail.com>
	<1219126228.1715.9.camel@localhost>
	<e63fe7530808190939v7eb100dds2d632115e587b3ed@mail.gmail.com>
	<1219164378.1694.24.camel@localhost>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: troubles with my webcam and kernel 2.6.27.rc3 Msi StarCam 0xc45
	0x60fc sn9c105 hv7131r with mic
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

Jean on opensuse there is only 1 .config file and that resides in
/usr/src/linux-2.6.25.11-0.1-obj/x86_64/default

there are also the Makefile modules.alias Module.symvers

all installed when i installed opensuse on that laptop
normaly there is no laptop on that machine so no driver

i have tryed it one again  the same result

Rob


2008/8/19 Jean-Francois Moine <moinejf@free.fr>:
> On Tue, 2008-08-19 at 12:39 -0400, rob koendering wrote:
>> Hello jean
>
> Hello Rob,
>
>> First  all the computers  are 64 bit  opensuse 11 or mandrive 2008.2
>
> No problem.
>
>> i have laptop with  opensuse 11.0
>>
>> compiled and installed  gspca-57535fa8aaff
>>
>> put my webcam in and reboot
>>
>> this are the boot messages:
>>
>>
>> gspca_main: disagrees about version of symbol video_ioctl2
>> gspca_main: Unknown symbol video_ioctl2
>> gspca_main: disagrees about version of symbol v4l_compat_ioctl32
>> gspca_main: Unknown symbol v4l_compat_ioctl32
>> gspca_main: disagrees about version of symbol video_devdata
>> gspca_main: Unknown symbol video_devdata
>> gspca_main: disagrees about version of symbol video_unregister_device
>> gspca_main: Unknown symbol video_unregister_device
>> gspca_main: disagrees about version of symbol video_register_device
>> gspca_main: Unknown symbol video_register_device
>> gspca_sonixj: Unknown symbol gspca_frame_add
>> gspca_sonixj: Unknown symbol gspca_debug
>> gspca_sonixj: Unknown symbol gspca_disconnect
>> gspca_sonixj: Unknown symbol gspca_dev_probe
>>
>> as i said nothing works  no driver loaded
>> nothing to do
>
> It is a generation problem: you did not compile with the same config as
> the kernel you use.
>
> To generate, you must go to the mercurial root
> (<where_you_installed>/gspca-57535fa8aaff/), copy the '.config' of your
> kernel (usually duplicated in '/boot/config') to 'v4l/', do a
>  'make xxconfig' (xx depending on your taste) to add the gspca driver,
> then 'make' and, as root, 'make install'.
>
> The last command (make install) will copy all the required video modules
> to the /lib/modules/`uname -r`/ tree, including the module 'videodev'
> where are defined the symbols video_ioctl2, v4l_compat_ioctl32...
>
> Indeed, if you played with your webcam before doing the make install,
> the old module videodev is already loaded. Then, you MUST do a rmmod of
> ALL the module related to video, mainly 'v4l1_compat' and
> 'videodev' (and the old webcam drivers).
>
> Regards.
>
> --
> Ken ar c'hentañ |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
>
>
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
