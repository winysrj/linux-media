Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FKLVUK012622
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 15:21:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1FKLAbm025290
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 15:21:10 -0500
Date: Fri, 15 Feb 2008 18:20:52 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Guillaume Quintard" <guillaume.quintard@gmail.com>
Message-ID: <20080215182052.1ac62967@gaivota>
In-Reply-To: <1e5fdab70802151136p2267dabu3b626d401854a6ee@mail.gmail.com>
References: <1e5fdab70802061744u4b053ab3o43fcfbb86fe248a@mail.gmail.com>
	<20080207174703.5e79d19a@gaivota>
	<1e5fdab70802071203ndbce13an1fa226d5ec3e4ca1@mail.gmail.com>
	<20080207181136.5c8c53fc@gaivota>
	<1e5fdab70802081827x4b656625h3b20332d0ee030ab@mail.gmail.com>
	<20080211104821.00756b8e@gaivota>
	<1e5fdab70802141534o194c79efu1ed974734878c052@mail.gmail.com>
	<20080215104945.4e6fe998@gaivota>
	<1e5fdab70802151022k3477f538j3ce0b56d7b462d6c@mail.gmail.com>
	<20080215165649.4263d630@gaivota>
	<1e5fdab70802151136p2267dabu3b626d401854a6ee@mail.gmail.com>
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

On Fri, 15 Feb 2008 11:36:00 -0800
"Guillaume Quintard" <guillaume.quintard@gmail.com> wrote:

> On Fri, Feb 15, 2008 at 10:56 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> >  It is the driver that works as a bridge between PCI or USB and I2C ;)
> >
> >  In the case of saa7115, the current bridge drivers that uses it are ivtv,
> >  em28xx, pvrusb2 and usbvision.
> 
> ok, so no wonder I've never heard about it earlier, as it is a custom
> board with no pci or usb. That means I'll have to implement the
> "missing" functions myself, right ?

Yes, but probably outside saa7115 driver. What functions are you missing?
> 
> anyway, thanks again for the help.
> 




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
