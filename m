Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56686 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbbLGSEq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2015 13:04:46 -0500
Subject: Re: Failed to build on 4.2.6
To: Steven Rostedt <rostedt@goodmis.org>,
	stable <stable@vger.kernel.org>
References: <20151207102519.6c6d850a@gandalf.local.home>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5665CA36.6090007@infradead.org>
Date: Mon, 7 Dec 2015 10:04:38 -0800
MIME-Version: 1.0
In-Reply-To: <20151207102519.6c6d850a@gandalf.local.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/07/15 07:25, Steven Rostedt wrote:
> Hi,
> 
> The attached config doesn't build on 4.2.6, but changing it to the
> following:
> 
>  VIDEO_V4L2_SUBDEV_API n -> y
> +V4L2_FLASH_LED_CLASS n
> 
> does build.
> 
> Sorry, I lost the build error (currently building now with a good
> config), But it's because in drivers/media/i2c/adv7604.c,
> v4l2_subdev_get_try_format() is not defined.
> 
> -- Steve
> 

4.2 stable needs this patch:

commit fc88dd16a0e430f57458e6bd9b62a631c6ea53a1
Author: Hans Verkuil <hverkuil@xs4all.nl>
Date:   Mon Sep 21 08:42:04 2015 -0300

    [media] cobalt: fix Kconfig dependency
    
    The cobalt driver should depend on VIDEO_V4L2_SUBDEV_API.

===

There was also an intervening patch which may cause some editing:

commit 2f8e75d2762496bb2fcea7fa437a3339d2a6d9d4
Author: Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon Jun 29 10:45:56 2015 -0300

    [media] adv7604/cobalt: Allow compile test if !GPIOLIB



-- 
~Randy
