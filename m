Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56681 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaLQDWr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Dec 2014 22:22:47 -0500
Date: Wed, 17 Dec 2014 11:22:02 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [linuxtv-media:master 7740/7741]
 drivers/staging/media/tlg2300/pd-main.c:81 send_set_req() error: doing dma
 on the stack (&data)
Message-ID: <201412171158.Z7PG4Zhx%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   427ae153c65ad7a08288d86baf99000569627d03
commit: ea2e813e8cc3492c951b9895724fd47187e04a6f [7740/7741] [media] tlg2300: move to staging in preparation for removal

drivers/staging/media/tlg2300/pd-main.c:81 send_set_req() error: doing dma on the stack (&data)
drivers/staging/media/tlg2300/pd-main.c:121 send_get_req() error: doing dma on the stack (&data)

vim +81 drivers/staging/media/tlg2300/pd-main.c

5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   75  		upper_16 = lower_16 = 0;
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   76  	} else {
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   77  		/* send 32 bit param as  two 16 bit param,little endian */
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   78  		lower_16 = (unsigned short)(param & 0xffff);
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   79  		upper_16 = (unsigned short)((param >> 16) & 0xffff);
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   80  	}
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  @81  	ret = usb_control_msg(pd->udev,
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   82  			 usb_rcvctrlpipe(pd->udev, 0),
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   83  			 REQ_SET_CMD | cmdid,
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   84  			 USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   85  			 lower_16,
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   86  			 upper_16,
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   87  			 &data,
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   88  			 sizeof(*cmd_status),
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   89  			 USB_CTRL_GET_TIMEOUT);
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   90  
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   91  	if (!ret) {
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   92  		return -ENXIO;
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   93  	} else {
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   94  		/*  1st 4 bytes into cmd_status   */
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   95  		memcpy((char *)cmd_status, &(data[0]), sizeof(*cmd_status));
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   96  	}
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   97  	return 0;
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   98  }
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02   99  
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  100  /*
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  101   * send get request to Poseidon firmware.
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  102   */
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  103  s32 send_get_req(struct poseidon *pd, u8 cmdid, s32 param,
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  104  			void *buf, s32 *cmd_status, s32 datalen)
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  105  {
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  106  	s32 ret;
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  107  	s8 data[128] = {};
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  108  	u16 lower_16, upper_16;
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  109  
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  110  	if (pd->state & POSEIDON_STATE_DISCONNECT)
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  111  		return -ENODEV;
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  112  
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  113  	mdelay(30);
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  114  	if (param == 0) {
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  115  		upper_16 = lower_16 = 0;
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  116  	} else {
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  117  		/*send 32 bit param as two 16 bit param, little endian */
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  118  		lower_16 = (unsigned short)(param & 0xffff);
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  119  		upper_16 = (unsigned short)((param >> 16) & 0xffff);
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  120  	}
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02 @121  	ret = usb_control_msg(pd->udev,
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  122  			 usb_rcvctrlpipe(pd->udev, 0),
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  123  			 REQ_GET_CMD | cmdid,
5b3f03f0 drivers/media/video/tlg2300/pd-main.c Huang Shijie 2010-02-02  124  			 USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,

:::::: The code at line 81 was first introduced by commit
:::::: 5b3f03f044ad6dffc8cd8c9c50bc5d7769cbd89f V4L/DVB: Add driver for Telegent tlg2300

:::::: TO: Huang Shijie <shijie8@gmail.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
