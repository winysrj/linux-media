Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALGGQiL022918
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 11:16:26 -0500
Received: from smtp-vbr10.xs4all.nl (smtp-vbr10.xs4all.nl [194.109.24.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALGGHbU012719
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 11:16:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Fri, 21 Nov 2008 17:16:14 +0100
References: <hvaibhav@ti.com>
	<1227280923-31654-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1227280923-31654-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811211716.14072.hverkuil@xs4all.nl>
Cc: linux-omap@vger.kernel.org,
	davinci-linux-open-source-bounces@linux.davincidsp.com
Subject: Re: [PATCH 2/2] TVP514x V4L int device driver support
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

On Friday 21 November 2008 16:22:03 hvaibhav@ti.com wrote:
> From: Vaibhav Hiremath <hvaibhav@ti.com>
>
> Added new V4L2 slave driver for TVP514x.
>
> The Driver interface has been tested on OMAP3EVM board
> with TI daughter card (TVP5146). Soon the patch for Daughter card
> will be posted on community.
>
> Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> 		Hardik Shah <hardik.shah@ti.com>
> 		Manjunath Hadli <mrh@ti.com>
> 		R Sivaraj <sivaraj@ti.com>
> 		Vaibhav Hiremath <hvaibhav@ti.com>
> 		Karicheri Muralidharan <m-karicheri2@ti.com>
> ---
>  drivers/media/video/Kconfig   |   11 +
>  drivers/media/video/Makefile  |    1 +
>  drivers/media/video/tvp514x.c | 1331
> +++++++++++++++++++++++++++++++++++++++++ include/media/tvp514x.h    
>   |  406 +++++++++++++
>  4 files changed, 1749 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/tvp514x.c
>  create mode 100644 include/media/tvp514x.h
>

I'll review this today or tomorrow.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
