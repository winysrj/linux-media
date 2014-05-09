Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49806 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750712AbaEIMi5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 9 May 2014 08:38:57 -0400
Date: Fri, 9 May 2014 15:38:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] smiapp: Check for GPIO validity using gpio_is_valid()
Message-ID: <20140509123851.GJ8753@valkosipuli.retiisi.org.uk>
References: <1399163517-5220-1-git-send-email-sakari.ailus@iki.fi>
 <1399163517-5220-3-git-send-email-sakari.ailus@iki.fi>
 <5427082.Dc0ESfsmo0@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5427082.Dc0ESfsmo0@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, May 09, 2014 at 02:18:24PM +0200, Laurent Pinchart wrote:
> On Sunday 04 May 2014 03:31:56 Sakari Ailus wrote:
> > Do not use our special value, SMIAPP_NO_XSHUTDOWN.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Wouldn't it make sense to switch to the gpiod API ? That change could then 
> replace this patch. If you would like to do so in an incremental patch 
> instead,

I'll do that a little later.

> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
