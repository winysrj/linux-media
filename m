Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB18UM63002297
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 03:30:22 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB18U95a016348
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 03:30:10 -0500
Date: Mon, 1 Dec 2008 09:30:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mike Rapoport <mike@compulab.co.il>
In-Reply-To: <493242F1.8000605@compulab.co.il>
Message-ID: <Pine.LNX.4.64.0812010927530.3915@axis700.grange>
References: <1227603594-16953-1-git-send-email-mike@compulab.co.il>
	<Pine.LNX.4.64.0811252225200.10677@axis700.grange>
	<492D1A2D.8070701@compulab.co.il> <493242F1.8000605@compulab.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] mt9m111: add support for mt9m112 since sensors seem
 identical
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

On Sun, 30 Nov 2008, Mike Rapoport wrote:

> Guennadi, Robert,
> 
> Mike Rapoport wrote:
> > 
> > Guennadi Liakhovetski wrote:
> >> On Tue, 25 Nov 2008, Mike Rapoport wrote:
> >>
> >>> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> >>> ---
> >>>  drivers/media/video/mt9m111.c |    3 ++-
> >>>  1 files changed, 2 insertions(+), 1 deletions(-)
> >>>
> >>> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> >>> index da0b2d5..49c1167 100644
> >>> --- a/drivers/media/video/mt9m111.c
> >>> +++ b/drivers/media/video/mt9m111.c
> >>> @@ -841,7 +841,8 @@ static int mt9m111_video_probe(struct soc_camera_device *icd)
> >>>  	data = reg_read(CHIP_VERSION);
> >>>  
> >>>  	switch (data) {
> >>> -	case 0x143a:
> >>> +	case 0x143a: /* MT9M111 */
> >>> +	case 0x148c: /* MT9M112 */
> >>>  		mt9m111->model = V4L2_IDENT_MT9M111;
> >> Wouldn't it be better to add a new chip ID? Are there any differences 
> >> between the two models, that the user might want to know about?
> > 
> > I don't have mt9m111 datasheet, I can only judge by "feature comparison" table
> > in the mt9m112 datasheet. It seems that sensors differ in there advanced image
> > processing and low power mode capabilities.
> > If you think it's worse adding new chip ID, I'll prepare the patches.
> 
> Any comments? Should I add a new chip ID, or modifying Kconfig and comments would
> be enough?

Personally, I think, it is nicer for a user to get precise information 
about their hardware. So, yes, I would add another ID, even if we don't 
support any extra features for now.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
