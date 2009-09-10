Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8AI3Q7L005283
	for <video4linux-list@redhat.com>; Thu, 10 Sep 2009 14:03:26 -0400
Received: from mail-px0-f203.google.com (mail-px0-f203.google.com
	[209.85.216.203])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8AI3As7019464
	for <video4linux-list@redhat.com>; Thu, 10 Sep 2009 14:03:10 -0400
Received: by pxi41 with SMTP id 41so273940pxi.30
	for <video4linux-list@redhat.com>; Thu, 10 Sep 2009 11:03:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <fa40cc720909072033l5ec82188va19da7b06b943fa2@mail.gmail.com>
References: <fa40cc720909072033l5ec82188va19da7b06b943fa2@mail.gmail.com>
Date: Thu, 10 Sep 2009 23:33:09 +0530
Message-ID: <ecf74bb50909101103m7a18b5e5mdac95a3acf4e54e8@mail.gmail.com>
From: Vinay Verma <vinayverma@gmail.com>
To: Guilherme Raymo Longo <grlongo.ireland@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Cc: video4linux-list@redhat.com
Subject: Re: VIDIOC_QUERYCAP: Invalid argument - app from scratch for an USB
	GENIUS videoCAM Look 310p
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

Hi,

>From the explanation I understand that you have a v4l2 driver ready for your
cam, and are trying to test the same using an application. If that is the
case, why dont you use some standard application like mplayer etc?

Regards
Vinay

On Tue, Sep 8, 2009 at 9:03 AM, Guilherme Raymo Longo <
grlongo.ireland@gmail.com> wrote:

> Good morning gentleman.
>
> I am building my first driver from scratch and I am hanving a hard time
> trying to figure all the steps I have to follow to get to what I need to
> achieve.
>
> What I am trying to do now is to develop a application to activate my
> webcam
> and to start capturing!
>
> I am getting the following error trying to query the capabilities:
>
> VIDIOC_QUERYCAP: Invalid argument
>
> I am implementing the video capturing interface and that is what I have got
> so far:
> http://pastebin.com/m4b5bdd36
>
> Could I get some help from here??
> My webcam is an usb Genius videoCAM look 310p
> I am using Slackware 13 and v4l2 api that I am following from here:
> http://v4l2spec.bytesex.org/spec/
>
> It works great on amsn and others applications so I presume I can develop I
> application to make it work!
>
> Thanks all in advanced!
> Guilherme Longo
> Software deloper
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
