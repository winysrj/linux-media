Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46789 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752266AbbCYBAn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 21:00:43 -0400
Date: Wed, 25 Mar 2015 03:00:37 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v1 07/11] media: Add registration helpers for V4L2 flash
 sub-devices
Message-ID: <20150325010037.GH18321@valkosipuli.retiisi.org.uk>
References: <1426863811-12516-1-git-send-email-j.anaszewski@samsung.com>
 <1426863811-12516-8-git-send-email-j.anaszewski@samsung.com>
 <20150322002229.GG16613@valkosipuli.retiisi.org.uk>
 <55102C5A.8060206@samsung.com>
 <20150323223546.GQ16613@valkosipuli.retiisi.org.uk>
 <551121B9.10905@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <551121B9.10905@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Tue, Mar 24, 2015 at 09:35:05AM +0100, Jacek Anaszewski wrote:
...
> >>>>diff --git a/drivers/media/v4l2-core/v4l2-flash.c b/drivers/media/v4l2-core/v4l2-flash.c
> >>>>new file mode 100644
> >>>>index 0000000..804c2e4
> >>>>--- /dev/null
> >>>>+++ b/drivers/media/v4l2-core/v4l2-flash.c
> >>>>@@ -0,0 +1,607 @@
> >>>>+/*
> >>>>+ * V4L2 Flash LED sub-device registration helpers.
> >>>>+ *
> >>>>+ *	Copyright (C) 2015 Samsung Electronics Co., Ltd
> >>>>+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>>>+ *
> >>>>+ * This program is free software; you can redistribute it and/or modify
> >>>>+ * it under the terms of the GNU General Public License version 2 as
> >>>>+ * published by the Free Software Foundation.
> >>>>+ */
> >>>>+
> >>>>+#include <linux/led-class-flash.h>
> >>>>+#include <linux/module.h>
> >>>>+#include <linux/mutex.h>
> >>>>+#include <linux/of.h>
> >>>>+#include <linux/slab.h>
> >>>>+#include <linux/types.h>
> >>>>+#include <media/v4l2-flash.h>
> >>>>+#include "../../leds/leds.h"
> >>>
> >>>What do you need from leds.h? Shouldn't this be e.g. under include/linux
> >>>instead?
> 
> I need led_trigger_remove function.

It's exported but defined in what is obviously a private header file to the
framework. Could it be moved to include/linux/leds.h instead?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
