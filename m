Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1R9Cn9L001560
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 04:12:49 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1R9CB5j001621
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 04:12:11 -0500
Date: Wed, 27 Feb 2008 06:11:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Keith Mok <ek9852@gmail.com>
Message-ID: <20080227061107.2d5f9fc1@areia>
In-Reply-To: <20080226163918.GB9178@plankton>
References: <47C14336.9030903@gmail.com>
	<20080226163918.GB9178@plankton>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Brandon Philips <bphilips@suse.de>
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

On Tue, 26 Feb 2008 08:39:18 -0800
Brandon Philips <bphilips@suse.de> wrote:

> On 18:13 Sun 24 Feb 2008, Keith Mok wrote:
> > Add hardware frequency seek ioctl and capacity as supported by many
> > chipsets but no interface in v4l2.  Any comments about adding a new
> > ioctl or use the reserved parameters in v4l2_frequency ?

Seems fine to me to have an specific ioctl for doing radio frequency seeks.

> If we do end up adding this we will need to add it to the spec:
>   http://v4l2spec.bytesex.org/

Yes. API should describe how this works.

> So, could you please explain what this control does?  And perhaps some
> pseudo code of how it would be used.   

It is good to have a patch to a real driver, implementing this feature. I don't
like the idea of implementing newer ioctls at the API without having an
in-kernel driver using. Having the driver ioctl implementation helps other
developers that may need to use this interface on other places.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
