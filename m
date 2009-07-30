Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:54954 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZG3JtP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 05:49:15 -0400
Received: from smtp06.web.de (fmsmtp06.dlan.cinetic.de [172.20.5.172])
	by fmmailgate02.web.de (Postfix) with ESMTP id 921F110EE94E4
	for <linux-media@vger.kernel.org>; Thu, 30 Jul 2009 11:49:14 +0200 (CEST)
Received: from [217.228.251.207] (helo=[172.16.99.2])
	by smtp06.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MWSG9-0006gm-00
	for linux-media@vger.kernel.org; Thu, 30 Jul 2009 11:49:13 +0200
Message-ID: <4A716C96.1080404@magic.ms>
Date: Thu, 30 Jul 2009 11:49:10 +0200
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

The more I look into this problem the stranger it becomes. I've compiled
the kernel for different CPUs:

                  |    mplayer               mythtv
-----------------+--------------------------------------------
CONFIG_M486      |    works                 works
CONFIG_M586      |    works                 cannot tune
CONFIG_MCORE2    |    cannot tune           cannot tune

These results are for my Atom N270 board. On my Core2 board, the Cinergy T2 works
all the time.

By applying -march=i486 and -march=i586 to individual source files, I found
out that dvb_frontend.c is the culprit.

By editing the assembly output for dvb_frontend.c, I found out that only
dvb_frontend_swzigzag_autotune() needs to be compiled with CONFIG_M486 to
make the Cinergy T2 work, everything else can be compiled with CONFIG_M586.

Both compiled versions of dvb_frontend_swzigzag_autotune() look OK (but I
haven't yet strictly verified the assembly code). Anyway, nothing in that
code should make a difference on N270 vs. Core, except for timing. Adding
NOPs doesn't seem to make a difference.

Any ideas? Could this be a CPU bug?
