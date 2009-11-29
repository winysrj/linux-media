Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:23930 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZK2QA1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 11:00:27 -0500
Received: by ey-out-2122.google.com with SMTP id 4so748136eyf.19
        for <linux-media@vger.kernel.org>; Sun, 29 Nov 2009 08:00:33 -0800 (PST)
Date: Sun, 29 Nov 2009 18:00:34 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org
Subject: bttv locking problem
Message-ID: <20091129160034.GK10640@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I did a smatch static checker run and found a double unlock in 
bttv-driver.c.
drivers/media/video/bt8xx/bttv-driver.c +3203 bttv_poll() error: double unlock '&fh->cap.vb_lock'
I would fix it myself, but I don't know if the poll_wait() is supposed
to be protected by mutex_unlock(&fh->cap.vb_lock) or not.

drivers/media/video/bt8xx/bttv-driver.c
  3192                  mutex_unlock(&fh->cap.vb_lock);
  3193                  buf = (struct bttv_buffer*)fh->cap.read_buf;
  3194          }
  3195
  3196          poll_wait(file, &buf->vb.done, wait);
  3197          if (buf->vb.state == VIDEOBUF_DONE ||
  3198              buf->vb.state == VIDEOBUF_ERROR)
  3199                  rc =  POLLIN|POLLRDNORM;
  3200          else
  3201                  rc = 0;
  3202  err:
  3203          mutex_unlock(&fh->cap.vb_lock);

regards,
dan carpenter
