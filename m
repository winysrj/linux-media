Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:61043 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbbL0QYU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Dec 2015 11:24:20 -0500
Subject: Re: [Cocci] [PATCH v2] coccinelle: api: check for propagation of
 error from platform_get_irq
To: Julia Lawall <julia.lawall@lip6.fr>
References: <1451157891-24881-1-git-send-email-Julia.Lawall@lip6.fr>
 <567EF188.7020203@cogentembedded.com>
 <alpine.DEB.2.02.1512262107340.2070@localhost6.localdomain6>
 <alpine.DEB.2.02.1512262123500.2070@localhost6.localdomain6>
 <567EF895.6080702@cogentembedded.com>
 <alpine.DEB.2.02.1512262156580.2070@localhost6.localdomain6>
 <567F9A29.50202@users.sourceforge.net>
 <alpine.DEB.2.02.1512271239460.2038@localhost6.localdomain6>
Cc: Coccinelle <cocci@systeme.lip6.fr>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
	linux-spi@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Gilles Muller <Gilles.Muller@lip6.fr>,
	Michal Marek <mmarek@suse.com>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <568010A2.3000902@users.sourceforge.net>
Date: Sun, 27 Dec 2015 17:24:02 +0100
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1512271239460.2038@localhost6.localdomain6>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> https://cwe.mitre.org/data/definitions/252.html
> 
> The value is not unchecked.

Would you like to express any stronger relationship between
the function call example and the occurrence of an if statement
by the discussed SmPL script?


> I made a specific rule because the specific problem is quite common.

Can it become also interesting to generalise this search pattern?

Regards,
Markus
