Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9LD6oWO000535
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 09:06:50 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9LD6Eku010136
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 09:06:35 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Tue, 21 Oct 2008 15:06:12 +0200
References: <208cbae30810191610s74b0dbeejef57ffd3d43cc3a4@mail.gmail.com>
	<200810211445.29008.tobias.lorenz@gmx.net>
	<20081021105322.5079ddad@pedra.chehab.org>
In-Reply-To: <20081021105322.5079ddad@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810211506.13073.tobias.lorenz@gmx.net>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] radio-si470x: add support for kworld usb-radio
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

> > > There is chip in there named "silabs something", so i tried to add
> > > support in Tobias' driver radio-si470x. Have success. Works fine with
> > > kradio and gnomeradio under 2.6.27-git5 kernel. Thanks Tobias for
> > > consideration.
> > > So, we have two patches. Patches attached to letter. Patch that
> > > touches HID-subsystem is created to be applied against -git tree on
> > > kernel.org.
> > 
> > Mauro can you apply the two patches in v4l-dvb?
> 
> Sure. Could you send me your acked-by?

Acked-By: Tobias Lorenz <tobias.lorenz@gmx.net>

Bye,
Toby

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
