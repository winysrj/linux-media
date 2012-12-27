Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab2L0UH4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 15:07:56 -0500
Date: Thu, 27 Dec 2012 18:07:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Albert Wang <twang13@marvell.com>, g.liakhovetski@gmx.de,
	linux-media@vger.kernel.org, Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 01/15] [media] marvell-ccic: use internal variable
 replace global frame stats variable
Message-ID: <20121227180725.10ca4290@redhat.com>
In-Reply-To: <20121216083659.5ef9317d@hpe.lwn.net>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-2-git-send-email-twang13@marvell.com>
	<20121216083659.5ef9317d@hpe.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 16 Dec 2012 08:36:59 -0700
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Sat, 15 Dec 2012 17:57:50 +0800
> Albert Wang <twang13@marvell.com> wrote:
> 
> > This patch replaces the global frame stats variables by using
> > internal variables in mcam_camera structure.
> 
> This one seems fine.  Someday it might be nice to have proper stats
> rather than my debugging hack, complete with a nice sysfs interface and
> all that.  
> 
> Acked-by: Jonathan Corbet <corbet@lwn.net>

While I understand that a v4 will popup, due to some comments done on
the other patches on this v3, this patch seems pretty much independent.
So, I'll just apply it right now, and tag the others as "changes_requested"
at patchwork.

Regards,
Mauro
