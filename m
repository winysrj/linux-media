Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60485 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306AbZJaJkJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 05:40:09 -0400
Date: Sat, 31 Oct 2009 07:38:36 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Massimo Del Fedele <max@veneto.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Hint request for driver change
Message-ID: <20091031073836.29081769@caramujo.chehab.org>
In-Reply-To: <loom.20091028T194649-34@post.gmane.org>
References: <4AE57DD5.8030706@veneto.com>
	<20091027082320.408afe1b@pedra.chehab.org>
	<loom.20091028T194649-34@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 28 Oct 2009 18:50:14 +0000 (UTC)
Massimo Del Fedele <max@veneto.com> escreveu:

> Mauro Carvalho Chehab <mchehab <at> infradead.org> writes:
> 
> 
> > 
> > It is better to not rename it, to avoid confusion.
> 
> Thank you for the answer :-)
> The only problem is that rewriting the full driver I will not be able to test
> all card supported by previous one (I just own one of them).
> Anyways I'll start with mine than ask for some test for the others.

Rewriting the full driver is generally a bad idea, since you'll probably loose
fixes and cause regressions. The better is to incrementally fix it.

> BTW, did you see my patch for adding Pinnacle PCTV310e support (DVB only) in
> current driver ? Did I post it correctly or it miss something ?

I just sent you an email about that. Basically, you forgot a SOB and to do make
checkpatch



Cheers,
Mauro
