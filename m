Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:37561 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab2JFI0q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Oct 2012 04:26:46 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so673292dak.19
        for <linux-media@vger.kernel.org>; Sat, 06 Oct 2012 01:26:46 -0700 (PDT)
Date: Sat, 6 Oct 2012 16:26:40 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Rob Herring <rob.herring@calxeda.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 27/34] media: mx2_camera: remove cpu_is_xxx by using
 platform_device_id
Message-ID: <20121006082638.GB20231@S2101-09.ap.freescale.net>
References: <1348123547-31082-1-git-send-email-shawn.guo@linaro.org>
 <1348123547-31082-28-git-send-email-shawn.guo@linaro.org>
 <20120927160321.56420910@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927160321.56420910@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 27, 2012 at 04:03:21PM -0300, Mauro Carvalho Chehab wrote:
> It seems that it depends on some stuff that got merged via the arm tree.
> 
> Not sure what would the better way to handle that, as applying it via -arm
> will likely generate conflicts when merging from both trees upstream.
> 
> If this change is not urgent, maybe it would be better to apply it after
> the end of the merge window, via either one of the trees.
> 
That's the original plan, having it merged via arm-soc tree at the end
of 3.7 merge window.  But I was told by arm-soc folks that we already
have enough conflicts to sort out for this window, and we do not want
any more.  And we have to postpone it to 3.8.

I will publish a topic branch for this series after 3.7-rc1 comes out.

Shawn
