Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA7KiDYJ015664
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 15:44:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA7KhoeM008915
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 15:43:56 -0500
Date: Fri, 7 Nov 2008 18:43:58 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "David Ellingsworth" <david@identd.dyndns.org>
Message-ID: <20081107184358.3e28577e@pedra.chehab.org>
In-Reply-To: <30353c3d0811061553h4c1a77e0t597bd394fa0ebdf1@mail.gmail.com>
References: <491339D9.2010504@personnelware.com>
	<30353c3d0811061553h4c1a77e0t597bd394fa0ebdf1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: weeding out v4l ver 1 stuff
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

Hi David,

On Thu, 6 Nov 2008 18:53:42 -0500
"David Ellingsworth" <david@identd.dyndns.org> wrote:


> With v4l1 going away, it would be nice to convert any drivers still
> using the v4l1 interface to v4l2. Drivers using usbvideo spring to
> mind. I've mentioned in the past, I've started a rewrite of ibmcam
> over to the v4l2 interface but I currently don't have much time to
> work on it and could use some assistance from the community. While
> Mauro suggested it be written against the gspca framework, I hesitate
> to do so since gspca does it's own memory management and will probably
> become somewhat obsolete once the new media framework is put together.
> If anyone is interested in helping, I'll happily set up a public git
> repository for contributions.

In general, sharing common code is a good idea. That's why I think it would be
better if you use gspca as the basis for your driver. That's also why I think
it would be better for gspca to use videobuf.

Reusing existing core components generally means less compatibility issues with
userspace apps. As you know, most of the webcam troubles we're currently facing
are related to some app developed for webcam A (or tv board A), that doesn't
work well if you use webcam B.

I think if all drivers would use the same memory management and core stuff, and
if we improve the core stuf more, those problems would disappear.

Yet, I prefer to commit a driver that doesn't share the common code, but adds
support for newer stuff and are compliant with V4L2 API than not supporting
that hardware at all.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
