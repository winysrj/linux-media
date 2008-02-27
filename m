Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1R9sXRn023859
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 04:54:34 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1R9rvF0030923
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 04:53:57 -0500
Date: Wed, 27 Feb 2008 06:52:51 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Robert Fitzsimons <robfitz@273k.net>
Message-ID: <20080227065251.3b2e4516@areia>
In-Reply-To: <20080227014729.GC2685@localhost>
References: <200802171036.19619.bonganilinux@mweb.co.za>
	<20080218131125.2857f7c7@gaivota>
	<200802182320.40732.bonganilinux@mweb.co.za>
	<200802190121.36280.bonganilinux@mweb.co.za>
	<20080219111640.409870a9@gaivota>
	<20080226154102.GD30463@localhost>
	<20080227014238.GA2685@localhost> <20080227014729.GC2685@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	Bongani Hlope <bonganilinux@mweb.co.za>
Subject: Re: [PATCH] bttv: Re-enabling radio support requires the use of
 struct bttv_fh.
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

On Wed, 27 Feb 2008 01:47:29 +0000
Robert Fitzsimons <robfitz@273k.net> wrote:

> A number of the radio tuner ioctl functions are shared with the TV
> tuner, these functions require a struct bttv_fh data structure to be
> allocated and initialized.
> 
> Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
> ---
>  drivers/media/video/bt8xx/bttv-driver.c |   21 ++++++++++++++++-----
>  1 files changed, 16 insertions(+), 5 deletions(-)
> 
> 
> Mauro, the radio_open function may want to do more initialisation then
> the amount I copied from bttv_open.

Maybe, but the proper way would be to use just one open for both radio and
video, like cx88. This driver violates V4L2 API, since the spec says that
opening /dev/radio will select radio, by default, but it is possible to listen
video also on that interface (the opposite is valid also for /dev/video).

I'll apply the fixes, for now. The better would be if you could try to use the
same approach present on cx88.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
