Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m61LGtTs019583
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 17:16:55 -0400
Received: from mailrelay007.isp.belgacom.be (mailrelay007.isp.belgacom.be
	[195.238.6.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m61LGGQ5012266
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 17:16:16 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Tue, 1 Jul 2008 23:16:14 +0200
References: <30353c3d0806281807p7b78dcd2xe2a91d560ae6df12@mail.gmail.com>
	<30353c3d0806291528qd61f4eey871db12dda64d38b@mail.gmail.com>
	<30353c3d0806291535q76877c82w1bb431bf1d8d9e7b@mail.gmail.com>
In-Reply-To: <30353c3d0806291535q76877c82w1bb431bf1d8d9e7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807012316.14708.laurent.pinchart@skynet.be>
Cc: David Ellingsworth <david@identd.dyndns.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] videodev: properly reference count video_device
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

On Monday 30 June 2008, David Ellingsworth wrote:
> On Sun, Jun 29, 2008 at 6:28 PM, David Ellingsworth
>
> <david@identd.dyndns.org> wrote:
> > [RFC v2] This patch should cleanly apply to the v4l-dvb devel branch.
> > The addition of the reference count results in the wrapping of the
> > file_operations release callback. Since open and release both take the
> > videodev_lock, the big kernel lock is no longer necessary to prevent
> > race conditions in sub-drivers.
>
> Patch attached

I don't know how other mailers perform, but kmail can't inline attached files 
when answering, which makes commenting patches difficult. If other mail 
clients suffer from the same problem, it would be better to send patches 
inlined as you did in your previous mail. If this is a kmail specific issue, 
feel free to ignore.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
