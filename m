Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24359 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab3BGKpA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 05:45:00 -0500
Date: Thu, 7 Feb 2013 13:44:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] tm6000: add support for control events and prio handling
Message-ID: <20130207104454.GA466@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans Verkuil,

The patch 770056c47fbb: "[media] tm6000: add support for control
events and prio handling" from Sep 11, 2012, leads to the following
Smatch warning:
"drivers/media/usb/tm6000/tm6000-video.c:1462 __tm6000_poll()
	 error: potentially dereferencing uninitialized 'buf'."

drivers/media/usb/tm6000/tm6000-video.c
  1453          if (!is_res_read(fh->dev, fh)) {
  1454                  /* streaming capture */
  1455                  if (list_empty(&fh->vb_vidq.stream))
  1456                          return res | POLLERR;
  1457                  buf = list_entry(fh->vb_vidq.stream.next, struct tm6000_buffer, vb.stream);
  1458          } else if (req_events & (POLLIN | POLLRDNORM)) {
  1459                  /* read() capture */
  1460                  return res | videobuf_poll_stream(file, &fh->vb_vidq, wait);
  1461          }

If we don't hit either side of the if else statement then buf is
uninitialized.

  1462          poll_wait(file, &buf->vb.done, wait);
  1463          if (buf->vb.state == VIDEOBUF_DONE ||
  1464              buf->vb.state == VIDEOBUF_ERROR)
  1465                  return res | POLLIN | POLLRDNORM;
  1466          return res;

regards,
dan carpenter

