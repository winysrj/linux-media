Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36620 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655AbaGVR3X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 13:29:23 -0400
Date: Wed, 23 Jul 2014 01:28:31 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 499/499]
 drivers/media/usb/go7007/go7007-usb.c:699:30: sparse: cast to restricted
 __le16
Message-ID: <53ce9f3f.xH5US4eMBqUXCn9y%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   7955f03d18d14d18188f94581a4ea336c94b1e2d
commit: 7955f03d18d14d18188f94581a4ea336c94b1e2d [499/499] [media] go7007: move out of staging into drivers/media/usb.
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/usb/go7007/go7007-usb.c:699:30: sparse: cast to restricted __le16
>> drivers/media/usb/go7007/go7007-usb.c:769:38: sparse: cast to restricted __le16
>> drivers/media/usb/go7007/go7007-usb.c:770:39: sparse: cast to restricted __le16

vim +699 drivers/media/usb/go7007/go7007-usb.c

866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  693  				usb_rcvctrlpipe(usb->usbdev, 0), 0x14,
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  694  				USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
9b6ebf33 drivers/staging/media/go7007/go7007-usb.c Hans Verkuil          2013-03-09  695  				0, HPI_STATUS_ADDR, go->usb_buf,
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  696  				sizeof(status_reg), timeout);
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  697  		if (r < 0)
9b6ebf33 drivers/staging/media/go7007/go7007-usb.c Hans Verkuil          2013-03-09  698  			break;
9b6ebf33 drivers/staging/media/go7007/go7007-usb.c Hans Verkuil          2013-03-09 @699  		status_reg = le16_to_cpu(*((u16 *)go->usb_buf));
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  700  		if (!(status_reg & 0x0010))
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  701  			break;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  702  		msleep(10);
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  703  	}
9b6ebf33 drivers/staging/media/go7007/go7007-usb.c Hans Verkuil          2013-03-09  704  	if (r < 0)
9b6ebf33 drivers/staging/media/go7007/go7007-usb.c Hans Verkuil          2013-03-09  705  		goto write_int_error;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  706  	if (i == 100) {
44ee8e80 drivers/staging/media/go7007/go7007-usb.c Dulshani Gunawardhana 2013-10-20  707  		dev_err(go->dev, "device is hung, status reg = 0x%04x\n", status_reg);
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  708  		return -1;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  709  	}
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  710  	r = usb_control_msg(usb->usbdev, usb_sndctrlpipe(usb->usbdev, 0), 0x12,
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  711  			USB_TYPE_VENDOR | USB_RECIP_DEVICE, data,
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  712  			INT_PARAM_ADDR, NULL, 0, timeout);
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  713  	if (r < 0)
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  714  		goto write_int_error;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  715  	r = usb_control_msg(usb->usbdev, usb_sndctrlpipe(usb->usbdev, 0),
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  716  			0x12, USB_TYPE_VENDOR | USB_RECIP_DEVICE, addr,
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  717  			INT_INDEX_ADDR, NULL, 0, timeout);
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  718  	if (r < 0)
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  719  		goto write_int_error;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  720  	return 0;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  721  
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  722  write_int_error:
44ee8e80 drivers/staging/media/go7007/go7007-usb.c Dulshani Gunawardhana 2013-10-20  723  	dev_err(go->dev, "error in WriteInterrupt: %d\n", r);
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  724  	return r;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  725  }
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  726  
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  727  static int go7007_usb_onboard_write_interrupt(struct go7007 *go,
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  728  						int addr, int data)
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  729  {
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  730  	struct go7007_usb *usb = go->hpi_context;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  731  	int r;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  732  	int timeout = 500;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  733  
66a528c1 drivers/staging/media/go7007/go7007-usb.c Greg Kroah-Hartman    2013-11-25  734  	pr_debug("WriteInterrupt: %04x %04x\n", addr, data);
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  735  
9b6ebf33 drivers/staging/media/go7007/go7007-usb.c Hans Verkuil          2013-03-09  736  	go->usb_buf[0] = data & 0xff;
9b6ebf33 drivers/staging/media/go7007/go7007-usb.c Hans Verkuil          2013-03-09  737  	go->usb_buf[1] = data >> 8;
9b6ebf33 drivers/staging/media/go7007/go7007-usb.c Hans Verkuil          2013-03-09  738  	go->usb_buf[2] = addr & 0xff;
9b6ebf33 drivers/staging/media/go7007/go7007-usb.c Hans Verkuil          2013-03-09  739  	go->usb_buf[3] = addr >> 8;
9b6ebf33 drivers/staging/media/go7007/go7007-usb.c Hans Verkuil          2013-03-09  740  	go->usb_buf[4] = go->usb_buf[5] = go->usb_buf[6] = go->usb_buf[7] = 0;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  741  	r = usb_control_msg(usb->usbdev, usb_sndctrlpipe(usb->usbdev, 2), 0x00,
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  742  			USB_TYPE_VENDOR | USB_RECIP_ENDPOINT, 0x55aa,
9b6ebf33 drivers/staging/media/go7007/go7007-usb.c Hans Verkuil          2013-03-09  743  			0xf0f0, go->usb_buf, 8, timeout);
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  744  	if (r < 0) {
44ee8e80 drivers/staging/media/go7007/go7007-usb.c Dulshani Gunawardhana 2013-10-20  745  		dev_err(go->dev, "error in WriteInterrupt: %d\n", r);
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  746  		return r;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  747  	}
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  748  	return 0;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  749  }
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  750  
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  751  static void go7007_usb_readinterrupt_complete(struct urb *urb)
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  752  {
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  753  	struct go7007 *go = (struct go7007 *)urb->context;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  754  	u16 *regs = (u16 *)urb->transfer_buffer;
9efb0525 drivers/staging/go7007/go7007-usb.c       Oliver Neukum         2008-12-18  755  	int status = urb->status;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  756  
9efb0525 drivers/staging/go7007/go7007-usb.c       Oliver Neukum         2008-12-18  757  	if (status) {
9efb0525 drivers/staging/go7007/go7007-usb.c       Oliver Neukum         2008-12-18  758  		if (status != -ESHUTDOWN &&
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  759  				go->status != STATUS_SHUTDOWN) {
44ee8e80 drivers/staging/media/go7007/go7007-usb.c Dulshani Gunawardhana 2013-10-20  760  			dev_err(go->dev, "error in read interrupt: %d\n", urb->status);
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  761  		} else {
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  762  			wake_up(&go->interrupt_waitq);
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  763  			return;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  764  		}
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  765  	} else if (urb->actual_length != urb->transfer_buffer_length) {
44ee8e80 drivers/staging/media/go7007/go7007-usb.c Dulshani Gunawardhana 2013-10-20  766  		dev_err(go->dev, "short read in interrupt pipe!\n");
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  767  	} else {
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  768  		go->interrupt_available = 1;
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15 @769  		go->interrupt_data = __le16_to_cpu(regs[0]);
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15 @770  		go->interrupt_value = __le16_to_cpu(regs[1]);
66a528c1 drivers/staging/media/go7007/go7007-usb.c Greg Kroah-Hartman    2013-11-25  771  		pr_debug("ReadInterrupt: %04x %04x\n",
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  772  				go->interrupt_value, go->interrupt_data);
866b8695 drivers/staging/go7007/go7007-usb.c       Greg Kroah-Hartman    2008-02-15  773  	}

:::::: The code at line 699 was first introduced by commit
:::::: 9b6ebf3309d1b2e62727133b446397a783813331 [media] go7007: fix DMA related errors

:::::: TO: Hans Verkuil <hans.verkuil@cisco.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
