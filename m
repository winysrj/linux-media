Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:49331 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab3DOOXV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 10:23:21 -0400
MIME-Version: 1.0
In-Reply-To: <1365781240-16149-3-git-send-email-g.liakhovetski@gmx.de>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de> <1365781240-16149-3-git-send-email-g.liakhovetski@gmx.de>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 15 Apr 2013 19:52:58 +0530
Message-ID: <CA+V-a8seAopcoXuUHP3yz+mcA6rg=crej8Yc8B+7JfdXO2607Q@mail.gmail.com>
Subject: Re: [PATCH v9 02/20] V4L2: support asynchronous subdevice registration
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Fri, Apr 12, 2013 at 9:10 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Currently bridge device drivers register devices for all subdevices
> synchronously, tupically, during their probing. E.g. if an I2C CMOS sensor
> is attached to a video bridge device, the bridge driver will create an I2C
> device and wait for the respective I2C driver to probe. This makes linking
> of devices straight forward, but this approach cannot be used with
> intrinsically asynchronous and unordered device registration systems like
> the Flattened Device Tree. To support such systems this patch adds an
> asynchronous subdevice registration framework to V4L2. To use it respective
> (e.g. I2C) subdevice drivers must register themselves with the framework.
> A bridge driver on the other hand must register notification callbacks,
> that will be called upon various related events.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>
> v9: addressed Laurent's comments (thanks)
> 1. moved valid hw->bus_type check
> 2. made v4l2_async_unregister() void
> 3. renamed struct v4l2_async_hw_device to struct v4l2_async_hw_info
> 4. merged struct v4l2_async_subdev_list into struct v4l2_subdev
> 5. fixed a typo
> 6. made subdev_num unsigned
>
>  drivers/media/v4l2-core/Makefile     |    3 +-
>  drivers/media/v4l2-core/v4l2-async.c |  284 ++++++++++++++++++++++++++++++++++
>  include/media/v4l2-async.h           |   99 ++++++++++++
>  include/media/v4l2-subdev.h          |   10 ++
>  4 files changed, 395 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/media/v4l2-core/v4l2-async.c
>  create mode 100644 include/media/v4l2-async.h

Cant wait until its stable, so thought of fixing it!
Finally I removed some spare time to fix the issue which i was being
pointing from past so many versions.
What was happening is bound() callback was being called for the bridge driver
for every subdevice in the subdevlist. This should not happen the
bound callback in the
bridge driver should only be called only if the interested subdev is
present in subdev list.
Following is the fix for it.

Regards,
--Prabhakar Lad

diff --git a/drivers/media/v4l2-core/v4l2-async.c
b/drivers/media/v4l2-core/v4l2-async.c
index 98db2e0..d817cda 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -83,7 +83,20 @@ static int v4l2_async_test_notify(struct
v4l2_async_notifier *notifier,
                                  struct v4l2_async_subdev_list *asdl,
                                  struct v4l2_async_subdev *asd)
 {
-       int ret;
+       int ret, i, found = 0;
+
+       /* scan through the waiting list and see if the async
+        * subdev is present in it.
+        */
+       for (i = 0; i < notifier->subdev_num; i++) {
+               if (asd == notifier->subdev[i]) {
+                       found = 1;
+                       break;
+               }
+       }
+       /* The async subdev 'asd' is not intrseted by waiting list */
+       if (!found)
+               return 0;

        /* Remove from the waiting list */
        list_del(&asd->list);
