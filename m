Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:33022 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab0KAWHS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Nov 2010 18:07:18 -0400
Date: Mon, 1 Nov 2010 23:07:15 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: jarod@wilsonet.com, mchehab@infradead.org
Subject: Re: [PATCH 0/7] rc-core: ir-core to rc-core conversion
Message-ID: <20101101220715.GC4808@hardeman.nu>
References: <20101029190745.11982.75723.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101029190745.11982.75723.stgit@localhost.localdomain>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Oct 29, 2010 at 09:07:52PM +0200, David Härdeman wrote:
> This is my current patch queue, the main change is to make struct rc_dev
> the primary interface for rc drivers and to abstract away the fact that
> there's an input device lurking in there somewhere. The patchset has been
> updated to apply on top of the staging/for_v2.6.37-rc1 branch of the
> media_tree git repo.

And 2.6.37-rc1 is now released with the large scancode support as well 
as two bugfixes to that code. Could I please get some indication on the 
status of my patches? Last time I heard anything it was that they should 
go in after 2.6.37-rc1. Having to keep on rebasing them is a pain in the 
ass.

-- 
David Härdeman
