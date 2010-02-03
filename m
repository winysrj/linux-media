Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:55041 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab0BCA0a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 19:26:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Martin Fuzzey <mfuzzey@gmail.com>
Subject: Re: [PATCH] Video : pwc : Fix regression in pwc_set_shutter_speed caused by bad constant => sizeof conversion.
Date: Wed, 3 Feb 2010 01:27:40 +0100
Cc: linux-media@vger.kernel.org, Greg KH <greg@kroah.com>,
	treecej@comcast.net
References: <20100130162650.18132.97369.stgit@srv002.fuzzey.net>
In-Reply-To: <20100130162650.18132.97369.stgit@srv002.fuzzey.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002030127.40268.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 30 January 2010 17:26:51 Martin Fuzzey wrote:
> Regression was caused by my commit 6b35ca0d3d586b8ecb8396821af21186e20afaf0
> which determined message size using sizeof rather than hardcoded constants.
> 
> Unfortunately pwc_set_shutter_speed reuses a 2 byte buffer for a one byte
> message too so the sizeof was bogus in this case.
> 
> All other uses of sizeof checked and are ok.
> 
> Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> 
> ---
> 
>  drivers/media/video/pwc/pwc-ctrl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/pwc/pwc-ctrl.c
>  b/drivers/media/video/pwc/pwc-ctrl.c index 50b415e..f7f7e04 100644
> --- a/drivers/media/video/pwc/pwc-ctrl.c
> +++ b/drivers/media/video/pwc/pwc-ctrl.c
> @@ -753,7 +753,7 @@ int pwc_set_shutter_speed(struct pwc_device *pdev, int
>  mode, int value) buf[0] = 0xff; /* fixed */
> 
>  	ret = send_control_msg(pdev,
> -		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, sizeof(buf));
> +		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, 1);
> 
>  	if (!mode && ret >= 0) {
>  		if (value < 0)
> 

-- 
Regards,

Laurent Pinchart
