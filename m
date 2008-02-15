Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FIvO3S021613
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 13:57:24 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1FIv2OL007385
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 13:57:02 -0500
Date: Fri, 15 Feb 2008 16:56:49 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Guillaume Quintard" <guillaume.quintard@gmail.com>
Message-ID: <20080215165649.4263d630@gaivota>
In-Reply-To: <1e5fdab70802151022k3477f538j3ce0b56d7b462d6c@mail.gmail.com>
References: <1e5fdab70802061744u4b053ab3o43fcfbb86fe248a@mail.gmail.com>
	<20080207174703.5e79d19a@gaivota>
	<1e5fdab70802071203ndbce13an1fa226d5ec3e4ca1@mail.gmail.com>
	<20080207181136.5c8c53fc@gaivota>
	<1e5fdab70802081827x4b656625h3b20332d0ee030ab@mail.gmail.com>
	<20080211104821.00756b8e@gaivota>
	<1e5fdab70802141534o194c79efu1ed974734878c052@mail.gmail.com>
	<20080215104945.4e6fe998@gaivota>
	<1e5fdab70802151022k3477f538j3ce0b56d7b462d6c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Question about saa7115
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

On Fri, 15 Feb 2008 10:22:25 -0800
"Guillaume Quintard" <guillaume.quintard@gmail.com> wrote:

> On Fri, Feb 15, 2008 at 4:49 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > On Thu, 14 Feb 2008 15:34:22 -0800
> >  At the current drivers, most of the API functions are handled by the bridge
> >  driver. So, only a subset of saa7115 features is needed for those devices. As a
> >  rule, we generally try not to add code on kernel drivers that aren't used by
> >  other kernel drivers.
> >
> 
> uh, sorry, but what is a bridge driver ? I've never heard of it, and
> could find any help on the web.

It is the driver that works as a bridge between PCI or USB and I2C ;)

In the case of saa7115, the current bridge drivers that uses it are ivtv,
em28xx, pvrusb2 and usbvision.
> 
> >  Yet, some functions shouldn't be on saa7115, like, for example:
> >         buffer handling - specific to the way it is connected;
> >         audio control and decoding - should be associated to an audio chip;
> >
> >  I don't know the implementation details of your driver. If you intend to submit
> >  your driver for its addition on kernel, feel free to propose the addition of
> >  new features to saa7115, and post to the list. Maybe your job will help also
> >  other users (for example, saa7115 driver doesn't work with Osprey 560
> >  - I'm not sure where's the issue).
> 
> sure, I'll do that, once it'll be ready, and there's a long way to go
> before that happens :-)

:)



Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
