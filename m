Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40432 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750707AbdLKSLG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 13:11:06 -0500
Date: Mon, 11 Dec 2017 16:10:58 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sebastian Reichel <sre@kernel.org>
Subject: Re: [PATCH v2 08/26] media: v4l2-async: shut up an unitialized
 symbol warning
Message-ID: <20171211161058.6cdedb7a@vento.lan>
In-Reply-To: <1844403.anYkCZaVIn@avalon>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
        <e510e9651f4c8672ab7f64df4a55863b4b9cb787.1509569763.git.mchehab@s-opensource.com>
        <1844403.anYkCZaVIn@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 02 Nov 2017 04:51:40 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Wednesday, 1 November 2017 23:05:45 EET Mauro Carvalho Chehab wrote:
> > Smatch reports this warning:
> > 	drivers/media/v4l2-core/v4l2-async.c:597 v4l2_async_register_subdev()
> > error: uninitialized symbol 'ret'.
> > 
> > However, there's nothing wrong there. So, just shut up the
> > warning.  
> 
> Nothing wrong, really ? ret does seem to be used uninitialized when the 
> function returns at the very last line.

There's nothing wrong. If you follow the logic, you'll see that
the line:

	return ret;

is called only at "err_unbind" label, with is called only on
two places:

                ret = v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
                if (ret)
                        goto err_unbind;

                ret = v4l2_async_notifier_try_complete(notifier);
                if (ret)
                        goto err_unbind;

There, ret is defined.

Yeah, the logic there is confusing.

Thanks,
Mauro

media: v4l2-async: shut up an unitialized symbol warning

Smatch reports this warning:
	drivers/media/v4l2-core/v4l2-async.c:597 v4l2_async_register_subdev() error: uninitialized symbol 'ret'.

However, there's nothing wrong there. Yet, the logic is more
complex than it should. So, rework it to make clearer about
what happens when ret != 0.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-async.c |   38 +++++++++++++++--------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

--- patchwork.orig/drivers/media/v4l2-core/v4l2-async.c
+++ patchwork/drivers/media/v4l2-core/v4l2-async.c
@@ -532,7 +532,7 @@ int v4l2_async_register_subdev(struct v4
 {
 	struct v4l2_async_notifier *subdev_notifier;
 	struct v4l2_async_notifier *notifier;
-	int ret;
+	int ret = 0;
 
 	/*
 	 * No reference taken. The reference is held by the device
@@ -560,11 +560,11 @@ int v4l2_async_register_subdev(struct v4
 
 		ret = v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
 		if (ret)
-			goto err_unbind;
+			break;
 
 		ret = v4l2_async_notifier_try_complete(notifier);
 		if (ret)
-			goto err_unbind;
+			break;
 
 		goto out_unlock;
 	}
@@ -572,26 +572,22 @@ int v4l2_async_register_subdev(struct v4
 	/* None matched, wait for hot-plugging */
 	list_add(&sd->async_list, &subdev_list);
 
-out_unlock:
-	mutex_unlock(&list_lock);
-
-	return 0;
-
-err_unbind:
-	/*
-	 * Complete failed. Unbind the sub-devices bound through registering
-	 * this async sub-device.
-	 */
-	subdev_notifier = v4l2_async_find_subdev_notifier(sd);
-	if (subdev_notifier)
-		v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
-
-	if (sd->asd)
-		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
-	v4l2_async_cleanup(sd);
+	if (ret) {
+		/*
+		 * Complete failed. Unbind the sub-devices bound through registering
+		 * this async sub-device.
+		 */
+		subdev_notifier = v4l2_async_find_subdev_notifier(sd);
+		if (subdev_notifier)
+			v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
+
+		if (sd->asd)
+			v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
+		v4l2_async_cleanup(sd);
+	}
 
+out_unlock:
 	mutex_unlock(&list_lock);
-
 	return ret;
 }
 EXPORT_SYMBOL(v4l2_async_register_subdev);
