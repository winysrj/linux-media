Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:48126 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1EENlZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 09:41:25 -0400
Message-ID: <4DC2A8FD.4010902@infradead.org>
Date: Thu, 05 May 2011 10:41:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
CC: Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH] cx18: Fix warnings introduced during cleanup
References: <4DC138F7.5050400@infradead.org> <1304599356-21951-1-git-send-email-simon.farnsworth@onelan.co.uk>
In-Reply-To: <1304599356-21951-1-git-send-email-simon.farnsworth@onelan.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-05-2011 09:42, Simon Farnsworth escreveu:
> I misused the ktime API, and failed to remove some traces of the
> in-kernel format conversion. Fix these, so the the driver builds
> without warnings.
> 
> Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
> ---
> Mauro,
> 
> You may want to squash this in with the cleanup patch itself - it's
> plain and simple oversight on my part (I should have seen the compiler
> warnings), and I should not have sent the cleanup patch to you without
> fixing these errors.
> 
It will all depend on how much time I'll have during the next merge window.
I can't do it at the already-applied patches, as other people use it as basis,
and a rebase there would break its clones.

Mauro.
