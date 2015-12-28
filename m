Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:54078 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbbL1Kay (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 05:30:54 -0500
Subject: Re: [media] tuners: One check less in m88rs6000t_get_rf_strength()
 after error detection
To: Julia Lawall <julia.lawall@lip6.fr>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5680FDB3.7060305@users.sourceforge.net>
 <alpine.DEB.2.10.1512281019050.2702@hadrien>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <56810F56.4080306@users.sourceforge.net>
Date: Mon, 28 Dec 2015 11:30:46 +0100
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1512281019050.2702@hadrien>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Move the jump label directly before the desired log statement
>> so that the variable "ret" will not be checked once more
>> after it was determined that a function call failed.
> 
> Why not avoid both unnecessary ifs

I would find such a fine-tuning also nice in principle at more source code places.


> and the enormous ugliness of a label inside an if by making two returns:
> a return 0 for success and a dev_dbg and return ret for failure?

How should your suggestion finally work when the desired execution success
can be determined for such functions only after several other calls succeeded?

Is consistent checking of failure predicates usually required?

Regards,
Markus
