Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab3GaO3O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 10:29:14 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id EFB28A4EB7
	for <linux-media@vger.kernel.org>; Wed, 31 Jul 2013 16:29:12 +0200 (CEST)
Message-ID: <1375280952.15881.2.camel@linux-fkkt.site>
Subject: camera always setting error bits at same resolutions
From: Oliver Neukum <oneukum@suse.de>
To: linux-media@vger.kernel.org
Date: Wed, 31 Jul 2013 16:29:12 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've got a new camera which perfectly works at some
resolutions (640x480, 640x360, 160x120). At all other resolutions
I get a black screen because all frames are dropped due to
a set error bit "Payload dropped (error bit set)"
Any idea how to debug it?

	Regards
		Oliver


