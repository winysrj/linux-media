Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m24DloZU008351
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 08:47:51 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m24DlHpT032273
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 08:47:17 -0500
Date: Tue, 4 Mar 2008 10:47:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <brandon@ifup.org>
Message-ID: <20080304104706.38666b7d@gaivota>
In-Reply-To: <20080303210650.GA16515@plankton.ifup.org>
References: <47C14336.9030903@gmail.com> <20080226163918.GB9178@plankton>
	<20080227061107.2d5f9fc1@areia>
	<200803021242.58744.tobias.lorenz@gmx.net>
	<20080303210650.GA16515@plankton.ifup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] v4l2: add hardware frequency seek
 ioctl interface
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

On Mon, 3 Mar 2008 13:06:50 -0800
Brandon Philips <brandon@ifup.org> wrote:

> On 12:42 Sun 02 Mar 2008, Tobias Lorenz wrote:
> > Additionally these parameters are only used by the seek algorithm: -
> > RSSI Seek Threshold (range: 0..254, 254=highest threshold) -
> > Signal-Noise-Ratio (range: 0..15, 15=higest SNR ratio) - FM-Impulse
> > Noise Detection Counter (range: 0..15, 15=best audio quality)
> > 
> > Propably it is wise to give the user space applications the possiblity
> > to change these parameters at run time (ioctl).  
> >
> > Else I'll implement them as module parameters, too.
> 
> Please don't implement things like this as module parameters.  What
> happens when you have two device plugged in and want different values?

Agreed.

> It would be far better to see these things defined per device in sysfs
> if you can't manage an IOCTL.  However, in this case it should be an
> IOCTL. 

The better would be to use VIDIOC_[G/S/ENUM]_CTRL to allow specifying those
parameters.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
