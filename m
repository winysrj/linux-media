Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBVJZC2I024895
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 14:35:12 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.169])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBVJYvGQ021551
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 14:34:57 -0500
Received: by wf-out-1314.google.com with SMTP id 25so5779073wfc.6
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 11:34:55 -0800 (PST)
Message-ID: <c785bba30812311134v86c1552o6fb7e76191c50182@mail.gmail.com>
Date: Wed, 31 Dec 2008 12:34:55 -0700
From: "Paul Thomas" <pthomas8589@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <412bdbff0812311133y7c3c4f28u9d9ed99cbc18233b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c785bba30812301646vf7572dcua9361eb10ec58716@mail.gmail.com>
	<20081231155344.4cc4594a@gmail.com>
	<c785bba30812311128u27f9326ah16728a17a5fce7e3@mail.gmail.com>
	<412bdbff0812311133y7c3c4f28u9d9ed99cbc18233b@mail.gmail.com>
Subject: Re: em28xx issues
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

Devin,

Here it is,

CC [M]  /home/raid5/kernels/v4l-dvb/v4l/bttv-input.o
In file included from /home/raid5/kernels/v4l-dvb/v4l/bttvp.h:36,
                 from /home/raid5/kernels/v4l-dvb/v4l/bttv-input.c:28:
include/linux/pci.h:1126: error: expected declaration specifiers or
'...' before '(' token
include/linux/pci.h:1126: error: expected declaration specifiers or
'...' before '(' token
include/linux/pci.h:1126: error: static declaration of
'ioremap_nocache' follows non-static declaration
include/asm/io_64.h:176: error: previous declaration of
'ioremap_nocache' was here
include/linux/pci.h: In function 'ioremap_nocache':
include/linux/pci.h:1127: error: number of arguments doesn't match prototype
include/asm/io_64.h:176: error: prototype declaration
include/linux/pci.h:1131: error: 'pdev' undeclared (first use in this function)
include/linux/pci.h:1131: error: (Each undeclared identifier is
reported only once
include/linux/pci.h:1131: error: for each function it appears in.)
include/linux/pci.h:1131: error: 'bar' undeclared (first use in this function)
make[3]: *** [/home/raid5/kernels/v4l-dvb/v4l/bttv-input.o] Error 1
make[2]: *** [_module_/home/raid5/kernels/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.27.9-73.fc9.x86_64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/raid5/kernels/v4l-dvb/v4l'
make: *** [all] Error 2

thanks,
Paul

On Wed, Dec 31, 2008 at 12:33 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> On Wed, Dec 31, 2008 at 2:28 PM, Paul Thomas <pthomas8589@gmail.com> wrote:
>> Markus & Douglas,
>>
>> Thanks for your help. Do I need more than just the kernel headers
>> installed? Both the full v4l-dvb and em28xx-new start to compile, but
>> generate errors an error before finishing.
>>
>> thanks,
>> Paul
>
> Paul,
>
> If you pastebin the output of attempting to compile v4l-dvb, I will
> see if it's something obvious.
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
