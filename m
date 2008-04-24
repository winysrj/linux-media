Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OGYSVP024720
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 12:34:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OGYHdV017160
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 12:34:17 -0400
Date: Thu, 24 Apr 2008 13:33:57 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Johan Hedlund <johan.hedlund@enea.com>
Message-ID: <20080424133357.7b003f74@gaivota>
In-Reply-To: <1209047735.9435.8.camel@ThePenguin>
References: <1209046379.9435.5.camel@ThePenguin>
	<20080424113125.7fd2de52@gaivota>
	<1209047735.9435.8.camel@ThePenguin>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: V4L2_PIX_FMT_SBGGR16 not in kernel
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

On Thu, 24 Apr 2008 16:35:35 +0200
Johan Hedlund <johan.hedlund@enea.com> wrote:

> I am developing my own capture drivers for our own developed hardware
> based on a driver that does not exist in mainline. This driver used a
> uyuv format, but since we want to use the raw bayer format with 10-bit
> color resolution I need to change the format.

> > > I am interested in using the format V4L2_PIX_FMT_SBGGR16 'BA82'

A format with this name will be added, but the fourcc code that Guennadi used
is different from yours. Not sure what would be the proper one.

This is what's currently defined:

#define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B','A','8','1') /*  8  BGBG.. GRGR.. */
#define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B','Y','R','2') /* 16  BGBG.. GRGR.. */


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
