Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:34515 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbZGYMWs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 08:22:48 -0400
Received: by ewy26 with SMTP id 26so2271344ewy.37
        for <linux-media@vger.kernel.org>; Sat, 25 Jul 2009 05:22:46 -0700 (PDT)
Date: Sat, 25 Jul 2009 15:22:38 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
To: mchehab@infradead.org
cc: linux-media@vger.kernel.org
Subject: double unlock in bttv_poll() and in saa7134-video.c
Message-ID: <alpine.DEB.2.00.0907191613250.12306@bicker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

My source code checker, smatch (http://repo.or.cz/w/smatch.git), 
complains about a double unlock in bttv_poll() from 
drivers/media/video/bt8xx/bttv-driver.c.  It unlocks on line 3190 and 
again on 3201.

  3190                  mutex_unlock(&fh->cap.vb_lock);
  3191                  buf = (struct bttv_buffer*)fh->cap.read_buf;
  3192          }
  3193  
  3194          poll_wait(file, &buf->vb.done, wait);
  3195          if (buf->vb.state == VIDEOBUF_DONE ||
  3196              buf->vb.state == VIDEOBUF_ERROR)
  3197                  rc =  POLLIN|POLLRDNORM;
  3198          else
  3199                  rc = 0;
  3200  err:
  3201          mutex_unlock(&fh->cap.vb_lock);

I looked at the code but I wasn't sure what the correct way to fix it is.

video_poll() from drivers/media/video/saa7134/saa7134-video.c has the same 
issue.

regards,
dan carpenter


