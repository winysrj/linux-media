Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17929 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578AbbJUU40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2015 16:56:26 -0400
Date: Wed, 21 Oct 2015 23:56:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: crope@iki.fi
Cc: linux-media@vger.kernel.org
Subject: re: [media] hackrf: add support for transmitter
Message-ID: <20151021205605.GE9839@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Antti Palosaari,

The patch 8bc4a9ed8504: "[media] hackrf: add support for transmitter"
from Oct 10, 2015, leads to the following static checker warning:

	drivers/media/usb/hackrf/hackrf.c:1533 hackrf_probe()
	error: we previously assumed 'dev' could be null (see line 1366)

drivers/media/usb/hackrf/hackrf.c
  1520          dev_notice(dev->dev, "SDR API is still slightly experimental and functionality changes may follow\n");
  1521          return 0;
  1522  err_video_unregister_device_rx:
  1523          video_unregister_device(&dev->rx_vdev);
  1524  err_v4l2_device_unregister:
  1525          v4l2_device_unregister(&dev->v4l2_dev);
  1526  err_v4l2_ctrl_handler_free_tx:
  1527          v4l2_ctrl_handler_free(&dev->tx_ctrl_handler);
  1528  err_v4l2_ctrl_handler_free_rx:
  1529          v4l2_ctrl_handler_free(&dev->rx_ctrl_handler);
  1530  err_kfree:
  1531          kfree(dev);
  1532  err:
  1533          dev_dbg(dev->dev, "failed=%d\n", ret);
                        ^^^
"dev" is either freed or NULL.  Also this change is basically unrelated
to adding transmitter support...  :/

  1534          return ret;
  1535  }

regards,
dan carpenter
