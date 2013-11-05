Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36963 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab3KEU0R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 15:26:17 -0500
Date: Tue, 5 Nov 2013 23:26:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: dulshani.gunawardhana89@gmail.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: re: staging: media: Use dev_err() instead of pr_err()
Message-ID: <20131105202605.GH3949@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Dulshani Gunawardhana,

The patch 44ee8e801137: "staging: media: Use dev_err() instead of 
pr_err()" from Oct 20, 2013, leads to the following
GCC warning: 

drivers/staging/media/go7007/go7007-usb.c: In function ‘go7007_usb_probe’:
drivers/staging/media/go7007/go7007-usb.c:1100:13: warning: ‘go’ may be used uninitialized in this function [-Wuninitialized]

drivers/staging/media/go7007/go7007-usb.c
  1049  static int go7007_usb_probe(struct usb_interface *intf,
  1050                  const struct usb_device_id *id)
  1051  {
  1052          struct go7007 *go;
  1053          struct go7007_usb *usb;
  1054          const struct go7007_usb_board *board;
  1055          struct usb_device *usbdev = interface_to_usbdev(intf);
  1056          unsigned num_i2c_devs;
  1057          char *name;
  1058          int video_pipe, i, v_urb_len;
  1059  
  1060          dev_dbg(go->dev, "probing new GO7007 USB board\n");
                        ^^^^^^^
  1061  
  1062          switch (id->driver_info) {
  1063          case GO7007_BOARDID_MATRIX_II:
  1064                  name = "WIS Matrix II or compatible";
  1065                  board = &board_matrix_ii;
  1066                  break;

There are several other uses of "go" before it has been initialized.

Probably you will just want to change these back to pr_info().  Some of
the messages are not very useful like:
	dev_info(go->dev, "Sensoray 2250 found\n");
You can delete that one.

regards,
dan carpenter

