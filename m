Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2OIwtSq029414
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 14:58:55 -0400
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2OIwEYb013320
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 14:58:14 -0400
Received: by fk-out-0910.google.com with SMTP id e30so1333522fke.3
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 11:58:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200903241542.32631.lamarque@gmail.com>
References: <200903231708.08860.lamarque@gmail.com> <49C8AF04.7070208@hhs.nl>
	<200903241311.10902.lamarque@gmail.com>
	<200903241542.32631.lamarque@gmail.com>
Date: Tue, 24 Mar 2009 19:58:11 +0100
Message-ID: <d9def9db0903241158h6324e805j68682c42098648cd@mail.gmail.com>
From: Markus Rechberger <mrechberger@gmail.com>
To: Lamarque Vieira Souza <lamarque@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Skype and libv4l
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

On Tue, Mar 24, 2009 at 7:42 PM, Lamarque Vieira Souza
<lamarque@gmail.com> wrote:
>        It must be some problem in LD_PRELOAD, even setting LIBV4L2_LOG_FILENAME the
> file is not created. I am running skype like this:
>
> LD_PRELOAD=/usr/lib32/libv4l2.so /opt/skype/skype
>
>        /opt/skype/skype is the binary executable. There is not error message about
> LD_PRELOAD or libv4l. Skype returns:
>
> Skype V4L2: Could not find a suitable capture format
> Skype V4L2: Could not find a suitable capture format
> Starting the process...
> Skype Xv: Xv ports available: 4
> Skype XShm: XShm support enabled
> Skype Xv: Using Xv port 131
> Skype Xv: No suitable overlay format found
>

this is a problem of your graphiccard or graphic driver, look for
xorg.org tweaks.

Markus

>        OBS: compat-ioctl32.ko is being used by the driver so it should support 32-
> bit ioctl.
>
> Em Tuesday 24 March 2009, Lamarque Vieira Souza escreveu:
>>       Hi,
>>
>> Em Tuesday 24 March 2009, Hans de Goede escreveu:
>> > On 03/23/2009 09:08 PM, Lamarque Vieira Souza wrote:
>> > >   Hi all,
>> > >
>> > >   I am trying to make Skype work with my webcam (Creative PC-CAM 880,
>> > > driver zr364xx). By what I have found Skype only supports YU12, YUYV
>> > > and UYVY pixel formats, which libv4l supports as source formats only
>> > > and not as destination formats.
>> >
>> > YU12 is the same as YUV420 (planar) which skype does support. I assure
>> > you that skype works with libv4l for cams which have a native format
>> > which skype does not understand.
>>
>>       My fault here (+/-), I created a function to decode fourcc hex numbers to
>> names and it returns V4L2_PIX_FMT_YU12 instead of V4L2_PIX_FMT_YUV420. I
>> did not know they are synonyms. Anyway, it seems lib4l 0.5.9 (32-bit) is
>> not working with Skype (32-bit) while lib4l 0.5.3 (64-bit) is working with
>> Kopete (64-bit) patched to work with libv4l (no LD_PRELOAD). I will keep on
>> trying to figure out why.
>>
>> > What is an other issue with skype is that it insists on asking 320x240,
>> > so if the driver for your cam cannot deliver 320x240 and libv4l fails to
>> > make 320x240 out of it in someway (see below) then skype will fail.
>> >
>> > libv4l will crop 352x288 to 320x240 especially for skype, and it will
>> > downscale 640x480 to 320x240 for the same reason.
>>
>>       The driver delivers 320x240 as default.
>
>
> --
> Lamarque V. Souza
> http://www.geographicguide.com/brazil.htm
> Linux User #57137 - http://counter.li.org/
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
