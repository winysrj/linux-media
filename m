Return-path: <mchehab@pedra>
Received: from claranet-outbound-smtp00.uk.clara.net ([195.8.89.33]:53675 "EHLO
	claranet-outbound-smtp00.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284Ab1EENoj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 09:44:39 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] cx18: Fix warnings introduced during cleanup
Date: Thu, 5 May 2011 14:44:32 +0100
Cc: Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Steven Toth <stoth@kernellabs.com>
References: <4DC138F7.5050400@infradead.org> <1304599356-21951-1-git-send-email-simon.farnsworth@onelan.co.uk> <4DC2A8FD.4010902@infradead.org>
In-Reply-To: <4DC2A8FD.4010902@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105051444.33707.simon.farnsworth@onelan.co.uk>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 5 May 2011, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> Em 05-05-2011 09:42, Simon Farnsworth escreveu:
> > I misused the ktime API, and failed to remove some traces of the
> > in-kernel format conversion. Fix these, so the the driver builds
> > without warnings.
> > 
> > Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
> > ---
> > Mauro,
> > 
> > You may want to squash this in with the cleanup patch itself - it's
> > plain and simple oversight on my part (I should have seen the compiler
> > warnings), and I should not have sent the cleanup patch to you without
> > fixing these errors.
> 
> It will all depend on how much time I'll have during the next merge window.
> I can't do it at the already-applied patches, as other people use it as
> basis, and a rebase there would break its clones.
> 
> Mauro.

No problem; if it ends up as a separate patch in the tree, it's not going to 
hurt, as the version with warnings functions adequately enough to not break 
bisection.
-- 
Simon Farnsworth
Software Engineer
ONELAN Limited
http://www.onelan.com/
