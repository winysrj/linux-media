Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:46771 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab3KNNIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Nov 2013 08:08:21 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MW900H2G8HOFY80@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Nov 2013 08:08:20 -0500 (EST)
Date: Thu, 14 Nov 2013 11:08:14 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Fw: staging: media: Use dev_err() instead of pr_err()
Message-id: <20131114110814.6b13f62b@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm not sure how this patch got applied upstream:

	commit b6ea5ef80aa7fd6f4b18ff2e4174930e8772e812
	Author: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
	Date:   Sun Oct 20 22:58:28 2013 +0530
	
	    staging:media: Use dev_dbg() instead of pr_debug()
	    
	    Use dev_dbg() instead of pr_debug() in go7007-usb.c.
    
	    Signed-off-by: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
	    Reviewed-by: Josh Triplett <josh@joshtriplett.org>
	    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

But, from the custody chain, it seems it was not C/C to linux-media ML,
doesn't have the driver maintainer's ack[1] and didn't went via my tree.

[1] Dulshani, please next time run the get_maintainer.pl script to get the
proper maintainers:
	$ /scripts/get_maintainer.pl -f drivers/staging/media/go7007/go7007-usb.c
	Hans Verkuil <hans.verkuil@cisco.com> (maintainer:STAGING - GO7007...)
	Mauro Carvalho Chehab <m.chehab@samsung.com> (maintainer:MEDIA INPUT INFRA...)
	Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:STAGING SUBSYSTEM)
	linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...)
	devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM)

Anyway, this patch is clearly wrong, and will cause an OOPS if CONFIG_DEBUG is 
enabled, during device probing, because of this change:

@@ -1052,21 +1050,21 @@ static int go7007_usb_probe(struct usb_interface *intf,
                const struct usb_device_id *id)
 {
        struct go7007 *go;
        struct go7007_usb *usb;
        const struct go7007_usb_board *board;
        struct usb_device *usbdev = interface_to_usbdev(intf);
        unsigned num_i2c_devs;
        char *name;
        int video_pipe, i, v_urb_len;
 
-       pr_debug("probing new GO7007 USB board\n");
+       dev_dbg(go->dev, "probing new GO7007 USB board\n");
 
        switch (id->driver_info) {
        case GO7007_BOARDID_MATRIX_II:
                name = "WIS Matrix II or compatible";
                board = &board_matrix_ii;
                break;
        case GO7007_BOARDID_MATRIX_RELOAD:
                name = "WIS Matrix Reloaded or compatible";
                board = &board_matrix_reload;
                break;


As it will try to de-reference the uninitialized "go" struct go7007_usb
pointer.

The alternative of mixing pr_debug with dev_debug, as Dan is suggesting
is, IMHO, worse, as it will lack coherency on the usage of printk
macros inside the driver.

So, I think we should just revert this patch.

Comments?

Regards,
Mauro

Forwarded message:

Date: Tue, 5 Nov 2013 23:26:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: dulshani.gunawardhana89@gmail.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: re: staging: media: Use dev_err() instead of pr_err()


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

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
