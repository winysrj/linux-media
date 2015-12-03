Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58603 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbbLCXcr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2015 18:32:47 -0500
Received: from recife.lan (201.86.133.92.dynamic.adsl.gvt.net.br [201.86.133.92])
	by lists.s-osg.org (Postfix) with ESMTPSA id 2AA88462A3
	for <linux-media@vger.kernel.org>; Thu,  3 Dec 2015 15:32:45 -0800 (PST)
Date: Thu, 3 Dec 2015 21:32:43 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: LMML <linux-media@vger.kernel.org>
Subject: [ANNOUNCE] Valid https certificates at LinuxTV.org
Message-ID: <20151203213243.0e6fac6e@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Today, I changed the https certificates at linuxtv.org to use valid
certificates provided by Let's Encrypt (http://letsencrypt.org/).

I also changed the URLs to use relative links on most places (I didn't
touch the legacy documentation), and the pointers to
https://patchwork.linuxtv.org and the links from patchwork and git to
https://linuxtv.org.

So, while the site keeps accepting http URLs as before, the default
and recommended way is to use https everywhere.

I hope this will help the efforts to make the Internet safer ;)

Enjoy!

Regards,
Mauro
