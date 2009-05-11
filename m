Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com (mx2.redhat.com [10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4BIpFDF005082
	for <video4linux-list@redhat.com>; Mon, 11 May 2009 14:51:15 -0400
Received: from mail-fx0-f214.google.com (mail-fx0-f214.google.com
	[209.85.220.214])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n4BIp1Uu000886
	for <video4linux-list@redhat.com>; Mon, 11 May 2009 14:51:01 -0400
Received: by fxm10 with SMTP id 10so2884551fxm.3
	for <video4linux-list@redhat.com>; Mon, 11 May 2009 11:50:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242053146.1729.1@lhost.ldomain>
References: <1242053146.1729.1@lhost.ldomain>
Date: Mon, 11 May 2009 20:50:00 +0200
Message-ID: <62e5edd40905111150p4e2dce52wba2b19d15c1e407a@mail.gmail.com>
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: MK <halfcountplus@intergate.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: working on webcam driver
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

2009/5/11 MK <halfcountplus@intergate.com>:
>
> Hi.  I'm a fledgling C programmer who just started work on a usb webcam
> driver in order to learn about kernel programming.  So far, all I have
> done is gotten the device to register, and iterated through the
> available interfaces (there are nine with three endpoints each, an iso,
> an interrupt, and a bulk in).
>
> Anyway, before I proceed, I thought I should clarify for myself "the
> big picture" of what I am doing.  I do not have a webcam that works
> under linux, so the whole apparatus is fuzzy; I am under the impression
> that the kernel modules work with the (seperate) video4linux subsystem?
> I have the USB Video Class Specifications and am busy reading that to
> find out how the camera itself operates, but vis. the linux end of
> things, can you point me to any technical documentation that might
> clarify what the driver will be expected to do?  At this point, I am
> assuming I will have to deliver a device node, but I don't know what
> calls will be made to it etc.
>
> Help and advice is much appreciated.  Of course, best of all would be a
> few general pointers from someone who has actually done this before...
>

Hi Mark,
First of all, this list is deprecated. Send mails to
linux-media@vger.kernel.org if you want to reach the kernel community.

Secondly, have you researched that there is no existing driver for
your camera? A good way to start would perhaps to search for the usb
id and linux in google to see if it generates some hits.

If you don't find any existing driver, you should base your new one on
the gspca framework as it does a lot of the webcam groundwork for you.

Hope this helps,
Erik


> Sincerely, Mark Eriksen
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
