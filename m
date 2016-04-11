Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35626 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbcDKUJT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2016 16:09:19 -0400
Date: Mon, 11 Apr 2016 13:09:11 -0700
From: Gustavo Padovan <gustavo@padovan.org>
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [RESEND] fence: add missing descriptions for fence
Message-ID: <20160411200911.GA11780@joana>
References: <1460375335-20188-1-git-send-email-luisbg@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1460375335-20188-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luis,

2016-04-11 Luis de Bethencourt <luisbg@osg.samsung.com>:

> The members child_list and active_list were added to the fence struct
> without descriptions for the Documentation. Adding these.
> 
> Fixes: b55b54b5db33 ("staging/android: remove struct sync_pt")
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
> Hi,
> 
> Just resending this patch since it hasn't had any reviews in since
> March 21st.
> 
> Thanks,
> Luis
> 
>  include/linux/fence.h | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

	Gustavo
