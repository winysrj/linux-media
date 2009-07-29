Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:35957 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZG2XnG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 19:43:06 -0400
Date: Wed, 29 Jul 2009 16:43:05 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Dan Carpenter <error27@gmail.com>
cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: double unlock in bttv_poll() and in saa7134-video.c
In-Reply-To: <alpine.DEB.2.00.0907191613250.12306@bicker>
Message-ID: <Pine.LNX.4.58.0907291629210.11911@shell2.speakeasy.net>
References: <alpine.DEB.2.00.0907191613250.12306@bicker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 25 Jul 2009, Dan Carpenter wrote:
> My source code checker, smatch (http://repo.or.cz/w/smatch.git),
> complains about a double unlock in bttv_poll() from
> drivers/media/video/bt8xx/bttv-driver.c.  It unlocks on line 3190 and
> again on 3201.

How about this:

http://linuxtv.org/hg/~tap/bttv?cmd=changeset;node=35ddb77b68f8

diff -r fd96af63f79b -r 35ddb77b68f8 linux/drivers/media/video/bt8xx/bttv-driver.c
--- a/linux/drivers/media/video/bt8xx/bttv-driver.c     Fri Jun 19 19:56:56 2009 +0000
+++ b/linux/drivers/media/video/bt8xx/bttv-driver.c     Wed Jul 29 16:33:45 2009 -0700
@@ -3191,15 +3191,14 @@ static unsigned int bttv_poll(struct fil
                return videobuf_poll_stream(file, &fh->vbi, wait);
        }

+       mutex_lock(&fh->cap.vb_lock);
        if (check_btres(fh,RESOURCE_VIDEO_STREAM)) {
-               mutex_lock(&fh->cap.vb_lock);
                /* streaming capture */
                if (list_empty(&fh->cap.stream))
                        goto err;
                buf = list_entry(fh->cap.stream.next,struct bttv_buffer,vb.stream);
        } else {
                /* read() capture */
-               mutex_lock(&fh->cap.vb_lock);
                if (NULL == fh->cap.read_buf) {
                        /* need to capture a new frame */
                        if (locked_btres(fh->btv,RESOURCE_VIDEO_STREAM))
@@ -3217,7 +3216,6 @@ static unsigned int bttv_poll(struct fil
                        fh->cap.ops->buf_queue(&fh->cap,fh->cap.read_buf);
                        fh->cap.read_off = 0;
                }
-               mutex_unlock(&fh->cap.vb_lock);
                buf = (struct bttv_buffer*)fh->cap.read_buf;
        }

