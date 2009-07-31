Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:60928 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZGaTiT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 15:38:19 -0400
Received: from smtp06.web.de (fmsmtp06.dlan.cinetic.de [172.20.5.172])
	by fmmailgate02.web.de (Postfix) with ESMTP id 748D810F53F51
	for <linux-media@vger.kernel.org>; Fri, 31 Jul 2009 21:37:33 +0200 (CEST)
Received: from [217.228.167.87] (helo=[172.16.99.2])
	by smtp06.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MWxv3-0004cZ-00
	for linux-media@vger.kernel.org; Fri, 31 Jul 2009 21:37:33 +0200
Message-ID: <4A7347F9.2050907@magic.ms>
Date: Fri, 31 Jul 2009 21:37:29 +0200
From: emagick@magic.ms
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Cinergy T2 stopped working with kernel 2.6.30
References: <4A61FD76.8010409@magic.ms> <4A733BAB.6080305@magic.ms>
In-Reply-To: <4A733BAB.6080305@magic.ms>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unfortunately, aligning cinergyt2_fe_set_frontend()'s param and result on a 32-bit
boundary doesn't help.
