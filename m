Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40567 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbZCZIeV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 04:34:21 -0400
Date: Thu, 26 Mar 2009 05:34:09 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: vasaka@gmail.com
Cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: patchwork tool
Message-ID: <20090326053409.6a310c6a@pedra.chehab.org>
In-Reply-To: <36c518800903251619j371b31bbyb6731d26c1357a34@mail.gmail.com>
References: <36c518800903251619j371b31bbyb6731d26c1357a34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 26 Mar 2009 01:19:08 +0200
vasaka@gmail.com wrote:

> Hello,
> 
> how should I format my post in order to patchwork tool understand
> included patch correctly,

If patchwork is not adding your patches there, then it means that the patches
are broken (for example, line-wrapped), or that you're attaching it, and your
emailer are using the wrong mime encoding type for diffs.

> should I just format it like in v4l-dvb/README.patches described?
> then how should I add additional comments to the mail which I do not
> want to be in the patch log?

All comments you add on your patch will be part of the commit message (except
for the meta-tags, like from:).

> It seems it is possible without special comment symbols.


Cheers,
Mauro
