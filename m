Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:36147 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbbESQr1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 12:47:27 -0400
MIME-Version: 1.0
In-Reply-To: <6092911.yr0lA5IaG4@wuerfel>
References: <6092911.yr0lA5IaG4@wuerfel>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 19 May 2015 17:46:55 +0100
Message-ID: <CA+V-a8tPSmRgNphN_CRjcsuL0xssDQ+3Oxne_mb=DQgs60ab8g@mail.gmail.com>
Subject: Re: [PATCH] [media] ov2659: add v4l2_subdev dependency
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	LKML <linux-kernel@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Benoit Parrot <bparrot@ti.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Thanks for the patch.

On Tue, May 19, 2015 at 1:39 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The newly added ov2659 driver uses the v4l2 subdev API, but
> can be enabled even when that API is not part of the kernel,
> resulting in this build error:
>
> media/i2c/ov2659.c: In function 'ov2659_get_fmt':
> media/i2c/ov2659.c:1054:8: error: implicit declaration of function 'v4l2_subdev_get_try_format' [-Werror=implicit-function-declaration]
> media/i2c/ov2659.c:1054:6: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
> media/i2c/ov2659.c: In function 'ov2659_set_fmt':
> media/i2c/ov2659.c:1129:6: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
> media/i2c/ov2659.c: In function 'ov2659_open':
> media/i2c/ov2659.c:1264:38: error: 'struct v4l2_subdev_fh' has no member named 'pad'
>
> This adds an explicit dependency, like all the other drivers have.
>
Patch fixing the above issue is already posted in the ML [1].

[1] https://patchwork.linuxtv.org/patch/29665/

Cheers,
--Prabhakar Lad
