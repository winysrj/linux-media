Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:24562 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab3CUKin convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 06:38:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFC PATCH 07/10] bttv: do not unmute the device before the first open
Date: Thu, 21 Mar 2013 11:38:42 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com> <1363807490-3906-8-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-8-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303211138.42368.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 20 March 2013 20:24:47 Frank Schäfer wrote:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/pci/bt8xx/bttv-driver.c |    4 +++-
>  1 Datei geändert, 3 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)
> 
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index 0df4a16..55eab61 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -4212,11 +4212,13 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
>  	btv->std = V4L2_STD_PAL;
>  	init_irqreg(btv);
>  	v4l2_ctrl_handler_setup(hdl);
> -
>  	if (hdl->error) {
>  		result = hdl->error;
>  		goto fail2;
>  	}
> +	/* mute device */
> +	audio_mute(btv, 1);
> +
>  	/* register video4linux + input */
>  	if (!bttv_tvcards[btv->c.type].no_video) {
>  		v4l2_ctrl_add_handler(&btv->radio_ctrl_handler, hdl,
> 
