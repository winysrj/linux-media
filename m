Return-path: <mchehab@gaivota>
Received: from lo.gmane.org ([80.91.229.12]:45666 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab1EKTqq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 15:46:46 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QKFMq-0005RF-PZ
	for linux-media@vger.kernel.org; Wed, 11 May 2011 21:46:45 +0200
Received: from 213.137.58.124 ([213.137.58.124])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 11 May 2011 21:46:44 +0200
Received: from root by 213.137.58.124 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 11 May 2011 21:46:44 +0200
To: linux-media@vger.kernel.org
From: Doychin Dokov <root@net1.cc>
Subject: Re: TT S2-3650CI problems with high-SR DVB-S2 transponders
Date: Wed, 11 May 2011 22:45:55 +0300
Message-ID: <iqep2o$vdh$1@dough.gmane.org>
References: <iqchgm$os9$1@dough.gmane.org> <iqci85$s6t$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <iqci85$s6t$1@dough.gmane.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

I've just tried with the 2.6.38 kernel from the backports, and the lock 
fix only - result is the same, unusable output from device - too many 
discontinuities.

Noone using the S2-3600 / 3650 on high-rate transponders?

Any other Linux-supported USB DVB-S2 device with CI and high SR support?



