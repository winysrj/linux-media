Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7JIOIku013631
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 14:24:18 -0400
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7JINYX2030425
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 14:23:34 -0400
Received: by wx-out-0506.google.com with SMTP id i27so65329wxd.6
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 11:23:34 -0700 (PDT)
Message-ID: <e63fe7530808191123r1a182c8fqfc2aa8f49c05d46@mail.gmail.com>
Date: Tue, 19 Aug 2008 14:23:32 -0400
From: "rob koendering" <susegebr@gmail.com>
To: "Jean-Francois Moine" <moinejf@free.fr>
In-Reply-To: <1219168723.1694.48.camel@localhost>
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
	<e63fe7530808191037j674d0efap3443ed6804638bb2@mail.gmail.com>
	<1219168723.1694.48.camel@localhost>
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

Jean i got the mgspcav1-01.00.20-3 drivers

They compile good     took the compiled modules put then in a map
GSPCA  put that map in the kernel modules    did a depmod -ae
reboot    and the webcam is working as before with the  pspcav1 driver

one more thing  this is a message from WXCAM

Determinig video4linux API version
/dev/video0 is no V4L2 device
Using video4linux 1 API
Found palette VIDEO_PALETTE_RGB24

Rob

2008/8/19 Jean-Francois Moine <moinejf@free.fr>:
> On Tue, 2008-08-19 at 13:37 -0400, rob koendering wrote:
>> jean  i come out the IT  so i know my way around
>>
>> I did delete everything in /ib/modules/kernelxxxxxx/drivers/video
>>
>> make and make install  there they were again  with date of today
>>
>> so i dont know  what can be wrong with that
>
> If the same date appears also in
>        /lib/modules/`uname -r`/kernel/drivers/media/video/gspca
> and if you did rmmod of all the video modules before plugging the
> webcam, I do not see what it can be...
>
>> tonight i am with someone who has Udbuntu on his machine  we will try
>> it there
>> with the same webcam
>>
>> By the way this kernel has no gspca drivers at all in the kernel
>
> Good! Thank you to give me the results.
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
