Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6KIHadJ021299
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 14:17:36 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6KIHMVW013244
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 14:17:23 -0400
Received: by nf-out-0910.google.com with SMTP id d3so354409nfc.21
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 11:17:22 -0700 (PDT)
Message-ID: <de8cad4d0807201117x1949ea7ax6485a128a17ce9ea@mail.gmail.com>
Date: Sun, 20 Jul 2008 14:17:21 -0400
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200807201612.33032.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <de8cad4d0807200710xde576bfpb495ae5dbbd0b394@mail.gmail.com>
	<200807201612.33032.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
Subject: Re: compat_ioctl32.o: Error compiling latest HG clone of v4l-dvb
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

On Sun, Jul 20, 2008 at 10:12 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Sunday 20 July 2008 16:10:12 Brandon Jenkins wrote:
>> Greetings,
>>
>> Snippet below.
>>
>> Thanks!
>
> Working on it...
>
>        Hans
>
>>
>> Brandon
>>
>> CC [M]  /root/v4l-dvb/v4l/compat_ioctl32.o
>> /root/v4l-dvb/v4l/compat_ioctl32.c: In function 'v4l_compat_ioctl32':
>> /root/v4l-dvb/v4l/compat_ioctl32.c:985: error: implicit declaration
>> of function 'v4l_printk_ioctl'
>> make[3]: *** [/root/v4l-dvb/v4l/compat_ioctl32.o] Error 1
>> make[2]: *** [_module_/root/v4l-dvb/v4l] Error 2
>> make[2]: Leaving directory `/usr/src/linux-2.6.26'
>> make[1]: *** [default] Error 2
>> make[1]: Leaving directory `/root/v4l-dvb/v4l'
>> make: *** [all] Error 2
>>
>> --
>> video4linux-list mailing list
>> Unsubscribe
>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

Hans,

Pull from http://linuxtv.org/hg/~hverkuil/v4l-dvb/ resolved
compilation issues. Thanks!

Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
