Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7JHcCdw010803
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 13:38:12 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7JHbt8h029144
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 13:37:58 -0400
Received: by yx-out-2324.google.com with SMTP id 31so13230yxl.81
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 10:37:55 -0700 (PDT)
Message-ID: <e63fe7530808191037j674d0efap3443ed6804638bb2@mail.gmail.com>
Date: Tue, 19 Aug 2008 13:37:54 -0400
From: "rob koendering" <susegebr@gmail.com>
To: "Jean-Francois Moine" <moinejf@free.fr>
In-Reply-To: <1219166101.1694.31.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <48A8ACFB.4070506@gmail.com> <1219046076.1707.30.camel@localhost>
	<e63fe7530808181758i1ffc1e38r7d388ad848f41e2b@mail.gmail.com>
	<1219126228.1715.9.camel@localhost>
	<e63fe7530808190939v7eb100dds2d632115e587b3ed@mail.gmail.com>
	<1219164378.1694.24.camel@localhost>
	<e63fe7530808191014naa031eke61963831fb9bc2b@mail.gmail.com>
	<1219166101.1694.31.camel@localhost>
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

jean  i come out the IT  so i know my way around

I did delete everything in /ib/modules/kernelxxxxxx/drivers/video

make and make install  there they were again  with date of today

so i dont know  what can be wrong with that

tonight i am with someone who has Udbuntu on his machine  we will try it there
with the same webcam

By the way this kernel has no gspca drivers at all in the kernel


Rob



2008/8/19 Jean-Francois Moine <moinejf@free.fr>:
> On Tue, 2008-08-19 at 13:14 -0400, rob koendering wrote:
>> Jean on opensuse there is only 1 .config file and that resides in
>> /usr/src/linux-2.6.25.11-0.1-obj/x86_64/default
>>
>> there are also the Makefile modules.alias Module.symvers
>>
>> all installed when i installed opensuse on that laptop
>> normaly there is no laptop on that machine so no driver
>>
>> i have tryed it one again  the same result
>
> Did you check the date of the modules in:
>        /lib/modules/`uname -r`/kernel/drivers/media/video
> and:
>        /lib/modules/`uname -r`/kernel/drivers/media/video/gspca
>
> If the dates are different, you have an install problem.
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
