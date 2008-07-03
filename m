Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6357f6V003618
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 01:07:41 -0400
Received: from smtp-vbr2.xs4all.nl (smtp-vbr2.xs4all.nl [194.109.24.22])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6357TE7023078
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 01:07:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dwaine Garden <dwainegarden@rogers.com>
Date: Thu, 3 Jul 2008 07:07:19 +0200
References: <25283.57206.qm@web88207.mail.re2.yahoo.com>
In-Reply-To: <25283.57206.qm@web88207.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Disposition: inline
Message-Id: <200807030707.19851.hverkuil@xs4all.nl>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Can we remove saa711x.c?
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

On Thursday 03 July 2008 07:03:07 Dwaine Garden wrote:
> What about the saa7113?  Have any of those devices moved over to the
> saa7115.c? It was the best decision for the usbvision driver to use
> what was packaged in the v4l kernel.

I think we never had a saa7113.c. I can't find it in any case.

Regards,

	Hans

>
>
> ----- Original Message ----
> From: Hans Verkuil <hverkuil@xs4all.nl>
> To: dwainegarden@rogers.com
> Cc: v4l <video4linux-list@redhat.com>; Mauro Carvalho Chehab
> <mchehab@infradead.org> Sent: Tuesday, July 1, 2008 2:28:26 AM
> Subject: Re: Can we remove saa711x.c?
>
> > Sounds good to me.  What about the other saa711().c modules?  Have
> > all the drivers moved over to the saa7115.c?
>
> saa7111 is still used by zoran and mxb.
> saa7114 is still used by zoran as well.
>
> I can test the zoran with the saa7111 (I'm fairly certain my iomega
> Buz has a saa7111), and I've contacted the mxb maintainer in the hope
> that he has one (it's been unmaintained for two years or so, so it
> might be difficult to find someone with that hardware).
>
> I'm hoping someone might have a zoran device with a saa7114, but if
> not then I wonder whether we shouldn't just replace it and cross our
> fingers.
>
> Regards,
>
>         Hans
>
> > ------Original Message------
> > From: Hans Verkuil
> > Sender:
> > To: v4l
> > Cc: Mauro Carvalho Chehab
> > Subject: Can we remove saa711x.c?
> > Sent: Jun 30, 2008 4:51 PM
> >
> > Hi all,
> >
> > It looks like the saa711x module is unused right now. Unless I'm
> > missing something I propose we remove it before the 2.6.27 window
> > opens.
> >
> > Regards,
> >
> >     Hans
> >
> > --
> > video4linux-list mailing list
> > Unsubscribe
> > mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
> >
> >
> > Sent from my BlackBerry device on the Rogers Wireless Network
>
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
