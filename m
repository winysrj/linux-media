Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65299 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752516AbcKRWth (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 17:49:37 -0500
Date: Sat, 19 Nov 2016 06:48:53 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Max Kellermann <max.kellermann@gmail.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [linuxtv-media:master 879/885] htmldocs:
 drivers/media/dvb-core/dvb_frontend.h:684: warning: No description found for
 parameter 'refcount'
Message-ID: <201611190639.EUqIsFWi%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://linuxtv.org/media_tree.git master
head:   c044170fcfca3783f7dd8eb69ff8b06d66fad5d8
commit: 1f862a68df2449bc7b1cf78dce616891697b4bdf [879/885] [media] dvb_frontend: move kref to struct dvb_frontend
reproduce: make htmldocs; make DOCBOOKS='' pdfdocs

All warnings (new ones prefixed by >>):

   make[3]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
   include/linux/init.h:1: warning: no structured comments found
   include/linux/workqueue.h:392: warning: No description found for parameter '...'
   include/linux/workqueue.h:392: warning: Excess function parameter 'args' description in 'alloc_workqueue'
   include/linux/workqueue.h:413: warning: No description found for parameter '...'
   include/linux/workqueue.h:413: warning: Excess function parameter 'args' description in 'alloc_ordered_workqueue'
   include/linux/kthread.h:26: warning: No description found for parameter '...'
   kernel/sys.c:1: warning: no structured comments found
   drivers/dma-buf/seqno-fence.c:1: warning: no structured comments found
   include/linux/fence-array.h:61: warning: No description found for parameter 'fence'
   include/sound/core.h:324: warning: No description found for parameter '...'
   include/sound/core.h:335: warning: No description found for parameter '...'
   include/sound/core.h:388: warning: No description found for parameter '...'
   drivers/media/dvb-core/dvb_frontend.h:274: warning: No description found for parameter 'fe'
>> drivers/media/dvb-core/dvb_frontend.h:684: warning: No description found for parameter 'refcount'
   include/media/media-entity.h:1054: warning: No description found for parameter '...'
   include/net/mac80211.h:3207: ERROR: Unexpected indentation.
   include/net/mac80211.h:3210: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/net/mac80211.h:3212: ERROR: Unexpected indentation.
   include/net/mac80211.h:3213: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/net/mac80211.h:1772: ERROR: Unexpected indentation.
   include/net/mac80211.h:1776: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/sched/fair.c:7259: WARNING: Inline emphasis start-string without end-string.
   kernel/time/timer.c:1240: ERROR: Unexpected indentation.
   kernel/time/timer.c:1242: ERROR: Unexpected indentation.
   kernel/time/timer.c:1243: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:121: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:124: ERROR: Unexpected indentation.
   include/linux/wait.h:126: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/time/hrtimer.c:1021: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/signal.c:317: WARNING: Inline literal start-string without end-string.
   drivers/base/firmware_class.c:1348: WARNING: Bullet list ends without a blank line; unexpected unindent.
   drivers/message/fusion/mptbase.c:5054: WARNING: Definition list ends without a blank line; unexpected unindent.
   drivers/tty/serial/serial_core.c:1893: WARNING: Definition list ends without a blank line; unexpected unindent.
   include/linux/spi/spi.h:369: ERROR: Unexpected indentation.
   WARNING: dvipng command 'dvipng' cannot be run (needed for math display), check the imgmath_dvipng setting

vim +/refcount +684 drivers/media/dvb-core/dvb_frontend.h

35848bf0 drivers/media/dvb-core/dvb_frontend.h     Mauro Carvalho Chehab 2015-08-22  668  
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.h Linus Torvalds        2005-04-16  669  struct dvb_frontend {
1f862a68 drivers/media/dvb-core/dvb_frontend.h     Max Kellermann        2016-08-09  670  	struct kref refcount;
dea74869 drivers/media/dvb/dvb-core/dvb_frontend.h Patrick Boettcher     2006-05-14  671  	struct dvb_frontend_ops ops;
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.h Linus Torvalds        2005-04-16  672  	struct dvb_adapter *dvb;
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.h Linus Torvalds        2005-04-16  673  	void *demodulator_priv;
7eef5dd6 drivers/media/dvb/dvb-core/dvb_frontend.h Andrew de Quincey     2006-04-18  674  	void *tuner_priv;
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.h Linus Torvalds        2005-04-16  675  	void *frontend_priv;
94cbae5a drivers/media/dvb/dvb-core/dvb_frontend.h Andrew de Quincey     2006-08-08  676  	void *sec_priv;
16f29168 drivers/media/dvb/dvb-core/dvb_frontend.h Michael Krufky        2007-10-21  677  	void *analog_demod_priv;
56f0680a drivers/media/dvb/dvb-core/dvb_frontend.h Steven Toth           2008-09-11  678  	struct dtv_frontend_properties dtv_property_cache;
ebb8d68a drivers/media/dvb/dvb-core/dvb_frontend.h Michael Krufky        2008-09-10  679  #define DVB_FRONTEND_COMPONENT_TUNER 0
b748e6a9 drivers/media/dvb/dvb-core/dvb_frontend.h Antti Palosaari       2012-01-10  680  #define DVB_FRONTEND_COMPONENT_DEMOD 1
ebb8d68a drivers/media/dvb/dvb-core/dvb_frontend.h Michael Krufky        2008-09-10  681  	int (*callback)(void *adapter_priv, int component, int cmd, int arg);
363c35fc drivers/media/dvb/dvb-core/dvb_frontend.h Steven Toth           2008-10-11  682  	int id;
18ed2860 drivers/media/dvb-core/dvb_frontend.h     Shuah Khan            2014-07-12  683  	unsigned int exit;
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.h Linus Torvalds        2005-04-16 @684  };
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.h Linus Torvalds        2005-04-16  685  
66f4b3cb drivers/media/dvb-core/dvb_frontend.h     Mauro Carvalho Chehab 2015-11-10  686  /**
66f4b3cb drivers/media/dvb-core/dvb_frontend.h     Mauro Carvalho Chehab 2015-11-10  687   * dvb_register_frontend() - Registers a DVB frontend at the adapter
66f4b3cb drivers/media/dvb-core/dvb_frontend.h     Mauro Carvalho Chehab 2015-11-10  688   *
66f4b3cb drivers/media/dvb-core/dvb_frontend.h     Mauro Carvalho Chehab 2015-11-10  689   * @dvb: pointer to the dvb adapter
66f4b3cb drivers/media/dvb-core/dvb_frontend.h     Mauro Carvalho Chehab 2015-11-10  690   * @fe: pointer to the frontend struct
66f4b3cb drivers/media/dvb-core/dvb_frontend.h     Mauro Carvalho Chehab 2015-11-10  691   *
66f4b3cb drivers/media/dvb-core/dvb_frontend.h     Mauro Carvalho Chehab 2015-11-10  692   * Allocate and initialize the private data needed by the frontend core to

:::::: The code at line 684 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--sdtB3X0nJg68CQEu
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--sdtB3X0nJg68CQEu--
