Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59758 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbbLUNqg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 08:46:36 -0500
Subject: Re: [PATCH 4/5] [media] au0828-core: fix compilation when
 !CONFIG_MEDIA_CONTROLLER
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
 <a1532b4df91d3444bb8f5a8925b0d5f2c0606fbd.1450285867.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <567802B5.9090607@osg.samsung.com>
Date: Mon, 21 Dec 2015 10:46:29 -0300
MIME-Version: 1.0
In-Reply-To: <a1532b4df91d3444bb8f5a8925b0d5f2c0606fbd.1450285867.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 12/16/2015 02:11 PM, Mauro Carvalho Chehab wrote:
> commit 1590ad7b52714 ("[media] media-device: split media initialization
> and registration") moved the media controller register to a
> separate function. That caused the following compilation issue,
> if !CONFIG_MEDIA_CONTROLLER:
> 
> vim +445 drivers/media/usb/au0828/au0828-core.c
> 
>    439		if (retval) {
>    440			pr_err("%s() au0282_dev_register failed to create graph\n",
>    441			       __func__);
>    442			goto done;
>    443		}
>    444
>  > 445		retval = media_device_register(dev->media_dev);
>    446
>    447	done:
>    448		if (retval < 0)
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Looks good to me, sorry for forgetting to test with !CONFIG_MEDIA_CONTROLLER
and missing this...

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
