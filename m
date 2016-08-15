Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:36687 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbcHON1B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 09:27:01 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3 09/14] media: platform: pxa_camera: add buffer sequencing
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
	<1470684652-16295-10-git-send-email-robert.jarzmik@free.fr>
Date: Mon, 15 Aug 2016 15:26:57 +0200
In-Reply-To: <1470684652-16295-10-git-send-email-robert.jarzmik@free.fr>
	(Robert Jarzmik's message of "Mon, 8 Aug 2016 21:30:47 +0200")
Message-ID: <87mvkeqi1q.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> Add sequence numbers to completed buffers.
>
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/platform/soc_camera/pxa_camera.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index d66443ac1f4d..8a65f126d091 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c
> @@ -401,6 +402,7 @@ static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
>  	unsigned long cicr0;
>  
>  	dev_dbg(pcdev_to_dev(pcdev), "%s\n", __func__);
> +	pcdev->buf_sequence = 0;

I'm not so sure this is the right place to reset the buffer sequence.

I've seen no documentation on the rules applicable to this sequence number:
 - should it be reset if a "start streaming" operation occurs ?
 - should it be reset if a streams stops by lack of video buffers queued ?
 - should it be reset in queue_setup() like in other drivers ?

Or should it _never_ be reset and only be a monotonic raising number ?

Cheers.

--
Robert
