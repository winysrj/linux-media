Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8BC7UJN004335
	for <video4linux-list@redhat.com>; Fri, 11 Sep 2009 08:07:30 -0400
Received: from mail-px0-f135.google.com (mail-px0-f135.google.com
	[209.85.216.135])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8BC7Kup011896
	for <video4linux-list@redhat.com>; Fri, 11 Sep 2009 08:07:20 -0400
Received: by pxi41 with SMTP id 41so81798pxi.30
	for <video4linux-list@redhat.com>; Fri, 11 Sep 2009 05:07:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b89eadb20909110234v2b8ee579nc19eed163cc77463@mail.gmail.com>
References: <25f5fcff0909110020m56f881d0q383aae1f5226476@mail.gmail.com>
	<b89eadb20909110234v2b8ee579nc19eed163cc77463@mail.gmail.com>
Date: Fri, 11 Sep 2009 17:37:19 +0530
Message-ID: <25f5fcff0909110507y635aa97eg1d599710372a6e9e@mail.gmail.com>
From: Niamathullah sharief <newbiesha@gmail.com>
To: Steven Yao <yaohaiping.linux@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable
Cc: kernelnewbies@nl.linux.org, video4linux-list@redhat.com
Subject: Re: About Webcam module
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

No i am getting the following error

root@sharief-desktop:/home/sharief# rmmod gspca_zc3xx
>
ERROR: Module gspca_zc3xx is in use
>
root@sharief-desktop:/home/sharief# rmmod gspca_main
>
ERROR: Module gspca_main is in use by gspca_zc3xx
>
root@sharief-desktop:/home/sharief#


So i am confused how to check.
if i check through "module -d "modulename". I am following things

sharief@sharief-desktop:~$ modinfo -d gspca_zc3xx
>
GSPCA ZC03xx/VC3xx USB Camera Driver
>
sharief@sharief-desktop:~$ modinfo -d gspca_main
>
GSPCA USB Camera Driver
>
sharief@sharief-desktop:~$ modinfo -d videodev
>
Device registrar for Video4Linux drivers v2
>
sharief@sharief-desktop:~$ modinfo -d v4l1_compat
>
v4l(1) compatibility layer for v4l2 drivers.
>
sharief@sharief-desktop:~$
>

So first two things are showing as camera driver. bur how it is possible.
kindly help me

>


>
> 2009/9/11 Steven Yao <yaohaiping.linux@gmail.com>

> Hi Niamathullah sharief=A3=AC
>
>    i think you can use rmmod  to test which module is exactly for your
> webcam.
>
> Best regards
> Steven Yao
>
> 2009/9/11 Niamathullah sharief <newbiesha@gmail.com>
>
>> Hi friends,
>>    I have some doubts in video device driver. I have an Creative webcam
>> with me. After inserting the webcam i have seen the following modules
>> installed
>>
>> Module              Size       Used by
>>>
>> gspca_zc3xx   55936      0
>>>
>> gspca_main    29312       1   gspca_zc3xx
>>>
>> videodev        41344       1   gspca_main
>>>
>> v4l1_compat  22404       1   videodev
>>
>>
>> I dont know which module is exactly for my webcam? i am seeing 5 extra
>> module installed after inserting my webcam. I am confused. Can anyone he=
lp
>> me?
>>
>>
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
