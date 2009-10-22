Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467AbZJVNvc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2009 09:51:32 -0400
Date: Thu, 22 Oct 2009 15:51:21 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, eric.dumazet@gmail.com,
	jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
	bruce.w.allan@intel.com, peter.p.waskiewicz.jr@intel.com,
	john.ronciak@intel.com, e1000-devel@lists.sourceforge.net,
	mchehab@infradead.org, linux-media@vger.kernel.org
Subject: [PATCH net-next-2.6 0/4] net: change the way mc_list is accessed
Message-ID: <20091022135120.GC2868@psychotron.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In a struct net_device, multicast addresses are stored using a self-made linked
list. To convert this to list_head list there would be needed to do the change
in all (literally all) network device drivers at once.

To solve this situation and also to make device drivers' code prettier I'm
introducing several multicast list helpers which can (and in the future they
should) be used to access mc list. Once all drivers will use these helpers,
we can easily convert to list_head.

The part of this patchset are also 3 examples of a usage of the helpers.

Kindly asking for review.

Thanks,

Jirka
