Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48822 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751988AbdA3Iuv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 03:50:51 -0500
Date: Mon, 30 Jan 2017 10:44:09 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tuukka Toivonen <tuukka.toivonen@intel.com>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] v4l2-async: failing functions shouldn't have
 side effects
Message-ID: <20170130084408.GN7139@valkosipuli.retiisi.org.uk>
References: <1485513176-6958-1-git-send-email-tuukka.toivonen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485513176-6958-1-git-send-email-tuukka.toivonen@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Heippa!

On Fri, Jan 27, 2017 at 12:32:56PM +0200, Tuukka Toivonen wrote:
> v4l2-async had several functions doing some operations and then
> not undoing the operations in a failure situation. For example,
> v4l2_async_test_notify() moved a subdev into notifier's done list
> even if registering the subdev (v4l2_device_register_subdev) failed.
> If the subdev was allocated and v4l2_async_register_subdev() called
> from the driver's probe() function, as usually, the probe()
> function freed the allocated subdev and returned a failure.
> Nevertheless, the subdev was still left into the notifier's done
> list, causing an access to already freed memory when the notifier
> was later unregistered.
> 
> A hand-edited call trace leaving freed subdevs into the notifier:
> 
> v4l2_async_register_notifier(notifier, asd)
> cameradrv_probe
>  sd = devm_kzalloc()
>  v4l2_async_register_subdev(sd)
>   v4l2_async_test_notify(notifier, sd, asd)
>    list_move(sd, &notifier->done)
>    v4l2_device_register_subdev(notifier->v4l2_dev, sd)
>     cameradrv_registered(sd) -> fails
> ->v4l2_async_register_subdev returns failure
> ->cameradrv_probe returns failure
> ->devres frees the allocated sd
> ->sd was freed but it still remains in the notifier's list.
> 
> This patch fixes this and several other cases where a failing
> function could leave nodes into a linked list while the caller
> might free the node due to a failure.
> 
> Signed-off-by: Tuukka Toivonen <tuukka.toivonen@intel.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Terveisin,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
