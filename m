Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:37061 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZHAI1b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2009 04:27:31 -0400
Received: from smtp06.web.de (fmsmtp06.dlan.cinetic.de [172.20.5.172])
	by fmmailgate02.web.de (Postfix) with ESMTP id 50E8810F219DF
	for <linux-media@vger.kernel.org>; Sat,  1 Aug 2009 10:27:31 +0200 (CEST)
Received: from [217.228.207.67] (helo=[172.16.99.2])
	by smtp06.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MX9wB-0002V8-00
	for linux-media@vger.kernel.org; Sat, 01 Aug 2009 10:27:31 +0200
Message-ID: <4A73FC6F.8000709@magic.ms>
Date: Sat, 01 Aug 2009 10:27:27 +0200
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

Yes, but first I have to investigate why tuning is still quite unreliable
(ie, more unreliable than in 2.6.29).

Am I really the only one who has those problems with the Cinergy T2 driver
in 2.6.30?
