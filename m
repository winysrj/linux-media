Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42063 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab2HBKuD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 06:50:03 -0400
Received: by lbbgm6 with SMTP id gm6so894814lbb.19
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2012 03:50:01 -0700 (PDT)
Message-ID: <501A5B20.9080903@mvista.com>
Date: Thu, 02 Aug 2012 14:49:04 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Dror Cohen <dror@liveu.tv>
CC: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	mchehab@infradead.org
Subject: Re: [PATCH 1/1] media/video: vpif: fixing function name start to
 vpif_config_params
References: <1343893232-19543-1-git-send-email-dror@liveu.tv> <1343893232-19543-2-git-send-email-dror@liveu.tv>
In-Reply-To: <1343893232-19543-2-git-send-email-dror@liveu.tv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 02-08-2012 11:40, Dror Cohen wrote:

> diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
> index a693d4e..8863de1 100644
> --- a/drivers/media/video/davinci/vpif_capture.h
> +++ b/drivers/media/video/davinci/vpif_capture.h
> @@ -144,7 +144,7 @@ struct vpif_device {
>   	struct v4l2_subdev **sd;
>   };
>
> -struct vpif_config_params {
> +struct config_vpif_params_t {

    IMO, '_t' postfix is used only for *typedef* names.

> diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
> index 56879d1..3e14807 100644
> --- a/drivers/media/video/davinci/vpif_display.h
> +++ b/drivers/media/video/davinci/vpif_display.h
> @@ -154,7 +154,7 @@ struct vpif_device {
>
>   };
>
> -struct vpif_config_params {
> +struct config_vpif_params_t {

    Same comment.

WBR, Sergei

