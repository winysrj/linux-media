Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40817 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475AbaAHImX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 03:42:23 -0500
Date: Wed, 8 Jan 2014 11:37:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [kbuild-all] [linuxtv-media:master 499/499]
 drivers/media/i2c/s5k5baf.c:362:3: warning: format '%d' expects argument of
 type 'int', but argument 3 has type 'size_t'
Message-ID: <20140108083736.GA27840@mwanda>
References: <52b94458.53lWHr3FG9kOLNn4%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52b94458.53lWHr3FG9kOLNn4%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The other thing that concerned me with this was the sparse warning:

drivers/media/i2c/s5k5baf.c:481:26: error: bad constant expression

It was hard to verify that this couldn't go over 512.  I guess 512 is
what we would consider an error in this context.  This seems like it
could be determined by the firmware?

regards,
dan carpenter

