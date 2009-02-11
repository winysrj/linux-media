Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com (mx2.redhat.com [10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1B7D1e9026008
	for <video4linux-list@redhat.com>; Wed, 11 Feb 2009 02:13:01 -0500
Received: from smtp-vbr17.xs4all.nl (smtp-vbr17.xs4all.nl [194.109.24.37])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n1B7CeJj010603
	for <video4linux-list@redhat.com>; Wed, 11 Feb 2009 02:12:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Wed, 11 Feb 2009 08:10:46 +0100
References: <8ef00f5a0812171449o19fe5656wec05889b738e7aed@mail.gmail.com>
	<20081231081243.0cecad1d@pedra.chehab.org>
	<495D7A51.40102@gmail.com>
In-Reply-To: <495D7A51.40102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200902110810.46825.hverkuil@xs4all.nl>
Content-Transfer-Encoding: 8bit
Cc: =?iso-8859-1?q?F=E1bio_Belavenuto?= <belavenuto@gmail.com>
Subject: Re: [PATCH] Add TEA5764 radio driver
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

On Friday 02 January 2009 03:22:09 Fábio Belavenuto wrote:
> Mauro Carvalho Chehab escreveu:
> > On Wed, 31 Dec 2008 10:52:40 +0100
> >
> > Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> Hi Mauro,
> >>
> >> Did you see my review of this driver?
> >>
> >> (http://lists-archives.org/video4linux/26062-add-tea5764-radio-driver.
> >>html)
> >>
> >> IMHO this driver shouldn't be added in this form. It's up to you of
> >> course to decide this, but I just want to make sure you read my
> >> posting.
> >
> > No, I haven't seen. I'm not sure why, but patchwork didn't show me your
> > review.
> >
> > My comments about the points you raised:
> >
> > a) Yes, the proper approach is to split it into 2 separate drivers:
> > 	1) a Motorola i2c bridge driver;
> > 	2) a generic tea5764 driver;
> >
> > I would very much appreciate if Fabio can do this work, allowing others
> > to use tea5764 driver;
> >
> > b) AFAIK, tea5764 is not so close to tea5767, so probably the right
> > decision is to have it as a separate driver;
> >
> > c) The same design trouble on radio-tea5764 is also present on other
> > radio-* drivers;
> >
> > d) While this design doesn't allow sharing tea5764 driver, for now, we
> > have at least something. A future patch may split it into two drivers.
> > That's why I decided to apply it.
> >
> > Fábio,
> >
> > Could you please work on split it into two drivers? You can use cx88 or
> > saa7134 as examples. On those drivers, the i2c stuff is at *-i2c.c, and
> > the radio interface are at *-video.c.
> >
> > Cheers,
> > Mauro
>
> Yes, I will change the driver, I will create 2 as explained, thanks.

Hi Fábio,

Any progress on this?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
