Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42819 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab1H2AjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Aug 2011 20:39:08 -0400
MIME-Version: 1.0
In-Reply-To: <1313746626-23845-4-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1313746626-23845-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<1313746626-23845-4-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Mon, 29 Aug 2011 09:39:06 +0900
Message-ID: <CANqRtoSozX5cPs1c2eqy=mcNi_qzVaVYb9Xmmgv8OOJRdUwWqg@mail.gmail.com>
Subject: Re: [PATCH/RFC v2 3/3] fbdev: sh_mobile_lcdc: Support FOURCC-based
 format API
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 19, 2011 at 6:37 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  arch/arm/mach-shmobile/board-ag5evm.c   |    2 +-
>  arch/arm/mach-shmobile/board-ap4evb.c   |    4 +-
>  arch/arm/mach-shmobile/board-mackerel.c |    4 +-
>  drivers/video/sh_mobile_lcdcfb.c        |  342 ++++++++++++++++++++-----------
>  include/video/sh_mobile_lcdc.h          |    4 +-
>  5 files changed, 230 insertions(+), 126 deletions(-)

Hi Laurent, thanks for the patch!

Since you're changing the LCDC platform data please make sure you also
update the 5 boards using the LCDC under arch/sh.

Thanks,

/ magnus
