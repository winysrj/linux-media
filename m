Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:56551 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbbL1PDW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 10:03:22 -0500
Subject: Re: [media] m88rs6000t: Better exception handling in five functions
To: Julia Lawall <julia.lawall@lip6.fr>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5680FDB3.7060305@users.sourceforge.net>
 <alpine.DEB.2.10.1512281019050.2702@hadrien>
 <56810F56.4080306@users.sourceforge.net>
 <alpine.DEB.2.10.1512281134590.2702@hadrien>
 <568148FD.7080209@users.sourceforge.net>
 <5681497E.7030702@users.sourceforge.net>
 <alpine.DEB.2.10.1512281541330.2702@hadrien>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <56814F35.5030103@users.sourceforge.net>
Date: Mon, 28 Dec 2015 16:03:17 +0100
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1512281541330.2702@hadrien>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Move the jump label directly before the desired log statement
>> so that the variable "ret" will not be checked once more
>> after a function call.
> 
> This commit message fits with the previous change.

Do you prefer an other wording?


> It could be nice to put a blank line before the error handling code.

Is it really a coding style requirement to insert another blank line between
the suggested placement of the statement "return 0;" and the jump label?

Regards,
Markus
