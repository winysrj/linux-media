Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7J6OBfV011938
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 02:24:11 -0400
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7J6O1v9006515
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 02:24:01 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: rob koendering <susegebr@gmail.com>
In-Reply-To: <e63fe7530808181758i1ffc1e38r7d388ad848f41e2b@mail.gmail.com>
References: <48A8ACFB.4070506@gmail.com> <1219046076.1707.30.camel@localhost>
	<e63fe7530808181758i1ffc1e38r7d388ad848f41e2b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 19 Aug 2008 08:10:28 +0200
Message-Id: <1219126228.1715.9.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: troubles with my webcam and kernel 2.6.27.rc3 Msi StarCam
	0xc45 0x60fc sn9c105 hv7131r with mic
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

On Mon, 2008-08-18 at 20:58 -0400, rob koendering wrote:
> Hello Jean

Hello Rob,

> did what say and installed all
> still the webcam is nor working
> none of the programs will give a picture
> either no /dev/video  or cant decode JPEG

The sensor you have has never been tested with gspca v2. May you give me
more information, i.e. syslog output with gspca_main/debug set to 0xff?

> recompiled the gspcav1 driver  which gave in nearly every line of
> gspca core a error  by rebooting
> 
> so i had to update opensuse 11   to get all as it was before including
> the kernel
> so now we have the  gspcav1 driver and all the webcam programs work fine
> 
> So you can go on with the new gspca drivers for 2.6.27.xx   and quite
> a few webcam wont work
> and most of the programs,

Indeed, if nobody wants to test, these webcams will never work!

> then i wil have this kernel and kernel sources 2.6.25  saved on dvd to
> be used by future versions of Opensuse
> or the makefile, possible some code  in gspcav1 has to be altered so
> we can compile it on 2.6.27

You do what you want: if you want to keep the gspca v1 you will have to
maintain it by yourself...

Regards.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
