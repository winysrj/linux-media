Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m17KCWtP029493
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 15:12:32 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m17KC51D016996
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 15:12:05 -0500
Date: Thu, 7 Feb 2008 18:11:36 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Guillaume Quintard" <guillaume.quintard@gmail.com>
Message-ID: <20080207181136.5c8c53fc@gaivota>
In-Reply-To: <1e5fdab70802071203ndbce13an1fa226d5ec3e4ca1@mail.gmail.com>
References: <1e5fdab70802061744u4b053ab3o43fcfbb86fe248a@mail.gmail.com>
	<20080207174703.5e79d19a@gaivota>
	<1e5fdab70802071203ndbce13an1fa226d5ec3e4ca1@mail.gmail.com>
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

On Thu, 7 Feb 2008 12:03:10 -0800
"Guillaume Quintard" <guillaume.quintard@gmail.com> wrote:

> On Feb 7, 2008 11:47 AM, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > On Wed, 6 Feb 2008 17:44:05 -0800
> > On embedded processors, you generally attach devices directly to the CPU i2c
> > bus. In this case, you'll need to implement a host v4l2 module for your
> > processor, and use it to access the i2c device.
> >
> 
> Ok, that's what I feared :-)

It shouldn't be that hard. You just need to implement something like vivi.c +
cx88-i2c ;)

> anyway, in the saa711x_probe function (in saa7115.c), the "if
> (adapter->class & I2C_CLASS_TV_ANALOG)" test always fails as
> I2C_CLASS_TV_ANALOG is 2 and adapter->class is 1 (lm sensors), is that
> normal ? shouldn't class be 2 ?

If you're using the same i2c bus for lm_sensors and for tv_analog,
you'll need to set adapter->class to 3.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
