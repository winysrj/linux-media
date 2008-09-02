Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m826WrfY006474
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 02:32:53 -0400
Received: from smtp-vbr5.xs4all.nl (smtp-vbr5.xs4all.nl [194.109.24.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m826Wfmm013231
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 02:32:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Tue, 2 Sep 2008 08:32:39 +0200
References: <A24693684029E5489D1D202277BE89441191E343@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89441191E343@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809020832.39530.hverkuil@xs4all.nl>
Cc: 
Subject: Re: [PATCH 12/15] OMAP3 camera driver: Add Sensor and Lens Driver.
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

On Saturday 30 August 2008 01:42:45 Aguirre Rodriguez, Sergio Alberto 
wrote:
> From: Sergio Aguirre <saaguirre@ti.com>
> 
> OMAP: CAM: Add Sensor and Lens Driver
> 
> This adds the following sensor drivers:
> * Micron MT9P012 sensor
> * DW9710 Lens driver
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  drivers/media/video/Kconfig   |   16
>  drivers/media/video/Makefile  |    2
>  drivers/media/video/Kconfig   |   16
>  drivers/media/video/Makefile  |    2

The diff for the Makefile shows the presence of OMAP2 drivers 
(omap24xxcam.o and omap24xxcam-dma.o), yet these drivers are not 
present in the master v4l-dvb repository. Why not submit these drivers 
as well? It would be nice to have the full set. Either that or redo the 
Kconfig and Makefile patches against the v4l-dvb master repository 
since they currently do not apply cleanly.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
