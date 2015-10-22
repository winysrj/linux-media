Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19933 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbbJVIql (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2015 04:46:41 -0400
Date: Thu, 22 Oct 2015 11:46:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] go7007: don't continue if firmware can't be loaded
Message-ID: <20151022084634.GA8196@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans Verkuil,

The patch 59aea928d57f: "[media] go7007: don't continue if firmware
can't be loaded" from Mar 17, 2013, leads to the following static
checker warning:

	drivers/media/usb/go7007/go7007-usb.c:1292 go7007_usb_probe()
	warn: we tested 'board->flags & (1 << 0)' before and it was 'true'

drivers/media/usb/go7007/go7007-usb.c
  1289  
  1290          /* Allocate the URBs and buffers for receiving the audio stream */
  1291          if ((board->flags & GO7007_USB_EZUSB) &&
  1292              (board->flags & GO7007_BOARD_HAS_AUDIO)) {

We used to test "go->audio_enabled" enabled here.  The GO7007_USB_EZUSB
and GO7007_BOARD_HAS_AUDIO are different names for BIT(0).

  1293                  for (i = 0; i < 8; ++i) {
  1294                          usb->audio_urbs[i] = usb_alloc_urb(0, GFP_KERNEL);
  1295                          if (usb->audio_urbs[i] == NULL)
  1296                                  goto allocfail;
  1297                          usb->audio_urbs[i]->transfer_buffer = kmalloc(4096,
  1298                                                                  GFP_KERNEL);
  1299                          if (usb->audio_urbs[i]->transfer_buffer == NULL)
  1300                                  goto allocfail;
  1301                          usb_fill_bulk_urb(usb->audio_urbs[i], usb->usbdev,
  1302                                  usb_rcvbulkpipe(usb->usbdev, 8),
  1303                                  usb->audio_urbs[i]->transfer_buffer, 4096,
  1304                                  go7007_usb_read_audio_pipe_complete, go);
  1305                  }
  1306          }


regards,
dan carpenter
