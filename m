Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7IGrp6U032737
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 12:53:51 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.232])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7IGrfYQ002617
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 12:53:41 -0400
Received: by rv-out-0506.google.com with SMTP id f6so4640435rvb.51
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 09:53:40 -0700 (PDT)
Message-ID: <6f278f100808180953h3a0a7f8fl55c239b825566551@mail.gmail.com>
Date: Mon, 18 Aug 2008 18:53:40 +0200
From: "Theou Jean-Baptiste" <jbtheou@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <20080818162449.GC22438@pippin.gateway.2wire.net>
MIME-Version: 1.0
References: <6f278f100808171248s53633e27xce36cbbf123c5e0a@mail.gmail.com>
	<6f278f100808171258r609757a0r1a605ffd9ddee0f1@mail.gmail.com>
	<20080818003448.GB22438@pippin.gateway.2wire.net>
	<6f278f100808180508k792b52f5x9e945ff08466f9e6@mail.gmail.com>
	<20080818162449.GC22438@pippin.gateway.2wire.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
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

Oh great ! Thanks you ;) I have send the request to my user. With debug=3D4
option according to modinfo.
I wait the result

2008/8/18 Mark Ferrell <majortrips@gmail.com>

> On Mon, Aug 18, 2008 at 02:08:13PM +0200, Theou Jean-Baptiste wrote:
> > My user had meet lot of stability problem when her webcam is plug. This
> > problem was fixed when he unplugged her webcam. And, just after 'sudo
> > modprobe', the blue led flash 2 sec and it's all
> >
> > Thanks. If you would other information, no problem
>
> The flashing of the LED happens during the call to ov534_setup().  After
> that the cam shouldn't do anything unless it is opened for streaming.
> Very verbose debug output can be enabled be loading the module with the
> option debug=3D5.  I would be interested in the logs if possible.
>
> I am almost done with a cleaned up version of the driver to correct
> unplugging the camera while it is streaming, and adding support for
> power management. Will hopefully have something usable for more diverse
> testing later this evening.
>
> --
> Mark
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscr=
ibe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>



--=20
Jean-Baptiste Th=E9ou
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
