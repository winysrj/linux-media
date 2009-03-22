Return-path: <linux-media-owner@vger.kernel.org>
Received: from Siano-NV.ser.netvision.net.il ([199.203.99.233]:40235 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754405AbZCVOsa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2009 10:48:30 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1 re-submit 1] sdio: add low level i/o functions for workarounds
Date: Sun, 22 Mar 2009 16:48:39 +0200
Message-ID: <3E442BA883529143B4AB72530285FC5D01B9E6DD@s-mail.siano-ms.ent>
In-Reply-To: <20090322153534.0c64de1e@mjolnir.ossman.eu>
References: <20090314074201.5c4a1ce1@pedra.chehab.org> <20090322153534.0c64de1e@mjolnir.ossman.eu>
From: "Uri Shkolnik" <uris@siano-ms.com>
To: "Pierre Ossman" <drzeus@drzeus.cx>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



-----Original Message-----
From: Pierre Ossman [mailto:drzeus@drzeus.cx] 
Sent: Sunday, March 22, 2009 4:36 PM
To: Mauro Carvalho Chehab
Cc: Uri Shkolnik; Linux Media Mailing List
Subject: Re: [PATCH 1/1 re-submit 1] sdio: add low level i/o functions
for workarounds

On Sat, 14 Mar 2009 07:42:01 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> Hi Pierre,
> 
> Uri sent me this patchset, as part of the changes for supporting some
devices
> from Siano.
> 
> The changeset looks fine, although I have no experiences with MMC. Are
you
> applying it on your tree, or do you prefer if I apply here?
> 
> If you're applying on yours, this is my ack:
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 

This should probably go in your tree with the patch for the Siano SDIO
driver. The problem is that that driver isn't ready yet. I was going
to do a final cleanup once the USB separations patches were done, but
those never materialised.

Rgds
-- 
     -- Pierre Ossman

---------------------------------

Hi Pierre,

The USB separation patches are ready, and will be committed for review
shortly (SDIO stack workaround + Siano SDIO driver were the first to be
re-re-re-committed, SPI will be next, and after them the "core" which
includes the 'separation' code). You can view one (of many) older commit
operations @
http://patchwork.kernel.org/project/linux-media/list/?submitter=Uri&stat
e=*

Please note that due the commit requirements I re-patch (re-generate)
the code patches you email me back at mid-2008 against kernel 2.6.29
(your code remain unchanged !).

Thanks,

Uri
