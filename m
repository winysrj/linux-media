Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1935 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3A1KIr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 05:08:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 2/7] saa7134: v4l2-compliance: don't report invalid audio modes for radio
Date: Mon, 28 Jan 2013 11:08:33 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org> <1359315912-1767-3-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359315912-1767-3-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301281108.33068.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun January 27 2013 20:45:07 Ondrej Zary wrote:
> Make saa7134 driver more V4L2 compliant: filter audio modes that came from
> tuner - keep only MONO/STEREO in radio mode
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/pci/saa7134/saa7134-video.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
> index ce15f1f..db8da32 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -2333,6 +2333,7 @@ static int radio_g_tuner(struct file *file, void *priv,
>  	t->type = V4L2_TUNER_RADIO;
>  
>  	saa_call_all(dev, tuner, g_tuner, t);
> +	t->audmode &= V4L2_TUNER_MODE_MONO | V4L2_TUNER_MODE_STEREO;
>  	if (dev->input->amux == TV) {
>  		t->signal = 0xf800 - ((saa_readb(0x581) & 0x1f) << 11);
>  		t->rxsubchans = (saa_readb(0x529) & 0x08) ?
> 
