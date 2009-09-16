Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:57108 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZIPLMn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 07:12:43 -0400
Date: Wed, 16 Sep 2009 13:13:26 +0200
From: Janne Grunau <j@jannau.net>
To: Julia Lawall <julia@diku.dk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/8] drivers/media/video/hdpvr: introduce missing kfree
Message-ID: <20090916111325.GA14900@aniel.lan>
References: <Pine.LNX.4.64.0909111821180.10552@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909111821180.10552@pc-004.diku.dk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 11, 2009 at 06:21:35PM +0200, Julia Lawall wrote:
> 
> Error handling code following a kzalloc should free the allocated data.

Thanks for the report. I'll commit a different patch which adds the buffer
to the buffer list as soon it is allocated. The hdpvr_free_buffers() in the
error handling code will clean it up then. See below:

diff --git a/linux/drivers/media/video/hdpvr/hdpvr-video.c b/linux/drivers/media/video/hdpvr/hdpvr-video.c
--- a/linux/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/linux/drivers/media/video/hdpvr/hdpvr-video.c
@@ -134,6 +134,8 @@
                        v4l2_err(&dev->v4l2_dev, "cannot allocate buffer\n");
                        goto exit;
                }
+               list_add_tail(&buf->buff_list, &dev->free_buff_list);
+
                buf->dev = dev;

                urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -158,7 +160,6 @@
                                  hdpvr_read_bulk_callback, buf);

                buf->status = BUFSTAT_AVAILABLE;
-               list_add_tail(&buf->buff_list, &dev->free_buff_list);
        }
        return 0;
 exit:
