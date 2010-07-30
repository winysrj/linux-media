Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:37250 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab0G3NnE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 09:43:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergio Aguirre <saaguirre@ti.com>
Subject: Re: [media-ctl PATCH 3/3] Be able to add more CFLAGS
Date: Fri, 30 Jul 2010 15:42:53 +0200
Cc: linux-media@vger.kernel.org
References: <1279124246-12187-1-git-send-email-saaguirre@ti.com> <1279124246-12187-4-git-send-email-saaguirre@ti.com>
In-Reply-To: <1279124246-12187-4-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007301542.54401.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

Thanks for the patch, and sorry for the delay. Applied.

On Wednesday 14 July 2010 18:17:26 Sergio Aguirre wrote:
> This allows the gcc compilation to build with extra parameters.
> 
> For example, if we want to build with -static, we just do:
> 
> make CFLAGS=-static
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 300ed7e..bd53626 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -3,7 +3,7 @@ HDIR ?= /usr/include
> 
>  CC   := $(CROSS_COMPILE)gcc
> 
> -CFLAGS = -O2 -Wall -fpic -I$(HDIR)
> +CFLAGS += -O2 -Wall -fpic -I$(HDIR)
>  OBJS = media.o main.o options.o subdev.o
> 
>  all: media-ctl

-- 
Regards,

Laurent Pinchart
