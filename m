Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1OLe1E4016710
	for <video4linux-list@redhat.com>; Sun, 24 Feb 2008 16:40:01 -0500
Received: from mailrelay011.isp.belgacom.be (mailrelay011.isp.belgacom.be
	[195.238.6.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1OLdURT027809
	for <video4linux-list@redhat.com>; Sun, 24 Feb 2008 16:39:30 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Sun, 24 Feb 2008 22:46:09 +0100
References: <47BC8BFC.2000602@kaiser-linux.li>
	<175f5a0f0802221615j3d2ec239r2e35d7c14dc80a28@mail.gmail.com>
	<47C0794B.5070807@free.fr>
In-Reply-To: <47C0794B.5070807@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802242246.09256.laurent.pinchart@skynet.be>
Cc: 
Subject: Re: V4L2_PIX_FMT_RAW
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

On Saturday 23 February 2008, Thierry Merle wrote:
> H. Willstrand a écrit :
> > Hi Thierry,
>
> [SNIP]
>
> > Ok, so the idea is to make converting and decompression transparent
> > for the application.
> >
> > Are there any plans to run the v4l2_helper as an shared object in the
> > application process with a direct interface? (to avoid the
> > kernel-to-user-space, user-to-kernel-space, kernel-to-user-space)
>
> Yes, this is the aim of the project; the final step I hope will show a
> new library that will be used by applications, discussing directly with
> the base drivers.

I really want to emphasise this. The final solution must not use any userspace 
daemon. The decompression (and rather transcoding) layer will be used 
directly by applications. This will of course not be transparent.

> Please join to the v4l2-library mailing-list to discuss about the
> implementation of the helper daemon in that way.
> Following discussions about this specific subject will be easier!

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
