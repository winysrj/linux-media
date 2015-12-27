Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:13357 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbbL0Lle (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Dec 2015 06:41:34 -0500
Date: Sun, 27 Dec 2015 12:41:30 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Julia Lawall <julia.lawall@lip6.fr>,
	Coccinelle <cocci@systeme.lip6.fr>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
	linux-spi@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Gilles Muller <Gilles.Muller@lip6.fr>,
	Michal Marek <mmarek@suse.com>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [Cocci] [PATCH v2] coccinelle: api: check for propagation of
 error from platform_get_irq
In-Reply-To: <567F9A29.50202@users.sourceforge.net>
Message-ID: <alpine.DEB.2.02.1512271239460.2038@localhost6.localdomain6>
References: <1451157891-24881-1-git-send-email-Julia.Lawall@lip6.fr> <567EF188.7020203@cogentembedded.com> <alpine.DEB.2.02.1512262107340.2070@localhost6.localdomain6> <alpine.DEB.2.02.1512262123500.2070@localhost6.localdomain6> <567EF895.6080702@cogentembedded.com>
 <alpine.DEB.2.02.1512262156580.2070@localhost6.localdomain6> <567F9A29.50202@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-506290417-1451216492=:2038"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-506290417-1451216492=:2038
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT



On Sun, 27 Dec 2015, SF Markus Elfring wrote:

> > The error return value of platform_get_irq seems to often get dropped.
> 
> How do you think about any more fine-tuning here?
> 
> Commit message:
> * … of the platform_get_irq() function seems to get dropped too often.
> 
> * Why do you concentrate on a single function name?
>   Do you plan to extend this source code analysis approach?
> 
> 
> > +@script:python r_report depends on report@
> > +j0 << r.j0;
> > +j1 << r.j1;
> > +@@
> > +
> > +msg = "Propagate return value of platform_get_irq around line %s." % (j1[0].line)
> 
> Are there more unchecked return values which are interesting
> for further considerations?
> https://cwe.mitre.org/data/definitions/252.html

The value is not unchecked.  I made a specific rule because the specific 
problem is quite common.

julia
--8323328-506290417-1451216492=:2038--
