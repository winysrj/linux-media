Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58702 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab2JJDnu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 23:43:50 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so115301pad.19
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 20:43:50 -0700 (PDT)
Date: Wed, 10 Oct 2012 12:43:42 +0900
From: Tejun Heo <tj@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: mchehab@infradead.org, javier.martin@vista-silicon.com,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] [media] coda: Do not use __cancel_delayed_work()
Message-ID: <20121010034342.GA3215@mtj.dyndns.org>
References: <1349840009-14014-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349840009-14014-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 10, 2012 at 12:33:29AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> commit 136b5721d (workqueue: deprecate __cancel_delayed_work()) made 
> __cancel_delayed_work deprecated. Use cancel_delayed_work instead and get rid of
> the following warning: 
> 
> drivers/media/platform/coda.c:1543: warning: '__cancel_delayed_work' is deprecated (declared at include/linux/workqueue.h:437)
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
