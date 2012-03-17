Return-path: <linux-media-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:39961 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab2CQGTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Mar 2012 02:19:16 -0400
Date: Fri, 16 Mar 2012 23:18:56 -0700 (PDT)
Message-Id: <20120316.231856.1071253468993560433.davem@davemloft.net>
To: santoshprasadnayak@gmail.com
Cc: hjlipp@web.de, tilman@imap.cc, isdn@linux-pingi.de,
	gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] isdn: Return -EINTR in gigaset_start() if locking
 attempts fails.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331903413-11426-1-git-send-email-santoshprasadnayak@gmail.com>
References: <1331903413-11426-1-git-send-email-santoshprasadnayak@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: santosh nayak <santoshprasadnayak@gmail.com>
Date: Fri, 16 Mar 2012 18:40:13 +0530

> We have 3 callers: gigaset_probe(), gigaset_tty_open() and
> gigaset_probe(). Each caller tries to free allocated memory
> if lock fails. This is possible if we returns -EINTR.

Look again at the callers.

They interpret "0" as an error, so your patch would break the driver.
