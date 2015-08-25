Return-path: <linux-media-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:59748 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbbHYVVU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 17:21:20 -0400
Date: Tue, 25 Aug 2015 14:21:19 -0700 (PDT)
Message-Id: <20150825.142119.1984045622358159031.davem@davemloft.net>
To: standby24x7@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	corbet@lwn.net, linux-media@vger.kernel.org
Subject: Re: [PATCH] net-next: Fix warning while make xmldocs caused by
 skbuff.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1440424614-471-1-git-send-email-standby24x7@gmail.com>
References: <1440424614-471-1-git-send-email-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Masanari Iida <standby24x7@gmail.com>
Date: Mon, 24 Aug 2015 22:56:54 +0900

> This patch fix following warnings.
> 
> .//net/core/skbuff.c:407: warning: No description found
> for parameter 'len'
> .//net/core/skbuff.c:407: warning: Excess function parameter
>  'length' description in '__netdev_alloc_skb'
> .//net/core/skbuff.c:476: warning: No description found
>  for parameter 'len'
> .//net/core/skbuff.c:476: warning: Excess function parameter
> 'length' description in '__napi_alloc_skb'
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Applied, thank you.
