Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:25545 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbcA0Poq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 10:44:46 -0500
Date: Wed, 27 Jan 2016 23:44:03 +0800
From: kbuild test robot <lkp@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/5] media: Always keep a graph walk large enough
 around
Message-ID: <201601272329.RRn1aH0N%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <1453906078-29087-3-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Sakari,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.5-rc1 next-20160127]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Sakari-Ailus/Unify-MC-graph-power-management-code/20160127-215417
base:   git://linuxtv.org/media_tree.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/linux/init.h:1: warning: no structured comments found
   kernel/sys.c:1: warning: no structured comments found
   drivers/dma-buf/seqno-fence.c:1: warning: no structured comments found
   drivers/dma-buf/reservation.c:1: warning: no structured comments found
   include/linux/reservation.h:1: warning: no structured comments found
>> include/media/media-device.h:334: warning: No description found for parameter 'pm_count_walk'
>> include/media/media-device.h:334: warning: No description found for parameter 'pm_count_walk'
   include/linux/spi/spi.h:540: warning: No description found for parameter 'max_transfer_size'

vim +/pm_count_walk +334 include/media/media-device.h

57cf79b7 Mauro Carvalho Chehab 2015-08-21  318  	struct list_head interfaces;
9155d859 Mauro Carvalho Chehab 2015-08-23  319  	struct list_head pads;
9155d859 Mauro Carvalho Chehab 2015-08-23  320  	struct list_head links;
53e269c1 Laurent Pinchart      2009-12-09  321  
a08fad1e Mauro Carvalho Chehab 2015-12-09  322  	/* Protects the graph objects creation/removal */
53e269c1 Laurent Pinchart      2009-12-09  323  	spinlock_t lock;
503c3d82 Laurent Pinchart      2010-03-07  324  	/* Serializes graph operations. */
503c3d82 Laurent Pinchart      2010-03-07  325  	struct mutex graph_mutex;
12c5791e Sakari Ailus          2016-01-27  326  	/*
12c5791e Sakari Ailus          2016-01-27  327  	 * Graph walk for power state walk. Access serialised using
12c5791e Sakari Ailus          2016-01-27  328  	 * graph_mutex.
12c5791e Sakari Ailus          2016-01-27  329  	 */
12c5791e Sakari Ailus          2016-01-27  330  	struct media_entity_graph pm_count_walk;
97548ed4 Laurent Pinchart      2009-12-09  331  
813f5c0a Sylwester Nawrocki    2013-05-31  332  	int (*link_notify)(struct media_link *link, u32 flags,
813f5c0a Sylwester Nawrocki    2013-05-31  333  			   unsigned int notification);
176fb0d1 Laurent Pinchart      2009-12-09 @334  };
176fb0d1 Laurent Pinchart      2009-12-09  335  
e576d60b Shuah Khan            2015-06-05  336  #ifdef CONFIG_MEDIA_CONTROLLER
e576d60b Shuah Khan            2015-06-05  337  
813f5c0a Sylwester Nawrocki    2013-05-31  338  /* Supported link_notify @notification values. */
813f5c0a Sylwester Nawrocki    2013-05-31  339  #define MEDIA_DEV_NOTIFY_PRE_LINK_CH	0
813f5c0a Sylwester Nawrocki    2013-05-31  340  #define MEDIA_DEV_NOTIFY_POST_LINK_CH	1
813f5c0a Sylwester Nawrocki    2013-05-31  341  
176fb0d1 Laurent Pinchart      2009-12-09  342  /* media_devnode to media_device */

:::::: The code at line 334 was first introduced by commit
:::::: 176fb0d108f7495ccf9aa127e1342a1a0d87e004 [media] media: Media device

:::::: TO: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--x+6KMIRAuhnl3hBn
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
F9AKr0z+ZmKXheA/6IG/MUpYAAA=

--x+6KMIRAuhnl3hBn--
