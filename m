Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51616
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751523AbdHIPXK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 11:23:10 -0400
Date: Wed, 9 Aug 2017 12:23:00 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 4.14] Sensor driver patches for 4.14
Message-ID: <20170809122300.4b0b3859@vento.lan>
In-Reply-To: <20170809075938.5jn7ww6h2cevtyqk@valkosipuli.retiisi.org.uk>
References: <20170809075938.5jn7ww6h2cevtyqk@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 9 Aug 2017 10:59:38 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> Here are a bunch of sensor driver fixes and improvements for 4.14.
> 
> Please pull.
> 
> 
> The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:
> 
>   media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/sailus/media_tree.git for-4.14-3
> 
> for you to fetch changes up to f95a6413a07c372cd586b9087a1425b6c216978a:
> 
>   ov9650: fix missing mutex_destroy() (2017-08-09 10:39:13 +0300)
> 
> ----------------------------------------------------------------
> Arnd Bergmann (1):
>       media: i2c: add KConfig dependencies for ov5670
> 
> Chiranjeevi Rapolu (4):
>       ov13858: Set default fps as current fps
>       ov13858: Fix initial expsoure max
>       ov13858: Correct link-frequency and pixel-rate
>       ov13858: Increase digital gain granularity, range
> 
> Fabio Estevam (2):
>       ov7670: Return the real error code
>       ov7670: Check the return value from clk_prepare_enable()
> 
> Hugues Fruchet (2):
>       ov9650: fix coding style
>       ov9650: fix missing mutex_destroy()
> 
> Julia Lawall (1):
>       vs6624: constify vs6624_default_fmt

Hi Sakari,

Patches 6 to 10 of this series seem to have already be applied. I suspect
that they were on a pull request from Hans.

The ones that applied fine were:

8593f82c01af media: vs6624: constify vs6624_default_fmt
dcadb26976a0 media: ov13858: Increase digital gain granularity, range
36b0d33bfeec media: ov13858: Correct link-frequency and pixel-rate
e1b84da2fa3e media: ov13858: Fix initial expsoure max
973e9b1109d8 media: ov13858: Set default fps as current fps

Please check if something is missing.

Regards,
Mauro

Thanks,
Mauro
