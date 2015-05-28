Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37130 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbbE1Ryv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 13:54:51 -0400
Date: Thu, 28 May 2015 19:54:48 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: "Enrico Weigelt, metux IT consult" <weigelt@melag.de>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] gpu: ipu-v3: Add mem2mem image conversion support
 to IC
Message-ID: <20150528175448.GO32610@pengutronix.de>
References: <1426674173-17088-1-git-send-email-p.zabel@pengutronix.de>
 <1426674173-17088-3-git-send-email-p.zabel@pengutronix.de>
 <CAH-u=82OC=r+kgyHpvQFLMwrBiuaV_V3Q7W5FKV3eK4o_n0-HA@mail.gmail.com>
 <5566D92F.8090802@melag.de>
 <1432809845.3228.25.camel@pengutronix.de>
 <5566FC95.3020000@melag.de>
 <1432814386.3228.51.camel@pengutronix.de>
 <5567528C.7010903@melag.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5567528C.7010903@melag.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 28, 2015 at 07:38:20PM +0200, Enrico Weigelt, metux IT consult wrote:
> Thx. already integrated it into my tree - works fine :)
> 
> By the way: i still have some your older patches (2012) in my tree,
> eg. some mediabus, camara, display timing stuff, etc ... not sure
> whether I really need them for my device.
> 
> Should I post them to linux-media list for review?

No. That's all old stuff and has developed quite a lot since then. We'll
post new series here on the lists when they are ready for mainline.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
