Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m52Ke8cg021028
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 16:40:08 -0400
Received: from mailrelay008.isp.belgacom.be (mailrelay008.isp.belgacom.be
	[195.238.6.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m52KdvKT020946
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 16:39:58 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Mon, 2 Jun 2008 22:39:51 +0200
References: <78877a450806012349j25cf72acm7aed866c3888ecdd@mail.gmail.com>
In-Reply-To: <78877a450806012349j25cf72acm7aed866c3888ecdd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806022239.52094.laurent.pinchart@skynet.be>
Cc: 
Subject: Re: Detecting webcam unplugging
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

Hi Gilles,

On Monday 02 June 2008, Gilles GIGAN wrote:
> Hi all,
> I have written a small app which uses V4L1 & V4L2 to do streaming captures
> from video sources (mostly webcams).
> Capture works perfectly. However, if a webcam is unplugged during the
> capture, the app hangs on ioctl(VIDIOCSYNC) if the source uses a V4L1
> driver whereas, for V4L2, the ioctl(VIDIOC_DQBUF) fails instead of just
> hanging. So, is there a reliable way to detect when a V4L1 video source has
> become unavailable ?
> I tested my app with the following V4L1 drivers:
> gspca (01.00.20) and qc-usb (0.6.6)

Even though the V4L1 specification doesn't describe what a driver should do 
when a device is disconnected, I would expect sane drivers to return an error 
on VIDIOCSYNC instead of blocking forever. Your V4L1 driver is probably to 
blame.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
