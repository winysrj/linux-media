Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:60618 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbZA2Jky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 04:40:54 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Thu, 29 Jan 2009 15:10:21 +0530
Subject: RE: [PATCH v2] v4l/tvp514x: make the module aware of rich people
Message-ID: <19F8576C6E063C45BE387C64729E739403FA79005D@dbde02.ent.ti.com>
In-Reply-To: <20090128152937.GA5063@www.tglx.de>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sebastian Andrzej Siewior
> Sent: Wednesday, January 28, 2009 9:00 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; Mauro Carvalho Chehab; video4linux-
> list@redhat.com
> Subject: [PATCH v2] v4l/tvp514x: make the module aware of rich
> people
> 
> because they might design two of those chips on a single board.
> You never know.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> v2: Make the content of the registers (brightness, \ldots) per
> decoder
>     and not global.
> v1: Initial version
> 
>  drivers/media/video/tvp514x.c |  166 ++++++++++++++++++++++--------
> -----------
>  1 files changed, 90 insertions(+), 76 deletions(-)
> 
[Hiremath, Vaibhav] Sebastian, I have done the basic testing and it seems to be working for me. I will ack the patch from my side once you fix the comments.

> diff --git a/drivers/media/video/tvp514x.c
> b/drivers/media/video/tvp514x.c
> index 8e23aa5..99cfc40 100644
> --- a/drivers/media/video/tvp514x.c
> +++ b/drivers/media/video/tvp514x.c
> @@ -86,45 +86,8 @@ struct tvp514x_std_info {
>  	struct v4l2_standard standard;
>  };
> 
> -/**
