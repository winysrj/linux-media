Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40576 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932117AbdBPOXb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 09:23:31 -0500
Date: Thu, 16 Feb 2017 14:20:28 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, sakari.ailus@linux.intel.com,
        nick@shmanahar.org, songjun.wu@microchip.com, pavel@ucw.cz,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        shuah@kernel.org, geert@linux-m68k.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, arnd@arndb.de, tiffany.lin@mediatek.com,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        mchehab@kernel.org, laurent.pinchart+renesas@ideasonboard.com,
        linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v4 20/36] media: imx: Add CSI subdev driver
Message-ID: <20170216142028.GP27312@n2100.armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-21-git-send-email-steve_longerbeam@mentor.com>
 <20170216115206.GL27312@n2100.armlinux.org.uk>
 <20170216124027.GM27312@n2100.armlinux.org.uk>
 <20170216130935.GN27312@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170216130935.GN27312@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 16, 2017 at 01:09:35PM +0000, Russell King - ARM Linux wrote:
> On Thu, Feb 16, 2017 at 12:40:27PM +0000, Russell King - ARM Linux wrote:
> > However, the following is primerily directed at Laurent as the one who
> > introduced the BUG_ON() in question...
> > 
> > NEVER EVER USE BUG_ON() IN A PATH THAT CAN RETURN AN ERROR.
> > 
> > It's possible to find Linus rants about this, eg,
> > https://www.spinics.net/lists/stable/msg146439.html
> > 
> >  I should have reacted to the damn added BUG_ON() lines. I suspect I
> >  will have to finally just remove the idiotic BUG_ON() concept once and
> >  for all, because there is NO F*CKING EXCUSE to knowingly kill the
> >  kernel.
> > 
> > Also: http://yarchive.net/comp/linux/BUG.html
> > 
> >  Rule of thumb: BUG() is only good for something that never happens and
> >  that we really have no other option for (ie state is so corrupt that
> >  continuing is deadly).
> > 
> > So, _unless_ people want to see BUG_ON() removed from the kernel, I
> > strongly suggest to _STOP_ using it as "we didn't like the function
> > arguments, let's use it as an assert() statement instead of returning
> > an error."
> > 
> > There's no excuse what so ever to be killing the machine in
> > media_create_pad_link().  If it doesn't like a NULL pointer, it's damn
> > well got an error path to report that fact.  Use that mechanism and
> > stop needlessly killing the kernel.
> > 
> > BUG_ON() IS NOT ASSERT().  DO NOT USE IT AS SUCH.
> > 
> > Linus is absolutely right about BUG_ON() - it hurts debuggability,
> > because now the only way to do further tests is to reboot the damned
> > machine after removing those fscking BUG_ON()s that should *never*
> > have been there in the first place.
> > 
> > As Linus went on to say:
> > 
> >  And dammit, if anybody else feels that they had done "debugging
> >  messages with BUG_ON()", I would suggest you
> > 
> >   (a) rethink your approach to programming
> > 
> >   (b) send me patches to remove the crap entirely, or make them real
> >  *DEBUGGING* messages, not "kill the whole machine" messages.
> > 
> >  I've ranted against people using BUG_ON() for debugging in the past.
> >  Why the f*ck does this still happen? And Andrew - please stop taking
> >  those kinds of patches! Lookie here:
> > 
> >      https://lwn.net/Articles/13183/
> > 
> >  so excuse me for being upset that people still do this shit almost 15
> >  years later.
> > 
> > So I suggest people heed that advice and start fixing these stupid
> > BUG_ON()s that they've created.
> 
> More crap.
> 
> If the "complete" method fails (or, in fact, anything in
> v4l2_async_test_notify() fails) then all hell breaks loose, because
> of the total lack of clean up (and no, this isn't anything to do with
> some stupid justification of those BUG_ON()s above.)
> 
> v4l2_async_notifier_register() gets called, it adds the notifier to
> the global notifier list.  v4l2_async_test_notify() gets called.  It
> returns an error, which is propagated out of
> v4l2_async_notifier_register().
> 
> So the caller thinks that v4l2_async_notifier_register() failed, which
> will cause imx_media_probe() to fail, causing imxmd->subdev_notifier
> to be kfree()'d.  We now have a use-after free bug.
> 
> Second case.  v4l2_async_register_subdev().  Almost exactly the same,
> except in this case adding sd->async_list to the notifier->done list
> may have succeeded, and failure after that, again, results in an
> in-use list_head being kfree()'d.

And here's a patch which, combined with the fixes for ipuv3, results in
everything appearing to work properly.  Feel free to tear out the bits
for your area and turn them into proper patches.

 drivers/gpu/ipu-v3/ipu-common.c           |  6 ---
 drivers/media/media-entity.c              |  7 +--
 drivers/media/v4l2-core/v4l2-async.c      | 71 +++++++++++++++++++++++--------
 drivers/staging/media/imx/imx-media-csi.c |  1 +
 drivers/staging/media/imx/imx-media-dev.c |  2 +-
 5 files changed, 59 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 97218af4fe75..8368e6f766ee 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -1238,12 +1238,6 @@ static int ipu_add_client_devices(struct ipu_soc *ipu, unsigned long ipu_base)
 			platform_device_put(pdev);
 			goto err_register;
 		}
-
-		/*
-		 * Set of_node only after calling platform_device_add. Otherwise
-		 * the platform:imx-ipuv3-crtc modalias won't be used.
-		 */
-		pdev->dev.of_node = of_node;
 	}
 
 	return 0;
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index f9f723f5e4f0..154593a168df 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -625,9 +625,10 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 	struct media_link *link;
 	struct media_link *backlink;
 
-	BUG_ON(source == NULL || sink == NULL);
-	BUG_ON(source_pad >= source->num_pads);
-	BUG_ON(sink_pad >= sink->num_pads);
+	if (WARN_ON(source == NULL || sink == NULL) ||
+	    WARN_ON(source_pad >= source->num_pads) ||
+	    WARN_ON(sink_pad >= sink->num_pads))
+		return -EINVAL;
 
 	link = media_add_link(&source->links);
 	if (link == NULL)
diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 5bada202b2d3..09934fb96a8d 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -94,7 +94,7 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
 }
 
 static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
-				  struct v4l2_subdev *sd,
+				  struct list_head *new, struct v4l2_subdev *sd,
 				  struct v4l2_async_subdev *asd)
 {
 	int ret;
@@ -107,22 +107,36 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 	if (notifier->bound) {
 		ret = notifier->bound(notifier, sd, asd);
 		if (ret < 0)
-			return ret;
+			goto err_bind;
 	}
+
 	/* Move from the global subdevice list to notifier's done */
-	list_move(&sd->async_list, &notifier->done);
+	list_move(&sd->async_list, new);
 
 	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
-	if (ret < 0) {
-		if (notifier->unbind)
-			notifier->unbind(notifier, sd, asd);
-		return ret;
-	}
+	if (ret < 0)
+		goto err_register;
 
-	if (list_empty(&notifier->waiting) && notifier->complete)
-		return notifier->complete(notifier);
+	if (list_empty(&notifier->waiting) && notifier->complete) {
+		ret = notifier->complete(notifier);
+		if (ret < 0)
+			goto err_complete;
+	}
 
 	return 0;
+
+err_complete:
+	v4l2_device_unregister_subdev(sd);
+err_register:
+	if (notifier->unbind)
+		notifier->unbind(notifier, sd, asd);
+err_bind:
+	sd->notifier = NULL;
+	sd->asd = NULL;
+	list_add(&asd->list, &notifier->waiting);
+	/* always take this off the list on error */
+	list_del(&sd->async_list);
+	return ret;
 }
 
 static void v4l2_async_cleanup(struct v4l2_subdev *sd)
@@ -139,7 +153,8 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 {
 	struct v4l2_subdev *sd, *tmp;
 	struct v4l2_async_subdev *asd;
-	int i;
+	LIST_HEAD(new);
+	int ret, i;
 
 	if (!notifier->num_subdevs || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
 		return -EINVAL;
@@ -172,22 +187,39 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 	list_add(&notifier->list, &notifier_list);
 
 	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
-		int ret;
-
 		asd = v4l2_async_belongs(notifier, sd);
 		if (!asd)
 			continue;
 
-		ret = v4l2_async_test_notify(notifier, sd, asd);
+		ret = v4l2_async_test_notify(notifier, &new, sd, asd);
 		if (ret < 0) {
-			mutex_unlock(&list_lock);
-			return ret;
+			/*
+			 * On failure, v4l2_async_test_notify() takes the
+			 * sd off the subdev list.  Add it back.
+			 */
+			list_add(&sd->async_list, &subdev_list);
+			goto err_notify;
 		}
 	}
 
+	list_splice(&new, &notifier->done);
+
 	mutex_unlock(&list_lock);
 
 	return 0;
+
+err_notify:
+	list_del(&notifier->list);
+	list_for_each_entry_safe(sd, tmp, &new, async_list) {
+		v4l2_device_unregister_subdev(sd);
+		list_move(&sd->async_list, &subdev_list);
+		if (notifier->unbind)
+			notifier->unbind(notifier, sd, sd->asd);
+		sd->notifier = NULL;
+		sd->asd = NULL;
+	}
+	mutex_unlock(&list_lock);
+	return ret;
 }
 EXPORT_SYMBOL(v4l2_async_notifier_register);
 
@@ -213,6 +245,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	list_del(&notifier->list);
 
 	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
+		struct v4l2_async_subdev *asd = sd->asd;
 		struct device *d;
 
 		d = get_device(sd->dev);
@@ -223,7 +256,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 		device_release_driver(d);
 
 		if (notifier->unbind)
-			notifier->unbind(notifier, sd, sd->asd);
+			notifier->unbind(notifier, sd, asd);
 
 		/*
 		 * Store device at the device cache, in order to call
@@ -288,7 +321,9 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 	list_for_each_entry(notifier, &notifier_list, list) {
 		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, sd);
 		if (asd) {
-			int ret = v4l2_async_test_notify(notifier, sd, asd);
+			int ret = v4l2_async_test_notify(notifier,
+							 &notifier->done,
+							 sd, asd);
 			mutex_unlock(&list_lock);
 			return ret;
 		}
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 9d9ec03436e4..507026feee91 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1427,6 +1427,7 @@ static int imx_csi_probe(struct platform_device *pdev)
 	priv->sd.entity.ops = &csi_entity_ops;
 	priv->sd.entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
 	priv->sd.dev = &pdev->dev;
+	priv->sd.of_node = pdata->of_node;
 	priv->sd.owner = THIS_MODULE;
 	priv->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 	priv->sd.grp_id = priv->csi_id ?
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 60f45fe4b506..5b4dfc1fb6ab 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -197,7 +197,7 @@ static int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
 	struct imx_media_subdev *imxsd;
 	int ret = -EINVAL;
 
-	imxsd = imx_media_find_async_subdev(imxmd, sd->dev->of_node,
+	imxsd = imx_media_find_async_subdev(imxmd, sd->of_node,
 					    dev_name(sd->dev));
 	if (!imxsd)
 		goto out;


-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
