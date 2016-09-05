Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:65453 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755414AbcIELya (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 07:54:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        xie.baoyou@zte.com.cn
Subject: Re: [PATCH] staging: media: omap4iss: mark omap4iss_flush() static
Date: Mon, 05 Sep 2016 13:49:14 +0200
Message-ID: <5765742.RO4gM8FzCf@wuerfel>
In-Reply-To: <1472971301-4650-1-git-send-email-baoyou.xie@linaro.org>
References: <1472971301-4650-1-git-send-email-baoyou.xie@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday, September 4, 2016 2:41:41 PM CEST Baoyou Xie wrote:
> We get 1 warning when building kernel with W=1:
> drivers/staging/media/omap4iss/iss.c:64:6: warning: no previous prototype for 'omap4iss_flush' [-Wmissing-prototypes]
> 
> In fact, this function is only used in the file in which it is
> declared and don't need a declaration, but can be made static.
> so this patch marks this function with 'static'.
> 
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
