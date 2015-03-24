Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out4.electric.net ([192.162.216.183]:51513 "EHLO
	smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbbCXOdl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 10:33:41 -0400
Message-ID: <5511759F.5050006@ad-holdings.co.uk>
Date: Tue, 24 Mar 2015 14:33:03 +0000
From: Ian Molton <imolton@ad-holdings.co.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: nicolas.dufresne@collabora.com, slongerbeam@gmail.com,
	jhautbois@gmail.com, Philipp Zabel <p.zabel@pengutronix.de>
Subject: Scaling and rounding issues
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

I've been discussing some issues with the CODA driver on gstreamer-devel and
the thread seems better suited to this list;

Here's a copy of what's been said thus far:

--------------------

I wrote:

I've located the cause of the "giant oops" I noted a couple of days ago.

because ctx->icc is recycled, it must be a valid or NULL pointer for kfree().

When an error occurs, the pointer is not reset to NULL, and kfree() crashes.

This helps:

@@ -208,10 +208,11 @@ static void ipu_scaler_work(struct work_struct *work)
          kfree(ctx->icc);
          ctx->icc = ipu_image_convert_prepare(ipu_scaler->ipu, &in,
                               &out, ctx->ctrl,
                               &ctx->num_tiles);
          if (IS_ERR(ctx->icc)) {
+            ctx->icc = NULL;
              schedule_work(&ctx->skip_run);
              return;
          }
      }

This fix "band-aids" it, but I don't think its complete, as IMO, this really
should result in gstreamer giving up, not displaying blank frames.

On the plus side, it does make the whole thing a lot more reliable.

It seems also like this case should be caught a lot earlier.

I've also noticed odd behaviour below width=480;  (height=272)

479: works
478: works
477: gstreamer errors out
476: works (but no video output)
475: ditto
747: ditto
743: gstreamer errors out

The error is:

0:00:00.284476334  1216   0xd01e30 ERROR          v4l2transform gstv4l2transform.c:239:gst_v4l2_transform_set_caps:<v4l2video0convert0> failed to set output caps: video/x-raw, pixel-aspect-ratio=(fraction)1/1, interlace-mode=(string)progressive, framerate=(fraction)24/1, format=(string)BGRx, width=(int)473, height=(int)272
ERROR: from element /GstPipeline:pipeline0/v4l2video0convert:v4l2video0convert0: Device '/dev/video0' cannot capture at 473x272
Additional debug info:
gstv4l2object.c(2967): gst_v4l2_object_set_format (): /GstPipeline:pipeline0/v4l2video0convert:v4l2video0convert0:
Tried to capture at 473x272, but device returned size 472x272
ERROR: pipeline doesn't want to preroll.

which smells like a shift or bitwise test thats not right.

I'm guessing 478 and 479 are rounding up to 480, but the others aren't.

--------------------------

Nicholas dufresne replied thus:

This is a famous case. The driver rounds middle, where only rounding up
can be managed by application. There is an RFC to add some flags to VB2
to let the driver decide what's ideal. When you crop, you want to round
down, when you allocate space, you want to round up (so one can crop on
top). The middle rounding is usually not very useful. I think this
discussion should move to linux-media ML.

--------------------------


So the question is what should be done about this?

-Ian
