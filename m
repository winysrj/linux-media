Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15764 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751268AbdLILuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Dec 2017 06:50:35 -0500
Date: Sat, 9 Dec 2017 19:49:35 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Sean Young <sean@mess.org>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [media-next:master 3023/3029] htmldocs: include/media/rc-core.h:96:
 warning: Excess struct member 'rawir' description in 'lirc_fh'
Message-ID: <201712091930.snTDSgDX%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/mchehab/media-next.git master
head:   ba815f198ca28764d3702d4401af91acf78d74c1
commit: 77bf465a4ffd7596f0367db74c571bb670ffdfb7 [3023/3029] media: lirc: allow lirc device to be opened more than once
reproduce: make htmldocs

All warnings (new ones prefixed by >>):


vim +96 include/media/rc-core.h

    70	
    71	/**
    72	 * struct lirc_fh - represents an open lirc file
    73	 * @list: list of open file handles
    74	 * @rc: rcdev for this lirc chardev
    75	 * @carrier_low: when setting the carrier range, first the low end must be
    76	 *	set with an ioctl and then the high end with another ioctl
    77	 * @send_timeout_reports: report timeouts in lirc raw IR.
    78	 * @rawir: queue for incoming raw IR
    79	 * @scancodes: queue for incoming decoded scancodes
    80	 * @wait_poll: poll struct for lirc device
    81	 * @send_mode: lirc mode for sending, either LIRC_MODE_SCANCODE or
    82	 *	LIRC_MODE_PULSE
    83	 * @rec_mode: lirc mode for receiving, either LIRC_MODE_SCANCODE or
    84	 *	LIRC_MODE_MODE2
    85	 */
    86	struct lirc_fh {
    87		struct list_head list;
    88		struct rc_dev *rc;
    89		int				carrier_low;
    90		bool				send_timeout_reports;
    91		DECLARE_KFIFO_PTR(rawir, unsigned int);
    92		DECLARE_KFIFO_PTR(scancodes, struct lirc_scancode);
    93		wait_queue_head_t		wait_poll;
    94		u8				send_mode;
    95		u8				rec_mode;
  > 96	};
    97	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
