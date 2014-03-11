Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22822 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390AbaCKKsz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 06:48:55 -0400
Date: Tue, 11 Mar 2014 18:48:53 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:master 499/499]
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h:22:0: error: unterminated
 #ifndef
Message-ID: <531eea15.KJn7IlN6hvOVHxI/%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   164e5cfb7d37e4826a8337029716f4885657d859
commit: 164e5cfb7d37e4826a8337029716f4885657d859 [499/499] [media] drx39xxj.h: Fix undefined reference to attach function
config: make ARCH=m68k allmodconfig

All error/warnings:

   In file included from drivers/media/usb/em28xx/em28xx-dvb.c:44:0:
>> drivers/media/dvb-frontends/drx39xyj/drx39xxj.h:22:0: error: unterminated #ifndef

vim +22 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h

38b2df95 Devin Heitmueller 2012-08-13  16   *
38b2df95 Devin Heitmueller 2012-08-13  17   *  You should have received a copy of the GNU General Public License
38b2df95 Devin Heitmueller 2012-08-13  18   *  along with this program; if not, write to the Free Software
38b2df95 Devin Heitmueller 2012-08-13  19   *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=
38b2df95 Devin Heitmueller 2012-08-13  20   */
38b2df95 Devin Heitmueller 2012-08-13  21  
38b2df95 Devin Heitmueller 2012-08-13 @22  #ifndef DRX39XXJ_H
38b2df95 Devin Heitmueller 2012-08-13  23  #define DRX39XXJ_H
38b2df95 Devin Heitmueller 2012-08-13  24  
38b2df95 Devin Heitmueller 2012-08-13  25  #include <linux/dvb/frontend.h>

:::::: The code at line 22 was first introduced by commit
:::::: 38b2df95c53be4bd5421d933ca0dabbcb82741d0 [media] drx-j: add a driver for Trident drx-j frontend

:::::: TO: Devin Heitmueller <dheitmueller@kernellabs.com>
:::::: CC: Mauro Carvalho Chehab <m.chehab@samsung.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
