Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:59726 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab3GLMj4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jul 2013 08:39:56 -0400
Message-ID: <51DFF8A9.2030705@schinagl.nl>
Date: Fri, 12 Jul 2013 14:38:01 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [RFC] Dropping of channels-conf from dtv-scan-tables
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey all,

The channels-conf directory in the dtv-scan-tables repository is 
bitrotten. Besides tw-All, the newest addition is over 6 years ago, with 
some being as old as 9 years. While I'm sure it's possible that the 
channels-conf are still accurate, it's not really needed any longer.

Unless valid reasons are brought up to keep it, I will move it to a 
seperate branch and delete it from the master branch in the next few weeks.

Thanks,

Oliver
