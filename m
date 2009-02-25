Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437AbZBYDYU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 22:24:20 -0500
Date: Tue, 24 Feb 2009 19:23:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	nm127@freemail.hu
Subject: Re: [Bugme-new] [Bug 12768] New: usb_alloc_urb() leaks memory
 together with uvcvideo driver
Message-Id: <20090224192330.338302fa.akpm@linux-foundation.org>
In-Reply-To: <d9def9db0902241815i7e0d8e90k59824c5a83534e2c@mail.gmail.com>
References: <bug-12768-10286@http.bugzilla.kernel.org/>
	<20090224135720.9e752fee.akpm@linux-foundation.org>
	<20090224230200.77469747@pedra.chehab.org>
	<d9def9db0902241815i7e0d8e90k59824c5a83534e2c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 25 Feb 2009 03:15:35 +0100 Markus Rechberger <mrechberger@gmail.com> wrote:

> On Wed, Feb 25, 2009 at 3:02 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > On Tue, 24 Feb 2009 13:57:20 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >>> > In the output of /proc/slab_allocators the number of blocks allocated by
> >> > usb_alloc_urb() increases, however, the xawtv is no longer running:
> >> >
> >> > size-2048: 18 usb_alloc_dev+0x1d/0x212 [usbcore]
> >> > size-2048: 2280 usb_alloc_urb+0xc/0x2b [usbcore]
> >> > size-1024: 100 usb_alloc_urb+0xc/0x2b [usbcore]
> >> > size-128: 10 usb_alloc_urb+0xc/0x2b [usbcore]
> >> >
> >> > Each time xawtv is started and stopped the value increases at the
> >> > usb_alloc_urb().
> >> >
> >> > Expected result: the same memory usage is reached again after xawtv exited.
> >> >
> >>
> >> I assume this is a v4l bug and not a USB core bug?
> >
> > I guess this is a v4l bug. We've found several memory leaks on em28xx driver,
> > fixed at the development -git:
> >
> > http://git.kernel.org/?p=linux/kernel/git/mchehab/devel.git
> >
> > I'll do some tests again with the latest em28xx driver to double check if it is
> > there any other memory leak. If not, then we could replicate the same approach
> > into uvcvideo.
> >
> 
> haha you never even had a look at the issue itself.

What a perfectly useless comment.
