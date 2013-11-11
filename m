Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50887 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab3KKXll (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Nov 2013 18:41:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Valentine Barshak <valentine.barshak@cogentembedded.com>
Cc: linux-media@vger.kernel.org, Simon Horman <horms@verge.net.au>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/3] media: Add SH-Mobile RCAR-H2 Lager board support
Date: Tue, 12 Nov 2013 00:42:16 +0100
Message-ID: <2610202.KZTyX0lZUJ@avalon>
In-Reply-To: <1380029916-10331-1-git-send-email-valentine.barshak@cogentembedded.com>
References: <1380029916-10331-1-git-send-email-valentine.barshak@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Valentine,

On Tuesday 24 September 2013 17:38:33 Valentine Barshak wrote:
> The following patches add ADV7611/ADV7612 HDMI receiver I2C driver
> and add RCAR H2 SOC support along with ADV761x output format support
> to rcar_vin soc_camera driver.
> 
> These changes are needed for SH-Mobile R8A7790 Lager board
> video input support.

Do you plan to submit a v2 ? I need the ADV761x driver pretty soon and I'd 
like to avoid submitting a competing patch :-)

> Valentine Barshak (3):
>   media: i2c: Add ADV761X support
>   media: rcar_vin: Add preliminary r8a7790 H2 support
>   media: rcar_vin: Add RGB888_1X24 input format support
> 
>  drivers/media/i2c/Kconfig                    |   11 +
>  drivers/media/i2c/Makefile                   |    1 +
>  drivers/media/i2c/adv761x.c                  | 1060 +++++++++++++++++++++++
>  drivers/media/platform/soc_camera/rcar_vin.c |   17 +-
>  include/media/adv761x.h                      |   28 +
>  5 files changed, 1114 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/media/i2c/adv761x.c
>  create mode 100644 include/media/adv761x.h
-- 
Regards,

Laurent Pinchart

