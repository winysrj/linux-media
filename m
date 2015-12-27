Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:23886 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782AbbL0GNv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Dec 2015 01:13:51 -0500
Date: Sun, 27 Dec 2015 07:13:48 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: Julia Lawall <julia.lawall@lip6.fr>,
	Gilles Muller <Gilles.Muller@lip6.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Michal Marek <mmarek@suse.com>, cocci@systeme.lip6.fr,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
	linux-spi@vger.kernel.org, dri-devel@lists.freedesktop.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] coccinelle: api: check for propagation of error from
 platform_get_irq
In-Reply-To: <567F166B.7030208@cogentembedded.com>
Message-ID: <alpine.DEB.2.02.1512270709420.2038@localhost6.localdomain6>
References: <1451157891-24881-1-git-send-email-Julia.Lawall@lip6.fr> <567EF188.7020203@cogentembedded.com> <alpine.DEB.2.02.1512262107340.2070@localhost6.localdomain6> <alpine.DEB.2.02.1512262123500.2070@localhost6.localdomain6> <567EF895.6080702@cogentembedded.com>
 <alpine.DEB.2.02.1512262156580.2070@localhost6.localdomain6> <567F141C.8010000@cogentembedded.com> <alpine.DEB.2.02.1512262330430.2070@localhost6.localdomain6> <567F166B.7030208@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>    Well, looking again, the patch should be good. I just thought its goal was
> to fix the code as well...

I could do that for the irq < 0 case, but I think that in that case, kbuild
will only run the patch version, and the <= cases will not be reported on.
I don't have a general fix for the <= 0.  Is it even correct to have < in
some cases and <= in others?

julia
