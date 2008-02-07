Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m17Jm8tM012432
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 14:48:08 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m17JlYNW003764
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 14:47:34 -0500
Date: Thu, 7 Feb 2008 17:47:03 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Guillaume Quintard" <guillaume.quintard@gmail.com>
Message-ID: <20080207174703.5e79d19a@gaivota>
In-Reply-To: <1e5fdab70802061744u4b053ab3o43fcfbb86fe248a@mail.gmail.com>
References: <1e5fdab70802061744u4b053ab3o43fcfbb86fe248a@mail.gmail.com>
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

On Wed, 6 Feb 2008 17:44:05 -0800
"Guillaume Quintard" <guillaume.quintard@gmail.com> wrote:

> Hi,
> (I'm not sure it's the right place, but I couldn't find any better
> place, so, if there is, please let me know)

This is the proper place ;)

> I'm kinda new to V4L2 (and kernel drivers in general) and I've been
> asked to se if I could control a saa7115 on an embedded linux
> platform, using the V4L2 driver.
> the driver loads without a problem, it creates an interface in /dev/,
> but that a I2C (89) file, and not a video (81) one. The thing is I
> have two saa7115 on the I2C bus, and I don't how to issue my command
> to the one I want.
> 
> Well, from what I understood, I can send instructions to the bus using
> ioctl() and /dev/i2c-0, but these are i2c/smbus commands, not V4L2
> ones, right ?
> 
> I read the sources and I still don't have a clue what I'm supposed to
> do, could you please give me a few hints ?

On most devices, you don't have direct access to i2c bus, since it is located
on a separate board. So, v4l drivers creates a host driver with PCI or USB bus.
The host driver then implements i2c methods. This is the case of cx88-i2c, for
example.

On embedded processors, you generally attach devices directly to the CPU i2c
bus. In this case, you'll need to implement a host v4l2 module for your
processor, and use it to access the i2c device.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
