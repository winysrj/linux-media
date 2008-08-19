Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7J0x2ut012066
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 20:59:02 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7J0wngO018014
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 20:58:50 -0400
Received: by gxk8 with SMTP id 8so6470876gxk.3
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 17:58:44 -0700 (PDT)
Message-ID: <e63fe7530808181758i1ffc1e38r7d388ad848f41e2b@mail.gmail.com>
Date: Mon, 18 Aug 2008 20:58:44 -0400
From: "rob koendering" <susegebr@gmail.com>
To: "Jean-Francois Moine" <moinejf@free.fr>
In-Reply-To: <1219046076.1707.30.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <48A8ACFB.4070506@gmail.com> <1219046076.1707.30.camel@localhost>
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

Hello Jean

did what say and installed all
still the webcam is nor working
none of the programs will give a picture
either no /dev/video  or cant decode JPEG

recompiled the gspcav1 driver  which gave in nearly every line of
gspca core a error  by rebooting

so i had to update opensuse 11   to get all as it was before including
the kernel
so now we have the  gspcav1 driver and all the webcam programs work fine

So you can go on with the new gspca drivers for 2.6.27.xx   and quite
a few webcam wont work
and most of the programs,
then i wil have this kernel and kernel sources 2.6.25  saved on dvd to
be used by future versions of Opensuse
or the makefile, possible some code  in gspcav1 has to be altered so
we can compile it on 2.6.27

Rob










2008/8/18 Jean-Francois Moine <moinejf@free.fr>:
> On Sun, 2008-08-17 at 18:58 -0400, rob wrote:
>> Hello all
>
> Hello rob,
>
>> This is my first post to this list
>
> No, it is the second one ;)
>
>> i have troubles with my webcam and kernel 2.6.27.rc3  (Opensuse)
>> there are modules loaded gspca  sonic sn9s102
>> but no program sees the webcam
>> The webcam is   Msi StarCam  0xc45 0x60fc   sn9c105  hv7131r   with mic
>
> This webcam is handled by both the sn9c102 and gspca drivers. If the
> driver sn9c102 is generated, gspca does not handle it.
>
>> With the gspcav1 drivers compiled on kernel 2.6.25.11-0.1 (opensuse)
>> the webcam is seen as a v4L1 webcam see  log below
>        [snip]
>
> If your webcam worked with gspca v1, it should work with gspca v2. So,
> remove the driver sn9c102, get the last gspca v2 from
>
>        http://linuxtv.org/hg/~jfrancois/gspca/
>
> and look at the gspca_README.txt in my page for generation and usage.
>
> Cheers.
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
