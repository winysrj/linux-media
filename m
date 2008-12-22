Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBMGmRPD010359
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 11:48:27 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBMGmCw7027286
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 11:48:12 -0500
Date: Mon, 22 Dec 2008 17:48:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jean Delvare <khali@linux-fr.org>
In-Reply-To: <200812221737.42194.khali@linux-fr.org>
Message-ID: <Pine.LNX.4.64.0812221746190.5241@axis700.grange>
References: <Pine.LNX.4.64.0812171939420.8733@axis700.grange>
	<Pine.LNX.4.64.0812180938380.3963@axis700.grange>
	<200812221737.42194.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 4/4 v2] soc-camera: add support for MT9T031 CMOS camera
 sensor  from Micron
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

On Mon, 22 Dec 2008, Jean Delvare wrote:

> Hi Guennadi,
> 
> Le Jeudi 18 Décembre 2008 09:40, Guennadi Liakhovetski a écrit :
> > From: Guennadi Liakhovetski <lg@denx.de>
> > 
> > This camera is rather similar to MT9M001, but also has a couple of
> > enhanced features, like pixel binning.
> 
> I didn't look at the datasheets, but just to make sure you didn't
> overlook this possibility: wouldn't it make sense to have a single
> driver for both devices? The i2c subsystem architecture makes this
> easy.

Yes, I thought about this, but at least in the present version that 
binning / skipping difference does make up a significant part of the 
driver, so, I preferred to make a separate one.

> > Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> > ---
> > 
> > Changes since v1: added
> > 
> >  i2c_set_clientdata(client, NULL);
> > 
> > in error path and in remove.
> > 
> >  drivers/media/video/Kconfig     |    6 +
> >  drivers/media/video/Makefile    |    1 +
> >  drivers/media/video/mt9t031.c   |  733 +++++++++++++++++++++++++++++++++++++++
> >  include/media/v4l2-chip-ident.h |    1 +
> >  4 files changed, 741 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/video/mt9t031.c
> > (...)
> 
> I took a quick look at the code and it looks fine to me, for the
> parts I can comment on. So this is:
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>

Good, thanks.

Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
