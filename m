Return-path: <video4linux-list-bounces@redhat.com>
Date: Mon, 26 May 2008 16:23:17 -0400
From: Alan Cox <alan@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080526202317.GA12793@devserv.devel.redhat.com>
References: <20080522223700.2f103a14@core> <20080526135951.7989516d@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526135951.7989516d@gaivota>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] video4linux: Push down the BKL
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

On Mon, May 26, 2008 at 01:59:51PM -0300, Mauro Carvalho Chehab wrote:
> cx18 and ivtv (see the attached log). Also, IMO, it would be better if you
> split drivers/net/tun.c into a different changeset.

That was most definitely not intended to be in the video patches 8)

> The next step can be to add the obvious locks inside video_ioctl2_unlocked(). Like, for
> example, locking the VIDIOC_S calls, if someone is calling the corresponding
> VIDIOC_G or VIDIOC_TRY ones.

Concentrate on the dats structures not the code - its one of those oft
quoted and very true rules - "lock data not code"

I'll tidy these up later in the week as I get time and merge them against
a current linux-next tree in bits with the rework done.

Alan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
