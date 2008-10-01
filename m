Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m918pYHI019225
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 04:51:34 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m918pNe9000485
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 04:51:23 -0400
Received: by wf-out-1314.google.com with SMTP id 25so444594wfc.6
	for <video4linux-list@redhat.com>; Wed, 01 Oct 2008 01:51:22 -0700 (PDT)
Message-ID: <62e5edd40810010151x7899559fx1f2d2af539c71fb4@mail.gmail.com>
Date: Wed, 1 Oct 2008 10:51:22 +0200
From: "=?ISO-8859-1?Q?Erik_Andr=E9n?=" <erik.andren@gmail.com>
To: "Jean-Francois Moine" <moinejf@free.fr>
In-Reply-To: <1222848527.1756.28.camel@localhost>
MIME-Version: 1.0
References: <48E273C3.5030902@gmail.com> <48E320F0.6030002@hhs.nl>
	<62e5edd40810010028yba5fa91m6acaf93d3662acb8@mail.gmail.com>
	<1222848527.1756.28.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Cc: video4linux-list@redhat.com, m560x-driver-devel@sourceforge.net
Subject: Re: [PATCH]Add support for the ALi m5602 usb bridge
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

2008/10/1 Jean-Francois Moine <moinejf@free.fr>

> On Wed, 2008-10-01 at 09:28 +0200, Erik Andr=E9n wrote:
>
> > 2008/10/1 Hans de Goede <j.w.r.degoede@hhs.nl>
> >         Erik Andr=E9n wrote:
> >                 This patch adds support for the ALi m5602 usb bridge
> >                 and is based on the gspca framework.
> >                 It contains code for communicating with 5 different
> >                 sensors:
> >                 OmniVision OV9650, Pixel Plus PO1030, Samsung S5K83A,
> >                 S5K4AA and finally Micron MT9M111.
>         [snip]
>
> >         Jean Fran=E7ois, can you pick this up and feed it to Mauro
> >         through the gspca tree?
>
> Done.
>
> Erik, I changed your name in the sources ('=E9' to 'e'). If you want it
> back, it must be UTF-8 encoded...


No problem, it doesn't matter for me.

>
>
> Thank you very much for this driver.


>
> BTW, I am waiting for the m5603c subdriver from Franck Bourdonnec. Did
> you find common routines?
>

The m5602 and m5603 differ too much to make code sharing useful.
They have to be treated as separate drivers in my opinion.

Best regards,
Erik

>
> Cheers.
>
> --
> Ken ar c'henta=F1 |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
>
>
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
