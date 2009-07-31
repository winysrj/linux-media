Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:32988 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZGaULn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 16:11:43 -0400
Received: from smtp06.web.de (fmsmtp06.dlan.cinetic.de [172.20.5.172])
	by fmmailgate02.web.de (Postfix) with ESMTP id 305D110F53E37
	for <linux-media@vger.kernel.org>; Fri, 31 Jul 2009 22:11:36 +0200 (CEST)
Received: from [217.228.167.87] (helo=[172.16.99.2])
	by smtp06.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MWyS0-0003Em-00
	for linux-media@vger.kernel.org; Fri, 31 Jul 2009 22:11:36 +0200
Message-ID: <4A734FF3.5060807@magic.ms>
Date: Fri, 31 Jul 2009 22:11:31 +0200
From: emagick@magic.ms
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Patch for  stack/DMA problems in Cinergy T2 drivers
References: <4A734F0A.4000600@magic.ms>
In-Reply-To: <4A734F0A.4000600@magic.ms>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch I sent is incomplete, there are more instances of the same problem
in cinergyT2-core.c.
