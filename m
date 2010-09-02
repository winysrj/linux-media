Return-path: <mchehab@localhost>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:45579 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab0IBUjZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Sep 2010 16:39:25 -0400
Date: Thu, 2 Sep 2010 22:39:21 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, jarod@redhat.com
Subject: Re: [PATCH 0/5] rc-core: ir-core to rc-core conversion
Message-ID: <20100902203921.GA3886@hardeman.nu>
References: <20100902202858.3671.50768.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100902202858.3671.50768.stgit@localhost.localdomain>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

On Thu, Sep 02, 2010 at 10:29:50PM +0200, David Härdeman wrote:
> This is my current patch queue, the main change is to make struct rc_dev
> the primary interface for rc drivers and to abstract away the fact that
> there's an input device lurking in there somewhere. The first three
> patches in the set are preparations for the change.

And I forgot to mention it, but the patches are now against media_tree, 
branch staging/v2.6.37...

-- 
David Härdeman
