Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:56705 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab0BSTm0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 14:42:26 -0500
Message-ID: <4B7EEB6B.5070400@gmail.com>
Date: Fri, 19 Feb 2010 20:50:03 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video_device: don't free_irq() an element past array
 vpif_obj.dev[] and fix test
References: <4B714E15.4020909@gmail.com> <A69FA2915331DC488A831521EAE36FE40169C5C9B5@dlee06.ent.ti.com> <25e057c01002181202v346f488bk571d099f679fea83@mail.gmail.com> <A69FA2915331DC488A831521EAE36FE40169C5CBD8@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40169C5CBD8@dlee06.ent.ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first loop ends when platform_get_resource() returns NULL. Can it occur
that no platform_get_resource() succeeded? I think we should error return if
that happens. Could k grow larger than VPIF_DISPLAY_MAX_DEVICES there?
Should we err out in that case?

In the loop `for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++)' if
video_device_alloc() fails I think we correctly release the devices,
but we have to do more before we reach label vpif_int_err.

As mentioned, we left the first loop with a res of NULL, which is
dereferenced at label vpif_int_err. So we have to get the resource again,
however, k was incremented at the end of that loop as well. Also i used
as index in the second loop as well should point to res->end before going
to label vpif_int_err, to free all requested irqs. All this needs to be
done for later error labels as well, so a new label is added where this
occurs, alloc_vid_fail.

Variable k can't be reused in the third for-loop and at label probe_out.
As mentioned k is needed to get the resource in case a error and clean-up
is required.

If we reach label vpif_int_err, res shouldn't be NULL, since we
dereference it. Previously we had:

        for (; k >= 0; k--) {
                for (m = i; m >= res->start; m--)
                        free_irq(m, (void *)(&vpif_obj.dev[k]->channel_id));
                res = platform_get_resource(pdev, IORESOURCE_IRQ, k-1);
                m = res->end;
        }

In the last iteration k equals 0, so we call platform_get_resource() with
-1 as a third argument. Since platform_get_resource() uses an unsigned it
is converted to 0xffffffff. platform_get_resource() fails for every index
and returns NULL. A test is lacking and we dereference NULL.

The error "VPIF IRQ request failed" should only be displayed when 
request_irq() failed, not in the case of other errors.

Also I changed some indexes, so a few could be removed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
There were some errors in the changelog and a signoff was missing.

> Ok. You are right! The ch_params[] is a table for keeping the information
> about different standards supported. For a given stdid in std_info, the function matches the stdid with that in the table and get the corresponding entry.

>>>> +      if (k == VPIF_DISPLAY_MAX_DEVICES)
>>>> +              k = VPIF_DISPLAY_MAX_DEVICES - 1;
>>
>> actually I think this is still not right. shouldn't it be be
>>
>> k = VPIF_DISPLAY_MAX_DEVICES - 1;
> 
> What you mean here? What you suggest here is same as in your patch, right?

I must admit I did not test this, except with checkpatch.pl, but I think
the issues are real and should be fixed. Do you have comments?

 drivers/media/video/davinci/vpif_display.c |   61 +++++++++++++++++++---------
 1 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index dfddef7..ae8ca94 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -383,7 +383,7 @@ static int vpif_get_std_info(struct channel_obj *ch)
 	int index;
 
 	std_info->stdid = vid_ch->stdid;
-	if (!std_info)
+	if (!std_info->stdid)
 		return -1;
 
 	for (index = 0; index < ARRAY_SIZE(ch_params); index++) {
@@ -1423,7 +1423,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
 	struct vpif_display_config *config;
-	int i, j = 0, k, q, m, err = 0;
+	int i, j, k, err;
 	struct i2c_adapter *i2c_adap;
 	struct common_obj *common;
 	struct channel_obj *ch;
@@ -1452,12 +1452,18 @@ static __init int vpif_probe(struct platform_device *pdev)
 			if (request_irq(i, vpif_channel_isr, IRQF_DISABLED,
 					"DM646x_Display",
 				(void *)(&vpif_obj.dev[k]->channel_id))) {
+				i--;
 				err = -EBUSY;
+				vpif_err("VPIF IRQ request failed\n");
 				goto vpif_int_err;
 			}
 		}
 		k++;
+		if (k >= VPIF_DISPLAY_MAX_DEVICES)
+			break;
 	}
+	if (k == 0)
+		return -ENODEV;
 
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
 
@@ -1472,7 +1478,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 				video_device_release(ch->video_dev);
 			}
 			err = -ENOMEM;
-			goto vpif_int_err;
+			goto alloc_vid_fail;
 		}
 
 		/* Initialize field of video device */
@@ -1489,13 +1495,13 @@ static __init int vpif_probe(struct platform_device *pdev)
 		ch->video_dev = vfd;
 	}
 
-	for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
-		ch = vpif_obj.dev[j];
+	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
+		ch = vpif_obj.dev[i];
 		/* Initialize field of the channel objects */
 		atomic_set(&ch->usrs, 0);
-		for (k = 0; k < VPIF_NUMOBJECTS; k++) {
-			ch->common[k].numbuffers = 0;
-			common = &ch->common[k];
+		for (j = 0; j < VPIF_NUMOBJECTS; j++) {
+			ch->common[j].numbuffers = 0;
+			common = &ch->common[j];
 			common->io_usrs = 0;
 			common->started = 0;
 			spin_lock_init(&common->irqlock);
@@ -1506,12 +1512,12 @@ static __init int vpif_probe(struct platform_device *pdev)
 			common->ctop_off = common->cbtm_off = 0;
 			common->cur_frm = common->next_frm = NULL;
 			memset(&common->fmt, 0, sizeof(common->fmt));
-			common->numbuffers = config_params.numbuffers[k];
+			common->numbuffers = config_params.numbuffers[j];
 
 		}
 		ch->initialized = 0;
-		ch->channel_id = j;
-		if (j < 2)
+		ch->channel_id = i;
+		if (i < 2)
 			ch->common[VPIF_VIDEO_INDEX].numbuffers =
 			    config_params.numbuffers[ch->channel_id];
 		else
@@ -1529,7 +1535,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 				(int)ch, (int)&ch->video_dev);
 
 		err = video_register_device(ch->video_dev,
-					  VFL_TYPE_GRABBER, (j ? 3 : 2));
+					  VFL_TYPE_GRABBER, (i ? 3 : 2));
 		if (err < 0)
 			goto probe_out;
 
@@ -1567,20 +1573,35 @@ static __init int vpif_probe(struct platform_device *pdev)
 probe_subdev_out:
 	kfree(vpif_obj.sd);
 probe_out:
-	for (k = 0; k < j; k++) {
-		ch = vpif_obj.dev[k];
+	for (j = 0; j < i; j++) {
+		ch = vpif_obj.dev[j];
 		video_unregister_device(ch->video_dev);
 		video_device_release(ch->video_dev);
 		ch->video_dev = NULL;
 	}
+alloc_vid_fail:
+	while (k--) {
+		res = platform_get_resource(pdev, IORESOURCE_IRQ, k);
+		if (res != NULL)
+			break;
+		vpif_err("Couldn't get resource %d, irqs not freed.\n", k);
+	}
+	if (res == NULL) {
+		vpif_err("Couldn't get any resource.\n");
+		return err;
+	}
+
+	i = res->end;
 vpif_int_err:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
-	vpif_err("VPIF IRQ request failed\n");
-	for (q = k; k >= 0; k--) {
-		for (m = i; m >= res->start; m--)
-			free_irq(m, (void *)(&vpif_obj.dev[k]->channel_id));
-		res = platform_get_resource(pdev, IORESOURCE_IRQ, k-1);
-		m = res->end;
+
+	for (j = i; j >= res->start; j--)
+		free_irq(j, (void *)(&vpif_obj.dev[k]->channel_id));
+
+	while (k--) {
+		res = platform_get_resource(pdev, IORESOURCE_IRQ, k);
+		for (j =  res->end; j >= res->start; j--)
+			free_irq(j, (void *)(&vpif_obj.dev[k]->channel_id));
 	}
 
 	return err;
