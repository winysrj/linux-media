Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9LCrvHO024883
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 08:53:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9LCrbia002143
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 08:53:37 -0400
Date: Tue, 21 Oct 2008 10:53:22 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Message-ID: <20081021105322.5079ddad@pedra.chehab.org>
In-Reply-To: <200810211445.29008.tobias.lorenz@gmx.net>
References: <208cbae30810191610s74b0dbeejef57ffd3d43cc3a4@mail.gmail.com>
	<200810211445.29008.tobias.lorenz@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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


On Tue, 21 Oct 2008 14:45:28 +0200
Tobias Lorenz <tobias.lorenz@gmx.net> wrote:

> Hi Alexey,
> 
> > There is chip in there named "silabs something", so i tried to add
> > support in Tobias' driver radio-si470x. Have success. Works fine with
> > kradio and gnomeradio under 2.6.27-git5 kernel. Thanks Tobias for
> > consideration.
> > (Tobias, if you want that patch change version of driver just ask and
> > i can re-make the patch)
> 
> Very nice patch. Approved.
> 
> > I think it's not critical right now, i used "arecord -D hw:2,0 -r96000
> > -c2 -f S16_LE | artsdsp aplay -B -" and periodically get "underrun"
> > messages:
> 
> I have the same problems with the usbaudio or snd-usb-audio drivers. Maybe we should get in contact with them. But I don't want to open another building site for me.
> 
> > So, we have two patches. Patches attached to letter. Patch that
> > touches HID-subsystem is created to be applied against -git tree on
> > kernel.org.
> 
> Mauro can you apply the two patches in v4l-dvb?

Sure. Could you send me your acked-by?
> 
> Thanks,
> Toby




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
