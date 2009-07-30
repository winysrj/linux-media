Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:46493 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZG3Rqv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 13:46:51 -0400
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate01.web.de (Postfix) with ESMTP id 4A83F10EEBEDF
	for <linux-media@vger.kernel.org>; Thu, 30 Jul 2009 19:46:51 +0200 (CEST)
Received: from [217.228.251.207] (helo=[172.16.99.2])
	by smtp07.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MWZiN-0002GF-00
	for linux-media@vger.kernel.org; Thu, 30 Jul 2009 19:46:51 +0200
Message-ID: <4A71DC86.8070201@magic.ms>
Date: Thu, 30 Jul 2009 19:46:46 +0200
From: emagick@magic.ms
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Cinergy T2 stopped working with kernel 2.6.30
References: <4A61FD76.8010409@magic.ms>
In-Reply-To: <4A61FD76.8010409@magic.ms>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've now compared the generated assembly code for dvb_frontend_swzigzag_autotune()
built with CONFIG_M486 vs. CONFIG_M586. Both versions are correct, but the one compiled
with -march=i586 (for which tuning does not work) uses more stack space (one 32-bit
word).

Does this ring any bells?
