Return-path: <linux-media-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:49392 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388161AbeGWWz5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 18:55:57 -0400
Date: Mon, 23 Jul 2018 14:52:40 -0700 (PDT)
Message-Id: <20180723.145240.185951244068948936.davem@davemloft.net>
To: linux@roeck-us.net
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rdunlap@infradead.org
Subject: Re: [PATCH] media: staging: omap4iss: Include asm/cacheflush.h
 after generic includes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1532381973-11856-1-git-send-email-linux@roeck-us.net>
References: <1532381973-11856-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guenter Roeck <linux@roeck-us.net>
Date: Mon, 23 Jul 2018 14:39:33 -0700

> Including asm/cacheflush.h first results in the following build error when
> trying to build sparc32:allmodconfig.
 ...
> Include generic includes files first to fix the problem.
> 
> Fixes: fc96d58c10162 ("[media] v4l: omap4iss: Add support for OMAP4 camera interface - Video devices")
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: David Miller <davem@davemloft.net>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: David S. Miller <davem@davemloft.net>
