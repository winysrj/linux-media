Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:57306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab1APSho (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 13:37:44 -0500
Message-ID: <4D333AF2.8070806@redhat.com>
Date: Sun, 16 Jan 2011 16:37:38 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Helmut Auer <vdr@helmutauer.de>
CC: linux-media@vger.kernel.org
Subject: Re: Patches an media build tree
References: <4D31A520.2050703@helmutauer.de>
In-Reply-To: <4D31A520.2050703@helmutauer.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-01-2011 11:46, Helmut Auer escreveu:
> Hello List
> 
> How long does it usually take til patches are integrated into the media build tree ( after posting these here ) ?
> I'm just wondering because I miss some patches posted here.

It takes as much it needs for the driver maintainer to look into it, and for
me to have time to handle them.

The pending patches are always at:

	https://patchwork.kernel.org/project/linux-media/list/

Please note that, by default, Patchwork filters the patches to display only
the ones marked as New or Under Review. If you want to see all patches, you
need to change the state filter to show all patches:
	https://patchwork.kernel.org/project/linux-media/list/?state=*

If the patch you're waiting are marked as Under Review, you should ping the
driver maintainer, as I'm waiting for his review. If it is new, that means
that I didn't have time yet to dig into it.

Cheers,
Mauro
