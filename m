Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m38FV5p9003790
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 11:31:05 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m38FUrxP024032
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 11:30:54 -0400
Date: Tue, 8 Apr 2008 17:31:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Mike Rapoport <mike@compulab.co.il>
In-Reply-To: <47FB0742.1060000@compulab.co.il>
Message-ID: <Pine.LNX.4.64.0804081729040.4987@axis700.grange>
References: <47FB0742.1060000@compulab.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: PATCH v2] pxa_camera: Add support for YUV modes
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

On Tue, 8 Apr 2008, Mike Rapoport wrote:

> +		struct pxa_cam_dma *buf_dma;
> +		struct pxa_cam_dma *act_dma;
> +		int channels = 1;
> +		int nents;
> +		int i;
> +
> +		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P)
> +			channels = 3;
> +
> +		for (i = 0; i < channels; i++) {
> +			buf_dma = &buf->dmas[i];
> +			act_dma = &active->dmas[0];

					   ^^^^^^^

Just came across this accidentally, is the "[0]" above correct?

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
