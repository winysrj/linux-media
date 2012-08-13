Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38621 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2HMOOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 10:14:07 -0400
Message-ID: <50290B89.7070100@ti.com>
Date: Mon, 13 Aug 2012 19:43:29 +0530
From: Manjunath Hadli <manjunath.hadli@ti.com>
MIME-Version: 1.0
To: Dror Cohen <dror@liveu.tv>, <mchehab@infradead.org>
CC: <linux-media@vger.kernel.org>,
	<davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: [PATCH 0/1 v2] media/video: vpif: fixing function name start
 to vpif_config_params
References: <1344494017-18099-1-git-send-email-dror@liveu.tv>
In-Reply-To: <1344494017-18099-1-git-send-email-dror@liveu.tv>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dror,

Thanks for the patch.

Mauro,

I'll queue this patch for v3.7 through my tree.

On Thursday 09 August 2012 12:03 PM, Dror Cohen wrote:
> This patch address the issue that a function named config_vpif_params should
> be vpif_config_params. However this name is shared with two structures defined
> already. So I changed the structures to config_vpif_params (origin was
> vpif_config_params)
>
> v2 changes: softer wording in description and the structs are now
> defined without _t
>
> Dror Cohen (1):
>   fixing function name start to vpif_config_params
>
>  drivers/media/video/davinci/vpif.c         |    6 +++---
>  drivers/media/video/davinci/vpif_capture.c |    2 +-
>  drivers/media/video/davinci/vpif_capture.h |    2 +-
>  drivers/media/video/davinci/vpif_display.c |    2 +-
>  drivers/media/video/davinci/vpif_display.h |    2 +-
>  5 files changed, 7 insertions(+), 7 deletions(-)
    Acked-by: Manjunath Hadli <manjunath.hadli@ti.com>

  Thx,
  --Manju

