Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46934 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbZIRURx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 16:17:53 -0400
Date: Fri, 18 Sep 2009 17:17:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hiranotaka@zng.jp
Cc: linux-media@vger.kernel.org, tomy@users.sourceforge.jp
Subject: Re: [PATCH 1/2] Add the DTV_ISDB_TS_ID property for ISDB_S
Message-ID: <20090918171717.2a37e6bb@pedra.chehab.org>
In-Reply-To: <87my5r6vfm.fsf@wei.zng.jp>
References: <87my5r6vfm.fsf@wei.zng.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 23 Aug 2009 12:49:49 +0900
hiranotaka@zng.jp escreveu:

> 
> Add the DTV_ISDB_TS_ID property for ISDB-S
> 
> In ISDB-S, time-devision duplex is used to multiplexing several waves
> in the same frequency. Each wave is identified by its own transport
> stream ID, or TS ID. We need to provide some way to specify this ID
> from user applications to handle ISDB-S frontends.
> 
> This code has been tested with the Earthsoft PT1 driver.

Committed, thanks. I had to fix a merge conflict with the ISDB-T API additions.

> +	u32			isdb_ts_id;
> +#define DTV_ISDB_TS_ID				41

I also added an "s" after ISDB to use the same name convention used on other
API functions.



Cheers,
Mauro
