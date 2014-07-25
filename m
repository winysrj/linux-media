Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19185 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaGYMWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 08:22:23 -0400
Date: Fri, 25 Jul 2014 15:21:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: crope@iki.fi
Cc: linux-media@vger.kernel.org
Subject: re: msi2500: move msi3101 out of staging and rename
Message-ID: <20140725122152.GD528@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Antti Palosaari,

The patch fd8b5f502929: "msi2500: move msi3101 out of staging and
rename" from Jul 13, 2014, leads to the following static checker
warning:

drivers/media/usb/msi2500/msi2500.c:887 msi2500_stop_streaming()
	 error: we previously assumed 's->udev' could be null (see line 880)

drivers/media/usb/msi2500/msi2500.c
   872  static void msi2500_stop_streaming(struct vb2_queue *vq)
   873  {
   874          struct msi2500_state *s = vb2_get_drv_priv(vq);
   875  
   876          dev_dbg(&s->udev->dev, "%s:\n", __func__);
   877  
   878          mutex_lock(&s->v4l2_lock);
   879  
   880          if (s->udev)
                    ^^^^^^^
Check.

   881                  msi2500_isoc_cleanup(s);
   882  
   883          msi2500_cleanup_queued_bufs(s);
   884  
   885          /* according to tests, at least 700us delay is required  */
   886          msleep(20);
   887          if (!msi2500_ctrl_msg(s, CMD_STOP_STREAMING, 0)) {
                     ^^^^^^^^^^^^^^^^^^
Unchecked dereference if you have debugging enabled.

   888                  /* sleep USB IF / ADC */
   889                  msi2500_ctrl_msg(s, CMD_WREG, 0x01000003);
   890          }

regards,
dan carpenter
