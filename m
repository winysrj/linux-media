Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1EB8Zj013085
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 09:11:08 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB1EAt8N023512
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 09:10:55 -0500
Date: Mon, 1 Dec 2008 15:11:05 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
In-Reply-To: <uej0s20i1.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0812011501250.3915@axis700.grange>
References: <uljvhtzst.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0811281707440.4430@axis700.grange>
	<uej0s20i1.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add ov7725 ov7720 support to ov772x driver
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

Morimoto,

one more question to your ov772x driver:

static unsigned long ov772x_query_bus_param(struct soc_camera_device *icd)
{
	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);

	return  SOCAM_PCLK_SAMPLE_RISING |
		SOCAM_HSYNC_ACTIVE_HIGH  |
		SOCAM_VSYNC_ACTIVE_HIGH  |
		SOCAM_MASTER             |
		priv->info->buswidth;
}

is priv->info->buswidth as provided by the platform indeed in terms of 
SOCAM_DATAWIDTH_*? Unfortunately, arch/sh/boards/mach-migor/setup.c as in 
next or in sh-2.6 still uses the soc_camera_platform driver.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
