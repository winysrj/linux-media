Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6TKw6IC002068
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 16:58:06 -0400
Received: from mailrelay011.isp.belgacom.be (mailrelay011.isp.belgacom.be
	[195.238.6.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6TKvO9S019483
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 16:57:24 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Tue, 29 Jul 2008 22:57:21 +0200
References: <488721F2.5000509@hhs.nl>
	<200807292105.18040.laurent.pinchart@skynet.be>
	<20080729175112.21f1560f@gaivota>
In-Reply-To: <20080729175112.21f1560f@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807292257.22154.laurent.pinchart@skynet.be>
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

On Tuesday 29 July 2008, Mauro Carvalho Chehab wrote:
> On Tue, 29 Jul 2008 21:05:17 +0200
>
> Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > > So, it returns the number of buffers that were really allocated. It is
> > > too late to change this, since this behaviour is very old. If the V4L2
> > > API spec is different, we should fix at the spec, not at the driver.
> >
> > I'm not sure to agree with that. The spec clearly states that 0 is
> > returned on success and -1 on error. Since applications don't choke with
> > the currently buggy videobuf-core implementation, they must all be check
> > against -1, or checking for a negative error code. So returning 0
> > shouldn't break any application, except if it relies on the ioctl
> > returning the number of buffers, which is not documented anywhere.
>
> There are some apps that relies on the number of buffers allocated. This is
> important on some cases. For example, if you have digital audio support,
> userspace app needs to know how much buffers were allocated, in order to
> proper synchronize audio and video.
>
> In the case of videobuf, used by most drivers since pre-2.6 kernels, it
> returns it at both req->count and as the returned value for ioctl.
>
> So, userspace apps may use req->count to know the effective number of
> allocated buffers, or the returned value for the ioctl. Since most apps
> were done considering bttv (a client of videobuf), I don't doubt that some
> of them are just using the returned value at the ioctl.

The documentation clearly states that the ioctl returns 0 on success, not the 
number of allocated buffers. Applications that have been developed from the 
spec will not break. Applications that rely on the wrong return value have 
been developed in violation of the spec.

This situation is analogous to using a structure with a reserved field that is 
clearly marked as "don't touch" by the spec. If an application relies on the 
reserved field being set to a specific value, you will surely not refrain 
from changing that value in the kernel because it would break the 
application.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
