Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:14573 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751906AbbL1Kg1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 05:36:27 -0500
Date: Mon, 28 Dec 2015 11:36:03 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [media] tuners: One check less in m88rs6000t_get_rf_strength()
 after error detection
In-Reply-To: <56810F56.4080306@users.sourceforge.net>
Message-ID: <alpine.DEB.2.10.1512281134590.2702@hadrien>
References: <566ABCD9.1060404@users.sourceforge.net> <5680FDB3.7060305@users.sourceforge.net> <alpine.DEB.2.10.1512281019050.2702@hadrien> <56810F56.4080306@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 28 Dec 2015, SF Markus Elfring wrote:

> >> Move the jump label directly before the desired log statement
> >> so that the variable "ret" will not be checked once more
> >> after it was determined that a function call failed.
> >
> > Why not avoid both unnecessary ifs
>
> I would find such a fine-tuning also nice in principle at more source code places.
>
>
> > and the enormous ugliness of a label inside an if by making two returns:
> > a return 0 for success and a dev_dbg and return ret for failure?
>
> How should your suggestion finally work when the desired execution success
> can be determined for such functions only after several other calls succeeded?

Not idea what this means, but immediate return 0 followed by various code
for reacting to an error is very common, so it looks like it should be
possible here.

julia
