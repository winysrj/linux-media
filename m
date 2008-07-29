Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6TKqHQg030026
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 16:52:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6TKq5Je016680
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 16:52:06 -0400
Date: Tue, 29 Jul 2008 17:51:12 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20080729175112.21f1560f@gaivota>
In-Reply-To: <200807292105.18040.laurent.pinchart@skynet.be>
References: <488721F2.5000509@hhs.nl> <488E46BC.10104@gmail.com>
	<20080729130013.1c61f79f@gaivota>
	<200807292105.18040.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Brandon Philips <bphilips@suse.de>, video4linux-list@redhat.com,
	Jiri Slaby <jirislaby@gmail.com>, v4l2 library <v4l2-library@linuxtv.org>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Subject: Re: [V4l2-library] Messed up syscall return value
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

On Tue, 29 Jul 2008 21:05:17 +0200
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> > So, it returns the number of buffers that were really allocated. It is too
> > late to change this, since this behaviour is very old. If the V4L2 API spec
> > is different, we should fix at the spec, not at the driver.
> 
> I'm not sure to agree with that. The spec clearly states that 0 is returned on 
> success and -1 on error. Since applications don't choke with the currently 
> buggy videobuf-core implementation, they must all be check against -1, or 
> checking for a negative error code. So returning 0 shouldn't break any 
> application, except if it relies on the ioctl returning the number of 
> buffers, which is not documented anywhere.

There are some apps that relies on the number of buffers allocated. This is
important on some cases. For example, if you have digital audio support,
userspace app needs to know how much buffers were allocated, in order to proper
synchronize audio and video.

In the case of videobuf, used by most drivers since pre-2.6 kernels, it returns
it at both req->count and as the returned value for ioctl.

So, userspace apps may use req->count to know the effective number of allocated
buffers, or the returned value for the ioctl. Since most apps were done
considering bttv (a client of videobuf), I don't doubt that some of them are
just using the returned value at the ioctl.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
