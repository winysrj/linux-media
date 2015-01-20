Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:53227 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbbATPlX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 10:41:23 -0500
Received: by mail-ie0-f169.google.com with SMTP id rl12so13000002iec.0
        for <linux-media@vger.kernel.org>; Tue, 20 Jan 2015 07:41:22 -0800 (PST)
Date: Tue, 20 Jan 2015 15:41:15 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 05/19] mfd: max77693: Modify flash cell name
 identifiers
Message-ID: <20150120154115.GD13701@x1>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-6-git-send-email-j.anaszewski@samsung.com>
 <20150120111346.GD13701@x1>
 <54BE50AD.7080801@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BE50AD.7080801@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 20 Jan 2015, Jacek Anaszewski wrote:

> On 01/20/2015 12:13 PM, Lee Jones wrote:
> >On Fri, 09 Jan 2015, Jacek Anaszewski wrote:
> >
> >>Change flash cell identifiers from max77693-flash to max77693-led
> >>to avoid confusion with NOR/NAND Flash.
> >
> >This is okay by me, but aren't these ABI yet?
> 
> No, the led driver using it hasn't been merged yet.

Very well.

For my on reference:

Acked-by: Lee Jones <lee.jones@linaro.org>

> >>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>Cc: Chanwoo Choi <cw00.choi@samsung.com>
> >>Cc: Lee Jones <lee.jones@linaro.org>
> >>---
> >>  drivers/mfd/max77693.c |    4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >>diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> >>index a159593..cb14afa 100644
> >>--- a/drivers/mfd/max77693.c
> >>+++ b/drivers/mfd/max77693.c
> >>@@ -53,8 +53,8 @@ static const struct mfd_cell max77693_devs[] = {
> >>  		.of_compatible = "maxim,max77693-haptic",
> >>  	},
> >>  	{
> >>-		.name = "max77693-flash",
> >>-		.of_compatible = "maxim,max77693-flash",
> >>+		.name = "max77693-led",
> >>+		.of_compatible = "maxim,max77693-led",
> >>  	},
> >>  };
> >>
> >
> 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
