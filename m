Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:38543 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZHANeW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2009 09:34:22 -0400
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate03.web.de (Postfix) with ESMTP id 7B8C41094EF86
	for <linux-media@vger.kernel.org>; Sat,  1 Aug 2009 15:34:22 +0200 (CEST)
Received: from [217.228.207.67] (helo=[172.16.99.2])
	by smtp07.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MXEj8-0002O4-00
	for linux-media@vger.kernel.org; Sat, 01 Aug 2009 15:34:22 +0200
Message-ID: <4A74445D.40900@magic.ms>
Date: Sat, 01 Aug 2009 15:34:21 +0200
From: emagick@magic.ms
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Patch for  stack/DMA problems in Cinergy T2 drivers (2)
References: <4A735330.1000406@magic.ms> <20090731214046.GA28139@linuxtv.org>
In-Reply-To: <20090731214046.GA28139@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Johannes Stezenbach wrote:

> There is a fair amount of code duplication.  A better aproach would
> be to allocate buffers once in cinergyt2_fe_attach()
> (add them to struct cinergyt2_fe_state).

That's how it was done in the old cinergyT2 driver.

Does the code in DVB frontend code assure that the frontend ops are entered by
only one thread at a time?

-emagick
