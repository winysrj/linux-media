Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab0AEKbH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jan 2010 05:31:07 -0500
Date: Tue, 5 Jan 2010 11:31:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] media/dvb: add __init/__exit macros to
 drivers/media/dvb/bt8xx/bt878.c
In-Reply-To: <20100105111348.4a2091bd@hyperion.delvare>
Message-ID: <alpine.LNX.2.00.1001051130550.2277@pobox.suse.cz>
References: <1261471095-24272-1-git-send-email-peterhuewe@gmx.de> <20100105111348.4a2091bd@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 5 Jan 2010, Jean Delvare wrote:

> > Trivial patch which adds the __init/__exit macros to the module_init/
> > module_exit functions of
> > 
> > drivers/media/dvb/bt8xx/bt878.c
> > 
> > Please have a look at the small patch and either pull it through
> > your tree, or please ack' it so Jiri can pull it through the trivial
> > tree.
> > 
> > Patch against linux-next-tree, 22. Dez 08:38:18 CET 2009
> > but also present in linus tree.
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
