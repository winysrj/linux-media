Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110807.mail.gq1.yahoo.com ([67.195.13.230]:28133 "HELO
	web110807.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753435AbZCYInu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 04:43:50 -0400
Message-ID: <82346.5913.qm@web110807.mail.gq1.yahoo.com>
Date: Wed, 25 Mar 2009 01:43:48 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: Re: [PATCH 1/1 re-submit 1] sdio: add low level i/o functions for workarounds
To: Uri Shkolnik <uris@siano-ms.com>, Pierre Ossman <drzeus@drzeus.cx>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




--- On Tue, 3/24/09, Pierre Ossman <drzeus@drzeus.cx> wrote:

> From: Pierre Ossman <drzeus@drzeus.cx>
> Subject: Re: [PATCH 1/1 re-submit 1] sdio: add low level i/o functions for workarounds
> To: "Uri Shkolnik" <uris@siano-ms.com>
> Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>, "Linux Media Mailing List" <linux-media@vger.kernel.org>
> Date: Tuesday, March 24, 2009, 10:04 PM
> On Sun, 22 Mar 2009 16:48:39 +0200
> "Uri Shkolnik" <uris@siano-ms.com>
> wrote:
> 
> > Hi Pierre,
> > 
> > The USB separation patches are ready, and will be
> committed for review
> > shortly (SDIO stack workaround + Siano SDIO driver
> were the first to be
> > re-re-re-committed, SPI will be next, and after them
> the "core" which
> > includes the 'separation' code). You can view one (of
> many) older commit
> > operations @
> > http://patchwork.kernel.org/project/linux-media/list/?submitter=Uri&stat
> > e=*
> > 
> 
> I see. Could you hold off on the SDIO patches and allow me
> to do a
> final cleanup once you have the separation patches done?
> Then I can
> send them directly to Mauro and we can have this merged
> quickly.
> 
> Rgds
> -- 
>      -- Pierre Ossman
> 
>   WARNING: This correspondence is being monitored by
> the
>   Swedish government. Make sure your server uses
> encryption
>   for SMTP traffic and consider using PGP for
> end-to-end
>   encryption.
> 



Hi Pierre,

The SDIO patches are part of (at least) dozen patches needed to upgrade the Siano's offering for Linux kernel.

The order is -
1) SDIO SMS interface driver and SDIO stack patch (add)
2) SPI interface driver (add)
3) USB interface driver (modify)
4) IR port (add)
5) USB v3 (modify)
6-15(?) ) "Core" and "Cards" modifications


The order of the patches places the SDIO among the first to be submitted for review (interface drivers must be patched before the "core", in order to make the various commits pass bisect tests).

I suggest that we'll continue the submission, and I'll cc you on ALL submissions. You will be able to review, and either ask for modification and/or suggest your on supplementary patches at any stage. 


Regards, 
________________________________

Uri Shkolnik



      
