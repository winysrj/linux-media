Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25749 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab2ICJZ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 05:25:56 -0400
Message-id: <504477A1.6020304@samsung.com>
Date: Mon, 03 Sep 2012 11:25:53 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Prabhakar Lad <prabhakar.lad@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-kernel@vger.kernel.org,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-doc@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Landley <rob@landley.net>
Subject: Re: [PATCH] media: v4l2-ctrls: add control for test pattern
References: <1346663777-23149-1-git-send-email-prabhakar.lad@ti.com>
In-reply-to: <1346663777-23149-1-git-send-email-prabhakar.lad@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/2012 11:16 AM, Prabhakar Lad wrote:
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 2d7bc15..ae709d1 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -430,6 +430,18 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		"Advanced Predictor",
>  		NULL,
>  	};
> +	static const char * const test_pattern[] = {
> +		"Test Pattern Disabled",

How about just "Disabled" ?

> +		"Vertical Lines",
> +		"Horizontal Lines",
> +		"Diagonal Lines",
> +		"Solid Black",
> +		"Solid White",
> +		"Solid Blue",
> +		"Solid Red",
> +		"Checker Board",
> +		NULL,
> +	};

--

Regards,
Sylwester
