Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA9M7PCc013544
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 17:07:25 -0500
Received: from mailrelay010.isp.belgacom.be (mailrelay010.isp.belgacom.be
	[195.238.6.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA9M78fr013032
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 17:07:08 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Jackson Yee" <jackson@gotpossum.com>
Date: Sun, 9 Nov 2008 23:07:20 +0100
References: <26aa882f0810280714u1b3964b9t1440369d2d2a36b7@mail.gmail.com>
	<200811060142.48227.laurent.pinchart@skynet.be>
	<26aa882f0811061612r1419b6a1p9dd8f17333be09ba@mail.gmail.com>
In-Reply-To: <26aa882f0811061612r1419b6a1p9dd8f17333be09ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811092307.20932.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com
Subject: Re: Testing Requested: Python Bindings for Video4linux2
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

Hi,

On Friday 07 November 2008, Jackson Yee wrote:
> Lauren,
>
> On Wed, Nov 5, 2008 at 7:42 PM, Laurent Pinchart
>
> <laurent.pinchart@skynet.be> wrote:
> > The uvcvideo driver doesn't implement the standard ioctls. This should
> > not be fatal (and you probably want to define FindKeyas well).
>
> The standard ioctls are, unfortunately, all I have to go by since I'm
> testing on my amd64 box with a bttv card. If a function does not
> succeed though, it should throw an exception and let the user code
> sort things out.

That's right. But your sample application should handle that.

> Do you have a link for the uncvideo driver so I could add support for it?

Sure. http://linux-uvc.berlios.de/

> FindKey looks to be Carl's code. ;-) I've added the function now.
>
> > The problem comes from a bad alignment in the PixFormat structure. At
> > least on my architecture (x86) the type field is 32 bits wide.
>
> I've updated the type field on PixFormat to c_long, which should come
> out to be the right size on both x86 and amd64 platforms now.
>
> Thanks for the test. I'm working on adding libavcodec/libavformat
> support so that we can capture straight to video instead of jpegs like
> we're doing now. Please let me know if we have any other issues.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
